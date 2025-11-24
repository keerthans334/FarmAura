import { useNavigate } from 'react-router-dom';
import { useState } from 'react';
import AppHeader from './AppHeader';
import AppFooter from './AppFooter';
import FloatingIVR from './FloatingIVR';
import { Bell, Languages, Shield, HelpCircle, Info, ChevronRight, MapPin, Navigation } from 'lucide-react';

interface SettingsProps {
  userLanguage?: string;
  setUserLanguage?: (lang: string) => void;
  location?: any;
  setLocation?: (loc: any) => void;
}

export default function Settings({ userLanguage = 'English', setUserLanguage, location, setLocation }: SettingsProps) {
  const navigate = useNavigate();
  const [notificationsEnabled, setNotificationsEnabled] = useState(true);
  const [showLanguageMenu, setShowLanguageMenu] = useState(false);
  const [showLocationMenu, setShowLocationMenu] = useState(false);

  const languages = ['English', 'Hindi', 'Bengali', 'Nagpuri', 'Kurmali', 'Santhali'];
  const states = [
    'Jharkhand', 'Bihar', 'West Bengal', 'Odisha', 'Chhattisgarh',
    'Uttar Pradesh', 'Madhya Pradesh', 'Maharashtra', 'Andhra Pradesh',
    'Telangana', 'Karnataka', 'Tamil Nadu', 'Kerala', 'Gujarat',
    'Rajasthan', 'Punjab', 'Haryana', 'Himachal Pradesh', 'Uttarakhand'
  ];

  const handleLanguageChange = (lang: string) => {
    if (setUserLanguage) {
      setUserLanguage(lang);
    }
    setShowLanguageMenu(false);
  };

  const handleLocationChange = (state: string) => {
    if (setLocation) {
      setLocation({
        ...location,
        state: state,
        detected: false
      });
    }
    setShowLocationMenu(false);
  };

  const detectLocation = () => {
    // Simulate GPS detection
    if (setLocation) {
      setLocation({
        district: 'Ranchi',
        state: 'Jharkhand',
        detected: true
      });
    }
    setShowLocationMenu(false);
  };

  const settingsSections = [
    {
      title: 'Preferences',
      items: [
        { 
          icon: Bell, 
          label: 'Notifications', 
          desc: notificationsEnabled ? 'Enabled' : 'Disabled', 
          action: () => setNotificationsEnabled(!notificationsEnabled)
        },
        { 
          icon: Languages, 
          label: 'Language', 
          desc: userLanguage, 
          action: () => setShowLanguageMenu(true)
        },
        { 
          icon: MapPin, 
          label: 'Location', 
          desc: `${location?.state || 'Jharkhand'}`, 
          action: () => setShowLocationMenu(true)
        },
      ]
    },
    {
      title: 'Privacy & Security',
      items: [
        { icon: Shield, label: 'Privacy Policy', desc: 'View privacy policy', action: () => navigate('/privacy-policy') },
        { icon: Shield, label: 'Terms of Service', desc: 'View terms and conditions', action: () => navigate('/terms-conditions') },
      ]
    },
    {
      title: 'Support',
      items: [
        { icon: HelpCircle, label: 'Help & Support', desc: 'Get help from our team', action: () => navigate('/help-support') },
        { icon: Info, label: 'About', desc: 'About Government of Jharkhand', action: () => navigate('/about-us') },
      ]
    }
  ];

  return (
    <div className="min-h-screen bg-[#FAFAF5] pb-24 max-w-md mx-auto animate-fade-in">
      <AppHeader title="Settings" showBack={true} showProfile={false} />
      
      <div className="pt-20 px-4">
        <div className="bg-gradient-to-br from-[#43A047] to-[#1B5E20] rounded-3xl p-6 text-white shadow-lg mb-6 animate-scale-in">
          <div className="text-center">
            <div className="w-20 h-20 bg-white/20 rounded-full flex items-center justify-center mx-auto mb-3">
              <span className="text-4xl">⚙️</span>
            </div>
            <h2 className="text-xl mb-1">Settings</h2>
            <p className="text-sm opacity-90">Manage your preferences</p>
          </div>
        </div>

        {settingsSections.map((section, idx) => (
          <div key={idx} className="mb-6">
            <h3 className="text-[#1B5E20] mb-3 px-2">{section.title}</h3>
            <div className="bg-white rounded-2xl shadow-sm overflow-hidden animate-scale-in">
              {section.items.map((item, itemIdx) => {
                const Icon = item.icon;
                return (
                  <div key={itemIdx}>
                    <button
                      onClick={item.action}
                      className="w-full p-4 flex items-center justify-between hover:bg-[#FAFAF5] transition-colors"
                    >
                      <div className="flex items-center gap-3">
                        <div className="w-10 h-10 bg-[#E8F5E9] rounded-full flex items-center justify-center">
                          <Icon className="w-5 h-5 text-[#43A047]" />
                        </div>
                        <div className="text-left">
                          <div className="text-[#1B5E20]">{item.label}</div>
                          <div className="text-[#757575] text-xs">{item.desc}</div>
                        </div>
                      </div>
                      <ChevronRight className="w-5 h-5 text-[#757575]" />
                    </button>
                    {itemIdx < section.items.length - 1 && (
                      <div className="border-t border-[#FAFAF5] mx-4"></div>
                    )}
                  </div>
                );
              })}
            </div>
          </div>
        ))}

        <div className="bg-blue-50 border-2 border-blue-200 rounded-2xl p-4">
          <div className="flex items-start gap-3">
            <div className="text-2xl">ℹ️</div>
            <div>
              <div className="text-[#1B5E20] mb-1">Government of Jharkhand</div>
              <div className="text-[#757575] text-sm">
                FarmAura is an official initiative by the Government of Jharkhand to empower farmers with AI-powered farming solutions.
              </div>
              <div className="text-[#757575] text-xs mt-2">Version 1.0.0</div>
            </div>
          </div>
        </div>
      </div>

      {/* Language Selection Modal */}
      {showLanguageMenu && (
        <div className="fixed inset-0 bg-black/50 z-50 flex items-center justify-center p-4">
          <div className="bg-white rounded-3xl p-6 max-w-md w-full max-h-[70vh] overflow-y-auto animate-scale-in">
            <h3 className="text-[#1B5E20] text-xl mb-4">Select Language</h3>
            <div className="space-y-2">
              {languages.map((lang) => (
                <button
                  key={lang}
                  onClick={() => handleLanguageChange(lang)}
                  className={`w-full p-4 rounded-2xl text-left transition-colors ${
                    userLanguage === lang
                      ? 'bg-[#43A047] text-white'
                      : 'bg-[#FAFAF5] text-[#1B5E20] hover:bg-[#E8F5E9]'
                  }`}
                >
                  {lang}
                </button>
              ))}
            </div>
            <button
              onClick={() => setShowLanguageMenu(false)}
              className="w-full mt-4 p-3 bg-[#FAFAF5] text-[#757575] rounded-2xl hover:bg-[#E8F5E9] transition-colors"
            >
              Cancel
            </button>
          </div>
        </div>
      )}

      {/* Location Selection Modal */}
      {showLocationMenu && (
        <div className="fixed inset-0 bg-black/50 z-50 flex items-center justify-center p-4">
          <div className="bg-white rounded-3xl p-6 max-w-md w-full max-h-[70vh] overflow-y-auto animate-scale-in">
            <h3 className="text-[#1B5E20] text-xl mb-4">Select State</h3>
            
            {/* GPS Detection Button */}
            <button
              onClick={detectLocation}
              className="w-full p-4 mb-4 bg-gradient-to-r from-[#43A047] to-[#1B5E20] text-white rounded-2xl flex items-center justify-center gap-2 hover:shadow-lg transition-all"
            >
              <Navigation className="w-5 h-5" />
              Auto-Detect Location
            </button>

            <div className="space-y-2">
              {states.map((state) => (
                <button
                  key={state}
                  onClick={() => handleLocationChange(state)}
                  className={`w-full p-4 rounded-2xl text-left transition-colors ${
                    location?.state === state
                      ? 'bg-[#43A047] text-white'
                      : 'bg-[#FAFAF5] text-[#1B5E20] hover:bg-[#E8F5E9]'
                  }`}
                >
                  {state}
                </button>
              ))}
            </div>
            <button
              onClick={() => setShowLocationMenu(false)}
              className="w-full mt-4 p-3 bg-[#FAFAF5] text-[#757575] rounded-2xl hover:bg-[#E8F5E9] transition-colors"
            >
              Cancel
            </button>
          </div>
        </div>
      )}

      <FloatingIVR />
      <AppFooter />
    </div>
  );
}