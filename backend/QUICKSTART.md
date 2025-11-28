# FarmAura Auto Detect - Quick Start Guide

## 🚀 Get Started in 5 Minutes

### Step 1: Install Dependencies
```bash
cd backend
pip install -r requirements.txt
```

### Step 2: Verify Data Files
All required files are already in place! ✅
- `models/expanded_synthetic_crop_dataset_300k.csv`
- `models/panIndia_JharkhandRich_crop_recommendation_300k.csv`
- `models/krishimitra_physical_v20251121_163313_8f07eda8.cbm`
- `models/label_encoder_v20251121_163313.pkl`
- `models/metadata_v20251121_163313.json`

### Step 3: Start the Server
```bash
python app.py
```

Wait for this message:
```
INFO - ============================================================
INFO - All resources initialized successfully!
INFO - ============================================================
INFO - Starting FarmAura Auto Detect API on port 5000...
```

### Step 4: Test the API
Open a new terminal and run:
```bash
python test_api.py
```

You should see:
```
✅ Health check passed
✅ Request successful
🌾 Top 3 Recommendations:
   1. RICE
      • Model Confidence: 89%
      • Suitability: HIGH (0.92)
      ...
```

### Step 5: Integrate with Flutter
See `flutter_integration_example.dart` for complete code examples.

---

## 📝 Example API Call

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

data = response.json()
for rec in data['recommendations']:
    print(f"{rec['crop']}: {rec['farmer_friendly_explanation'][:100]}...")
```

---

## 🔧 Troubleshooting

### Server won't start?
1. Check Python version: `python --version` (need 3.8+)
2. Reinstall dependencies: `pip install -r requirements.txt`
3. Check `.env` has `GEMINI_API_KEY`

### API returns errors?
1. Check server logs for details
2. Verify state/district/crop names are spelled correctly
3. Try with a different test case

### Slow responses?
- First request takes 10-15 seconds (loading data)
- Subsequent requests: 2-3 seconds
- This is normal!

---

## 📚 Next Steps

1. **Read the full README**: `backend/README.md`
2. **Integrate with Flutter**: Use `flutter_integration_example.dart`
3. **Deploy to production**: See deployment section in README
4. **Customize**: Modify prompts, add features, etc.

---

## 🎯 What This Does

When a farmer taps "Auto Detect":

1. **Filters** 300K rows of crop data for their region
2. **Generates** 29 realistic soil/climate parameters
3. **Predicts** top 3 crops using ML model (85% accuracy)
4. **Retrieves** yield, profit, risk data for each crop
5. **Explains** in simple language using Gemini AI
6. **Returns** everything to Flutter app in JSON

All in ~3 seconds! ⚡

---

## ✅ Manual Tasks Remaining

- [ ] Wire Flutter "Auto Detect" button to call the API
- [ ] Create UI to display the 3 recommendations
- [ ] Deploy backend to a server (local or cloud)
- [ ] Update Flutter code with server URL
- [ ] (Optional) Add multi-language support

---

**Need help?** Check `backend/README.md` for detailed documentation.
