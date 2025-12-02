import os
import numpy as np
from PIL import Image
import io
import tensorflow as tf

# Hardcoded class names from the training notebook
CLASS_NAMES = [
    'Apple___Apple_scab', 'Apple___Black_rot', 'Apple___Cedar_apple_rust', 'Apple___healthy',
    'Blueberry___healthy', 'Cherry_(including_sour)___Powdery_mildew', 'Cherry_(including_sour)___healthy',
    'Corn_(maize)___Cercospora_leaf_spot Gray_leaf_spot', 'Corn_(maize)___Common_rust_',
    'Corn_(maize)___Northern_Leaf_Blight', 'Corn_(maize)___healthy', 'Grape___Black_rot',
    'Grape___Esca_(Black_Measles)', 'Grape___Leaf_blight_(Isariopsis_Leaf_Spot)', 'Grape___healthy',
    'Orange___Haunglongbing_(Citrus_greening)', 'Peach___Bacterial_spot', 'Peach___healthy',
    'Pepper,_bell___Bacterial_spot', 'Pepper,_bell___healthy', 'Potato___Early_blight',
    'Potato___Late_blight', 'Potato___healthy', 'Raspberry___healthy', 'Soybean___healthy',
    'Squash___Powdery_mildew', 'Strawberry___Leaf_scorch', 'Strawberry___healthy',
    'Tomato___Bacterial_spot', 'Tomato___Early_blight', 'Tomato___Late_blight', 'Tomato___Leaf_Mold',
    'Tomato___Septoria_leaf_spot', 'Tomato___Spider_mites Two-spotted_spider_mite',
    'Tomato___Target_Spot', 'Tomato___Tomato_Yellow_Leaf_Curl_Virus', 'Tomato___Tomato_mosaic_virus',
    'Tomato___healthy'
]



class DiseaseModel:
    def __init__(self, model_path: str = "models/plant_scan.h5"):
        self.model_path = model_path
        self.model = None
        self.image_size = (256, 256) # Default from notebook

    def load_model(self):
        """Loads the Keras model from disk."""
        if not os.path.exists(self.model_path):
            print(f"Warning: Model file not found at {self.model_path}. Predictions will fail.")
            return

        try:
            from tensorflow import keras
            self.model = keras.models.load_model(self.model_path)
            print(f"Model loaded successfully from {self.model_path}")
        except Exception as e:
            print(f"Error loading model: {e}")
            # Do not raise, let it fail gracefully so predict() can use mock
            self.model = None

    def preprocess_image(self, image_bytes: bytes) -> np.ndarray:
        """
        Reads image bytes, resizes, and converts to numpy array batch.
        """
        try:
            image = Image.open(io.BytesIO(image_bytes))
            image = image.resize(self.image_size)
            image_array = np.array(image)
            
            # Ensure 3 channels (RGB)
            if image_array.shape[-1] != 3:
                 image_array = image_array[..., :3] # Handle RGBA

            # Add batch dimension
            img_batch = np.expand_dims(image_array, axis=0)
            return img_batch
        except Exception as e:
            print(f"Error preprocessing image: {e}")
            raise e

    def predict(self, image_bytes: bytes):
        """
        Runs inference on the provided image bytes.
        """
        if self.model is None:
            # Try loading if not loaded (e.g. lazy loading)
            self.load_model()
            if self.model is None:
                print("Model failed to load. Returning mock prediction.")
                return {
                    "disease_name": "Mock Disease (Model Error)",
                    "confidence": 0.99,
                    "severity": "high",
                    "raw_logits": []
                }

        processed_image = self.preprocess_image(image_bytes)
        
        predictions = self.model.predict(processed_image)
        
        # Get top prediction
        predicted_class_index = np.argmax(predictions[0])
        predicted_class = CLASS_NAMES[predicted_class_index]
        confidence = float(np.max(predictions[0])) # Convert numpy float to python float
        
        # Simple severity logic based on class name (can be enhanced)
        severity = "unknown"
        if "healthy" in predicted_class.lower():
            severity = "healthy"
        elif "late_blight" in predicted_class.lower() or "bacterial" in predicted_class.lower():
            severity = "high" # Example logic
        else:
            severity = "moderate"

        return {
            "disease_name": predicted_class,
            "confidence": confidence,
            "severity": severity,
            "raw_logits": predictions[0].tolist()
        }

# Singleton instance for easy import
disease_model = DiseaseModel()
