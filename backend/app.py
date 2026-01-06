"""
FarmAura Auto Detect Crop Recommendation Backend API
=====================================================

This Flask API provides the /api/auto-detect-crop endpoint that:
1. Receives farmer location and context data
2. Filters synthetic dataset for relevant regional data
3. Generates 29 model input parameters with smart randomization
4. Calls the trained CatBoost crop recommendation model
5. Retrieves detailed recommendations from the recommendation dataset
6. Uses Gemini AI to generate farmer-friendly explanations
7. Returns structured JSON response for Flutter frontend

Author: Antigravity Agent for FarmAura
Date: 2025-11-28
"""

from flask import Flask, request, jsonify
from flask_cors import CORS
import pandas as pd
import numpy as np
import os
import json
import logging
from datetime import datetime
from dotenv import load_dotenv
import google.generativeai as genai
from catboost import CatBoostClassifier
import pickle
from typing import Dict, List, Tuple, Optional
import traceback
import sys

# Add root directory to path to import models
sys.path.append(os.path.dirname(os.path.dirname(os.path.abspath(__file__))))
from models.disease_model import disease_model

# Load environment variables
load_dotenv()

# Configure logging
logging.basicConfig(
    level=logging.INFO,
    format='%(asctime)s - %(name)s - %(levelname)s - %(message)s'
)
logger = logging.getLogger(__name__)

# Initialize Flask app
app = Flask(__name__)
CORS(app)  # Enable CORS for Flutter frontend

# Configuration
class Config:
    """Application configuration"""
    BASE_DIR = os.path.dirname(os.path.dirname(os.path.abspath(__file__)))
    MODELS_DIR = os.path.join(BASE_DIR, 'models')
    
    # Model files
    MODEL_FILE = os.path.join(MODELS_DIR, 'krishimitra_physical_v20251121_163313_8f07eda8.cbm')
    LABEL_ENCODER_FILE = os.path.join(MODELS_DIR, 'label_encoder_v20251121_163313.pkl')
    METADATA_FILE = os.path.join(MODELS_DIR, 'metadata_v20251121_163313.json')
    
    # Data files
    SYNTHETIC_DATASET = os.path.join(MODELS_DIR, 'expanded_synthetic_crop_dataset_300k.csv')
    RECOMMENDATION_DATASET = os.path.join(MODELS_DIR, 'panIndia_JharkhandRich_crop_recommendation_300k.csv')
    
    # Gemini API
    GEMINI_API_KEY = os.getenv('GEMINI_API_KEY')
    GEMINI_MODEL = os.getenv('GEMINI_MODEL', 'gemini-1.5-flash')
    
    # Model parameters (29 features expected by the model)
    MODEL_FEATURES = [
        "Temperature", "Humidity", "Rainfall", "pH", "OrganicCarbon",
        "Nitrogen", "Phosphorus", "Potassium", "Sulphur", "Zinc",
        "Copper", "Boron", "Iron", "Manganese", "EC (Electrical Conductivity)",
        "SoilSalinityIndex", "SoilMoisture", "SoilPorosity", "BulkDensity",
        "CEC", "WaterHoldingCapacity", "NDVI", "EVI", "SoilFertilityIndex",
        "ErosionRisk", "SoilTexture", "SoilDepthCategory",
        "Temperature_Anomaly", "Rainfall_Anomaly"
    ]
    
    # Randomization noise percentage (±5%)
    NOISE_PERCENTAGE = 0.05
    
    # Top N recommendations
    TOP_N_CROPS = 3

config = Config()

# Global variables for loaded models and data
model = None
label_encoder = None
metadata = None
synthetic_df = None
recommendation_df = None
gemini_model = None


