import { BrowserRouter as Router, Routes, Route, Navigate } from 'react-router-dom';
import { useState } from 'react';
import WelcomeScreen from './components/WelcomeScreen';
import PhoneLogin from './components/PhoneLogin';
import OTPVerification from './components/OTPVerification';
import ProfileSetup from './components/ProfileSetup';
import FarmSetup from './components/FarmSetup';
import Dashboard from './components/Dashboard';
import SoilDetails from './components/SoilDetails';
import WeatherDetails from './components/WeatherDetails';
import CropRecommendationStart from './components/CropRecommendationStart';
import CombinedInput from './components/CombinedInput';
import RecommendationResults from './components/RecommendationResults';
import WhyThisCrop from './components/WhyThisCrop';
import MarketPrice from './components/MarketPrice';
import PestDetection from './components/PestDetection';
import CameraInterface from './components/CameraInterface';
import UploadImage from './components/UploadImage';
import CameraPreview from './components/CameraPreview';
import PestResult from './components/PestResult';
import CommunityFeed from './components/CommunityFeed';
import FarmerVideos from './components/FarmerVideos';
import Profile from './components/Profile';
import ProfileEdit from './components/ProfileEdit';
import Settings from './components/Settings';
import AIChatbot from './components/AIChatbot';
import PersonalFinance from './components/PersonalFinance';
import PestAlerts from './components/PestAlerts';
import CropDetails from './components/CropDetails';
import TermsConditions from './components/TermsConditions';
import PrivacyPolicy from './components/PrivacyPolicy';
import AboutUs from './components/AboutUs';
import HelpSupport from './components/HelpSupport';
import ScrollToTop from './components/ScrollToTop';

function App() {
  const [userLanguage, setUserLanguage] = useState('English');
  const [isLoggedIn, setIsLoggedIn] = useState(false);
  const [location, setLocation] = useState({
    district: 'Ranchi',
    state: 'Jharkhand',
    detected: false
  });
  const [userData, setUserData] = useState({
    name: '',
    village: '',
    district: '',
    state: 'Jharkhand',
    phone: '',
    email: '',
    landSize: '',
    irrigation: '',
    occupation: 'Farmer'
  });

  // Language change handler that doesn't log out user
  const handleLanguageChange = (language: string) => {
    setUserLanguage(language);
  };

  return (
    <Router>
      <ScrollToTop />
      <div className="min-h-screen bg-[#FAFAF5]">
        <Routes>
          <Route path="/" element={<WelcomeScreen setLanguage={handleLanguageChange} />} />
          <Route path="/preview_page_v2.html" element={<Navigate to="/" replace />} />
          <Route path="/login" element={<PhoneLogin userLanguage={userLanguage} />} />
          <Route path="/otp" element={<OTPVerification setUserData={setUserData} setLocation={setLocation} />} />
          <Route path="/profile-setup" element={<ProfileSetup setUserData={setUserData} location={location} setLocation={setLocation} />} />
          <Route path="/farm-setup" element={<FarmSetup setUserData={setUserData} location={location} setLocation={setLocation} />} />
          <Route path="/dashboard" element={<Dashboard userData={userData} location={location} userLanguage={userLanguage} onLanguageChange={handleLanguageChange} />} />
          <Route path="/soil" element={<SoilDetails location={location} />} />
          <Route path="/weather" element={<WeatherDetails location={location} />} />
          <Route path="/crop-rec" element={<CropRecommendationStart />} />
          <Route path="/crop-input" element={<CombinedInput location={location} />} />
          <Route path="/crop-results" element={<RecommendationResults />} />
          <Route path="/crop-details" element={<CropDetails />} />
          <Route path="/why-crop" element={<WhyThisCrop />} />
          <Route path="/market" element={<MarketPrice />} />
          <Route path="/pest" element={<PestDetection />} />
          <Route path="/camera" element={<CameraInterface />} />
          <Route path="/camera-interface" element={<CameraInterface />} />
          <Route path="/upload-image" element={<UploadImage />} />
          <Route path="/camera-preview" element={<CameraPreview />} />
          <Route path="/pest-result" element={<PestResult />} />
          <Route path="/community" element={<CommunityFeed />} />
          <Route path="/videos" element={<FarmerVideos />} />
          <Route path="/profile" element={<Profile userData={userData} setUserData={setUserData} location={location} setLocation={setLocation} />} />
          <Route path="/profile-edit" element={<ProfileEdit userData={userData} setUserData={setUserData} location={location} setLocation={setLocation} />} />
          <Route path="/settings" element={<Settings userLanguage={userLanguage} setUserLanguage={handleLanguageChange} location={location} setLocation={setLocation} />} />
          <Route path="/ai-chat" element={<AIChatbot />} />
          <Route path="/finance" element={<PersonalFinance />} />
          <Route path="/pest-alerts" element={<PestAlerts />} />
          <Route path="/terms-conditions" element={<TermsConditions />} />
          <Route path="/privacy-policy" element={<PrivacyPolicy />} />
          <Route path="/about-us" element={<AboutUs />} />
          <Route path="/help-support" element={<HelpSupport />} />
          <Route path="*" element={<Navigate to="/" replace />} />
        </Routes>
      </div>
    </Router>
  );
}

export default App;