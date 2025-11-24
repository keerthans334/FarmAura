import { useNavigate } from 'react-router-dom';
import { Check } from 'lucide-react';
import { useState } from 'react';

interface LanguageSelectionProps {
  setLanguage: (lang: string) => void;
}

export default function LanguageSelection({ setLanguage }: LanguageSelectionProps) {
  const navigate = useNavigate();
  const [selected, setSelected] = useState('English');

  const languages = [
    { code: 'en', name: 'English', native: 'English' },
    { code: 'hi', name: 'Hindi', native: 'हिंदी' },
    { code: 'bn', name: 'Bengali', native: 'বাংলা' },
    { code: 'nag', name: 'Nagpuri', native: 'नागपुरी' },
    { code: 'kur', name: 'Kurmali', native: 'कुड़माली' },
    { code: 'sat', name: 'Santhali', native: 'ᱥᱟᱱᱛᱟᱲᱤ' },
  ];

  const handleSelect = (lang: string) => {
    setSelected(lang);
    setLanguage(lang);
  };

  return (
    <div className="min-h-screen bg-[#FAFAF5] p-6 max-w-md mx-auto animate-fade-in">
      <div className="pt-6">
        <h2 className="text-[#1B5E20] text-3xl mb-2">Choose Your Language</h2>
        <p className="text-[#757575] text-sm mb-8">Select your preferred language for the app</p>

        <div className="space-y-3">
          {languages.map((lang) => (
            <button
              key={lang.code}
              onClick={() => handleSelect(lang.name)}
              className={`w-full p-4 rounded-2xl flex items-center justify-between transition-all card-hover ${
                selected === lang.name
                  ? 'bg-gradient-to-r from-[#43A047] to-[#1B5E20] text-white shadow-lg'
                  : 'bg-white text-[#1B5E20] shadow-sm'
              }`}
            >
              <div className="flex items-center gap-3">
                <span className="text-2xl">{lang.native}</span>
              </div>
              {selected === lang.name && <Check className="w-6 h-6" />}
            </button>
          ))}
        </div>

        <button
          onClick={() => navigate('/login')}
          className="w-full bg-gradient-to-r from-[#43A047] to-[#1B5E20] text-white py-4 rounded-2xl mt-8 shadow-lg hover:shadow-xl transition-all hover:scale-105"
        >
          Continue
        </button>
      </div>
    </div>
  );
}