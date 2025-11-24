import { useNavigate } from 'react-router-dom';
import AppHeader from './AppHeader';
import AppFooter from './AppFooter';
import FloatingIVR from './FloatingIVR';
import { ArrowLeft, Droplets, Wind, Eye, Gauge } from 'lucide-react';

export default function WeatherDetails() {
  const navigate = useNavigate();

  const forecast = [
    { day: 'Today', date: 'Nov 21', icon: '☀️', high: 32, low: 22, rain: 10, humidity: 65, wind: 12 },
    { day: 'Tomorrow', date: 'Nov 22', icon: '⛅', high: 28, low: 20, rain: 30, humidity: 72, wind: 15 },
    { day: 'Saturday', date: 'Nov 23', icon: '🌧️', high: 26, low: 19, rain: 80, humidity: 85, wind: 18 },
    { day: 'Sunday', date: 'Nov 24', icon: '⛅', high: 30, low: 21, rain: 20, humidity: 68, wind: 14 },
    { day: 'Monday', date: 'Nov 25', icon: '☀️', high: 33, low: 23, rain: 5, humidity: 60, wind: 10 },
    { day: 'Tuesday', date: 'Nov 26', icon: '☀️', high: 34, low: 24, rain: 5, humidity: 58, wind: 11 },
    { day: 'Wednesday', date: 'Nov 27', icon: '⛅', high: 31, low: 22, rain: 15, humidity: 70, wind: 13 },
  ];

  return (
    <div className="min-h-screen bg-[#FAFAF5] pb-24 max-w-md mx-auto">
      <AppHeader />
      <div className="pt-20 px-4">
        <button
          onClick={() => navigate('/dashboard')}
          className="flex items-center gap-2 text-[#43A047] mb-4"
        >
          <ArrowLeft className="w-5 h-5" />
          Back
        </button>

        <h1 className="text-[#1B5E20] text-3xl mb-6">Weather Forecast</h1>

        {/* Current Weather */}
        <div className="bg-gradient-to-br from-[#FFC107] to-[#FF9800] rounded-3xl p-6 text-white shadow-lg mb-6">
          <div className="flex items-start justify-between mb-4">
            <div>
              <h2 className="text-5xl mb-2">32°C</h2>
              <p className="text-xl opacity-90">Sunny & Clear</p>
              <p className="text-sm opacity-75">Feels like 34°C</p>
            </div>
            <div className="text-7xl">☀️</div>
          </div>
          <div className="grid grid-cols-4 gap-4 pt-4 border-t border-white/30">
            <div className="text-center">
              <Droplets className="w-5 h-5 mx-auto mb-1" />
              <div className="text-xs opacity-75">Humidity</div>
              <div>65%</div>
            </div>
            <div className="text-center">
              <Wind className="w-5 h-5 mx-auto mb-1" />
              <div className="text-xs opacity-75">Wind</div>
              <div>12 km/h</div>
            </div>
            <div className="text-center">
              <Eye className="w-5 h-5 mx-auto mb-1" />
              <div className="text-xs opacity-75">Visibility</div>
              <div>10 km</div>
            </div>
            <div className="text-center">
              <Gauge className="w-5 h-5 mx-auto mb-1" />
              <div className="text-xs opacity-75">Pressure</div>
              <div>1013 mb</div>
            </div>
          </div>
        </div>

        {/* 7-Day Forecast */}
        <h3 className="text-[#1B5E20] mb-4">7-Day Forecast</h3>
        <div className="space-y-3 mb-6">
          {forecast.map((day, idx) => (
            <div key={idx} className="bg-white rounded-2xl p-4 shadow-sm">
              <div className="flex items-center justify-between">
                <div className="flex items-center gap-4">
                  <div className="text-4xl">{day.icon}</div>
                  <div>
                    <div className="text-[#1B5E20]">{day.day}</div>
                    <div className="text-[#757575] text-sm">{day.date}</div>
                  </div>
                </div>
                <div className="flex items-center gap-4">
                  <div className="text-right">
                    <div className="text-[#1B5E20]">{day.high}°</div>
                    <div className="text-[#757575] text-sm">{day.low}°</div>
                  </div>
                  <div className="flex items-center gap-1 text-blue-500">
                    <Droplets className="w-4 h-4" />
                    <span className="text-sm">{day.rain}%</span>
                  </div>
                </div>
              </div>
              <div className="flex gap-6 mt-3 pt-3 border-t border-[#FAFAF5] text-sm text-[#757575]">
                <div className="flex items-center gap-1">
                  <Droplets className="w-4 h-4" />
                  <span>{day.humidity}%</span>
                </div>
                <div className="flex items-center gap-1">
                  <Wind className="w-4 h-4" />
                  <span>{day.wind} km/h</span>
                </div>
              </div>
            </div>
          ))}
        </div>

        {/* Weather Alerts */}
        <div className="bg-blue-50 rounded-2xl p-4 border-l-4 border-blue-500">
          <div className="text-[#1B5E20] mb-1">🌧️ Heavy Rain Alert</div>
          <div className="text-[#757575] text-sm">
            Heavy rainfall expected on Saturday. Plan your farming activities accordingly.
          </div>
        </div>
      </div>

      <FloatingIVR />
      <AppFooter />
    </div>
  );
}