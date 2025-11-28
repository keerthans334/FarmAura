# FarmAura Auto Detect Crop Recommendation Backend

## Overview

This backend API powers the **"Auto Detect"** crop recommendation feature in the FarmAura mobile application. It provides an intelligent, end-to-end pipeline that:

1. **Receives** farmer location and context data from the Flutter frontend
2. **Filters** a 300K-row synthetic crop dataset for regional relevance
3. **Generates** 29 model input parameters using smart randomization
4. **Predicts** top 3 crop recommendations using a trained CatBoost ML model
5. **Retrieves** detailed agronomic and economic data from a recommendation dataset
6. **Generates** farmer-friendly explanations using Google Gemini AI
7. **Returns** structured JSON response to the Flutter app

---

## Architecture

```
Flutter App (Auto Detect Button)
        ↓
POST /api/auto-detect-crop
        ↓
┌─────────────────────────────────────────┐
│  Flask Backend API (app.py)             │
├─────────────────────────────────────────┤
│  1. Filter Synthetic Dataset            │
│     - State + District + Crop matching  │
│     - Multi-level fallback strategy     │
│                                         │
│  2. Generate Model Input (29 params)    │
│     - Random sampling from filtered data│
│     - ±5% noise for variation          │
│     - Bounds checking                   │
│                                         │
│  3. CatBoost Model Prediction           │
│     - Load .cbm model file              │
│     - Get top 3 crops with confidence   │
│                                         │
│  4. Recommendation Details Lookup       │
│     - Match crops in recommendation CSV │
│     - Extract yield, profit, risk data  │
│                                         │
│  5. Gemini AI Explanation               │
│     - Generate farmer-friendly text     │
│     - Simple language, actionable tips  │
│                                         │
│  6. Return JSON Response                │
└─────────────────────────────────────────┘
        ↓
Flutter App (Display Recommendations)
```

---

## Data Sources

### 1. Synthetic Crop Dataset
- **File**: `models/expanded_synthetic_crop_dataset_300k.csv`
- **Size**: ~300,000 rows
- **Purpose**: Source of realistic environmental and soil parameters for the farmer's region
- **Key Columns**:
  - Location: `State`, `District`, `Season`
  - Climate: `Temperature`, `Humidity`, `Rainfall`, `Temperature_Anomaly`, `Rainfall_Anomaly`
  - Soil Nutrients: `Nitrogen`, `Phosphorus`, `Potassium`, `Sulphur`, `Zinc`, `Copper`, `Boron`, `Iron`, `Manganese`
  - Soil Properties: `pH`, `OrganicCarbon`, `EC`, `SoilTexture`, `SoilDepthCategory`, `SoilMoisture`, `SoilPorosity`, `BulkDensity`, `CEC`, `WaterHoldingCapacity`
  - Indices: `NDVI`, `EVI`, `SoilFertilityIndex`, `ErosionRisk`
  - Crop: `Crop` (the crop grown in this record)

### 2. Recommendation Dataset
- **File**: `models/panIndia_JharkhandRich_crop_recommendation_300k.csv`
- **Size**: ~300,000 rows
- **Purpose**: Detailed agronomic, economic, and advisory information for each crop recommendation
- **Key Columns**:
  - `Recommended_Crop`, `Suitability_Score`, `Suitability_Flag`
  - `Expected_Yield_q_per_ha`, `Expected_Profit_INR`, `Risk_Index`
  - `Mandi_Suggestion`, `Fertilizer_Recommendation`, `Fertilizer_Note`
  - `Recommendation_Reason` (technical explanation)
  - All agronomic parameters (N, P, K, pH, etc.)

### 3. CatBoost Model
- **File**: `models/krishimitra_physical_v20251121_163313_8f07eda8.cbm`
- **Type**: Multi-class classification (13 crop classes)
- **Accuracy**: 85.5% (Top-3 accuracy: 99.1%)
- **Input**: 29 features (27 numeric + 2 categorical)
- **Output**: Probability distribution over 13 crops

### 4. Supporting Files
- `models/label_encoder_v20251121_163313.pkl`: Label encoder for crop names
- `models/metadata_v20251121_163313.json`: Model metadata, feature names, bounds, medians

---

## API Endpoints

### 1. Health Check
```
GET /api/health
```

**Response**:
```json
{
  "status": "healthy",
  "timestamp": "2025-11-28T16:56:16+05:30",
  "model_loaded": true,
  "data_loaded": true
}
```

