import { useNavigate, useLocation } from 'react-router-dom';
import { Bug, Sprout, Home, User, Video } from 'lucide-react';

export default function AppFooter() {
  const navigate = useNavigate();
  const location = useLocation();

  const navItems = [
    { icon: Bug, label: 'Pest Detection', path: '/pest', shortLabel: 'Pest' },
    { icon: Sprout, label: 'Crop Rec', path: '/crop-rec', shortLabel: 'Crop' },
    { icon: Home, label: 'Dashboard', path: '/dashboard', shortLabel: 'Home' },
    { icon: User, label: 'Profile', path: '/profile', shortLabel: 'Profile' },
    { icon: Video, label: 'Entertainment', path: '/videos', shortLabel: 'Videos' }
  ];

  return (
    <div className="fixed bottom-0 left-0 right-0 bg-white shadow-lg z-50 max-w-md mx-auto">
      <div className="flex items-center justify-around p-2 py-3">
        {navItems.map((item) => {
          const Icon = item.icon;
          const isActive = location.pathname === item.path;
          return (
            <button
              key={item.path}
              onClick={() => navigate(item.path)}
              className={`flex flex-col items-center gap-0.5 min-w-0 flex-1 ${
                isActive ? 'text-[#43A047]' : 'text-[#757575]'
              }`}
            >
              <Icon className="w-6 h-6 flex-shrink-0" />
              <span className="text-[10px] sm:text-xs truncate max-w-full px-0.5">{item.shortLabel}</span>
            </button>
          );
        })}
      </div>
    </div>
  );
}