def initialize_resources():
    """Initialize all required resources: models, datasets, and Gemini API"""
    global model, label_encoder, metadata, synthetic_df, recommendation_df, gemini_model
    
    try:
        logger.info("Initializing resources...")
        
        # 1. Load CatBoost model
        if not os.path.exists(config.MODEL_FILE):
            raise FileNotFoundError(f"Model file not found: {config.MODEL_FILE}")
        logger.info(f"Loading CatBoost model from {config.MODEL_FILE}")
        model = CatBoostClassifier()
        model.load_model(config.MODEL_FILE)
        logger.info("✓ CatBoost model loaded successfully")
        
        # 2. Load metadata (contains class names, so we don't need label encoder)
        if not os.path.exists(config.METADATA_FILE):
            raise FileNotFoundError(f"Metadata file not found: {config.METADATA_FILE}")
        with open(config.METADATA_FILE, 'r') as f:
            metadata = json.load(f)
        logger.info("✓ Metadata loaded successfully")
        
        # 3. Load synthetic dataset
        if not os.path.exists(config.SYNTHETIC_DATASET):
            raise FileNotFoundError(
                f"Synthetic dataset not found: {config.SYNTHETIC_DATASET}\n"
                f"Please ensure expanded_synthetic_crop_dataset_300k.csv is in the models/ directory."
            )
        logger.info(f"Loading synthetic dataset (this may take a moment)...")
        try:
            # Try different encodings
            synthetic_df = pd.read_csv(config.SYNTHETIC_DATASET, encoding='utf-8')
        except UnicodeDecodeError:
            try:
                logger.warning("UTF-8 failed, trying latin-1 encoding...")
                synthetic_df = pd.read_csv(config.SYNTHETIC_DATASET, encoding='latin-1')
            except Exception as e2:
                raise ValueError(
                    f"Cannot read synthetic dataset. The file appears to be corrupted or in wrong format.\n"
                    f"Please ensure the file is a valid CSV file.\n"
                    f"Current file: {config.SYNTHETIC_DATASET}\n"
                    f"Error: {str(e2)}"
                )
        logger.info(f"✓ Synthetic dataset loaded: {len(synthetic_df)} rows")
        
        # 4. Load recommendation dataset
        if not os.path.exists(config.RECOMMENDATION_DATASET):
            logger.warning(
                f"Recommendation dataset not found: {config.RECOMMENDATION_DATASET}\n"
                f"Using generic fallback values for recommendations."
            )
            recommendation_df = pd.DataFrame() # Empty DF
        else:
            logger.info(f"Loading recommendation dataset (this may take a moment)...")
            recommendation_df = pd.read_csv(config.RECOMMENDATION_DATASET)
            logger.info(f"✓ Recommendation dataset loaded: {len(recommendation_df)} rows")
        
        # 5. Initialize Gemini API
        if not config.GEMINI_API_KEY:
            raise ValueError(
                "GEMINI_API_KEY not found in .env file.\n"
                "Please add GEMINI_API_KEY=your_api_key to the .env file."
            )
        genai.configure(api_key=config.GEMINI_API_KEY)
        gemini_model = genai.GenerativeModel(config.GEMINI_MODEL)
        logger.info(f"✓ Gemini API initialized with model: {config.GEMINI_MODEL}")
        
        logger.info("=" * 60)
        
        # 6. Initialize Disease Model
        try:
            logger.info("Initializing Disease Detection Model...")
            disease_model.model_path = os.path.join(config.MODELS_DIR, 'plant_scan.h5')
            disease_model.load_model()
            logger.info("✓ Disease Model initialized")
        except Exception as e:
            logger.error(f"Failed to load Disease Model: {e}")
            logger.warning("Disease detection will use mock data.")

        logger.info("=" * 60)
        logger.info("All resources initialized successfully!")
        logger.info("=" * 60)
        
    except Exception as e:
        logger.error(f"Failed to initialize resources: {str(e)}")
        logger.error(traceback.format_exc())
        # Don't raise, let server start with partial resources
        # raise


def normalize_crop_name(crop_name: str) -> str:
    """Normalize crop name for matching (lowercase, strip whitespace)"""
    if pd.isna(crop_name):
        return ""
    return str(crop_name).strip().lower()


def filter_synthetic_data(state: str, district: str, frequent_crop: str) -> pd.DataFrame:
    """
    Filter synthetic dataset based on location and frequent crop with fallback strategy.
    
    Fallback order:
    1. State + District + Crop
    2. State + Crop (ignore district)
    3. District + Crop (ignore state)
    4. State only
    5. Crop only (nationwide)
    6. All data (last resort)
    
    Returns:
        Filtered DataFrame
    """
    global synthetic_df
    
    logger.info(f"Filtering data for: State={state}, District={district}, Crop={frequent_crop}")
    
    # Normalize inputs
    state_norm = state.strip().lower() if state else ""
    district_norm = district.strip().lower() if district else ""
    crop_norm = normalize_crop_name(frequent_crop)
    
    # Normalize DataFrame columns for matching
    df = synthetic_df.copy()
    df['State_norm'] = df['State'].apply(lambda x: str(x).strip().lower() if pd.notna(x) else "")
    df['District_norm'] = df['District'].apply(lambda x: str(x).strip().lower() if pd.notna(x) else "")
    df['Crop_norm'] = df['Crop'].apply(normalize_crop_name)
    
    # Try fallback strategies
    strategies = [
        # 1. State + District + Crop
        (df['State_norm'] == state_norm) & (df['District_norm'] == district_norm) & (df['Crop_norm'] == crop_norm),
        # 2. State + Crop
        (df['State_norm'] == state_norm) & (df['Crop_norm'] == crop_norm),
        # 3. District + Crop
        (df['District_norm'] == district_norm) & (df['Crop_norm'] == crop_norm),
        # 4. State only
        (df['State_norm'] == state_norm),
        # 5. Crop only
        (df['Crop_norm'] == crop_norm),
    ]
    
    strategy_names = [
        "State + District + Crop",
        "State + Crop",
        "District + Crop",
        "State only",
        "Crop only (nationwide)"
    ]
    
    for i, (condition, name) in enumerate(zip(strategies, strategy_names)):
        filtered = df[condition]
        if len(filtered) > 0:
            logger.info(f"✓ Found {len(filtered)} rows using strategy: {name}")
            return filtered.drop(columns=['State_norm', 'District_norm', 'Crop_norm'])
    
    # Last resort: return random sample
    logger.warning("No matching data found with any strategy. Using random sample from entire dataset.")
    return df.sample(n=min(1000, len(df))).drop(columns=['State_norm', 'District_norm', 'Crop_norm'])