---

### 2. Auto Detect Crop Recommendation
```
POST /api/auto-detect-crop
```

**Request Body**:
```json
{
  "state": "Jharkhand",
  "district": "Dhanbad",
  "frequent_grown_crop": "rice",
  "land_size": 2.5,
  "irrigation_type": "rainfed",
  "season": "kharif"
}
```

**Required Fields**:
- `state` (string): Farmer's state
- `district` (string): Farmer's district
- `frequent_grown_crop` (string): Crop the farmer grows most often

**Optional Fields**:
- `land_size` (float): Land size in hectares (default: 1.0)
- `irrigation_type` (string): Type of irrigation (default: "rainfed")
- `season` (string): Current season (optional)

**Response** (Success - 200):
```json
{
  "status": "success",
  "timestamp": "2025-11-28T16:56:16+05:30",
  "location": {
    "state": "Jharkhand",
    "district": "Dhanbad",
    "season": "kharif"
  },
  "farmer_context": {
    "frequent_grown_crop": "rice",
    "land_size": 2.5,
    "irrigation_type": "rainfed"
  },
  "model_input_used": {
    "Temperature": 25.5,
    "Humidity": 65.0,
    "Rainfall": 1200.5,
    "pH": 6.5,
    "OrganicCarbon": 1.8,
    "Nitrogen": 120.0,
    "Phosphorus": 35.0,
    "Potassium": 220.0,
    "...": "... (all 29 parameters)"
  },
  "recommendations": [
    {
      "crop": "rice",
      "model_confidence": 0.89,
      "suitability_score": 0.92,
      "suitability_flag": "HIGH",
      "expected_yield_q_per_ha": 45.0,
      "expected_profit_inr": 52000.0,
      "risk_index": 0.2,
      "mandi_suggestion": "Dhanbad Mandi",
      "fertilizer_recommendation": "NPK 120:60:40",
      "fertilizer_note": "Apply in 3 splits: basal, tillering, panicle initiation",
      "technical_reason": "Soil pH 6.5 is ideal for rice. High organic carbon (1.8%) supports nutrient retention...",
      "farmer_friendly_explanation": "Rice is an excellent choice for your land in Dhanbad. Your soil has the right acidity (pH 6.5) and good organic matter, which rice loves. You can expect around 45 quintals per hectare, earning you about ₹52,000 in profit...",
      "agronomic_params": {
        "temperature_c": 25.5,
        "humidity_pct": 65.0,
        "rainfall_mm": 1200.5,
        "ph": 6.5,
        "nitrogen_kg_ha": 120.0,
        "phosphorus_kg_ha": 35.0,
        "potassium_kg_ha": 220.0
      }
    },
    {
      "crop": "maize",
      "...": "..."
    },
    {
      "crop": "pigeonpea",
      "...": "..."
    }
  ]
}
```

**Response** (Error - 400/500):
```json
{
  "status": "error",
  "message": "Missing required fields: state, district, frequent_grown_crop"
}
```

---

## Pipeline Details

### Step 1: Filter Synthetic Dataset

**Objective**: Find rows in the synthetic dataset that match the farmer's location and frequent crop.

**Fallback Strategy** (in order):
1. **State + District + Crop**: Most specific match
2. **State + Crop**: Ignore district, match state-wide
3. **District + Crop**: Ignore state, match district-wide
4. **State only**: All crops in the state
5. **Crop only**: Nationwide data for that crop
6. **Random sample**: Last resort if nothing matches

**Example**:
```python
# Input: State=Jharkhand, District=Dhanbad, Crop=rice
# Filters synthetic_df for rows where:
filtered_df = synthetic_df[
    (synthetic_df['State'] == 'Jharkhand') &
    (synthetic_df['District'] == 'Dhanbad') &
    (synthetic_df['Crop'] == 'rice')
]
# Result: ~500 rows of rice data from Dhanbad, Jharkhand
```

---

### Step 2: Generate Model Input (29 Parameters)

**Objective**: Create a realistic set of 29 input parameters for the ML model.

**Strategy**:
- For each numeric feature (e.g., `Temperature`, `Nitrogen`):
  1. Randomly select a value from the filtered dataset
  2. Add small noise (±5%) for variation
  3. Clip to plausible bounds (from metadata)
  
- For categorical features (`SoilTexture`, `SoilDepthCategory`):
  1. Randomly select from available values in filtered data

