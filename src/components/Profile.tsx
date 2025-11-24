import { useNavigate } from 'react-router-dom';
import { useState } from 'react';
import AppHeader from './AppHeader';
import AppFooter from './AppFooter';
import FloatingIVR from './FloatingIVR';
import { MapPin, Droplets, TrendingUp, Edit2, Settings, LogOut, DollarSign } from 'lucide-react';

interface ProfileProps {
  userData: any;
  setUserData?: any;
  location?: any;
  setLocation?: any;
}

export default function Profile({ userData, setUserData, location, setLocation }: ProfileProps) {
  const navigate = useNavigate();

  const farmInfo = {
    landSize: userData.landSize || '2-5 Acres',
    irrigation: userData.irrigation || 'Borewell',
    soilType: 'Loamy',
    crops: ['Cotton', 'Wheat', 'Soybean']
  };

  const cropHistory = [
    { crop: 'Cotton', season: 'Kharif 2024', yield: '18 quintals', profit: '₹75,000', icon: '🌾' },
    { crop: 'Wheat', season: 'Rabi 2023-24', yield: '32 quintals', profit: '₹65,000', icon: '🌾' },
    { crop: 'Soybean', season: 'Kharif 2023', yield: '14 quintals', profit: '₹48,000', icon: '🫘' }
  ];

  const savedRecommendations = [
    { crop: 'Cotton', score: 95, date: 'Nov 20, 2024' },
    { crop: 'Maize', score: 88, date: 'Nov 15, 2024' },
    { crop: 'Tomato', score: 82, date: 'Nov 10, 2024' }
  ];

  return (
    <div className="min-h-screen bg-[#FAFAF5] pb-24 max-w-md mx-auto">
      <AppHeader />
      <div className="pt-20 px-4">
        <h1 className="text-[#1B5E20] text-3xl mb-6">My Profile</h1>

        {/* Profile Card */}
        <div className="bg-gradient-to-br from-[#43A047] to-[#1B5E20] rounded-3xl p-6 text-white shadow-lg mb-6">
          <div className="flex items-start justify-between mb-4">
            <div className="flex items-center gap-4">
              <div className="w-20 h-20 bg-white rounded-full flex items-center justify-center text-4xl">
                👨‍🌾
              </div>
              <div>
                <h2 className="text-2xl mb-1">{userData.name || 'Farmer'}</h2>
                <div className="flex items-center gap-2 text-sm opacity-90">
                  <MapPin className="w-4 h-4" />
                  <span>{userData.village || 'Village'}, {userData.district || location?.district || 'District'}</span>
                </div>
                <div className="text-sm opacity-90">{userData.state || location?.state || 'State'}</div>
                <div className="text-sm opacity-90 mt-1">📱 {userData.phone || '+91 XXXXXXXXXX'}</div>
              </div>
            </div>
            <button 
              onClick={() => navigate('/profile-edit')}
              className="p-2 bg-white/20 rounded-full hover:bg-white/30 transition-colors"
              aria-label="Edit Profile"
            >
              <Edit2 className="w-5 h-5" />
            </button>
          </div>
          <div className="grid grid-cols-3 gap-3 pt-4 border-t border-white/30">
            <div className="text-center">
              <div className="text-2xl mb-1">12</div>
              <div className="text-xs opacity-90">Crops Grown</div>
            </div>
            <div className="text-center">
              <div className="text-2xl mb-1">3</div>
              <div className="text-xs opacity-90">Active Fields</div>
            </div>
            <div className="text-center">
              <div className="text-2xl mb-1">4.8</div>
              <div className="text-xs opacity-90">Rating</div>
            </div>
          </div>
        </div>

        {/* Farm Summary */}
        <h3 className="text-[#1B5E20] mb-3">My Farm Summary</h3>
        <div className="grid grid-cols-2 gap-3 mb-6">
          <div className="bg-white rounded-2xl p-4 shadow-sm">
            <div className="text-[#757575] text-sm mb-1">Land Size</div>
            <div className="text-[#1B5E20]">{farmInfo.landSize}</div>
          </div>
          <div className="bg-white rounded-2xl p-4 shadow-sm">
            <div className="flex items-center gap-2 text-[#757575] text-sm mb-1">
              <Droplets className="w-4 h-4" />
              <span>Irrigation</span>
            </div>
            <div className="text-[#1B5E20]">{farmInfo.irrigation}</div>
          </div>
          <div className="bg-white rounded-2xl p-4 shadow-sm col-span-2">
            <div className="text-[#757575] text-sm mb-1">Soil Type</div>
            <div className="text-[#1B5E20]">{farmInfo.soilType}</div>
          </div>
        </div>

        {/* Crop History */}
        <h3 className="text-[#1B5E20] mb-3">Crop History</h3>
        <div className="flex gap-3 overflow-x-auto pb-4 mb-6">
          {cropHistory.map((crop, idx) => (
            <div key={idx} className="bg-white rounded-2xl p-4 min-w-[260px] shadow-sm">
              <div className="flex items-center gap-3 mb-3">
                <div className="text-4xl">{crop.icon}</div>
                <div>
                  <div className="text-[#1B5E20]">{crop.crop}</div>
                  <div className="text-[#757575] text-sm">{crop.season}</div>
                </div>
              </div>
              <div className="space-y-2 text-sm">
                <div className="flex justify-between">
                  <span className="text-[#757575]">Yield:</span>
                  <span className="text-[#1B5E20]">{crop.yield}</span>
                </div>
                <div className="flex justify-between">
                  <span className="text-[#757575]">Profit:</span>
                  <span className="text-green-600">{crop.profit}</span>
                </div>
              </div>
            </div>
          ))}
        </div>

        {/* Saved Recommendations */}
        <h3 className="text-[#1B5E20] mb-3">Saved Recommendations</h3>
        <div className="space-y-3 mb-6">
          {savedRecommendations.map((rec, idx) => (
            <div key={idx} className="bg-white rounded-2xl p-4 shadow-sm flex items-center justify-between">
              <div>
                <div className="text-[#1B5E20] mb-1">{rec.crop}</div>
                <div className="text-[#757575] text-sm">{rec.date}</div>
              </div>
              <div className="text-right">
                <div className="text-[#43A047] mb-1">{rec.score}%</div>
                <button className="text-[#757575] text-sm hover:text-[#43A047]">View</button>
              </div>
            </div>
          ))}
        </div>

        {/* Settings Options */}
        <div className="bg-white rounded-2xl shadow-sm overflow-hidden mb-6">
          <button 
            onClick={() => navigate('/profile-edit')}
            className="w-full p-4 flex items-center justify-between hover:bg-[#FAFAF5] transition-colors"
          >
            <div className="flex items-center gap-3">
              <Edit2 className="w-5 h-5 text-[#43A047]" />
              <span className="text-[#1B5E20]">Edit Profile</span>
            </div>
          </button>
          <div className="border-t border-[#FAFAF5]"></div>
          <button 
            onClick={() => navigate('/finance')}
            className="w-full p-4 flex items-center justify-between hover:bg-[#FAFAF5] transition-colors"
          >
            <div className="flex items-center gap-3">
              <DollarSign className="w-5 h-5 text-[#43A047]" />
              <span className="text-[#1B5E20]">Personal Finance</span>
            </div>
          </button>
          <div className="border-t border-[#FAFAF5]"></div>
          <button 
            onClick={() => navigate('/farm-setup')}
            className="w-full p-4 flex items-center justify-between hover:bg-[#FAFAF5] transition-colors"
          >
            <div className="flex items-center gap-3">
              <TrendingUp className="w-5 h-5 text-[#43A047]" />
              <span className="text-[#1B5E20]">Manage Farms</span>
            </div>
          </button>
          <div className="border-t border-[#FAFAF5]"></div>
          <button 
            onClick={() => navigate('/settings')}
            className="w-full p-4 flex items-center justify-between hover:bg-[#FAFAF5] transition-colors"
          >
            <div className="flex items-center gap-3">
              <Settings className="w-5 h-5 text-[#43A047]" />
              <span className="text-[#1B5E20]">Settings</span>
            </div>
          </button>
          <div className="border-t border-[#FAFAF5]"></div>
          <button 
            onClick={() => navigate('/')}
            className="w-full p-4 flex items-center justify-between hover:bg-red-50 transition-colors"
          >
            <div className="flex items-center gap-3">
              <LogOut className="w-5 h-5 text-red-600" />
              <span className="text-red-600">Logout</span>
            </div>
          </button>
        </div>
      </div>

      <FloatingIVR />
      <AppFooter />
    </div>
  );
}