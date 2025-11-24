import { useNavigate } from 'react-router-dom';
import AppHeader from './AppHeader';
import AppFooter from './AppFooter';
import FloatingIVR from './FloatingIVR';
import { ArrowLeft, TrendingUp, Droplets, DollarSign } from 'lucide-react';

export default function RecommendationResults() {
  const navigate = useNavigate();

  const recommendations = [
    {
      crop: 'Cotton',
      icon: '🌾',
      suitability: 95,
      profit: '₹85,000',
      yield: '18-20 quintals/acre',
      reason: 'Excellent soil match',
      color: 'from-[#43A047] to-[#1B5E20]'
    },
    {
      crop: 'Soybean',
      icon: '🫘',
      suitability: 88,
      profit: '₹65,000',
      yield: '12-15 quintals/acre',
      reason: 'Good rotation benefit',
      color: 'from-[#FFC107] to-[#FF9800]'
    },
    {
      crop: 'Maize',
      icon: '🌽',
      suitability: 82,
      profit: '₹55,000',
      yield: '25-30 quintals/acre',
      reason: 'Favorable weather',
      color: 'from-[#8D6E63] to-[#6D4C41]'
    }
  ];

  return (
    <div className="min-h-screen bg-[#FAFAF5] pb-24 max-w-md mx-auto">
      <AppHeader />
      <div className="pt-20 px-4">
        <button
          onClick={() => navigate('/crop-input')}
          className="flex items-center gap-2 text-[#43A047] mb-4"
        >
          <ArrowLeft className="w-5 h-5" />
          Back
        </button>

        <h1 className="text-[#1B5E20] text-3xl mb-2">Recommended Crops</h1>
        <p className="text-[#757575] mb-6">Based on your farm conditions</p>

        <div className="space-y-4 mb-6">
          {recommendations.map((rec, idx) => (
            <div key={idx} className="bg-white rounded-3xl p-6 shadow-lg">
              <div className="flex items-start justify-between mb-4">
                <div className="flex items-center gap-3">
                  <div className="text-5xl">{rec.icon}</div>
                  <div>
                    <h3 className="text-[#1B5E20] text-xl">{rec.crop}</h3>
                    <p className="text-[#757575] text-sm">{rec.reason}</p>
                  </div>
                </div>
                <div className={`bg-gradient-to-r ${rec.color} text-white px-3 py-1 rounded-full text-sm`}>
                  #{idx + 1}
                </div>
              </div>

              <div className="mb-4">
                <div className="flex justify-between text-sm text-[#757575] mb-2">
                  <span>Suitability Score</span>
                  <span className="text-[#1B5E20]">{rec.suitability}%</span>
                </div>
                <div className="bg-[#FAFAF5] rounded-full h-3">
                  <div
                    className={`bg-gradient-to-r ${rec.color} h-3 rounded-full transition-all`}
                    style={{ width: `${rec.suitability}%` }}
                  />
                </div>
              </div>

              <div className="grid grid-cols-2 gap-4 mb-4">
                <div className="bg-[#FAFAF5] rounded-2xl p-3">
                  <div className="flex items-center gap-2 text-[#757575] text-sm mb-1">
                    <DollarSign className="w-4 h-4" />
                    <span>Expected Profit</span>
                  </div>
                  <div className="text-[#1B5E20]">{rec.profit}</div>
                  <div className="text-[#757575] text-xs">per acre</div>
                </div>
                <div className="bg-[#FAFAF5] rounded-2xl p-3">
                  <div className="flex items-center gap-2 text-[#757575] text-sm mb-1">
                    <TrendingUp className="w-4 h-4" />
                    <span>Yield Estimate</span>
                  </div>
                  <div className="text-[#1B5E20] text-sm">{rec.yield}</div>
                </div>
              </div>

              <div className="flex gap-3">
                <button
                  onClick={() => navigate('/why-crop')}
                  className="flex-1 bg-[#43A047] text-white py-3 rounded-xl hover:bg-[#1B5E20] transition-colors"
                >
                  Why This Crop?
                </button>
                <button 
                  onClick={() => navigate('/crop-details', { state: rec })}
                  className="flex-1 border-2 border-[#43A047] text-[#43A047] py-3 rounded-xl hover:bg-[#FAFAF5] transition-colors"
                >
                  View Details
                </button>
              </div>
            </div>
          ))}
        </div>

        <button
          onClick={() => navigate('/crop-input')}
          className="w-full bg-white border-2 border-[#43A047] text-[#43A047] py-4 rounded-2xl hover:bg-[#FAFAF5] transition-colors"
        >
          Try Different Inputs
        </button>
      </div>

      <FloatingIVR />
      <AppFooter />
    </div>
  );
}