**Example**:
```python
# For Temperature:
base_temp = random.choice(filtered_df['Temperature'])  # e.g., 25.0
noise = random.uniform(-0.05, 0.05)  # e.g., 0.02 (2%)
temp = base_temp * (1 + noise)  # 25.0 * 1.02 = 25.5
temp = clip(temp, 9.94, 31.85)  # Ensure within bounds
```

**Column Mapping**:
Most columns in the synthetic dataset match model feature names exactly. Key mappings:
- `EC (Electrical Conductivity)` ← `EC (Electrical Conductivity)` (same)
- `SoilSalinityIndex` ← `SoilSalinityIndex` (same)
- All others: direct match

---

### Step 3: CatBoost Model Prediction

**Objective**: Get top 3 crop recommendations with confidence scores.

**Process**:
1. Load the CatBoost model from `.cbm` file
2. Prepare input DataFrame with 29 features in correct order
3. Call `model.predict_proba()` to get probability distribution
4. Sort crops by probability, return top 3

**Example Output**:
```python
[
    ('rice', 0.89),
    ('maize', 0.06),
    ('pigeonpea', 0.03)
]
```

---

### Step 4: Recommendation Details Lookup

**Objective**: For each recommended crop, find detailed information in the recommendation dataset.

**Fallback Strategy**:
1. **State + District + Crop**: Most specific
2. **State + Crop**: State-wide
3. **Crop only**: Nationwide average

**Selection**: Among matching rows, pick the one with the **highest `Suitability_Score`**.

**Extracted Fields**:
- Suitability: `Suitability_Score`, `Suitability_Flag`
- Economics: `Expected_Yield_q_per_ha`, `Expected_Profit_INR`, `Risk_Index`
- Advisory: `Mandi_Suggestion`, `Fertilizer_Recommendation`, `Fertilizer_Note`, `Recommendation_Reason`
- Agronomic: All N, P, K, pH, etc. values

---

### Step 5: Gemini AI Explanation

**Objective**: Convert technical data into farmer-friendly language.

**Prompt Structure**:
```
You are an agriculture advisor. Explain to a farmer why [CROP] is suitable for their land in [DISTRICT], [STATE].

Technical data:
- Suitability Score: 0.92
- Reason: [technical reason from CSV]
- Soil pH: 6.5
- N/P/K: 120/35/220 kg/ha
- Expected Yield: 45 q/ha
- Expected Profit: ₹52,000
- Risk: 0.2 (low)

Farmer's context:
- Frequent crop: rice
- Land size: 2.5 ha

Instructions:
1. Use simple words, avoid jargon
2. Short sentences
3. Explain: why suitable, expected income, care tips
4. Be encouraging and practical
```

**Output Example**:
```
Rice is an excellent choice for your land in Dhanbad. Your soil has the right acidity (pH 6.5) 
and good organic matter, which rice loves. The climate here—with good rainfall and warm 
temperatures—is perfect for rice cultivation.

You can expect around 45 quintals per hectare, which should earn you about ₹52,000 in profit 
after costs. This is a reliable income for your 2.5 hectare farm.

Since you've been growing rice before, you know the basics. Just make sure to apply fertilizer 
in three stages: at the start, during tillering, and when the panicles form. The risk is low, 
so this is a safe choice for your family.
```

---

## Installation & Setup

### Prerequisites
- Python 3.8 or higher
- pip (Python package manager)

### Step 1: Install Dependencies
```bash
cd backend
pip install -r requirements.txt
```

### Step 2: Verify Data Files
Ensure these files exist in the `models/` directory:
- ✅ `expanded_synthetic_crop_dataset_300k.csv`
- ✅ `panIndia_JharkhandRich_crop_recommendation_300k.csv`
- ✅ `krishimitra_physical_v20251121_163313_8f07eda8.cbm`
- ✅ `label_encoder_v20251121_163313.pkl`
- ✅ `metadata_v20251121_163313.json`

### Step 3: Configure Environment Variables
Ensure `.env` file in the project root contains:
```
GEMINI_API_KEY=AIzaSyBcHIdWBXLTl5T6wjggsa-OrtvRGci4v8c
GEMINI_MODEL=gemini-2.0-flash-exp
```

### Step 4: Run the Server
```bash
python app.py
```

The server will start on `http://0.0.0.0:5000`.