def generate_model_input(filtered_df: pd.DataFrame) -> Dict:
    """
    Generate 29 model input parameters from filtered synthetic data with randomization.
    
    Strategy:
    - For each numeric feature: randomly select from filtered data + add small noise (±5%)
    - For categorical features: randomly select from filtered data
    - Ensure values stay within plausible bounds
    
    Returns:
        Dictionary with 29 model input parameters
    """
    logger.info("Generating model input parameters...")
    
    if len(filtered_df) == 0:
        raise ValueError("Cannot generate model input from empty filtered dataset")
    
    model_input = {}
    
    # Column mapping from synthetic dataset to model features
    # Some columns may have different names in the CSV
    column_mapping = {
        "Temperature": "Temperature",
        "Humidity": "Humidity",
        "Rainfall": "Rainfall",
        "pH": "pH",
        "OrganicCarbon": "OrganicCarbon",
        "Nitrogen": "Nitrogen",
        "Phosphorus": "Phosphorus",
        "Potassium": "Potassium",
        "Sulphur": "Sulphur",
        "Zinc": "Zinc",
        "Copper": "Copper",
        "Boron": "Boron",
        "Iron": "Iron",
        "Manganese": "Manganese",
        "EC (Electrical Conductivity)": "EC (Electrical Conductivity)",
        "SoilSalinityIndex": "SoilSalinityIndex",
        "SoilMoisture": "SoilMoisture",
        "SoilPorosity": "SoilPorosity",
        "BulkDensity": "BulkDensity",
        "CEC": "CEC",
        "WaterHoldingCapacity": "WaterHoldingCapacity",
        "NDVI": "NDVI",
        "EVI": "EVI",
        "SoilFertilityIndex": "SoilFertilityIndex",
        "ErosionRisk": "ErosionRisk",
        "SoilTexture": "SoilTexture",
        "SoilDepthCategory": "SoilDepthCategory",
        "Temperature_Anomaly": "Temperature_Anomaly",
        "Rainfall_Anomaly": "Rainfall_Anomaly"
    }
    
    # Numeric features with bounds from metadata
    numeric_bounds = metadata['preprocessing_meta']['numeric_clip_bounds']
    numeric_medians = metadata['preprocessing_meta']['numeric_medians']
    
    # Generate numeric features
    for feature in config.MODEL_FEATURES:
        if feature in ["SoilTexture", "SoilDepthCategory"]:
            continue  # Handle categorical separately
        
        csv_column = column_mapping.get(feature, feature)
        
        if csv_column in filtered_df.columns:
            # Randomly select a value from filtered data
            available_values = filtered_df[csv_column].dropna()
            
            if len(available_values) > 0:
                base_value = np.random.choice(available_values)
                
                # Convert to float (in case it's a string from CSV)
                try:
                    base_value = float(base_value)
                except (ValueError, TypeError):
                    # If conversion fails, use median
                    logger.warning(f"Could not convert {feature} value to float, using median")
                    model_input[feature] = float(numeric_medians.get(feature, 0))
                    continue
                
                # Add small random noise (±5%)
                noise = np.random.uniform(-config.NOISE_PERCENTAGE, config.NOISE_PERCENTAGE)
                value = base_value * (1 + noise)
                
                # Clip to plausible bounds
                if feature in numeric_bounds:
                    bounds = numeric_bounds[feature]
                    if not (pd.isna(bounds[0]) or pd.isna(bounds[1])):
                        value = np.clip(value, bounds[0], bounds[1])
                
                # Ensure non-negative for certain features
                if feature in ["Rainfall", "Humidity", "Temperature"]:
                    value = max(0, value)
                
                model_input[feature] = float(value)
            else:
                # Use median as fallback
                model_input[feature] = float(numeric_medians.get(feature, 0))
        else:
            # Column not found, use median
            logger.warning(f"Column {csv_column} not found in dataset, using median")
            model_input[feature] = float(numeric_medians.get(feature, 0))
    
    # Generate categorical features
    categorical_modes = metadata['preprocessing_meta']['categorical_modes']
    
    for feature in ["SoilTexture", "SoilDepthCategory"]:
        csv_column = column_mapping.get(feature, feature)
        
        if csv_column in filtered_df.columns:
            available_values = filtered_df[csv_column].dropna().unique()
            if len(available_values) > 0:
                model_input[feature] = str(np.random.choice(available_values))
            else:
                model_input[feature] = categorical_modes.get(feature, "Unknown")
        else:
            model_input[feature] = categorical_modes.get(feature, "Unknown")
    
    # Handle any NaN values that might have slipped through
    for feature, value in model_input.items():
        if isinstance(value, float) and (pd.isna(value) or np.isnan(value) or np.isinf(value)):
            logger.warning(f"Replacing NaN/Inf value for {feature} with median")
            median_val = numeric_medians.get(feature, 0)
            
            # Check if median itself is NaN (as seen with ErosionRisk)
            try:
                if pd.isna(median_val) or np.isnan(float(median_val)):
                    logger.warning(f"Median for {feature} is also NaN, using 0.0")
                    median_val = 0.0
            except (ValueError, TypeError):
                median_val = 0.0
                
            model_input[feature] = float(median_val)
    
    logger.info(f"✓ Generated {len(model_input)} model input parameters")
    return model_input


def predict_crops(model_input: Dict) -> List[Tuple[str, float]]:
    """
    Call the CatBoost model to get top 3 crop recommendations.
    
    Returns:
        List of (crop_name, probability) tuples, sorted by probability descending
    """
    global model, label_encoder, metadata
    
    logger.info("Calling CatBoost model for predictions...")
    
    # Prepare input DataFrame in correct order
    input_df = pd.DataFrame([model_input])
    input_df = input_df[config.MODEL_FEATURES]  # Ensure correct order
    
    # Get categorical feature indices
    categorical_features = metadata['preprocessing_meta']['categorical_features']
    cat_feature_indices = [i for i, feat in enumerate(config.MODEL_FEATURES) if feat in categorical_features]
    
    # Create CatBoost Pool with categorical features specified
    from catboost import Pool
    pool = Pool(data=input_df, cat_features=cat_feature_indices)
    
    # Get predictions and probabilities
    predictions = model.predict(pool)
    probabilities = model.predict_proba(pool)[0]
    
    # Get class names
    class_names = metadata['class_names']
    
    # Create list of (crop, probability) tuples
    crop_probs = [(class_names[i], float(probabilities[i])) for i in range(len(class_names))]
    
    # Sort by probability descending
    crop_probs.sort(key=lambda x: x[1], reverse=True)
    
    # Get top N
    top_crops = crop_probs[:config.TOP_N_CROPS]
    
    logger.info(f"✓ Top {config.TOP_N_CROPS} predictions: {[f'{c}({p:.2%})' for c, p in top_crops]}")
    
    return top_crops


