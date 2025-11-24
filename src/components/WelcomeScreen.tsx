import { useNavigate } from 'react-router-dom';
import { Sprout, Sparkles, Globe } from 'lucide-react';
import { useState } from 'react';

interface WelcomeScreenProps {
  setLanguage: (lang: string) => void;
}

export default function WelcomeScreen({ setLanguage }: WelcomeScreenProps) {
  const navigate = useNavigate();
  const [selectedLanguage, setSelectedLanguage] = useState('English');
  const [showAllLanguages, setShowAllLanguages] = useState(false);

  const allLanguages = [
    { code: 'en', name: 'English', native: 'English' },
    { code: 'hi', name: 'Hindi', native: 'हिंदी' },
    { code: 'bn', name: 'Bengali', native: 'বাংলা' },
    { code: 'nag', name: 'Nagpuri', native: 'नागपुरी' },
    { code: 'kur', name: 'Kurmali', native: 'कुड़माली' },
    { code: 'sat', name: 'Santhali', native: 'ᱥᱟᱱᱛᱟᱲᱤ' },
  ];

  const handleLanguageSelect = (lang: string) => {
    setSelectedLanguage(lang);
    setLanguage(lang);
    setShowAllLanguages(false);
  };

  const handleGetStarted = () => {
    navigate('/login', { state: { isNewUser: true } });
  };

  return (
    <div className="min-h-screen bg-gradient-to-b from-[#E8F5E9] to-white flex flex-col items-center justify-between p-6 max-w-md mx-auto">
      {/* Logo Section */}
      <div className="text-center mt-20 animate-fade-in">
        <div className="mb-8 relative">
          <div className="w-32 h-32 mx-auto bg-gradient-to-br from-[#43A047] to-[#1B5E20] rounded-3xl shadow-2xl flex items-center justify-center animate-scale-in">
            <Sprout className="w-16 h-16 text-white" />
          </div>
          <div className="absolute -top-2 -right-2 w-12 h-12 bg-[#FFC107] rounded-full flex items-center justify-center shadow-lg animate-scale-in">
            <Sparkles className="w-6 h-6 text-white" />
          </div>
        </div>
        <h1 className="text-[#1B5E20] text-5xl mb-3">FarmAura</h1>
        <p className="text-[#757575]">Government of Jharkhand</p>
      </div>

      {/* Action Buttons and Language Selection */}
      <div className="w-full space-y-4 mb-8">
        <button
          onClick={handleGetStarted}
          className="w-full bg-gradient-to-r from-[#43A047] to-[#1B5E20] text-white py-5 rounded-2xl shadow-xl hover:shadow-2xl transition-all hover:scale-105"
        >
          Get Started
        </button>
        <button
          onClick={() => navigate('/login')}
          className="w-full bg-white border-2 border-[#43A047] text-[#43A047] py-5 rounded-2xl hover:bg-[#FAFAF5] transition-all hover:scale-105 shadow-md"
        >
          Login
        </button>
        <p className="text-[#757575] text-sm text-center pt-2">
          Already have an account? Login to continue
        </p>

        {/* Compact Language Selection */}
        <div className="pt-4">
          <button
            onClick={() => setShowAllLanguages(!showAllLanguages)}
            className="w-full flex items-center justify-center gap-3 bg-white border-2 border-[#43A047]/30 rounded-xl py-4 hover:border-[#43A047] hover:bg-[#E8F5E9] transition-all shadow-sm"
          >
            <Globe className="w-5 h-5 text-[#43A047]" />
            <span className="text-[#1B5E20]">{selectedLanguage}</span>
            <span className="text-[#43A047]">▼</span>
          </button>

          {/* Language Dropdown */}
          {showAllLanguages && (
            <div className="mt-2 bg-white rounded-xl shadow-lg p-2 animate-fade-in border-2 border-[#43A047]">
              {allLanguages.map((lang) => (
                <button
                  key={lang.code}
                  onClick={() => handleLanguageSelect(lang.name)}
                  className={`w-full px-4 py-3 rounded-lg text-left transition-all ${
                    selectedLanguage === lang.name
                      ? 'bg-[#43A047] text-white'
                      : 'hover:bg-[#E8F5E9] text-[#1B5E20]'
                  }`}
                >
                  <span>{lang.native}</span>
                </button>
              ))}
            </div>
          )}
        </div>
      </div>
    </div>
  );
}