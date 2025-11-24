import { useNavigate } from 'react-router-dom';
import AppHeader from './AppHeader';
import AppFooter from './AppFooter';
import FloatingIVR from './FloatingIVR';
import LocationMapPopup from './LocationMapPopup';
import { Progress } from './ui/progress';
import { Sun, Droplets, TrendingUp, Sprout, Bug, TestTube, DollarSign, TrendingDown, Users, Mic, MapPin, Heart, Leaf, AlertCircle, CloudRain, TrendingUpIcon, ChevronRight, Wind, CloudDrizzle } from 'lucide-react';
import { useState } from 'react';
import { t } from '../utils/translations';
import exampleImage from 'figma:asset/1e8cc99a7cf42c1fafcdc9e6256b23fcfff80333.png';

interface DashboardProps {
  userData: any;
  location: any;
  userLanguage?: string;
  onLanguageChange?: (language: string) => void;
}

export default function Dashboard({ userData, location, userLanguage = 'English', onLanguageChange }: DashboardProps) {
  const navigate = useNavigate();
  const name = userData.name || 'Farmer';

  const getGreeting = () => {
    const hour = new Date().getHours();
    if (hour < 12) return t('goodMorning', userLanguage);
    if (hour < 17) return t('goodAfternoon', userLanguage);
    return t('goodEvening', userLanguage);
  };

  const weatherForecast = [
    { day: 'Mon', temp: '32°C', icon: '☀️' },
    { day: 'Tue', temp: '28°C', icon: '⛅' },
    { day: 'Wed', temp: '26°C', icon: '🌧️' },
    { day: 'Thu', temp: '30°C', icon: '⛅' },
    { day: 'Fri', temp: '33°C', icon: '☀️' },
  ];

  const alerts = [
    { type: 'Pest Alert', text: 'High pest activity in nearby farms', color: 'bg-red-100' },
    { type: 'Rain Expected', text: 'Heavy rain expected tomorrow', color: 'bg-blue-100' },
    { type: 'Price Drop', text: 'Tomato prices increased by 15%', color: 'bg-green-100' },
  ];

  const tips = [
    { text: 'Best time for sowing wheat is November', icon: '🌾' },
    { text: 'Check soil moisture before irrigation', icon: '💧' },
    { text: 'Use neem oil for organic pest control', icon: '🌿' },
  ];

  const quickActions = [
    { icon: Sprout, label: 'Crop Advisor', path: '/crop-rec', color: 'bg-[#43A047]' },
    { icon: Bug, label: 'Pest Scanner', path: '/pest', color: 'bg-[#FFC107]' },
    { icon: TestTube, label: 'Soil Test', path: '/soil', color: 'bg-[#8D6E63]' },
    { icon: DollarSign, label: 'Market Prices', path: '/market', color: 'bg-[#1B5E20]' },
    { icon: TrendingDown, label: 'Profit & Loss', path: '/finance', color: 'bg-[#43A047]' },
    { icon: Users, label: 'Community', path: '/community', color: 'bg-[#FFC107]' },
  ];

  const [showLocationMap, setShowLocationMap] = useState(false);

  return (
    <div className="min-h-screen bg-[#FAFAF5] pb-24 max-w-md mx-auto animate-fade-in">
      <AppHeader showBack={false} showProfile={true} userLanguage={userLanguage} onLanguageChange={onLanguageChange} />
      <div className="pt-20 px-4">
        {/* Greeting */}
        <div className="mb-6 animate-scale-in">
          <h1 className="text-[#1B5E20] text-3xl mb-1">{getGreeting()}, {name}! 👋</h1>
          <button 
            onClick={() => setShowLocationMap(true)}
            className="flex items-center gap-2 text-[#757575] hover:text-[#1B5E20] transition-all group"
          >
            <MapPin className="w-4 h-4 text-red-500 animate-bounce group-hover:scale-125 transition-transform" />
            <p className="cursor-pointer hover:underline hover:text-[#43A047] transition-all">Location: {location.district}, {location.state}</p>
          </button>
        </div>

        {/* AI Assistant Bar */}
        <div className="bg-white rounded-2xl p-4 mb-6 shadow-sm flex items-center gap-3 card-hover animate-scale-in">
          <button className="w-10 h-10 bg-gradient-to-br from-[#43A047] to-[#1B5E20] rounded-full flex items-center justify-center shadow-md">
            <Mic className="w-5 h-5 text-white" />
          </button>
          <input
            type="text"
            placeholder="Ask AI Assistant anything..."
            className="flex-1 bg-transparent focus:outline-none text-[#1B5E20]"
            onFocus={() => navigate('/ai-chat')}
          />
        </div>

        {/* Map + Weather + Info Cards Section */}
        <div className="mb-6">
          <div className="flex items-center justify-between mb-3">
            <h2 className="text-[#1B5E20] text-2xl">Dashboard</h2>
            <span className="text-[#757575] text-sm">Today</span>
          </div>

          {/* Map and Side Cards Container */}
          <div className="grid grid-cols-2 gap-3 mb-4">
            {/* Map Card */}
            <button
              onClick={() => setShowLocationMap(true)}
              className="bg-white rounded-2xl p-4 shadow-lg hover:shadow-xl transition-all card-hover aspect-square flex items-center justify-center overflow-hidden relative"
            >
              <iframe
                src={`https://maps.google.com/maps?q=${location.district},${location.state}&t=&z=13&ie=UTF8&iwloc=&output=embed`}
                className="absolute inset-0 w-full h-full"
                style={{ border: 0, pointerEvents: 'none' }}
                loading="lazy"
              ></iframe>
              <div className="absolute inset-0 bg-gradient-to-t from-black/20 to-transparent"></div>
            </button>

            {/* Weather Card */}
            <div className="bg-white rounded-2xl p-4 shadow-lg">
              <div className="mb-2">
                <h3 className="text-[#757575] text-xs mb-1">{location.district}, {location.state}</h3>
                <div className="flex items-baseline gap-1 mb-3">
                  <span className="text-[#1B5E20] text-3xl">28.0°C</span>
                  <span className="text-[#757575] text-xs">Partly Cloudy</span>
                </div>
              </div>

              <div className="space-y-2">
                <div className="flex items-center gap-2 bg-[#F5F5F5] rounded-lg px-2 py-1.5">
                  <Droplets className="w-3 h-3 text-[#43A047]" />
                  <span className="text-[#757575] text-xs">68% humidity</span>
                </div>
                <div className="flex items-center gap-2 bg-[#F5F5F5] rounded-lg px-2 py-1.5">
                  <Wind className="w-3 h-3 text-[#43A047]" />
                  <span className="text-[#757575] text-xs">9.5 km/h wind</span>
                </div>
                <div className="flex items-center gap-2 bg-[#F5F5F5] rounded-lg px-2 py-1.5">
                  <CloudDrizzle className="w-3 h-3 text-[#43A047]" />
                  <span className="text-[#757575] text-xs">24% rain</span>
                </div>
              </div>
            </div>
          </div>
        </div>

        {/* Quick Actions */}
        <div className="mb-6">
          <h3 className="text-[#1B5E20] mb-3">Quick Actions</h3>
          <div className="grid grid-cols-3 gap-3">
            {quickActions.map((action, idx) => {
              const Icon = action.icon;
              return (
                <button
                  key={idx}
                  onClick={() => navigate(action.path)}
                  className={`${action.color} rounded-2xl p-4 text-white shadow-lg flex flex-col items-center gap-2 card-hover animate-scale-in`}
                >
                  <Icon className="w-8 h-8" />
                  <span className="text-xs text-center">{action.label}</span>
                </button>
              );
            })}
          </div>
        </div>

        {/* Important Updates */}
        <div className="mb-6 animate-scale-in">
          <h3 className="text-[#1B5E20] mb-3">Important Updates</h3>
          <div className="space-y-2">
            {/* High Priority - Pest Alert */}
            <button
              onClick={() => navigate('/pest-alerts')}
              className="w-full bg-red-500/10 backdrop-blur-md rounded-2xl p-4 hover:bg-red-500/15 transition-all flex items-center gap-3"
            >
              <div className="w-10 h-10 bg-red-500/20 backdrop-blur-sm rounded-xl flex items-center justify-center flex-shrink-0">
                <Bug className="w-5 h-5 text-red-600" />
              </div>
              <div className="flex-1 text-left">
                <span className="text-[#1B5E20]">Pest & Alerts</span>
              </div>
              <ChevronRight className="w-4 h-4 text-red-500" />
            </button>

            {/* Medium Priority - Weather */}
            <button
              onClick={() => navigate('/weather')}
              className="w-full bg-orange-500/10 backdrop-blur-md rounded-2xl p-4 hover:bg-orange-500/15 transition-all flex items-center gap-3"
            >
              <div className="w-10 h-10 bg-orange-500/20 backdrop-blur-sm rounded-xl flex items-center justify-center flex-shrink-0">
                <CloudRain className="w-5 h-5 text-orange-600" />
              </div>
              <div className="flex-1 text-left">
                <span className="text-[#1B5E20]">Heavy Rain Tomorrow</span>
              </div>
              <ChevronRight className="w-4 h-4 text-orange-500" />
            </button>

            {/* Good News - Market */}
            <button
              onClick={() => navigate('/market')}
              className="w-full bg-green-500/10 backdrop-blur-md rounded-2xl p-4 hover:bg-green-500/15 transition-all flex items-center gap-3"
            >
              <div className="w-10 h-10 bg-green-500/20 backdrop-blur-sm rounded-xl flex items-center justify-center flex-shrink-0">
                <TrendingUpIcon className="w-5 h-5 text-green-600" />
              </div>
              <div className="flex-1 text-left">
                <span className="text-[#1B5E20]">Wheat Price ↑ ₹80</span>
              </div>
              <ChevronRight className="w-4 h-4 text-green-500" />
            </button>
          </div>
        </div>

        {/* Performance Metrics */}
        <div className="mb-6">
          <h3 className="text-[#1B5E20] mb-3">Farm Performance</h3>
          <div className="bg-gradient-to-br from-white to-[#F1F8E9] rounded-3xl p-5 shadow-lg animate-scale-in border border-[#E8F5E9]">
            <div className="space-y-5">
              {/* Crop Health */}
              <div>
                <div className="flex justify-between items-center mb-2.5">
                  <div className="flex items-center gap-3">
                    <div className="w-10 h-10 rounded-full bg-gradient-to-br from-[#66BB6A] to-[#43A047] flex items-center justify-center shadow-md">
                      <Heart className="w-5 h-5 text-white" />
                    </div>
                    <span className="text-[#1B5E20]">Crop Health</span>
                  </div>
                  <span className="text-[#43A047] px-3 py-1 bg-[#E8F5E9] rounded-full text-sm">92%</span>
                </div>
                <Progress value={92} className="h-2.5" indicatorClassName="bg-gradient-to-r from-[#66BB6A] to-[#43A047]" />
              </div>

              {/* Profit Margin */}
              <div>
                <div className="flex justify-between items-center mb-2.5">
                  <div className="flex items-center gap-3">
                    <div className="w-10 h-10 rounded-full bg-gradient-to-br from-[#FFC107] to-[#FF9800] flex items-center justify-center shadow-md">
                      <DollarSign className="w-5 h-5 text-white" />
                    </div>
                    <span className="text-[#1B5E20]">Profit Margin</span>
                  </div>
                  <span className="text-[#FF9800] px-3 py-1 bg-[#FFF8E1] rounded-full text-sm">78%</span>
                </div>
                <Progress value={78} className="h-2.5" indicatorClassName="bg-gradient-to-r from-[#FFC107] to-[#FF9800]" />
              </div>

              {/* Soil Quality */}
              <div>
                <div className="flex justify-between items-center mb-2.5">
                  <div className="flex items-center gap-3">
                    <div className="w-10 h-10 rounded-full bg-gradient-to-br from-[#A1887F] to-[#8D6E63] flex items-center justify-center shadow-md">
                      <Leaf className="w-5 h-5 text-white" />
                    </div>
                    <span className="text-[#1B5E20]">Soil Quality</span>
                  </div>
                  <span className="text-[#8D6E63] px-3 py-1 bg-[#EFEBE9] rounded-full text-sm">88%</span>
                </div>
                <Progress value={88} className="h-2.5" indicatorClassName="bg-gradient-to-r from-[#A1887F] to-[#8D6E63]" />
              </div>
            </div>
          </div>
        </div>
      </div>

      <FloatingIVR />
      <AppFooter />
      {showLocationMap && <LocationMapPopup location={location} onClose={() => setShowLocationMap(false)} />}
    </div>
  );
}