import { useNavigate } from 'react-router-dom';
import { useState } from 'react';
import { Sprout, MapPin, Navigation, Check } from 'lucide-react';
import FloatingIVR from './FloatingIVR';

interface FarmSetupProps {
  setUserData: (data: any) => void;
  location: any;
  setLocation: (data: any) => void;
}

export default function FarmSetup({ setUserData, location, setLocation }: FarmSetupProps) {
  const navigate = useNavigate();
  const [landSize, setLandSize] = useState('');
  const [irrigation, setIrrigation] = useState('');
  const [customLandSize, setCustomLandSize] = useState('');
  const [showCustomInput, setShowCustomInput] = useState(false);
  const [previousCrops, setPreviousCrops] = useState<string[]>([]);
  const [customCrop, setCustomCrop] = useState('');

  const landSizes = [
    { value: '< 1 Acre', icon: '🌾', desc: 'Small plot' },
    { value: '1-2 Acres', icon: '🌾', desc: 'Medium farm' },
    { value: '2-5 Acres', icon: '🌾', desc: 'Large farm' },
    { value: '5-10 Acres', icon: '🌾', desc: 'Very large' },
    { value: '> 10 Acres', icon: '🌾', desc: 'Estate' },
    { value: 'Custom', icon: '✏️', desc: 'Enter size' }
  ];

  const irrigationTypes = [
    { type: 'Rainfed', icon: '🌧️', desc: 'Rain dependent', color: 'from-blue-400 to-blue-600' },
    { type: 'Canal', icon: '🚰', desc: 'Canal irrigation', color: 'from-cyan-400 to-cyan-600' },
    { type: 'Borewell', icon: '⚡', desc: 'Borewell water', color: 'from-yellow-400 to-yellow-600' },
    { type: 'Drip', icon: '💧', desc: 'Drip irrigation', color: 'from-teal-400 to-teal-600' }
  ];

  const cropOptions = [
    { name: 'Rice', icon: '🌾', desc: 'Paddy crop' },
    { name: 'Wheat', icon: '🌾', desc: 'Wheat crop' },
    { name: 'Maize', icon: '🌽', desc: 'Corn crop' },
    { name: 'Potato', icon: '🥔', desc: 'Potato crop' },
    { name: 'Onion', icon: '🧅', desc: 'Onion crop' },
    { name: 'Sugarcane', icon: '🎋', desc: 'Sugar crop' },
    { name: 'Cotton', icon: '☁️', desc: 'Cotton crop' },
    { name: 'Chickpea', icon: '🫘', desc: 'Chana crop' },
    { name: 'Lentil', icon: '🫘', desc: 'Dal crop' },
    { name: 'Groundnut', icon: '🥜', desc: 'Peanut crop' },
    { name: 'Sunflower', icon: '🌻', desc: 'Sunflower crop' },
  ];

  const handleCropToggle = (cropName: string) => {
    if (previousCrops.includes(cropName)) {
      setPreviousCrops(previousCrops.filter(c => c !== cropName));
    } else {
      setPreviousCrops([...previousCrops, cropName]);
    }
  };

  const handleAutoDetect = () => {
    // Simulate GPS detection
    setLocation({
      district: 'Ranchi',
      state: 'Jharkhand',
      detected: true
    });
  };

  const handleLandSizeSelect = (size: string) => {
    if (size === 'Custom') {
      setShowCustomInput(true);
      setLandSize('');
    } else {
      setShowCustomInput(false);
      setLandSize(size);
    }
  };

  const handleSubmit = () => {
    const finalLandSize = showCustomInput ? customLandSize : landSize;
    setUserData((prev: any) => ({ ...prev, landSize: finalLandSize, irrigation, previousCrops }));
    navigate('/dashboard');
  };

  const isFormValid = () => {
    if (showCustomInput) {
      return customLandSize && irrigation;
    }
    return landSize && irrigation;
  };

  return (
    <div className="min-h-screen bg-gradient-to-b from-[#E8F5E9] to-[#FAFAF5] p-6 max-w-md mx-auto animate-fade-in pb-32">
      <div className="pt-6">
        {/* Header */}
        <div className="text-center mb-8 animate-scale-in">
          <div className="w-20 h-20 bg-gradient-to-br from-[#43A047] to-[#1B5E20] rounded-full flex items-center justify-center mx-auto mb-4 shadow-lg">
            <Sprout className="w-10 h-10 text-white" />
          </div>
          <h1 className="text-[#1B5E20] mb-2">Farm Details</h1>
          <p className="text-[#757575] text-sm">Tell us about your farmland</p>
        </div>

        {/* Location Section */}
        <div className="bg-white rounded-3xl p-6 shadow-xl mb-5 animate-scale-in">
          <h3 className="text-[#1B5E20] mb-4 flex items-center gap-2">
            <MapPin className="w-5 h-5 text-[#43A047]" />
            Location
          </h3>
          
          <button
            onClick={handleAutoDetect}
            className="w-full bg-gradient-to-r from-[#FFC107] to-[#FF9800] text-white py-3.5 rounded-2xl flex items-center justify-center gap-2 shadow-lg hover:shadow-xl transition-all hover:scale-105"
          >
            <Navigation className="w-5 h-5" />
            Auto-Detect via GPS
          </button>

          {location.detected && (
            <div className="bg-gradient-to-r from-[#E8F5E9] to-[#C8E6C9] border-2 border-[#43A047] rounded-2xl p-4 mt-3 flex items-center gap-3">
              <Check className="w-5 h-5 text-[#1B5E20] flex-shrink-0" />
              <div>
                <p className="text-[#1B5E20]">📍 {location.district}, {location.state}</p>
                <p className="text-[#43A047] text-xs mt-1">Location detected successfully</p>
              </div>
            </div>
          )}
        </div>

        {/* Land Size */}
        <div className="bg-white rounded-3xl p-6 shadow-xl mb-5 animate-scale-in">
          <h3 className="text-[#1B5E20] mb-4">Land Size</h3>
          <div className="grid grid-cols-3 gap-3 mb-4">
            {landSizes.map((size) => (
              <button
                key={size.value}
                onClick={() => handleLandSizeSelect(size.value)}
                className={`p-4 rounded-2xl border-2 transition-all card-hover ${
                  (landSize === size.value || (size.value === 'Custom' && showCustomInput))
                    ? 'bg-gradient-to-br from-[#43A047] to-[#1B5E20] text-white border-[#43A047] shadow-lg scale-105'
                    : 'bg-[#FAFAF5] text-[#1B5E20] border-[#E8F5E9]'
                }`}
              >
                <div className="text-2xl mb-1">{size.icon}</div>
                <div className="text-xs">{size.value}</div>
              </button>
            ))}
          </div>
          
          {showCustomInput && (
            <input
              type="text"
              value={customLandSize}
              onChange={(e) => setCustomLandSize(e.target.value)}
              placeholder="Enter land size (e.g., 3.5 Acres)"
              className="w-full px-4 py-3.5 bg-[#FAFAF5] rounded-2xl border-2 border-[#43A047] focus:outline-none focus:border-[#1B5E20] transition-all"
            />
          )}
        </div>

        {/* Irrigation Type */}
        <div className="bg-white rounded-3xl p-6 shadow-xl mb-6 animate-scale-in">
          <h3 className="text-[#1B5E20] mb-4">Irrigation Type</h3>
          <div className="grid grid-cols-2 gap-4">
            {irrigationTypes.map((item) => (
              <button
                key={item.type}
                onClick={() => setIrrigation(item.type)}
                className={`p-5 rounded-2xl border-2 transition-all card-hover relative overflow-hidden ${
                  irrigation === item.type
                    ? 'bg-gradient-to-br from-[#43A047] to-[#1B5E20] text-white border-[#43A047] shadow-lg scale-105'
                    : 'bg-[#FAFAF5] text-[#1B5E20] border-[#E8F5E9]'
                }`}
              >
                <div className="text-3xl mb-2">{item.icon}</div>
                <div className="text-sm mb-1">{item.type}</div>
                <div className={`text-xs ${irrigation === item.type ? 'text-white/80' : 'text-[#757575]'}`}>
                  {item.desc}
                </div>
                {irrigation === item.type && (
                  <Check className="absolute top-2 right-2 w-5 h-5" />
                )}
              </button>
            ))}
          </div>
        </div>

        {/* Previous Crops */}
        <div className="bg-white rounded-3xl p-6 shadow-xl mb-5 animate-scale-in">
          <h3 className="text-[#1B5E20] mb-4">Previous Crops Grown</h3>
          <p className="text-[#757575] text-sm mb-4">Select crops you've grown before (helps us give better advice)</p>
          
          {/* Dropdown for crop selection */}
          <select
            value=""
            onChange={(e) => {
              if (e.target.value && !previousCrops.includes(e.target.value)) {
                setPreviousCrops([...previousCrops, e.target.value]);
              }
            }}
            className="w-full px-4 py-3.5 bg-[#FAFAF5] rounded-2xl border-2 border-[#43A047] focus:outline-none focus:border-[#1B5E20] transition-all text-[#1B5E20] mb-4"
          >
            <option value="">+ Add a crop you've grown</option>
            {cropOptions.map((crop) => (
              <option 
                key={crop.name} 
                value={crop.name}
                disabled={previousCrops.includes(crop.name)}
              >
                {crop.icon} {crop.name} - {crop.desc}
              </option>
            ))}
          </select>

          {/* Selected crops display */}
          {previousCrops.length > 0 && (
            <div className="space-y-2">
              <p className="text-[#43A047] text-sm flex items-center gap-1 mb-2">
                ✓ {previousCrops.length} crop(s) selected
              </p>
              <div className="flex flex-wrap gap-2">
                {previousCrops.map((crop) => {
                  const cropInfo = cropOptions.find(c => c.name === crop);
                  return (
                    <div
                      key={crop}
                      className="bg-gradient-to-br from-[#43A047] to-[#1B5E20] text-white px-4 py-2 rounded-xl flex items-center gap-2 shadow-md"
                    >
                      <span>{cropInfo?.icon || '🌾'}</span>
                      <span className="text-sm">{crop}</span>
                      <button
                        onClick={() => setPreviousCrops(previousCrops.filter(c => c !== crop))}
                        className="ml-1 text-white/80 hover:text-white transition-colors"
                      >
                        ×
                      </button>
                    </div>
                  );
                })}
              </div>
            </div>
          )}
        </div>

        {/* Submit Button */}
        <button
          onClick={handleSubmit}
          disabled={!isFormValid()}
          className="w-full bg-gradient-to-r from-[#43A047] to-[#1B5E20] text-white py-4 rounded-2xl disabled:opacity-50 disabled:cursor-not-allowed shadow-lg hover:shadow-xl transition-all hover:scale-105 disabled:hover:scale-100"
        >
          Complete Setup
        </button>

        {/* Progress Indicator */}
        <div className="mt-6 flex items-center justify-center gap-2">
          <div className="w-2 h-2 bg-[#C8E6C9] rounded-full"></div>
          <div className="w-8 h-2 bg-[#43A047] rounded-full"></div>
          <div className="w-2 h-2 bg-[#C8E6C9] rounded-full"></div>
        </div>
      </div>

      <FloatingIVR />
    </div>
  );
}