**Expected Output**:
```
INFO - Loading CatBoost model from models/krishimitra_physical_v20251121_163313_8f07eda8.cbm
INFO - ✓ CatBoost model loaded successfully
INFO - ✓ Label encoder loaded successfully
INFO - ✓ Metadata loaded successfully
INFO - Loading synthetic dataset (this may take a moment)...
INFO - ✓ Synthetic dataset loaded: 300000 rows
INFO - Loading recommendation dataset (this may take a moment)...
INFO - ✓ Recommendation dataset loaded: 300000 rows
INFO - ✓ Gemini API initialized with model: gemini-2.0-flash-exp
INFO - ============================================================
INFO - All resources initialized successfully!
INFO - ============================================================
INFO - Starting FarmAura Auto Detect API on port 5000...
```

---

## Testing the API

### Using cURL
```bash
curl -X POST http://localhost:5000/api/auto-detect-crop \
  -H "Content-Type: application/json" \
  -d '{
    "state": "Jharkhand",
    "district": "Dhanbad",
    "frequent_grown_crop": "rice",
    "land_size": 2.5,
    "irrigation_type": "rainfed"
  }'
```

### Using Python
```python
import requests

response = requests.post('http://localhost:5000/api/auto-detect-crop', json={
    'state': 'Jharkhand',
    'district': 'Dhanbad',
    'frequent_grown_crop': 'rice',
    'land_size': 2.5,
    'irrigation_type': 'rainfed'
})

print(response.json())
```

### Using Postman
1. Method: `POST`
2. URL: `http://localhost:5000/api/auto-detect-crop`
3. Headers: `Content-Type: application/json`
4. Body (raw JSON):
```json
{
  "state": "Jharkhand",
  "district": "Dhanbad",
  "frequent_grown_crop": "rice",
  "land_size": 2.5,
  "irrigation_type": "rainfed"
}
```

---

## Flutter Integration

### 1. Add HTTP Package
In `pubspec.yaml`:
```yaml
dependencies:
  http: ^1.1.0
```

### 2. Create API Service
```dart
import 'dart:convert';
import 'package:http/http.dart' as http;

class CropRecommendationService {
  static const String baseUrl = 'http://YOUR_SERVER_IP:5000';
  
  Future<Map<String, dynamic>> autoDetectCrop({
    required String state,
    required String district,
    required String frequentGrownCrop,
    required double landSize,
    String irrigationType = 'rainfed',
    String? season,
  }) async {
    final response = await http.post(
      Uri.parse('$baseUrl/api/auto-detect-crop'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'state': state,
        'district': district,
        'frequent_grown_crop': frequentGrownCrop,
        'land_size': landSize,
        'irrigation_type': irrigationType,
        if (season != null) 'season': season,
      }),
    );
    
    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Failed to get recommendations: ${response.body}');
    }
  }
}
```

### 3. Use in Auto Detect Button
```dart
ElevatedButton(
  onPressed: () async {
    try {
      final result = await CropRecommendationService().autoDetectCrop(
        state: 'Jharkhand',
        district: 'Dhanbad',
        frequentGrownCrop: 'rice',
        landSize: 2.5,
      );
      
      // Navigate to results screen
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => RecommendationsScreen(data: result),
        ),
      );
    } catch (e) {
      // Show error
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $e')),
      );
    }
  },
  child: Text('Auto Detect'),
)
```

---

## Error Handling

### Common Errors

#### 1. Missing Data Files
**Error**:
```
FileNotFoundError: Synthetic dataset not found: models/expanded_synthetic_crop_dataset_300k.csv
```

**Solution**:
- Ensure `expanded_synthetic_crop_dataset_300k.csv` is in the `models/` directory
- If you have a `.numbers` file, export it to CSV first

#### 2. Missing Gemini API Key
**Error**:
```
ValueError: GEMINI_API_KEY not found in .env file.
```

**Solution**:
- Add `GEMINI_API_KEY=your_key_here` to the `.env` file in the project root

#### 3. Model File Not Found
**Error**:
```
FileNotFoundError: Model file not found: models/krishimitra_physical_v20251121_163313_8f07eda8.cbm
```

**Solution**:
- Ensure the `.cbm` model file is in the `models/` directory
- Check the filename matches exactly

#### 4. No Matching Data
**Error**:
```json
{
  "status": "error",
  "message": "Cannot generate model input from empty filtered dataset"
}
```

**Solution**:
- This happens when the state/district/crop combination has no data
- The API will automatically fall back to broader matches
- If this persists, check that the crop name is spelled correctly and matches the dataset

