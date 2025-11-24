import { Menu, ArrowLeft, MoreVertical } from 'lucide-react';
import { useNavigate } from 'react-router-dom';
import { useState } from 'react';
import SideMenu from './SideMenu';

interface AppHeaderProps {
  title?: string;
  showBack?: boolean;
  showProfile?: boolean;
  userLanguage?: string;
  onLanguageChange?: (language: string) => void;
}

export default function AppHeader({ title, showBack = false, showProfile = true, userLanguage = 'English', onLanguageChange }: AppHeaderProps) {
  const navigate = useNavigate();
  const [showMenu, setShowMenu] = useState(false);

  return (
    <>
      <div className="fixed top-0 left-0 right-0 bg-white shadow-sm z-50 max-w-md mx-auto animate-fade-in">
        <div className="flex items-center justify-between p-4">
          <div className="flex items-center gap-3">
            {showBack && (
              <button 
                onClick={() => navigate(-1)}
                className="p-2 hover:bg-[#FAFAF5] rounded-full transition-colors"
              >
                <ArrowLeft className="w-5 h-5 text-[#1B5E20]" />
              </button>
            )}
            {showProfile && !showBack && (
              <button 
                onClick={() => navigate('/profile')}
                className="w-10 h-10 bg-gradient-to-br from-[#43A047] to-[#1B5E20] rounded-full flex items-center justify-center shadow-md hover:opacity-90 transition-opacity"
              >
                <span className="text-white">👤</span>
              </button>
            )}
            {title && (
              <h2 className="text-[#1B5E20] text-lg">{title}</h2>
            )}
          </div>
          
          <div className="flex items-center gap-2">
            <button 
              onClick={() => setShowMenu(true)}
              className="p-2 hover:bg-[#FAFAF5] rounded-full transition-colors"
            >
              <MoreVertical className="w-5 h-5 text-[#1B5E20]" />
            </button>
          </div>
        </div>
      </div>

      <SideMenu 
        isOpen={showMenu} 
        onClose={() => setShowMenu(false)} 
        userLanguage={userLanguage}
        onLanguageChange={onLanguageChange}
      />
    </>
  );
}