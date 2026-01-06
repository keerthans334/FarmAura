# FarmAura 🌾

![FarmAura Banner](https://img.shields.io/badge/Status-Active-success?style=for-the-badge) ![License](https://img.shields.io/badge/License-MIT-blue?style=for-the-badge) ![Flutter](https://img.shields.io/badge/Flutter-3.10-02569B?style=for-the-badge&logo=flutter&logoColor=white) ![Python](https://img.shields.io/badge/Python-3.8+-3776AB?style=for-the-badge&logo=python&logoColor=white) ![Gemini AI](https://img.shields.io/badge/AI-Gemini%20Flash-8E75B2?style=for-the-badge&logo=google&logoColor=white)

> **Award Winning Project**: Showcased at the **Smart India Hackathon (National Level)** 🏆 | Team Leader - Group 6

---

## 📖 About The Project

**FarmAura** is a next-generation **Smart Crop Advisory System** designed specifically for small and marginal farmers. It bridges the gap between advanced technology and traditional farming by providing intelligent, data-driven insights in a simple, accessible mobile interface.

Farming is complex. Factors like soil health, weather patterns, and market trends constantly change. FarmAura simplifies this by using **Machine Learning** and **Generative AI** to analyze:
*   🌱 **Soil Health**: Micro and macro-nutrient data.
*   🌦️ **Climate**: Region-specific weather conditions.
*   🚜 **Farming Context**: Land size, irrigation type, and crop history.

The result is a comprehensive advisory system that tells farmers **what to grow**, **how to grow it**, and **how to protect it**, all in their native language through an **IVR-based voice interface**.

---

## ✨ Key Features

### 🧠 Intelligent Crop Recommendation
*   Driven by a **CatBoost ML Model** trained on ~300k synthetic data points.
*   Analyzes 29 different parameters (N, P, K, pH, Rainfall, Humidity, etc.) to suggest the top 3 most suitable crops.
*   Provides confidence scores and yield predictions.

### 🐛 AI Pest Detection
*   **Computer Vision** powered pest diagnosis.
*   Simply click a photo of the affected plant to identify pests or diseases instantly.
*   Get immediate remedies and chemical/organic treatment suggestions.

### 🗣️ Voice-First Interface (IVR)
*   Fully accessible for users with low literacy.
*   **Speech-to-Text**: Farmers can ask questions verbally.
*   **Text-to-Speech**: All recommendations and advice are read out loud.
*   **Multilingual**: Supports local languages for broader accessibility.

### 🤖 Generative AI Advisory (Gemini)
*   Integrated **Google Gemini 2.0 Flash** for natural language explanations.
*   Converts complex agronomic data into simple, "farmer-friendly" advice.
*   Explains *why* a crop is recommended and *how* to maximize profit.

### 💰 Personal Finance & Market
*   **Mandi Prices**: Live updates on crop prices in nearby markets.
*   **Expense Tracker**: dedicated module for farmers to manage their income and farm expenses.

### 🌐 Community & Learning
*   **Community Feed**: Connect with other farmers.
*   **Video Library**: Curated videos for modern farming techniques.

---

## 📱 User Interface

| **Home Dashboard** | **Crop Recommendations** | **Pest Detection** |
|:---:|:---:|:---:|
| <img src="assets/images/dashboard.jpeg" alt="Home" height="400"> | <img src="assets/images/recommendation_preview.png" alt="Recs" height="400"> | <img src="assets/images/pest_preview.png" alt="Pest" height="400"> |



---

## 🛠️ Technical Stack

### **Frontend (Mobile App)**
*   ![Flutter](https://img.shields.io/badge/Flutter-02569B?style=flat&logo=flutter&logoColor=white) **Flutter**: Cross-platform mobile framework.
*   ![Dart](https://img.shields.io/badge/Dart-0175C2?style=flat&logo=dart&logoColor=white) **Dart**: Programming language.
*   **State Management**: Provider.
*   **Key Packages**: `geolocator`, `speech_to_text`, `firebase_auth`, `google_fonts`.

### **Backend (API & ML)**
*   ![Python](https://img.shields.io/badge/Python-3776AB?style=flat&logo=python&logoColor=white) **Python**: Core logic.
*   ![Flask](https://img.shields.io/badge/Flask-000000?style=flat&logo=flask&logoColor=white) **Flask**: REST API framework.
*   ![CatBoost](https://img.shields.io/badge/CatBoost-FF9E0F?style=flat&logo=catboost&logoColor=black) **CatBoost**: High-performance gradient boosting on decision trees.
*   ![Gemini](https://img.shields.io/badge/Google%20Gemini-8E75B2?style=flat&logo=google&logoColor=white) **Google Gemini**: Generative AI for explanations.

### **Cloud & Data**
*   ![Firebase](https://img.shields.io/badge/Firebase-FFCA28?style=flat&logo=firebase&logoColor=black) **Firebase**: Auth & Firestore Database.
*   ![Google Cloud](https://img.shields.io/badge/Google_Cloud-4285F4?style=flat&logo=google-cloud&logoColor=white) **Google Cloud**: API hosting.

---

## 🚀 Getting Started

### Prerequisites
*   [Flutter SDK](https://docs.flutter.dev/get-started/install) installed.
*   [Python 3.8+](https://www.python.org/downloads/) installed.
*   Gemini API Key.

### 1. Clone the Repository
```bash
git clone https://github.com/keerthans334/FarmAura.git
cd FarmAura/FarmAura_application
```

### 2. Backward Setup (Python)
Navigate to the backend directory and install dependencies.
```bash
cd backend
pip install -r requirements.txt
```
Create a `.env` file in `backend/` and add your keys:
```env
GEMINI_API_KEY=your_api_key_here
GEMINI_MODEL=gemini-2.0-flash-exp
```
Run the server:
```bash
python app.py
```

### 3. Frontend Setup (Flutter)
Install packages:
```bash
flutter pub get
```
Run the app (ensure an emulator or device is connected):
```bash
flutter run
```

---

## 🤝 Contribution
Contributions are what make the open source community such an amazing place to learn, inspire, and create. Any contributions you make are **greatly appreciated**.

1.  Fork the Project
2.  Create your Feature Branch (`git checkout -b feature/AmazingFeature`)
3.  Commit your Changes (`git commit -m 'Add some AmazingFeature'`)
4.  Push to the Branch (`git push origin feature/AmazingFeature`)
5.  Open a Pull Request

---

## 📞 Contact

**Keerthan Shetty**  
*Lead Developer & Team Lead*

[![LinkedIn](https://img.shields.io/badge/LinkedIn-0077B5?style=for-the-badge&logo=linkedin&logoColor=white)](https://www.linkedin.com/in/keerthanshetty334krishimitraaifarmauralead07072005) [![GitHub](https://img.shields.io/badge/GitHub-100000?style=for-the-badge&logo=github&logoColor=white)](https://github.com/keerthans334) [![Email](https://img.shields.io/badge/Email-D14836?style=for-the-badge&logo=gmail&logoColor=white)](mailto:keerthans334@gmail.com)