---

## Performance Considerations

### Loading Time
- **First request**: ~10-15 seconds (loads 600K+ rows of CSV data into memory)
- **Subsequent requests**: ~2-3 seconds (data already in memory)

### Memory Usage
- **Synthetic dataset**: ~500 MB
- **Recommendation dataset**: ~1 GB
- **Total**: ~1.5-2 GB RAM required

### Optimization Tips
1. **Use a production server**: Gunicorn or uWSGI instead of Flask dev server
2. **Cache datasets**: Keep in memory, don't reload on each request
3. **Use database**: For production, load CSVs into PostgreSQL/MySQL for faster queries
4. **Add caching**: Cache common location+crop combinations with Redis

---

## Deployment

### Option 1: Local Server (Development)
```bash
python app.py
```

### Option 2: Gunicorn (Production)
```bash
pip install gunicorn
gunicorn -w 4 -b 0.0.0.0:5000 app:app
```

### Option 3: Docker
Create `Dockerfile`:
```dockerfile
FROM python:3.10-slim
WORKDIR /app
COPY requirements.txt .
RUN pip install -r requirements.txt
COPY . .
CMD ["gunicorn", "-w", "4", "-b", "0.0.0.0:5000", "app:app"]
```

Build and run:
```bash
docker build -t farmaura-backend .
docker run -p 5000:5000 farmaura-backend
```

### Option 4: Cloud Deployment
- **Google Cloud Run**: Serverless, auto-scaling
- **AWS EC2**: Full control, manual scaling
- **Heroku**: Easy deployment, limited free tier

---

## Manual Tasks Required

### ⚠️ IMPORTANT: The following tasks MUST be done manually by Keerthan:

1. **✅ Data Files**: Already in place
   - `expanded_synthetic_crop_dataset_300k.csv` ✓
   - `panIndia_JharkhandRich_crop_recommendation_300k.csv` ✓

2. **✅ Model Files**: Already in place
   - `krishimitra_physical_v20251121_163313_8f07eda8.cbm` ✓
   - `label_encoder_v20251121_163313.pkl` ✓
   - `metadata_v20251121_163313.json` ✓

3. **✅ Environment Variables**: Already configured
   - `GEMINI_API_KEY` in `.env` ✓

4. **⚠️ Flutter Integration**: Needs manual work
   - Wire the "Auto Detect" button to call `/api/auto-detect-crop`
   - Create UI to display the 3 recommendations
   - Show farmer-friendly explanations
   - Display agronomic parameters in "View Details"

5. **⚠️ Server Deployment**: Needs manual work
   - Decide where to host the backend (local/cloud)
   - Configure firewall/network to allow Flutter app to reach the server
   - Update Flutter code with the correct server IP/URL

6. **⚠️ Language Localization** (Optional): Needs manual work
   - If you want explanations in Hindi/Kannada/other languages:
     - Modify the Gemini prompt to specify the language
     - Or use a translation API after getting English explanation

---

## Troubleshooting

### Server won't start
1. Check Python version: `python --version` (should be 3.8+)
2. Check dependencies: `pip install -r requirements.txt`
3. Check data files exist in `models/` directory
4. Check `.env` file has `GEMINI_API_KEY`

### Predictions seem wrong
1. Check the filtered dataset size in logs
2. Verify the farmer's state/district/crop are spelled correctly
3. Check model input parameters are within reasonable bounds

### Gemini explanations fail
1. Check API key is valid
2. Check internet connection
3. Check Gemini API quota/billing
4. Fallback: The API will still return technical info even if Gemini fails

---

## Future Enhancements

1. **Real-time Weather Integration**: Use live weather APIs instead of synthetic data
2. **Soil Testing Integration**: Allow farmers to input actual soil test results
3. **Multi-language Support**: Generate explanations in Hindi, Kannada, Bengali, etc.
4. **Caching**: Cache common requests to reduce latency
5. **Database**: Move CSVs to PostgreSQL for faster queries
6. **User Feedback**: Allow farmers to rate recommendations, improve model over time
7. **Seasonal Recommendations**: Factor in current season more explicitly
8. **Market Prices**: Integrate real-time mandi prices for profit estimation

---

## License

This backend is part of the FarmAura project.

---

## Contact

For questions or issues, contact the FarmAura development team.

---

**Generated by**: Antigravity Agent  
**Date**: 2025-11-28  
**Version**: 1.0.0
