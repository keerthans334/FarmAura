import { useNavigate } from 'react-router-dom';
import { useState } from 'react';
import AppHeader from './AppHeader';
import AppFooter from './AppFooter';
import FloatingIVR from './FloatingIVR';
import { Upload, Navigation, Plus, X } from 'lucide-react';
import { toast } from 'react-toastify';

interface CombinedInputProps {
  location: any;
}

interface FertilizerEntry {
  id: string;
  fertilizer: string;
  customFertilizer: string;
  quantity: string;
  unit: string;
  customUnit: string;
  frequency: string;
  customFrequency: string;
  isOther: boolean;
  isOtherUnit: boolean;
  isOtherFrequency: boolean;
}

export default function CombinedInput({ location }: CombinedInputProps) {
  const navigate = useNavigate();
  const [soilInputMode, setSoilInputMode] = useState<'auto' | 'manual' | 'shc'>('auto');
  const [shcNumber, setShcNumber] = useState('');
  const [formData, setFormData] = useState({
    landSize: '',
    irrigation: '',
    soilType: '',
    pH: 7,
    nitrogen: '',
    phosphorus: '',
    potassium: '',
    moisture: '',
    texture: '',
    lastCrop: '',
    previousCrop: ''
  });
  const [customInputs, setCustomInputs] = useState({
    landSize: '',
    irrigation: '',
    soilType: '',
    texture: '',
    lastCrop: '',
    previousCrop: ''
  });
  const [showOtherInput, setShowOtherInput] = useState({
    landSize: false,
    irrigation: false,
    soilType: false,
    texture: false,
    lastCrop: false,
    previousCrop: false
  });
  
  // Multiple fertilizers state
  const [fertilizers, setFertilizers] = useState<FertilizerEntry[]>([
    { id: '1', fertilizer: '', customFertilizer: '', quantity: '', unit: '', customUnit: '', frequency: '', customFrequency: '', isOther: false, isOtherUnit: false, isOtherFrequency: false }
  ]);

  const handleSubmit = () => {
    navigate('/crop-results');
  };

  // Check if all required fields are filled
  const isFormValid = () => {
    // Get effective values (either from formData or customInputs)
    const effectiveLandSize = showOtherInput.landSize ? customInputs.landSize : formData.landSize;
    const effectiveIrrigation = showOtherInput.irrigation ? customInputs.irrigation : formData.irrigation;
    const effectiveLastCrop = showOtherInput.lastCrop ? customInputs.lastCrop : formData.lastCrop;
    const effectivePreviousCrop = showOtherInput.previousCrop ? customInputs.previousCrop : formData.previousCrop;

    const requiredFields = [
      effectiveLandSize,
      effectiveIrrigation,
      effectiveLastCrop,
      effectivePreviousCrop
    ];

    // For manual mode, also require soil type and NPK values
    if (soilInputMode === 'manual') {
      const effectiveSoilType = showOtherInput.soilType ? customInputs.soilType : formData.soilType;
      const effectiveTexture = showOtherInput.texture ? customInputs.texture : formData.texture;
      
      requiredFields.push(
        effectiveSoilType,
        formData.nitrogen,
        formData.phosphorus,
        formData.potassium,
        formData.moisture,
        effectiveTexture
      );
    }

    // Check if all required fields are not empty
    return requiredFields.every(field => field && field.trim() !== '');
  };

  const landSizes = ['< 1 Acre', '1-2 Acres', '2-5 Acres', '5-10 Acres', '> 10 Acres', 'Other (Manual)'];
  const irrigationTypes = ['Rainfed', 'Canal', 'Borewell', 'Drip', 'Other (Manual)'];
  const soilTypes = ['Sandy', 'Loamy', 'Clay', 'Red', 'Black', 'Other (Manual)'];
  const soilTextures = ['Fine', 'Medium', 'Coarse', 'Other (Manual)'];
  const crops = ['Wheat', 'Rice', 'Cotton', 'Sugarcane', 'Soybean', 'Maize', 'Tomato', 'Potato', 'Other (Manual)'];
  const fertilizersList = ['Urea', 'DAP', 'NPK', 'Organic Manure', 'None', 'Other (Manual)'];
  const units = ['kg', 'g', 'L', 'mL', 'Bags', 'Other (Manual)'];
  const frequencies = ['Weekly', 'Monthly', 'Per Stage', 'Other (Specify)'];

  // Fertilizer handlers
  const addFertilizer = () => {
    const newId = (fertilizers.length + 1).toString();
    setFertilizers([...fertilizers, { 
      id: newId, 
      fertilizer: '', 
      customFertilizer: '', 
      quantity: '', 
      unit: '', 
      customUnit: '', 
      frequency: '', 
      customFrequency: '', 
      isOther: false, 
      isOtherUnit: false, 
      isOtherFrequency: false 
    }]);
  };

  const removeFertilizer = (id: string) => {
    if (fertilizers.length > 1) {
      setFertilizers(fertilizers.filter(f => f.id !== id));
    }
  };

  const updateFertilizer = (id: string, field: keyof FertilizerEntry, value: string | boolean) => {
    setFertilizers(fertilizers.map(f => 
      f.id === id ? { ...f, [field]: value } : f
    ));
  };

  return (
    <div className="min-h-screen bg-[#FAFAF5] pb-24 max-w-md mx-auto animate-fade-in">
      <AppHeader title="Crop Input" showBack={true} showProfile={false} />
      <div className="pt-20 px-4">
        <h1 className="text-[#1B5E20] text-3xl mb-2">Crop Advisory Form</h1>
        <p className="text-[#757575] mb-6">Fill details for personalized recommendations</p>

        {/* Section A - Farm Details */}
        <div className="bg-white rounded-3xl p-6 shadow-lg mb-4 animate-scale-in">
          <h3 className="text-[#1B5E20] mb-4">Section A — Farm Details</h3>
          
          <div className="mb-4">
            <label className="block text-[#757575] text-sm mb-2">Land Size</label>
            <div className="grid grid-cols-3 gap-2">
              {landSizes.map((size) => (
                <button
                  key={size}
                  onClick={() => {
                    if (size === 'Other (Manual)') {
                      setShowOtherInput({ ...showOtherInput, landSize: true });
                    } else {
                      setFormData({ ...formData, landSize: size });
                      setShowOtherInput({ ...showOtherInput, landSize: false });
                    }
                  }}
                  className={`p-3 rounded-xl border-2 text-sm transition-all card-hover ${
                    formData.landSize === size
                      ? 'bg-gradient-to-r from-[#43A047] to-[#1B5E20] text-white border-[#43A047]'
                      : 'bg-[#FAFAF5] text-[#1B5E20] border-[#43A047]'
                  }`}
                >
                  {size}
                </button>
              ))}
            </div>
            {showOtherInput.landSize && (
              <input
                type="text"
                value={customInputs.landSize}
                onChange={(e) => setCustomInputs({ ...customInputs, landSize: e.target.value })}
                placeholder="Enter land size"
                className="w-full px-4 py-3 bg-[#FAFAF5] rounded-xl border-2 border-[#43A047] focus:outline-none focus:border-[#1B5E20] mt-2"
              />
            )}
          </div>

          <div>
            <label className="block text-[#757575] text-sm mb-2">Irrigation Type</label>
            <div className="grid grid-cols-2 gap-2">
              {irrigationTypes.map((type) => (
                <button
                  key={type}
                  onClick={() => {
                    if (type === 'Other (Manual)') {
                      setShowOtherInput({ ...showOtherInput, irrigation: true });
                    } else {
                      setFormData({ ...formData, irrigation: type });
                      setShowOtherInput({ ...showOtherInput, irrigation: false });
                    }
                  }}
                  className={`p-3 rounded-xl border-2 transition-all card-hover ${
                    formData.irrigation === type
                      ? 'bg-gradient-to-r from-[#43A047] to-[#1B5E20] text-white border-[#43A047]'
                      : 'bg-[#FAFAF5] text-[#1B5E20] border-[#43A047]'
                  }`}
                >
                  {type}
                </button>
              ))}
            </div>
            {showOtherInput.irrigation && (
              <input
                type="text"
                value={customInputs.irrigation}
                onChange={(e) => setCustomInputs({ ...customInputs, irrigation: e.target.value })}
                placeholder="Enter irrigation type"
                className="w-full px-4 py-3 bg-[#FAFAF5] rounded-xl border-2 border-[#43A047] focus:outline-none focus:border-[#1B5E20] mt-2"
              />
            )}
          </div>
        </div>

        {/* Section B - Soil Info with Mode Selector */}
        <div className="bg-white rounded-3xl p-6 shadow-lg mb-4 animate-scale-in">
          <h3 className="text-[#1B5E20] mb-4">Section B — Soil Information</h3>
          
          {/* Soil Input Mode Selector */}
          <div className="bg-[#E8F5E9] rounded-2xl p-4 mb-4">
            <p className="text-[#1B5E20] text-sm mb-3">Choose Input Method:</p>
            <div className="grid grid-cols-3 gap-2">
              <button
                onClick={() => setSoilInputMode('auto')}
                className={`p-3 rounded-xl text-sm transition-all card-hover ${
                  soilInputMode === 'auto'
                    ? 'bg-gradient-to-r from-[#43A047] to-[#1B5E20] text-white'
                    : 'bg-white text-[#1B5E20] border-2 border-[#43A047]'
                }`}
              >
                <Navigation className="w-5 h-5 mx-auto mb-1" />
                Auto-detect
              </button>
              <button
                onClick={() => setSoilInputMode('manual')}
                className={`p-3 rounded-xl text-sm transition-all card-hover ${
                  soilInputMode === 'manual'
                    ? 'bg-gradient-to-r from-[#43A047] to-[#1B5E20] text-white'
                    : 'bg-white text-[#1B5E20] border-2 border-[#43A047]'
                }`}
              >
                ✍️
                Manual
              </button>
              <button
                onClick={() => setSoilInputMode('shc')}
                className={`p-3 rounded-xl text-sm transition-all card-hover ${
                  soilInputMode === 'shc'
                    ? 'bg-gradient-to-r from-[#43A047] to-[#1B5E20] text-white'
                    : 'bg-white text-[#1B5E20] border-2 border-[#43A047]'
                }`}
              >
                <Upload className="w-5 h-5 mx-auto mb-1" />
                SHC
              </button>
            </div>
          </div>

          {/* Auto-detect Mode */}
          {soilInputMode === 'auto' && (
            <div className="bg-blue-50 border-2 border-blue-200 rounded-2xl p-4">
              <p className="text-[#1B5E20] mb-2">📍 Location: {location.district}, {location.state}</p>
              <p className="text-[#757575] text-sm">Soil data will be auto-detected based on your location</p>
            </div>
          )}

          {/* Manual Mode */}
          {soilInputMode === 'manual' && (
            <>
              <div className="mb-4">
                <label className="block text-[#757575] text-sm mb-2">Soil Type</label>
                <select
                  value={formData.soilType}
                  onChange={(e) => {
                    if (e.target.value === 'Other (Manual)') {
                      setShowOtherInput({ ...showOtherInput, soilType: true });
                    } else {
                      setFormData({ ...formData, soilType: e.target.value });
                      setShowOtherInput({ ...showOtherInput, soilType: false });
                    }
                  }}
                  className="w-full px-4 py-3 bg-[#FAFAF5] rounded-xl border-2 border-[#43A047] focus:outline-none focus:border-[#1B5E20]"
                >
                  <option value="">Select soil type</option>
                  {soilTypes.map(type => (
                    <option key={type} value={type}>{type}</option>
                  ))}
                </select>
                {showOtherInput.soilType && (
                  <input
                    type="text"
                    value={customInputs.soilType}
                    onChange={(e) => setCustomInputs({ ...customInputs, soilType: e.target.value })}
                    placeholder="Enter soil type"
                    className="w-full px-4 py-3 bg-[#FAFAF5] rounded-xl border-2 border-[#43A047] focus:outline-none focus:border-[#1B5E20] mt-2"
                  />
                )}
              </div>

              <div className="mb-4">
                <label className="block text-[#757575] text-sm mb-2">Soil Texture</label>
                <div className="grid grid-cols-2 gap-2">
                  {soilTextures.map((texture) => (
                    <button
                      key={texture}
                      onClick={() => {
                        if (texture === 'Other (Manual)') {
                          setShowOtherInput({ ...showOtherInput, texture: true });
                        } else {
                          setFormData({ ...formData, texture });
                          setShowOtherInput({ ...showOtherInput, texture: false });
                        }
                      }}
                      className={`p-3 rounded-xl border-2 text-sm transition-all ${
                        formData.texture === texture
                          ? 'bg-[#43A047] text-white border-[#43A047]'
                          : 'bg-[#FAFAF5] text-[#1B5E20] border-[#43A047]'
                      }`}
                    >
                      {texture}
                    </button>
                  ))}
                </div>
                {showOtherInput.texture && (
                  <input
                    type="text"
                    value={customInputs.texture}
                    onChange={(e) => setCustomInputs({ ...customInputs, texture: e.target.value })}
                    placeholder="Enter soil texture"
                    className="w-full px-4 py-3 bg-[#FAFAF5] rounded-xl border-2 border-[#43A047] focus:outline-none focus:border-[#1B5E20] mt-2"
                  />
                )}
              </div>

              <div className="mb-4">
                <label className="block text-[#757575] text-sm mb-2">pH Level: {formData.pH}</label>
                <input
                  type="range"
                  min="4"
                  max="10"
                  step="0.1"
                  value={formData.pH}
                  onChange={(e) => setFormData({ ...formData, pH: parseFloat(e.target.value) })}
                  className="w-full"
                />
                <div className="flex justify-between text-xs text-[#757575]">
                  <span>Acidic (4)</span>
                  <span>Neutral (7)</span>
                  <span>Alkaline (10)</span>
                </div>
              </div>

              <div className="grid grid-cols-3 gap-3 mb-4">
                <div>
                  <label className="block text-[#757575] text-xs mb-2">Nitrogen (N)</label>
                  <input
                    type="number"
                    value={formData.nitrogen}
                    onChange={(e) => setFormData({ ...formData, nitrogen: e.target.value })}
                    placeholder="0-100"
                    className="w-full px-3 py-2 bg-[#FAFAF5] rounded-xl border-2 border-[#43A047] focus:outline-none focus:border-[#1B5E20] text-sm"
                  />
                </div>
                <div>
                  <label className="block text-[#757575] text-xs mb-2">Phosphorus (P)</label>
                  <input
                    type="number"
                    value={formData.phosphorus}
                    onChange={(e) => setFormData({ ...formData, phosphorus: e.target.value })}
                    placeholder="0-100"
                    className="w-full px-3 py-2 bg-[#FAFAF5] rounded-xl border-2 border-[#43A047] focus:outline-none focus:border-[#1B5E20] text-sm"
                  />
                </div>
                <div>
                  <label className="block text-[#757575] text-xs mb-2">Potassium (K)</label>
                  <input
                    type="number"
                    value={formData.potassium}
                    onChange={(e) => setFormData({ ...formData, potassium: e.target.value })}
                    placeholder="0-100"
                    className="w-full px-3 py-2 bg-[#FAFAF5] rounded-xl border-2 border-[#43A047] focus:outline-none focus:border-[#1B5E20] text-sm"
                  />
                </div>
              </div>

              <div>
                <label className="block text-[#757575] text-sm mb-2">Soil Moisture (%)</label>
                <input
                  type="number"
                  value={formData.moisture}
                  onChange={(e) => setFormData({ ...formData, moisture: e.target.value })}
                  placeholder="Enter moisture percentage"
                  className="w-full px-4 py-3 bg-[#FAFAF5] rounded-xl border-2 border-[#43A047] focus:outline-none focus:border-[#1B5E20]"
                />
              </div>
            </>
          )}

          {/* SHC Mode */}
          {soilInputMode === 'shc' && (
            <div className="space-y-4">
              <div className="bg-gradient-to-r from-[#43A047] to-[#1B5E20] text-white p-5 rounded-2xl shadow-xl border-4 border-[#FFC107] relative overflow-hidden">
                <div className="absolute inset-0 bg-[#FFC107] opacity-10 animate-pulse"></div>
                <div className="relative z-10 flex items-center gap-3 mb-3">
                  <span className="text-2xl">🧪</span>
                  <div>
                    <div className="font-medium">Enter SHC Registration Number</div>
                    <div className="text-xs opacity-90">Automatically fetch your soil health data</div>
                  </div>
                </div>
                <input
                  type="text"
                  value={shcNumber}
                  onChange={(e) => setShcNumber(e.target.value.toUpperCase())}
                  placeholder="e.g., JH123456789"
                  maxLength={15}
                  className="w-full px-4 py-3 bg-white text-[#1B5E20] rounded-xl border-2 border-[#FFC107] focus:outline-none focus:border-[#43A047] tracking-wider relative z-10"
                />
                {shcNumber && (
                  <div className="mt-3 flex items-center gap-2 relative z-10">
                    <div className="w-5 h-5 bg-green-500 rounded-full flex items-center justify-center">
                      ✓
                    </div>
                    <span className="text-sm">SHC Number: {shcNumber}</span>
                  </div>
                )}
              </div>
              <p className="text-[#757575] text-sm text-center">
                💡 Enter your Soil Health Card registration number to auto-fill soil data
              </p>
            </div>
          )}
        </div>

        {/* Section C - Past Crop Rotation */}
        <div className="bg-white rounded-3xl p-6 shadow-lg mb-32 animate-scale-in">
          <h3 className="text-[#1B5E20] mb-4">Section C — Past Crop Rotation</h3>
          
          <div className="mb-4">
            <label className="block text-[#757575] text-sm mb-2">Last Crop Grown</label>
            <select
              value={formData.lastCrop}
              onChange={(e) => {
                if (e.target.value === 'Other (Manual)') {
                  setShowOtherInput({ ...showOtherInput, lastCrop: true });
                } else {
                  setFormData({ ...formData, lastCrop: e.target.value });
                  setShowOtherInput({ ...showOtherInput, lastCrop: false });
                }
              }}
              className="w-full px-4 py-3 bg-[#FAFAF5] rounded-xl border-2 border-[#43A047] focus:outline-none focus:border-[#1B5E20]"
            >
              <option value="">Select crop</option>
              {crops.map(crop => (
                <option key={crop} value={crop}>{crop}</option>
              ))}
            </select>
            {showOtherInput.lastCrop && (
              <input
                type="text"
                value={customInputs.lastCrop}
                onChange={(e) => setCustomInputs({ ...customInputs, lastCrop: e.target.value })}
                placeholder="Enter last crop"
                className="w-full px-4 py-3 bg-[#FAFAF5] rounded-xl border-2 border-[#43A047] focus:outline-none focus:border-[#1B5E20] mt-2"
              />
            )}
          </div>

          <div className="mb-4">
            <label className="block text-[#757575] text-sm mb-2">Frequent Crop</label>
            <select
              value={formData.previousCrop}
              onChange={(e) => {
                if (e.target.value === 'Other (Manual)') {
                  setShowOtherInput({ ...showOtherInput, previousCrop: true });
                } else {
                  setShowOtherInput({ ...showOtherInput, previousCrop: false });
                  setFormData({ ...formData, previousCrop: e.target.value });
                }
              }}
              className="w-full px-4 py-3 bg-[#FAFAF5] rounded-xl border-2 border-[#43A047] focus:outline-none focus:border-[#1B5E20]"
            >
              <option value="">Select frequent crop</option>
              <option value="Rice">Rice</option>
              <option value="Wheat">Wheat</option>
              <option value="Maize">Maize</option>
              <option value="Cotton">Cotton</option>
              <option value="Sugarcane">Sugarcane</option>
              <option value="Potato">Potato</option>
              <option value="Tomato">Tomato</option>
              <option value="Onion">Onion</option>
              <option value="Other (Manual)">Other (Manual)</option>
            </select>
            {showOtherInput.previousCrop && (
              <input
                type="text"
                value={customInputs.previousCrop}
                onChange={(e) => setCustomInputs({ ...customInputs, previousCrop: e.target.value })}
                placeholder="Enter frequent crop"
                className="w-full px-4 py-3 bg-[#FAFAF5] rounded-xl border-2 border-[#43A047] focus:outline-none focus:border-[#1B5E20] mt-2"
              />
            )}
          </div>

          {/* Fertilizer Entries */}
          <div className="space-y-4">
            <h4 className="text-[#1B5E20] text-sm mb-2">Fertilizer Details</h4>
            {fertilizers.map((fertilizer, index) => (
              <div key={fertilizer.id} className="bg-[#FAFAF5] rounded-2xl p-4 border-2 border-[#43A047]">
                <div className="flex justify-between items-center mb-3">
                  <p className="text-[#1B5E20] font-medium">Fertilizer {index + 1}</p>
                  {fertilizers.length > 1 && (
                    <button
                      onClick={() => removeFertilizer(fertilizer.id)}
                      className="text-red-600 hover:text-red-800"
                    >
                      <X className="w-5 h-5" />
                    </button>
                  )}
                </div>
                
                {/* Fertilizer Type */}
                <select
                  value={fertilizer.fertilizer}
                  onChange={(e) => {
                    if (e.target.value === 'Other (Manual)') {
                      updateFertilizer(fertilizer.id, 'isOther', true);
                    } else {
                      updateFertilizer(fertilizer.id, 'fertilizer', e.target.value);
                      updateFertilizer(fertilizer.id, 'isOther', false);
                    }
                  }}
                  className="w-full px-4 py-3 bg-white rounded-xl border-2 border-[#43A047] focus:outline-none focus:border-[#1B5E20] mb-2"
                >
                  <option value="">Select fertilizer</option>
                  {fertilizersList.map(fert => (
                    <option key={fert} value={fert}>{fert}</option>
                  ))}
                </select>
                {fertilizer.isOther && (
                  <input
                    type="text"
                    value={fertilizer.customFertilizer}
                    onChange={(e) => updateFertilizer(fertilizer.id, 'customFertilizer', e.target.value)}
                    placeholder="Enter fertilizer name"
                    className="w-full px-4 py-3 bg-white rounded-xl border-2 border-[#43A047] focus:outline-none focus:border-[#1B5E20] mb-2"
                  />
                )}
                
                {/* Quantity and Unit */}
                <div className="grid grid-cols-2 gap-2 mb-2">
                  <input
                    type="number"
                    value={fertilizer.quantity}
                    onChange={(e) => updateFertilizer(fertilizer.id, 'quantity', e.target.value)}
                    placeholder="Quantity"
                    className="w-full px-4 py-3 bg-white rounded-xl border-2 border-[#43A047] focus:outline-none focus:border-[#1B5E20]"
                  />
                  <select
                    value={fertilizer.unit}
                    onChange={(e) => {
                      if (e.target.value === 'Other (Manual)') {
                        updateFertilizer(fertilizer.id, 'isOtherUnit', true);
                      } else {
                        updateFertilizer(fertilizer.id, 'unit', e.target.value);
                        updateFertilizer(fertilizer.id, 'isOtherUnit', false);
                      }
                    }}
                    className="w-full px-4 py-3 bg-white rounded-xl border-2 border-[#43A047] focus:outline-none focus:border-[#1B5E20]"
                  >
                    <option value="">Unit</option>
                    {units.map(unit => (
                      <option key={unit} value={unit}>{unit}</option>
                    ))}
                  </select>
                </div>
                {fertilizer.isOtherUnit && (
                  <input
                    type="text"
                    value={fertilizer.customUnit}
                    onChange={(e) => updateFertilizer(fertilizer.id, 'customUnit', e.target.value)}
                    placeholder="Enter custom unit"
                    className="w-full px-4 py-3 bg-white rounded-xl border-2 border-[#43A047] focus:outline-none focus:border-[#1B5E20] mb-2"
                  />
                )}
                
                {/* Frequency */}
                <select
                  value={fertilizer.frequency}
                  onChange={(e) => {
                    if (e.target.value === 'Other (Specify)') {
                      updateFertilizer(fertilizer.id, 'isOtherFrequency', true);
                    } else {
                      updateFertilizer(fertilizer.id, 'frequency', e.target.value);
                      updateFertilizer(fertilizer.id, 'isOtherFrequency', false);
                    }
                  }}
                  className="w-full px-4 py-3 bg-white rounded-xl border-2 border-[#43A047] focus:outline-none focus:border-[#1B5E20]"
                >
                  <option value="">Select frequency</option>
                  {frequencies.map(freq => (
                    <option key={freq} value={freq}>{freq}</option>
                  ))}
                </select>
                {fertilizer.isOtherFrequency && (
                  <input
                    type="text"
                    value={fertilizer.customFrequency}
                    onChange={(e) => updateFertilizer(fertilizer.id, 'customFrequency', e.target.value)}
                    placeholder="Specify frequency"
                    className="w-full px-4 py-3 bg-white rounded-xl border-2 border-[#43A047] focus:outline-none focus:border-[#1B5E20] mt-2"
                  />
                )}
              </div>
            ))}
            <button
              onClick={addFertilizer}
              className="w-full bg-gradient-to-r from-[#43A047] to-[#1B5E20] text-white py-4 rounded-2xl flex items-center justify-center gap-2 shadow-lg hover:shadow-xl transition-all hover:scale-105"
            >
              <Plus className="w-5 h-5" />
              Add Fertilizer
            </button>
          </div>
        </div>

        {/* Fixed Bottom Button */}
        <div className="fixed bottom-20 left-0 right-0 px-4 max-w-md mx-auto">
          <button
            onClick={handleSubmit}
            disabled={!isFormValid()}
            className={`w-full py-4 rounded-2xl shadow-lg transition-all ${
              isFormValid()
                ? 'bg-gradient-to-r from-[#43A047] to-[#1B5E20] text-white hover:shadow-xl hover:scale-105'
                : 'bg-gray-300 text-gray-500 cursor-not-allowed'
            }`}
          >
            Get Recommendation
          </button>
          {!isFormValid() && (
            <p className="text-center text-[#757575] text-xs mt-2">
              Please fill all required fields to continue
            </p>
          )}
        </div>
      </div>

      <FloatingIVR />
      <AppFooter />
    </div>
  );
}