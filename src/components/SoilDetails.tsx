import { useNavigate } from 'react-router-dom';
import { useState } from 'react';
import AppHeader from './AppHeader';
import AppFooter from './AppFooter';
import FloatingIVR from './FloatingIVR';
import { Droplets, Upload, Navigation } from 'lucide-react';
import { toast } from 'sonner';

interface SoilDetailsProps {
  location: any;
}

export default function SoilDetails({ location }: SoilDetailsProps) {
  const navigate = useNavigate();
  const [inputMode, setInputMode] = useState<'view' | 'upload'>('view');
  const [uploadedFile, setUploadedFile] = useState<File | null>(null);

  const handleFileUpload = (e: React.ChangeEvent<HTMLInputElement>) => {
    const file = e.target.files?.[0];
    if (file) {
      setUploadedFile(file);
      toast.success('SHC image uploaded successfully!');
      setTimeout(() => {
        setInputMode('view');
      }, 1500);
    }
  };

  const npkData = [
    { label: 'Nitrogen (N)', value: 45, max: 100, color: 'bg-blue-500', status: 'Good' },
    { label: 'Phosphorus (P)', value: 38, max: 100, color: 'bg-purple-500', status: 'Moderate' },
    { label: 'Potassium (K)', value: 52, max: 100, color: 'bg-orange-500', status: 'Good' },
  ];

  const insights = [
    { text: 'Your soil is rich in organic matter', icon: '✅' },
    { text: 'Consider adding phosphorus fertilizer', icon: '💡' },
    { text: 'pH level is ideal for most crops', icon: '🎯' },
    { text: 'Good water retention capacity', icon: '💧' },
  ];

  return (
    <div className="min-h-screen bg-[#FAFAF5] pb-24 max-w-md mx-auto animate-fade-in">
      <AppHeader title="Soil Details" showBack={true} showProfile={false} />
      
      <div className="pt-20 px-4">
        <div className="flex items-center justify-between mb-6">
          <h1 className="text-[#1B5E20] text-3xl">Soil Health</h1>
          <button
            onClick={() => setInputMode(inputMode === 'view' ? 'upload' : 'view')}
            className="text-[#43A047] text-sm underline"
          >
            {inputMode === 'view' ? 'Upload SHC' : 'View Details'}
          </button>
        </div>

        {inputMode === 'upload' ? (
          // SHC Upload Section
          <div className="space-y-4">
            <div className="bg-white rounded-3xl p-6 shadow-lg animate-scale-in">
              <h3 className="text-[#1B5E20] mb-4">Upload Soil Health Card</h3>
              
              <label htmlFor="shc-upload" className="block">
                <div className="w-full bg-gradient-to-r from-[#FFC107] to-[#FF9800] text-white py-4 rounded-2xl flex items-center justify-center gap-2 shadow-lg hover:shadow-xl transition-all hover:scale-105 mb-4 cursor-pointer">
                  <Upload className="w-5 h-5" />
                  {uploadedFile ? `Uploaded: ${uploadedFile.name}` : 'Upload SHC Image'}
                </div>
              </label>
              <input
                id="shc-upload"
                type="file"
                accept="image/*"
                onChange={handleFileUpload}
                className="hidden"
              />

              <div className="bg-[#E8F5E9] rounded-2xl p-4 mb-4">
                <p className="text-[#1B5E20] text-sm mb-2">📸 Tips for best results:</p>
                <ul className="text-[#757575] text-sm space-y-1">
                  <li>• Take clear photo in good lighting</li>
                  <li>• Ensure all text is readable</li>
                  <li>• Capture entire card in frame</li>
                </ul>
              </div>

              <div className="text-center text-[#757575] mb-4">OR</div>

              <div className="bg-[#FAFAF5] rounded-2xl p-4 border-2 border-[#43A047]">
                <p className="text-[#1B5E20] mb-3">Enter SHC Details Manually</p>
                <div className="space-y-3">
                  <input
                    type="text"
                    placeholder="SHC Number"
                    className="w-full px-4 py-3 bg-white rounded-xl border-2 border-[#43A047] focus:outline-none focus:border-[#1B5E20]"
                  />
                  <input
                    type="date"
                    placeholder="Test Date"
                    className="w-full px-4 py-3 bg-white rounded-xl border-2 border-[#43A047] focus:outline-none focus:border-[#1B5E20]"
                  />
                  <button className="w-full bg-gradient-to-r from-[#43A047] to-[#1B5E20] text-white py-3 rounded-xl shadow-md hover:shadow-lg transition-all">
                    Submit Details
                  </button>
                </div>
              </div>
            </div>

            <div className="bg-white rounded-3xl p-6 shadow-lg animate-scale-in">
              <h3 className="text-[#1B5E20] mb-4">Auto-Detect Soil Data</h3>
              
              <button className="w-full bg-gradient-to-r from-[#43A047] to-[#1B5E20] text-white py-4 rounded-2xl flex items-center justify-center gap-2 shadow-lg hover:shadow-xl transition-all hover:scale-105">
                <Navigation className="w-5 h-5" />
                Auto-Detect from Location
              </button>

              <div className="bg-blue-50 border-2 border-blue-200 rounded-2xl p-4 mt-4">
                <p className="text-[#1B5E20] mb-1">📍 Current Location</p>
                <p className="text-[#757575] text-sm">{location.district}, {location.state}</p>
                <p className="text-[#757575] text-xs mt-2">
                  We'll use regional soil data based on your location
                </p>
              </div>
            </div>
          </div>
        ) : (
          // Soil Details View
          <>
            <div className="bg-gradient-to-br from-[#8D6E63] to-[#6D4C41] rounded-3xl p-6 text-white shadow-lg mb-6 animate-scale-in">
              <div className="text-center">
                <div className="text-5xl mb-2">🌱</div>
                <h2 className="text-xl mb-1">Soil Status: Good</h2>
                <p className="text-sm opacity-90">Based on {location.district} region</p>
              </div>
            </div>

            {/* NPK Cards */}
            <div className="space-y-4 mb-6">
              {npkData.map((item) => (
                <div key={item.label} className="bg-white rounded-2xl p-4 shadow-sm animate-scale-in card-hover">
                  <div className="flex justify-between items-center mb-2">
                    <span className="text-[#1B5E20]">{item.label}</span>
                    <span className={`px-3 py-1 rounded-full text-xs ${
                      item.status === 'Good' ? 'bg-green-100 text-green-700' : 'bg-yellow-100 text-yellow-700'
                    }`}>
                      {item.status}
                    </span>
                  </div>
                  <div className="flex items-center gap-3">
                    <div className="flex-1 bg-[#FAFAF5] rounded-full h-3">
                      <div
                        className={`${item.color} h-3 rounded-full transition-all`}
                        style={{ width: `${item.value}%` }}
                      />
                    </div>
                    <span className="text-[#1B5E20]">{item.value}%</span>
                  </div>
                </div>
              ))}
            </div>

            {/* Soil Properties */}
            <div className="bg-white rounded-2xl p-6 shadow-sm mb-6 animate-scale-in">
              <h3 className="text-[#1B5E20] mb-4">Soil Properties</h3>
              <div className="space-y-4">
                <div className="flex items-center justify-between">
                  <span className="text-[#757575]">Soil Type</span>
                  <span className="text-[#1B5E20]">Loamy</span>
                </div>
                <div className="flex items-center justify-between">
                  <span className="text-[#757575]">pH Level</span>
                  <span className="text-[#1B5E20]">6.5 (Neutral)</span>
                </div>
                <div className="flex items-center justify-between">
                  <span className="text-[#757575]">Moisture</span>
                  <div className="flex items-center gap-2">
                    <Droplets className="w-4 h-4 text-blue-500" />
                    <span className="text-[#1B5E20]">68%</span>
                  </div>
                </div>
                <div className="flex items-center justify-between">
                  <span className="text-[#757575]">Organic Matter</span>
                  <span className="text-[#1B5E20]">4.2%</span>
                </div>
                <div className="flex items-center justify-between">
                  <span className="text-[#757575]">EC (Salinity)</span>
                  <span className="text-[#1B5E20]">0.8 dS/m</span>
                </div>
              </div>
            </div>

            {/* pH Slider */}
            <div className="bg-white rounded-2xl p-6 shadow-sm mb-6 animate-scale-in">
              <h3 className="text-[#1B5E20] mb-4">pH Scale</h3>
              <div className="relative">
                <div className="h-8 rounded-full bg-gradient-to-r from-red-500 via-yellow-500 via-green-500 to-blue-500"></div>
                <div
                  className="absolute top-0 w-4 h-8 bg-white border-4 border-[#1B5E20] rounded-full shadow-lg"
                  style={{ left: '50%', transform: 'translateX(-50%)' }}
                ></div>
              </div>
              <div className="flex justify-between text-xs text-[#757575] mt-2">
                <span>Acidic (0)</span>
                <span>Neutral (7)</span>
                <span>Alkaline (14)</span>
              </div>
            </div>

            {/* Insights */}
            <div className="mb-6">
              <h3 className="text-[#1B5E20] mb-3">Soil Insights</h3>
              <div className="flex gap-3 overflow-x-auto pb-2 horizontal-scroll">
                {insights.map((insight, idx) => (
                  <div key={idx} className="bg-white rounded-2xl p-4 min-w-[280px] shadow-sm flex items-start gap-3 card-hover animate-scale-in">
                    <div className="text-2xl">{insight.icon}</div>
                    <div className="text-[#1B5E20] text-sm">{insight.text}</div>
                  </div>
                ))}
              </div>
            </div>

            {/* Test Again Button */}
            <button className="w-full bg-gradient-to-r from-[#43A047] to-[#1B5E20] text-white py-4 rounded-2xl shadow-lg hover:shadow-xl transition-all hover:scale-105">
              Request Soil Test
            </button>
          </>
        )}
      </div>

      <FloatingIVR />
      <AppFooter />
    </div>
  );
}