def get_recommendation_details(crop: str, state: str, district: str) -> Optional[Dict]:
    """
    Retrieve detailed recommendation information for a crop from the recommendation dataset.
    
    Fallback strategy:
    1. State + District + Crop
    2. State + Crop
    3. Crop only
    
    Returns:
        Dictionary with recommendation details or None if not found
    """
    global recommendation_df
    
    logger.info(f"Retrieving recommendation details for {crop} in {district}, {state}")
    
    # Normalize inputs
    state_norm = state.strip().lower() if state else ""
    district_norm = district.strip().lower() if district else ""
    crop_norm = normalize_crop_name(crop)
    
    # Normalize DataFrame columns
    df = recommendation_df.copy()
    df['State_norm'] = df['State'].apply(lambda x: str(x).strip().lower() if pd.notna(x) else "")
    df['District_norm'] = df['District'].apply(lambda x: str(x).strip().lower() if pd.notna(x) else "")
    df['Crop_norm'] = df['Recommended_Crop'].apply(normalize_crop_name)
    
    # Try fallback strategies
    strategies = [
        (df['State_norm'] == state_norm) & (df['District_norm'] == district_norm) & (df['Crop_norm'] == crop_norm),
        (df['State_norm'] == state_norm) & (df['Crop_norm'] == crop_norm),
        (df['Crop_norm'] == crop_norm),
    ]
    
    for condition in strategies:
        filtered = df[condition]
        if len(filtered) > 0:
            # Pick the row with highest suitability score
            best_row = filtered.loc[filtered['Suitability_Score'].idxmax()]
            
            details = {
                'crop': best_row['Recommended_Crop'],
                'suitability_score': float(best_row['Suitability_Score']) if pd.notna(best_row['Suitability_Score']) else 0.0,
                'suitability_flag': str(best_row['Suitability_Flag']) if pd.notna(best_row['Suitability_Flag']) else 'MEDIUM',
                'expected_yield_q_per_ha': float(best_row['Expected_Yield_q_per_ha']) if pd.notna(best_row['Expected_Yield_q_per_ha']) else 0.0,
                'expected_profit_inr': float(best_row['Expected_Profit_INR']) if pd.notna(best_row['Expected_Profit_INR']) else 0.0,
                'risk_index': float(best_row['Risk_Index']) if pd.notna(best_row['Risk_Index']) else 0.5,
                'mandi_suggestion': str(best_row['Mandi_Suggestion']) if pd.notna(best_row['Mandi_Suggestion']) else 'Local Market',
                'fertilizer_recommendation': str(best_row['Fertilizer_Recommendation']) if pd.notna(best_row['Fertilizer_Recommendation']) else '',
                'fertilizer_note': str(best_row['Fertilizer_Note']) if pd.notna(best_row['Fertilizer_Note']) else '',
                'technical_reason': str(best_row['Recommendation_Reason']) if pd.notna(best_row['Recommendation_Reason']) else '',
                'agronomic_params': {
                    'temperature_c': float(best_row['Temperature_C']) if pd.notna(best_row['Temperature_C']) else 0.0,
                    'humidity_pct': float(best_row['Humidity_pct']) if pd.notna(best_row['Humidity_pct']) else 0.0,
                    'rainfall_mm': float(best_row['Rainfall_mm']) if pd.notna(best_row['Rainfall_mm']) else 0.0,
                    'ph': float(best_row['pH']) if pd.notna(best_row['pH']) else 6.5,
                    'nitrogen_kg_ha': float(best_row['Nitrogen_kg_ha']) if pd.notna(best_row['Nitrogen_kg_ha']) else 0.0,
                    'phosphorus_kg_ha': float(best_row['Phosphorus_kg_ha']) if pd.notna(best_row['Phosphorus_kg_ha']) else 0.0,
                    'potassium_kg_ha': float(best_row['Potassium_kg_ha']) if pd.notna(best_row['Potassium_kg_ha']) else 0.0,
                }
            }
            
            logger.info(f"✓ Found recommendation details (Suitability: {details['suitability_score']:.2f})")
            return details
    
    # Try fuzzy matching if exact match fails
    logger.info(f"Exact match not found for {crop_norm}. Trying fuzzy match...")
    try:
        matching_crops = df[df['Crop_norm'].str.contains(crop_norm, na=False)]['Recommended_Crop'].unique()
        if len(matching_crops) > 0:
            best_match = matching_crops[0]
            logger.info(f"Fuzzy match found: {best_match}")
            # Recurse with the matched name if it's different to avoid infinite loop
            if normalize_crop_name(best_match) != crop_norm:
                 return get_recommendation_details(best_match, state, district)
    except Exception as e:
        logger.warning(f"Fuzzy matching failed: {e}")

    logger.warning(f"No recommendation details found for {crop}")
    return None


