import { X, Home, User, Settings, FileText, Gift, Languages, LogOut, Upload, DollarSign } from 'lucide-react';
import { useNavigate } from 'react-router-dom';
import { useState } from 'react';
import LanguageChangeModal from './LanguageChangeModal';

interface SideMenuProps {
  isOpen: boolean;
  onClose: () => void;
  userLanguage?: string;
  onLanguageChange?: (language: string) => void;
}

export default function SideMenu({ isOpen, onClose, userLanguage = 'English', onLanguageChange }: SideMenuProps) {
  const navigate = useNavigate();
  const [showLanguageModal, setShowLanguageModal] = useState(false);

  const handleNavigate = (path: string) => {
    navigate(path);
    onClose();
  };

  const handleLanguageClick = () => {
    setShowLanguageModal(true);
  };

  const handleLanguageChange = (language: string) => {
    if (onLanguageChange) {
      onLanguageChange(language);
    }
    setShowLanguageModal(false);
  };

  const menuItems = [
    { icon: Home, label: 'Home', path: '/dashboard', isNavigation: true },
    { icon: User, label: 'Profile', path: '/profile', isNavigation: true },
    { icon: DollarSign, label: 'Personal Finance', path: '/finance', isNavigation: true },
    { icon: Settings, label: 'Settings', path: '/settings', isNavigation: true },
    { icon: Upload, label: 'Soil Health Card Upload', path: '/soil', isNavigation: true },
    { icon: Gift, label: 'Government Schemes', path: '/community', isNavigation: true },
    { icon: Languages, label: 'Language', path: '', isNavigation: false, action: handleLanguageClick },
  ];

  if (!isOpen) return null;

  return (
    <>
      {/* Backdrop */}
      <div 
        className="fixed inset-0 bg-black/50 z-50 animate-fade-in max-w-md mx-auto"
        onClick={onClose}
      />
      
      {/* Side Menu Container */}
      <div className="fixed inset-0 z-[60] pointer-events-none max-w-md mx-auto">
        <div 
          className="absolute top-0 right-0 bottom-0 bg-white shadow-2xl animate-slide-in-right pointer-events-auto"
          style={{
            width: 'min(288px, calc(100% - 3rem))'
          }}
        >
          <div className="flex flex-col h-full">
            {/* Header */}
            <div className="bg-gradient-to-br from-[#43A047] to-[#1B5E20] p-6 text-white relative">
              <button 
                onClick={onClose}
                className="absolute top-4 right-4 p-2 hover:bg-white/20 rounded-full transition-colors"
              >
                <X className="w-6 h-6" />
              </button>
              <div className="mt-4">
                <div className="w-16 h-16 bg-white/20 rounded-full flex items-center justify-center mb-3">
                  <span className="text-3xl">🌾</span>
                </div>
                <h2 className="text-xl">FarmAura</h2>
                <p className="text-sm opacity-90">Government of Jharkhand</p>
              </div>
            </div>

            {/* Menu Items */}
            <div className="flex-1 overflow-y-auto p-4">
              {menuItems.map((item) => {
                const Icon = item.icon;
                return (
                  <button
                    key={item.label}
                    onClick={() => item.isNavigation ? handleNavigate(item.path) : item.action?.()}
                    className="w-full flex items-center gap-4 p-4 hover:bg-[#FAFAF5] rounded-2xl transition-colors mb-2"
                  >
                    <Icon className="w-5 h-5 text-[#43A047]" />
                    <span className="text-[#1B5E20]">{item.label}</span>
                    {item.label === 'Language' && (
                      <span className="ml-auto text-xs text-[#757575]">{userLanguage}</span>
                    )}
                  </button>
                );
              })}
            </div>

            {/* Logout */}
            <div className="p-4 border-t border-[#FAFAF5]">
              <button
                onClick={() => handleNavigate('/')}
                className="w-full flex items-center gap-4 p-4 hover:bg-red-50 rounded-2xl transition-colors text-red-600"
              >
                <LogOut className="w-5 h-5" />
                <span>Logout</span>
              </button>
            </div>
          </div>
        </div>
      </div>

      {/* Language Change Modal */}
      <LanguageChangeModal
        isOpen={showLanguageModal}
        onClose={() => setShowLanguageModal(false)}
        currentLanguage={userLanguage}
        onLanguageChange={handleLanguageChange}
      />
    </>
  );
}