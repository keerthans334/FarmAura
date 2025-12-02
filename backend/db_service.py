import os
import logging
import uuid
from azure.cosmos import CosmosClient, PartitionKey, exceptions
from dotenv import load_dotenv
from datetime import datetime

load_dotenv()

logger = logging.getLogger(__name__)

class DBService:
    _instance = None
    
    def __new__(cls):
        if cls._instance is None:
            cls._instance = super(DBService, cls).__new__(cls)
            cls._instance._initialized = False
        return cls._instance
    
    def __init__(self):
        if self._initialized:
            return
            
        self.client = None
        self.database = None
        self.containers = {}
        
        self.endpoint = os.getenv('COSMOS_DB_URI')
        self.key = os.getenv('COSMOS_DB_KEY')
        
        if not self.endpoint or not self.key:
            logger.error("COSMOS_DB_URI or COSMOS_DB_KEY not found in environment variables")
            return

        try:
            # Initialize Cosmos Client
            self.client = CosmosClient(self.endpoint, self.key)
            
            # Create Database
            self.database = self.client.create_database_if_not_exists(id="FarmAuraDB")
            logger.info("✓ Database 'FarmAuraDB' ready")
            
            # Create Containers
            container_defs = [
                {'id': 'Users', 'partition_key': '/phoneNumber'},
                {'id': 'Recommendations', 'partition_key': '/phoneNumber'},
                {'id': 'SoilRecords', 'partition_key': '/phoneNumber'},
                {'id': 'DiseaseReports', 'partition_key': '/phoneNumber'}
            ]
            
            for c_def in container_defs:
                container = self.database.create_container_if_not_exists(
                    id=c_def['id'],
                    partition_key=PartitionKey(path=c_def['partition_key'])
                )
                self.containers[c_def['id']] = container
                logger.info(f"✓ Container '{c_def['id']}' ready")
            
            self._initialized = True
            
        except Exception as e:
            logger.error(f"Failed to initialize Cosmos DB: {str(e)}")
            self.client = None

    def is_connected(self):
        return self.client is not None

    def save_recommendation(self, data):
        if not self.is_connected():
            logger.warning("Database not connected. Skipping save.")
            return False
            
        try:
            container = self.containers.get('Recommendations')
            if not container:
                logger.error("Recommendations container not found")
                return False
                
            # Prepare item for Cosmos DB
            # Must have 'id' and the partition key 'phoneNumber'
            item = {
                'id': str(uuid.uuid4()),
                'timestamp': datetime.now().isoformat(),
                **data
            }
            
            # Ensure phoneNumber is present (Partition Key)
            if 'phone_number' in data:
                item['phoneNumber'] = data['phone_number'] # Map snake_case to camelCase if needed, or stick to one
            elif 'phoneNumber' not in item:
                logger.error("Missing phoneNumber in data")
                return False
                
            # Create item
            container.create_item(body=item)
            logger.info(f"✓ Recommendation saved with ID: {item['id']}")
            return item['id']
            
        except exceptions.CosmosHttpResponseError as e:
            logger.error(f"Cosmos DB Error: {e.message}")
            return False
        except Exception as e:
            logger.error(f"Failed to save recommendation: {str(e)}")
            return False

    def get_recommendations(self, phone_number):
        if not self.is_connected():
            return []
            
        try:
            container = self.containers.get('Recommendations')
            if not container:
                return []
                
            # Query items
            query = "SELECT * FROM c WHERE c.phoneNumber = @phoneNumber ORDER BY c.timestamp DESC"
            params = [{"name": "@phoneNumber", "value": phone_number}]
            
            items = list(container.query_items(
                query=query,
                parameters=params,
                enable_cross_partition_query=False
            ))
            
            return items
            
        except Exception as e:
            logger.error(f"Failed to fetch recommendations: {str(e)}")
            return []

    def save_disease_report(self, data):
        if not self.is_connected():
            return False
            
        try:
            container = self.containers.get('DiseaseReports')
            if not container:
                return False
                
            item = {
                'id': str(uuid.uuid4()),
                'timestamp': datetime.now().isoformat(),
                **data
            }
            
            # Ensure phoneNumber
            if 'phone_number' in data:
                item['phoneNumber'] = data['phone_number']
            elif 'phoneNumber' not in item:
                logger.error("Missing phoneNumber in disease report")
                return False
                
            container.create_item(body=item)
            logger.info(f"✓ Disease report saved with ID: {item['id']}")
            return item['id']
            
        except Exception as e:
            logger.error(f"Failed to save disease report: {str(e)}")
            return False

    def get_latest_disease_report(self, phone_number):
        if not self.is_connected():
            return None
            
        try:
            container = self.containers.get('DiseaseReports')
            if not container:
                return None
                
            query = "SELECT * FROM c WHERE c.phoneNumber = @phoneNumber ORDER BY c.timestamp DESC OFFSET 0 LIMIT 1"
            params = [{"name": "@phoneNumber", "value": phone_number}]
            
            items = list(container.query_items(
                query=query,
                parameters=params,
                enable_cross_partition_query=False
            ))
            
            if items:
                return items[0]
            return None
            
        except Exception as e:
            logger.error(f"Failed to fetch latest disease report: {str(e)}")
            return None

# Global instance
db = DBService()
