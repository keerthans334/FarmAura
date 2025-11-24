import { useState } from 'react';
import { X, Check } from 'lucide-react';

interface LanguageChangeModalProps {
  isOpen: boolean;
  onClose: () => void;
  currentLanguage: string;
  onLanguageChange: (language: string) => void;
}

export default function LanguageChangeModal({ 
  isOpen, 
  onClose, 
  currentLanguage, 
  onLanguageChange 
}: LanguageChangeModalProps) {
  const languages = [
    { code: 'en', name: 'English', nativeName: 'English', flag: '🇬🇧' },
    { code: 'hi', name: 'Hindi', nativeName: 'हिंदी', flag: '🇮🇳' },
    { code: 'bn', name: 'Bengali', nativeName: 'বাংলা', flag: '🇮🇳' },
    { code: 'np', name: 'Nagpuri', nativeName: 'नागपुरी', flag: '🇮🇳' },
    { code: 'ku', name: 'Kurmali', nativeName: 'कुड़माली', flag: '🇮🇳' },
    { code: 'sa', name: 'Santhali', nativeName: 'ᱥᱟᱱᱛᱟᱲᱤ', flag: '🇮🇳' }
  ];

  const [selectedLanguage, setSelectedLanguage] = useState(currentLanguage);

  const handleLanguageSelect = (langName: string) => {
    setSelectedLanguage(langName);
  };

  const handleConfirm = () => {
    onLanguageChange(selectedLanguage);
    onClose();
  };

  if (!isOpen) return null;

  return (
    <div className="fixed inset-0 bg-black/50 z-[70] flex items-center justify-center p-4">
      <div className="bg-white rounded-3xl max-w-md w-full max-h-[80vh] overflow-y-auto animate-scale-in">
        {/* Header */}
        <div className="sticky top-0 bg-gradient-to-br from-[#43A047] to-[#1B5E20] p-6 text-white rounded-t-3xl">
          <div className="flex items-center justify-between">
            <div>
              <h2 className="text-xl mb-1">Change Language</h2>
              <p className="text-sm opacity-90">Select your preferred language</p>
            </div>
            <button
              onClick={onClose}
              className="w-10 h-10 bg-white/20 rounded-full flex items-center justify-center hover:bg-white/30 transition-colors"
            >
              <X className="w-6 h-6" />
            </button>
          </div>
        </div>

        {/* Language Options */}
        <div className="p-6 space-y-3">
          {languages.map((lang) => (
            <button
              key={lang.code}
              onClick={() => handleLanguageSelect(lang.name)}
              className={`w-full p-4 rounded-2xl border-2 transition-all flex items-center justify-between ${
                selectedLanguage === lang.name
                  ? 'bg-[#E8F5E9] border-[#43A047] shadow-md'
                  : 'bg-[#FAFAF5] border-transparent hover:border-[#C8E6C9]'
              }`}
            >
              <div className="flex items-center gap-3">
                <span className="text-3xl">{lang.flag}</span>
                <div className="text-left">
                  <div className={`${selectedLanguage === lang.name ? 'text-[#1B5E20]' : 'text-[#757575]'}`}>
                    {lang.name}
                  </div>
                  <div className={`text-sm ${selectedLanguage === lang.name ? 'text-[#43A047]' : 'text-[#757575]'}`}>
                    {lang.nativeName}
                  </div>
                </div>
              </div>
              {selectedLanguage === lang.name && (
                <Check className="w-6 h-6 text-[#43A047]" />
              )}
            </button>
          ))}
        </div>

        {/* Footer Actions */}
        <div className="p-6 border-t border-[#FAFAF5] flex gap-3">
          <button
            onClick={onClose}
            className="flex-1 py-3 bg-[#FAFAF5] text-[#757575] rounded-2xl hover:bg-[#E8F5E9] transition-colors"
          >
            Cancel
          </button>
          <button
            onClick={handleConfirm}
            className="flex-1 py-3 bg-gradient-to-r from-[#43A047] to-[#1B5E20] text-white rounded-2xl hover:shadow-lg transition-all"
          >
            Apply
          </button>
        </div>
      </div>
    </div>
  );
}
