import { useNavigate } from 'react-router-dom';
import AppHeader from './AppHeader';
import AppFooter from './AppFooter';
import FloatingIVR from './FloatingIVR';
import { ArrowLeft, Bug, CloudRain, AlertTriangle, MapPin, Calendar } from 'lucide-react';

export default function PestAlerts() {
  const navigate = useNavigate();

  const pestAlerts = [
    {
      id: 1,
      type: 'High Risk',
      pest: 'Stem Borer',
      crop: 'Rice',
      location: 'Ranchi District',
      date: '2 hours ago',
      severity: 'high',
      description: 'High pest activity detected in nearby farms. Immediate action recommended.',
      action: 'Apply neem oil or approved pesticides'
    },
    {
      id: 2,
      type: 'Medium Risk',
      pest: 'Aphids',
      crop: 'Wheat',
      location: 'Hazaribagh District',
      date: '5 hours ago',
      severity: 'medium',
      description: 'Moderate aphid infestation reported. Monitor your crops closely.',
      action: 'Use insecticidal soap spray'
    },
    {
      id: 3,
      type: 'Low Risk',
      pest: 'Leaf Miner',
      crop: 'Vegetables',
      location: 'Dhanbad District',
      date: '1 day ago',
      severity: 'low',
      description: 'Minor pest activity. Preventive measures recommended.',
      action: 'Regular crop inspection advised'
    }
  ];

  const weatherAlerts = [
    {
      id: 1,
      type: 'Heavy Rain',
      description: 'Heavy rainfall expected in the next 48 hours',
      location: 'Ranchi, Jharkhand',
      date: 'Tomorrow',
      severity: 'high',
      action: 'Ensure proper drainage in fields',
      icon: CloudRain
    },
    {
      id: 2,
      type: 'High Temperature',
      description: 'Temperature may reach 38°C this week',
      location: 'Ranchi, Jharkhand',
      date: 'Next 3 days',
      severity: 'medium',
      action: 'Increase irrigation frequency',
      icon: AlertTriangle
    }
  ];

  const getSeverityColor = (severity: string) => {
    switch (severity) {
      case 'high': return 'bg-red-100 border-red-300';
      case 'medium': return 'bg-yellow-100 border-yellow-300';
      case 'low': return 'bg-green-100 border-green-300';
      default: return 'bg-gray-100 border-gray-300';
    }
  };

  const getSeverityBadge = (severity: string) => {
    switch (severity) {
      case 'high': return 'bg-red-500 text-white';
      case 'medium': return 'bg-yellow-500 text-white';
      case 'low': return 'bg-green-500 text-white';
      default: return 'bg-gray-500 text-white';
    }
  };

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

        <h1 className="text-[#1B5E20] text-3xl mb-2">Pest & Alerts</h1>
        <p className="text-[#757575] mb-6">Stay updated with pest and weather alerts</p>

        {/* Pest Detection Alerts */}
        <div className="mb-6">
          <div className="flex items-center gap-2 mb-4">
            <Bug className="w-6 h-6 text-[#1B5E20]" />
            <h2 className="text-[#1B5E20] text-xl">Pest Alerts</h2>
          </div>
          <div className="flex gap-4 overflow-x-auto pb-2 horizontal-scroll">
            {pestAlerts.map((alert) => (
              <div
                key={alert.id}
                className={`min-w-[320px] rounded-2xl p-4 border-2 ${getSeverityColor(alert.severity)} shadow-sm`}
              >
                <div className="flex items-start justify-between mb-3">
                  <div>
                    <div className="flex items-center gap-2 mb-1">
                      <span className={`px-3 py-1 rounded-full text-xs ${getSeverityBadge(alert.severity)}`}>
                        {alert.type}
                      </span>
                    </div>
                    <h3 className="text-[#1B5E20] text-lg">{alert.pest}</h3>
                    <p className="text-[#757575] text-sm">Affects: {alert.crop}</p>
                  </div>
                  <Bug className="w-8 h-8 text-[#8D6E63]" />
                </div>
                
                <p className="text-[#1B5E20] text-sm mb-3">{alert.description}</p>
                
                <div className="flex items-center gap-2 text-[#757575] text-xs mb-2">
                  <MapPin className="w-3 h-3" />
                  <span>{alert.location}</span>
                </div>
                
                <div className="flex items-center gap-2 text-[#757575] text-xs mb-3">
                  <Calendar className="w-3 h-3" />
                  <span>{alert.date}</span>
                </div>
                
                <div className="bg-white rounded-xl p-3">
                  <p className="text-[#43A047] text-sm">
                    <span className="font-medium">Action: </span>
                    {alert.action}
                  </p>
                </div>
              </div>
            ))}
          </div>
        </div>

        {/* Weather Warnings */}
        <div className="mb-6">
          <div className="flex items-center gap-2 mb-4">
            <CloudRain className="w-6 h-6 text-[#1B5E20]" />
            <h2 className="text-[#1B5E20] text-xl">Weather Warnings</h2>
          </div>
          <div className="flex gap-4 overflow-x-auto pb-2 horizontal-scroll">
            {weatherAlerts.map((alert) => {
              const Icon = alert.icon;
              return (
                <div
                  key={alert.id}
                  className={`min-w-[320px] rounded-2xl p-4 border-2 ${getSeverityColor(alert.severity)} shadow-sm`}
                >
                  <div className="flex items-start justify-between mb-3">
                    <div>
                      <div className="flex items-center gap-2 mb-1">
                        <span className={`px-3 py-1 rounded-full text-xs ${getSeverityBadge(alert.severity)}`}>
                          Alert
                        </span>
                      </div>
                      <h3 className="text-[#1B5E20] text-lg">{alert.type}</h3>
                    </div>
                    <Icon className="w-8 h-8 text-[#FFC107]" />
                  </div>
                  
                  <p className="text-[#1B5E20] text-sm mb-3">{alert.description}</p>
                  
                  <div className="flex items-center gap-2 text-[#757575] text-xs mb-2">
                    <MapPin className="w-3 h-3" />
                    <span>{alert.location}</span>
                  </div>
                  
                  <div className="flex items-center gap-2 text-[#757575] text-xs mb-3">
                    <Calendar className="w-3 h-3" />
                    <span>{alert.date}</span>
                  </div>
                  
                  <div className="bg-white rounded-xl p-3">
                    <p className="text-[#43A047] text-sm">
                      <span className="font-medium">Action: </span>
                      {alert.action}
                    </p>
                  </div>
                </div>
              );
            })}
          </div>
        </div>

        {/* Alert Preferences */}
        <div className="bg-gradient-to-br from-[#43A047] to-[#1B5E20] rounded-2xl p-6 text-white">
          <h3 className="text-xl mb-2">Alert Preferences</h3>
          <p className="text-sm opacity-90 mb-4">
            Customize which alerts you want to receive for your farming activities
          </p>
          <button 
            onClick={() => navigate('/settings')}
            className="bg-white text-[#43A047] px-6 py-3 rounded-xl hover:bg-[#FAFAF5] transition-colors"
          >
            Manage Alerts
          </button>
        </div>
      </div>

      <FloatingIVR />
      <AppFooter />
    </div>
  );
}