def generate_farmer_explanation(crop_details: Dict, frequent_crop: str, land_size: float, 
                                state: str, district: str) -> str:
    """
    Use Gemini AI to generate a farmer-friendly explanation.
    
    Returns:
        Farmer-friendly explanation text
    """
    global gemini_model
    
    logger.info(f"Generating farmer-friendly explanation for {crop_details['crop']}...")
    
    prompt = f"""You are a friendly agriculture advisor talking to a farmer in India. 
Explain simply why "{crop_details['crop']}" is a good choice for their land in {district}, {state}.

Data:
- Suitability: {crop_details['suitability_score']:.2f} (High)
- Soil Nutrients: N:{crop_details['agronomic_params']['nitrogen_kg_ha']:.0f}, P:{crop_details['agronomic_params']['phosphorus_kg_ha']:.0f}, K:{crop_details['agronomic_params']['potassium_kg_ha']:.0f}
- Expected Profit: ₹{crop_details['expected_profit_inr']:,.0f}
- Expected Yield: {crop_details['expected_yield_q_per_ha']:.1f} q/ha

Instructions:
1. Write in simple, conversational English (like you are talking to them).
2. No big words or technical headings.
3. Clearly mention the expected profit and yield.
4. Explain simply if the soil nutrients are good for this crop.
5. Keep it short (3 paragraphs max).
6. Be encouraging!

Generate the advice:"""

    try:
        response = gemini_model.generate_content(prompt)
        explanation = response.text.strip()
        logger.info(f"✓ Generated explanation ({len(explanation)} characters)")
        return explanation
    except Exception as e:
        logger.error(f"Failed to generate Gemini explanation: {str(e)}")
        # Return a basic fallback explanation
        # Return a structured fallback explanation
        return f"""**Analysis for {crop_details['crop']}**

Based on your farm's soil and climate conditions, this crop is a strong match.

**Economic Potential:**
• Expected Yield: {crop_details['expected_yield_q_per_ha']:.1f} quintals/ha
• Estimated Profit: ₹{crop_details['expected_profit_inr']:,.0f} per hectare

**Key Recommendation:**
{crop_details['technical_reason']}

**Fertilizer Note:**
{crop_details['fertilizer_note']}"""


@app.route('/api/health', methods=['GET'])
def health_check():
    """Health check endpoint"""
    return jsonify({
        'status': 'healthy',
        'timestamp': datetime.now().isoformat(),
        'model_loaded': model is not None,
        'data_loaded': synthetic_df is not None and recommendation_df is not None
    })


@app.route('/api/auto-fill-parameters', methods=['POST'])
def auto_fill_parameters():
    """
    Auto-fill the 29 model parameters based on farmer's location and context.
    This endpoint does NOT call the ML model or Gemini - it just generates parameters.
    
    Expected JSON payload:
    {
        "state": "Jharkhand",
        "district": "Dhanbad",
        "frequent_grown_crop": "rice",
        "land_size": 2.5,
        "irrigation_type": "rainfed",
        "season": "kharif"  // optional
    }
    
    Returns:
    {
        "status": "success",
        "parameters": {
            "Temperature": 25.5,
            "Humidity": 75.2,
            ... (all 29 parameters)
        },
        "location": {...},
        "farmer_context": {...}
    }
    """
    try:
        # Parse request
        data = request.get_json()
        
        if not data:
            return jsonify({
                'status': 'error',
                'message': 'No JSON data provided'
            }), 400
        
        # Extract required fields
        state = data.get('state', '')
        district = data.get('district', '')
        frequent_crop = data.get('frequent_grown_crop', '')
        land_size = float(data.get('land_size', 1.0))
        irrigation_type = data.get('irrigation_type', 'rainfed')
        season = data.get('season', '')
        
        if not state or not district or not frequent_crop:
            return jsonify({
                'status': 'error',
                'message': 'Missing required fields: state, district, frequent_grown_crop'
            }), 400
        
        logger.info("=" * 60)
        logger.info(f"Auto-fill request: {state}/{district}, Crop: {frequent_crop}")
        logger.info("=" * 60)
        
        # Step 1: Filter synthetic dataset
        filtered_df = filter_synthetic_data(state, district, frequent_crop)
        
        # Step 2: Generate model input parameters
        model_input = generate_model_input(filtered_df)
        
        # Build response (NO model call, NO Gemini call)
        response = {
            'status': 'success',
            'timestamp': datetime.now().isoformat(),
            'location': {
                'state': state,
                'district': district,
                'season': season
            },
            'farmer_context': {
                'frequent_grown_crop': frequent_crop,
                'land_size': land_size,
                'irrigation_type': irrigation_type
            },
            'parameters': model_input,
            'message': 'Parameters auto-filled successfully. Review and edit if needed, then click Get Recommendation.'
        }
        
        logger.info("✓ Auto-fill completed successfully")
        logger.info("=" * 60)
        
        return jsonify(response), 200
        
    except Exception as e:
        logger.error(f"Error in auto_fill_parameters: {str(e)}")
        logger.error(traceback.format_exc())
        
        return jsonify({
            'status': 'error',
            'message': str(e),
            'traceback': traceback.format_exc()
        }), 500


