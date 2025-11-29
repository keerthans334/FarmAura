import os
import logging
from pymongo import MongoClient
from dotenv import load_dotenv
from datetime import datetime

load_dotenv()

logger = logging.getLogger(__name__)

class Database:
    _instance = None
    
    def __new__(cls):
        if cls._instance is None:
            cls._instance = super(Database, cls).__new__(cls)
            cls._instance._initialized = False
        return cls._instance
    
    def __init__(self):
        if self._initialized:
            return
            
        self.client = None
        self.db = None
        self.uri = os.getenv('COSMOS_MONGODB_URI')
        
        if not self.uri:
            logger.error("COSMOS_MONGODB_URI not found in environment variables")
            return

        try:
            # Initialize MongoDB client
            # Azure Cosmos DB requires specific SSL settings which are usually in the URI
            self.client = MongoClient(self.uri)
            
            # Verify connection
            # The 'ping' command is a lightweight way to check connectivity
            self.client.admin.command('ping')
            logger.info("✓ Successfully connected to Azure Cosmos DB (MongoDB)")
            
            # Get database
            self.db = self.client['farmAuraDB']
            
            # Initialize collections
            self.crop_recommendations = self.db['crop_recommendations']
            self.fertilizer_advice = self.db['fertilizer_advice']
            self.user_profiles = self.db['user_profiles']
            
            self._initialized = True
            
        except Exception as e:
            logger.error(f"Failed to connect to Azure Cosmos DB: {str(e)}")
            self.client = None
            self.db = None

    def is_connected(self):
        return self.client is not None

    def save_recommendation(self, data):
        if not self.is_connected():
            logger.warning("Database not connected. Skipping save.")
            return False
        try:
            # Ensure timestamp is present
            if 'timestamp' not in data:
                data['timestamp'] = datetime.now().isoformat()
                
            result = self.crop_recommendations.insert_one(data)
            logger.info(f"✓ Recommendation saved with ID: {result.inserted_id}")
            return str(result.inserted_id)
        except Exception as e:
            logger.error(f"Failed to save recommendation: {str(e)}")
            return False

    def save_fertilizer_advice(self, data):
        if not self.is_connected():
            logger.warning("Database not connected. Skipping save.")
            return False
        try:
            if 'timestamp' not in data:
                data['timestamp'] = datetime.now().isoformat()
                
            result = self.fertilizer_advice.insert_one(data)
            logger.info(f"✓ Fertilizer advice saved with ID: {result.inserted_id}")
            return str(result.inserted_id)
        except Exception as e:
            logger.error(f"Failed to save fertilizer advice: {str(e)}")
            return False

    def get_history(self, phone_number, collection_name):
        if not self.is_connected():
            return []
        try:
            collection = self.db[collection_name]
            # Convert cursor to list and handle ObjectId serialization if needed later
            # For now, we return the raw dicts (ObjectId needs str conversion in app.py)
            cursor = collection.find({'phone_number': phone_number}).sort('timestamp', -1).limit(20)
            return list(cursor)
        except Exception as e:
            logger.error(f"Failed to fetch history: {str(e)}")
            return []

# Global instance
db = Database()