@app.route('/api/get-recommendation', methods=['POST'])
def get_recommendation():
    """
    Get crop recommendations using provided 29 parameters.
    This endpoint calls the ML model and Gemini for explanations.
    
    Expected JSON payload:
    {
        "state": "Jharkhand",
        "district": "Dhanbad",
        "frequent_grown_crop": "rice",
        "land_size": 2.5,
        "irrigation_type": "rainfed",
        "season": "kharif",
        "parameters": {
            "Temperature": 25.5,
            "Humidity": 75.2,
            ... (all 29 parameters - can be edited by farmer)
        }
    }
    
    Returns:
    {
        "status": "success",
        "recommendations": [
            {
                "crop": "rice",
                "model_confidence": 0.89,
                "suitability_score": 0.92,
                "expected_yield_q_per_ha": 45.0,
                "expected_profit_inr": 52000.0,
                "farmer_friendly_explanation": "..."
            },
            ...
        ]
    }
    """
    try:
        # Parse request
        data = request.get_json()
        
        if not data:
            return jsonify({
                'status': 'error',
                'message': 'No JSON data provided'
            }), 400
        
        # Extract required fields
        state = data.get('state', '')
        district = data.get('district', '')
        frequent_crop = data.get('frequent_grown_crop', '')
        land_size = float(data.get('land_size', 1.0))
        irrigation_type = data.get('irrigation_type', 'rainfed')
        season = data.get('season', '')
        model_input = data.get('parameters', {})
        
        if not state or not district or not frequent_crop:
            return jsonify({
                'status': 'error',
                'message': 'Missing required fields: state, district, frequent_grown_crop'
            }), 400
        
        if not model_input or len(model_input) != 29:
            return jsonify({
                'status': 'error',
                'message': f'Invalid parameters. Expected 29 parameters, got {len(model_input)}'
            }), 400
        
        logger.info("=" * 60)
        logger.info(f"Get Recommendation request: {state}/{district}, Crop: {frequent_crop}")
        logger.info("=" * 60)
        
        # Step 1: Get crop predictions using provided parameters
        top_crops = predict_crops(model_input)
        
        # Step 2 & 3: Get details and generate explanations for each crop
        recommendations = []
        
        for crop_name, probability in top_crops:
            # Get recommendation details
            details = get_recommendation_details(crop_name, state, district)
            
            if details:
                # Generate farmer-friendly explanation
                # SKIP GEMINI FOR SPEED - Lazy load later
                # explanation = generate_farmer_explanation(
                #     details, frequent_crop, land_size, state, district
                # )
                explanation = "Click 'View Details' to see the AI-generated explanation."
                
                recommendations.append({
                    'crop': details['crop'],
                    'model_confidence': float(probability),
                    'suitability_score': details['suitability_score'],
                    'suitability_flag': details['suitability_flag'],
                    'expected_yield_q_per_ha': details['expected_yield_q_per_ha'],
                    'expected_profit_inr': details['expected_profit_inr'],
                    'risk_index': details['risk_index'],
                    'mandi_suggestion': details['mandi_suggestion'],
                    'fertilizer_recommendation': details['fertilizer_recommendation'],
                    'fertilizer_note': details['fertilizer_note'],
                    'technical_reason': details['technical_reason'],
                    'farmer_friendly_explanation': explanation,
                    'agronomic_params': details['agronomic_params']
                })
            else:
                # Fallback if no details found
                # Use model confidence as suitability score so it's not 0%
                suitability = float(probability)
                
                recommendations.append({
                    'crop': crop_name,
                    'model_confidence': suitability,
                    'suitability_score': suitability,
                    'suitability_flag': 'HIGH' if suitability > 0.7 else 'MEDIUM',
                    'expected_yield_q_per_ha': 25.0, # Generic estimate
                    'expected_profit_inr': 35000.0, # Generic estimate
                    'risk_index': 0.5,
                    'mandi_suggestion': 'Local Market',
                    'fertilizer_recommendation': 'Standard NPK',
                    'fertilizer_note': 'Apply standard NPK dosage.',
                    'technical_reason': f'Predicted by AI model with {suitability:.0%} confidence.',
                    'farmer_friendly_explanation': "Click 'View Details' to see the AI-generated explanation.",
                    'agronomic_params': {
                        'ph': 6.5, 'nitrogen_kg_ha': 100, 'phosphorus_kg_ha': 50, 'potassium_kg_ha': 50,
                        'temperature_c': 25.0, 'rainfall_mm': 100.0
                    }
                })
        
        # Sort recommendations by suitability_score descending
        recommendations.sort(key=lambda x: x['suitability_score'], reverse=True)
        
        # Build response
        response = {
            'status': 'success',
            'timestamp': datetime.now().isoformat(),
            'location': {
                'state': state,
                'district': district,
                'season': season
            },
            'farmer_context': {
                'frequent_grown_crop': frequent_crop,
                'land_size': land_size,
                'irrigation_type': irrigation_type
            },
            'parameters_used': model_input,
            'recommendations': recommendations
        }
        
        logger.info("✓ Get Recommendation completed successfully")
        logger.info("=" * 60)
        
        return jsonify(response), 200
        
    except Exception as e:
        logger.error(f"Error in get_recommendation: {str(e)}")
        logger.error(traceback.format_exc())
        
        return jsonify({
            'status': 'error',
            'message': str(e),
            'traceback': traceback.format_exc()
        }), 500






@app.route('/api/get-explanation', methods=['POST'])
def get_explanation():
    """
    Generate AI explanation for a specific crop recommendation on demand.
    """
    try:
        data = request.get_json()
        crop_name = data.get('crop_name')
        
        # Context
        state = data.get('state', 'Unknown')
        district = data.get('district', 'Unknown')
        
        if not crop_name:
            return jsonify({'status': 'error', 'message': 'Missing crop_name'}), 400
            
        logger.info(f"Generating on-demand explanation for {crop_name}...")
        
        # Fetch full recommendation details
        # We assume season is 'kharif' if not provided, similar to get_recommendation
        season = data.get('season', 'kharif')
        
        details = get_recommendation_details(crop_name, state, district)
        
        if not details:
            # Fallback if details not found
            details = {
                'crop': crop_name,
                'suitability_score': 0.7,
                'technical_reason': 'Suitable for local conditions',
                'agronomic_params': {'ph': 7.0, 'nitrogen_kg_ha': 100, 'phosphorus_kg_ha': 50, 'potassium_kg_ha': 50},
                'expected_yield_q_per_ha': 25.0,
                'expected_profit_inr': 35000.0,
                'risk_index': 0.5,
                'fertilizer_note': 'Apply standard NPK dosage.'
            }
        
        explanation = generate_farmer_explanation(
            details, 
            data.get('frequent_grown_crop', 'unknown'), 
            data.get('land_size', 1.0), 
            state, 
            district
        )
        
        return jsonify({
            'status': 'success',
            'explanation': explanation
        }), 200

    except Exception as e:
        logger.error(f"Error in get_explanation: {str(e)}")
        return jsonify({'status': 'error', 'message': str(e)}), 500

from db_service import db

@app.route('/api/recommendations/save', methods=['POST'])
def save_recommendation():
    try:
        data = request.get_json()
        if not data:
            return jsonify({'status': 'error', 'message': 'No data provided'}), 400
            
        # Validate required fields
        required_fields = ['phone_number', 'recommendations', 'location', 'farmer_context']
        for field in required_fields:
            if field not in data:
                return jsonify({'status': 'error', 'message': f'Missing field: {field}'}), 400
        
        result_id = db.save_recommendation(data)
        
        if result_id:
            return jsonify({'status': 'success', 'id': result_id}), 201
        else:
            return jsonify({'status': 'error', 'message': 'Failed to save to database'}), 500
            
    except Exception as e:
        logger.error(f"Error saving recommendation: {str(e)}")
        return jsonify({'status': 'error', 'message': str(e)}), 500

@app.route('/api/recommendations/<phone_number>', methods=['GET'])
def get_recommendation_history(phone_number):
    try:
        history = db.get_recommendations(phone_number)
        return jsonify({'status': 'success', 'history': history}), 200
    except Exception as e:
        logger.error(f"Error fetching history: {str(e)}")
        return jsonify({'status': 'error', 'message': str(e)}), 500
@app.route('/api/voice-query', methods=['POST'])
def process_voice_query():
    try:
        data = request.get_json()
        if not data:
            return jsonify({'status': 'error', 'message': 'No data provided'}), 400
            
        query = data.get('query')
        context = data.get('context', {})
        language = data.get('language', 'en')
        
        if not query:
            return jsonify({'status': 'error', 'message': 'Missing query'}), 400

        logger.info(f"Processing voice query: '{query}' in language: {language}")
        
        # Construct prompt for Gemini
        # Construct prompt for Gemini
        screen_context = context.get('screen', 'home')
        farmer_profile = context.get('profile', {})
        location = context.get('location', {})
        weather = context.get('weather', {})
        latest_reco = context.get('latest_crop_reco', {})
        memory = context.get('memory', [])
        
        # Fetch latest disease report if phone number is available
        latest_disease = {}
        if farmer_profile.get('phone'):
            latest_disease = db.get_latest_disease_report(farmer_profile['phone'])

        system_instruction = f"""You are a friendly agricultural assistant for an Indian farmer.
Current Language: {language} (Reply in this language or English if requested).
Farmer Name: {farmer_profile.get('name', 'Farmer')}
Location: {location.get('district', 'Unknown')}, {location.get('state', 'India')}
Current Screen: {screen_context}
Weather: {json.dumps(weather)}
Latest Crop Recommendation: {json.dumps(latest_reco)}
Latest Disease Report: {json.dumps(latest_disease)}

Task: Answer the farmer's question simply and clearly.
- Keep it short (2-3 sentences max) for voice output.
- Use simple words.
- Use the provided context (Weather, Crop Reco, Disease Report) to give personalized advice.
- Maintain conversation continuity based on previous messages.
"""

        # Format memory for prompt (last 5 turns)
        memory_str = ""
        if memory:
            memory_str = "Previous Conversation:\n" + "\n".join([f"User: {m.get('user_query')}\nAssistant: {m.get('assistant_response')}" for m in memory[-5:]])

        user_prompt = f"{memory_str}\n\nFarmer asks: {query}\n\nAdditional Context Data: {json.dumps(context.get('data', {}))}"
        
        full_prompt = f"{system_instruction}\n\n{user_prompt}"
        
        try:
            response = gemini_model.generate_content(full_prompt)
            answer = response.text.strip()
        except Exception as e:
            logger.error(f"Gemini generation failed: {e}")
            answer = "I am sorry, I could not process your request at the moment. Please try again."

        return jsonify({
            'status': 'success',
            'response': answer,
            'language': language
        }), 200

    except Exception as e:
        logger.error(f"Error processing voice query: {str(e)}")
        return jsonify({'status': 'error', 'message': str(e)}), 500

@app.errorhandler(404)
def not_found(e):
    return jsonify({
        'status': 'error',
        'message': 'Endpoint not found'
    }), 404


@app.errorhandler(500)
def internal_error(e):
    return jsonify({
        'status': 'error',
        'message': 'Internal server error'
    }), 500

@app.route('/api/narrate', methods=['POST'])
def narrate_content():
    try:
        data = request.get_json()
        content = data.get('content')
        context = data.get('context', {})
        language = data.get('language', 'en')
        
        if not content:
            return jsonify({'status': 'error', 'message': 'Missing content'}), 400

        logger.info(f"Processing narration request in {language}")
        
        prompt = f"""You are a friendly agricultural assistant. 
        Task: Rephrase the following information into a short, natural, spoken summary for a farmer.
        Language: {language}
        Tone: Friendly, encouraging, simple.
        
        Information to narrate:
        {content}
        
        Keep it concise (2-3 sentences). Do not use markdown or bullet points. Just the spoken text.
        """
        
        try:
            response = gemini_model.generate_content(prompt)
            narration = response.text.strip()
        except Exception as e:
            logger.error(f"Gemini generation failed: {e}")
            narration = "Here is the information you requested."

        return jsonify({
            'status': 'success',
            'narration': narration,
            'language': language
        }), 200

    except Exception as e:
        logger.error(f"Error in narration: {str(e)}")
        return jsonify({'status': 'error', 'message': str(e)}), 500


@app.route('/api/disease/scan', methods=['POST'])
def scan_disease():
    """
    Analyze uploaded plant images to detect diseases.
    Accepts multiple images, runs inference on each, and returns the highest confidence result.
    """
    try:
        if 'images' not in request.files:
            return jsonify({'status': 'error', 'message': 'No images provided'}), 400
            
        files = request.files.getlist('images')
        if not files or files[0].filename == '':
            return jsonify({'status': 'error', 'message': 'No selected file'}), 400

        results = []
        
        for file in files:
            try:
                # Read file bytes
                image_bytes = file.read()
                # Run prediction
                result = disease_model.predict(image_bytes)
                results.append(result)
            except Exception as e:
                logger.error(f"Error processing image {file.filename}: {e}")
                continue
                
        if not results:
            return jsonify({'status': 'error', 'message': 'Failed to process any images'}), 500
            
        # Pick the result with highest confidence
        best_result = max(results, key=lambda x: x['confidence'])
        
        logger.info(f"Disease Scan Result: {best_result['disease_name']} ({best_result['confidence']:.2%})")
        
        return jsonify({
            'status': 'success',
            'result': best_result,
            'all_results': results
        }), 200
        
    except Exception as e:
        logger.error(f"Error in disease scan: {str(e)}")
        return jsonify({'status': 'error', 'message': str(e)}), 500


@app.route('/api/disease/diagnose', methods=['POST'])
def diagnose_disease():
    """
    Generate treatment recommendations using Gemini based on detected disease.
    """
    try:
        data = request.get_json()
        disease_name = data.get('disease_name')
        crop_name = data.get('crop_name', 'Unknown Crop')
        context = data.get('context', {}) # location, soil, etc.
        
        if not disease_name:
            return jsonify({'status': 'error', 'message': 'Missing disease_name'}), 400
            
        logger.info(f"Generating diagnosis for {disease_name} on {crop_name}")
        
        prompt = f"""You are an expert plant pathologist and agriculture advisor.
        
        Task: Provide treatment recommendations for the following plant disease:
        Disease: {disease_name}
        Crop: {crop_name}
        Context: {json.dumps(context)}
        
        Please provide recommendations in three distinct categories:
        1. Chemical Control (Fungicides/Pesticides with dosage if known)
        2. Biological Control (Biopesticides, natural enemies)
        3. Organic Alternative (Home remedies, cultural practices)
        
        Format the output as a valid JSON object with these keys:
        {{
            "chemical_control": "...",
            "biological_control": "...",
            "organic_alternative": "..."
        }}
        
        Keep the advice practical for an Indian farmer.
        """
        
        try:
            response = gemini_model.generate_content(prompt)
            # Clean up response to ensure it's valid JSON
            text = response.text.strip()
            if text.startswith('```json'):
                text = text[7:-3]
            elif text.startswith('```'):
                text = text[3:-3]
                
            diagnosis = json.loads(text)
            
        except Exception as e:
            logger.error(f"Gemini diagnosis failed: {e}")
            # Fallback
            diagnosis = {
                "chemical_control": "Consult local agriculture officer for specific chemical treatments.",
                "biological_control": "Use Trichoderma viride or Pseudomonas fluorescens if available.",
                "organic_alternative": "Remove infected parts and spray neem oil."
            }
            
        return jsonify({
            'status': 'success',
            'diagnosis': diagnosis
        }), 200
        
    except Exception as e:
        logger.error(f"Error in diagnosis: {str(e)}")
        return jsonify({'status': 'error', 'message': str(e)}), 500


@app.route('/api/disease/report/save', methods=['POST'])
def save_disease_report():
    try:
        data = request.get_json()
        if not data:
            return jsonify({'status': 'error', 'message': 'No data provided'}), 400
            
        # Validate required fields
        if 'phone_number' not in data:
            return jsonify({'status': 'error', 'message': 'Missing phone_number'}), 400
            
        result_id = db.save_disease_report(data)
        
        if result_id:
            return jsonify({'status': 'success', 'id': result_id}), 201
        else:
            return jsonify({'status': 'error', 'message': 'Failed to save to database'}), 500
            
    except Exception as e:
        logger.error(f"Error saving disease report: {str(e)}")
        return jsonify({'status': 'error', 'message': str(e)}), 500

if __name__ == '__main__':
    try:
        # Initialize all resources before starting the server
        initialize_resources()
        
        # Start Flask server
        port = int(os.getenv('PORT', 5000))
        logger.info(f"Starting FarmAura Auto Detect API on port {port}...")
        app.run(host='0.0.0.0', port=port, debug=True)
        
    except Exception as e:
        logger.error(f"Failed to start server: {str(e)}")
        logger.error(traceback.format_exc())
        exit(1)
