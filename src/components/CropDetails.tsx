import { useNavigate, useLocation } from 'react-router-dom';
import AppHeader from './AppHeader';
import AppFooter from './AppFooter';
import FloatingIVR from './FloatingIVR';
import { ArrowLeft, Droplets, TrendingUp, DollarSign, Calendar, Sun, Bug, AlertCircle } from 'lucide-react';

export default function CropDetails() {
  const navigate = useNavigate();
  const location = useLocation();
  
  // Default crop data - in real app, would come from navigation state
  const cropData = location.state || {
    crop: 'Cotton',
    icon: '🌾',
    suitability: 95,
    profit: '₹85,000',
    yield: '18-20 quintals/acre',
    reason: 'Excellent soil match',
    color: 'from-[#43A047] to-[#1B5E20]'
  };

  const detailedInfo = {
    growingPeriod: '150-180 days',
    waterRequirement: 'Medium (600-700mm)',
    soilType: 'Black cotton soil, Red soil',
    pHRange: '6.0-7.5 (Slightly acidic to neutral)',
    temperature: '21-30°C',
    rainfall: '600-1200mm annually',
    season: 'Kharif (June-October)',
    spacing: '90cm x 30cm',
    seedRate: '1-1.5 kg/acre',
    fertilizer: 'N:P:K = 120:60:60 kg/ha',
  };

  const stages = [
    { phase: 'Sowing', duration: '0-15 days', tasks: 'Seed treatment, Land preparation', icon: '🌱' },
    { phase: 'Vegetative', duration: '15-60 days', tasks: 'Irrigation, Weeding, First fertilizer dose', icon: '🌿' },
    { phase: 'Flowering', duration: '60-90 days', tasks: 'Pest control, Second fertilizer dose', icon: '🌸' },
    { phase: 'Boll Formation', duration: '90-120 days', tasks: 'Regular monitoring, Adequate water supply', icon: '🌾' },
    { phase: 'Harvesting', duration: '150-180 days', tasks: 'Hand picking when bolls open', icon: '👐' }
  ];

  const pestDiseases = [
    { name: 'Bollworm', severity: 'High', control: 'Neem oil spray, BT cotton variety', icon: '🐛' },
    { name: 'Aphids', severity: 'Medium', control: 'Insecticidal soap, Natural predators', icon: '🦗' },
    { name: 'Wilting', severity: 'Medium', control: 'Crop rotation, Resistant varieties', icon: '🍂' }
  ];

  const fertilizerPlan = [
    { stage: 'Basal (At sowing)', fertilizer: 'DAP', quantity: '50 kg/acre', timing: 'Day 0' },
    { stage: 'First dose', fertilizer: 'Urea', quantity: '25 kg/acre', timing: 'Day 30' },
    { stage: 'Second dose', fertilizer: 'NPK (19:19:19)', quantity: '30 kg/acre', timing: 'Day 60' },
    { stage: 'Third dose', fertilizer: 'Potash', quantity: '20 kg/acre', timing: 'Day 90' }
  ];

  const irrigationSchedule = [
    { stage: 'Sowing to germination', frequency: 'Light irrigation', timing: 'Days 0-10', water: '20mm' },
    { stage: 'Vegetative growth', frequency: 'Every 7-10 days', timing: 'Days 15-60', water: '40-50mm per irrigation' },
    { stage: 'Flowering', frequency: 'Every 5-7 days', timing: 'Days 60-90', water: '50-60mm per irrigation' },
    { stage: 'Boll development', frequency: 'Every 7-10 days', timing: 'Days 90-150', water: '40-50mm per irrigation' }
  ];

  const marketInfo = {
    currentPrice: '₹6,500/quintal',
    trend: 'Stable',
    demand: 'High',
    majorBuyers: 'Textile mills, Export market'
  };

  return (
    <div className="min-h-screen bg-[#FAFAF5] pb-24 max-w-md mx-auto">
      <AppHeader />
      <div className="pt-20 px-4">
        <button
          onClick={() => navigate(-1)}
          className="flex items-center gap-2 text-[#43A047] mb-4"
        >
          <ArrowLeft className="w-5 h-5" />
          Back
        </button>

        {/* Crop Header */}
        <div className="bg-gradient-to-br from-[#43A047] to-[#1B5E20] rounded-3xl p-6 text-white mb-6 shadow-lg">
          <div className="flex items-start justify-between mb-4">
            <div className="flex items-center gap-4">
              <div className="text-6xl">{cropData.icon}</div>
              <div>
                <h1 className="text-3xl mb-1">{cropData.crop}</h1>
                <p className="opacity-90">{cropData.reason}</p>
              </div>
            </div>
          </div>
          
          <div className="flex justify-between text-sm opacity-90 mb-2">
            <span>Suitability Score</span>
            <span>{cropData.suitability}%</span>
          </div>
          <div className="bg-white/20 rounded-full h-3">
            <div
              className="bg-white h-3 rounded-full transition-all"
              style={{ width: `${cropData.suitability}%` }}
            />
          </div>
        </div>

        {/* Quick Stats */}
        <div className="grid grid-cols-2 gap-4 mb-6">
          <div className="bg-white rounded-2xl p-4 shadow-sm">
            <div className="flex items-center gap-2 text-[#757575] text-sm mb-1">
              <DollarSign className="w-4 h-4" />
              <span>Expected Profit</span>
            </div>
            <div className="text-[#1B5E20] text-xl">{cropData.profit}</div>
            <div className="text-[#757575] text-xs">per acre</div>
          </div>
          <div className="bg-white rounded-2xl p-4 shadow-sm">
            <div className="flex items-center gap-2 text-[#757575] text-sm mb-1">
              <TrendingUp className="w-4 h-4" />
              <span>Yield Estimate</span>
            </div>
            <div className="text-[#1B5E20] text-sm">{cropData.yield}</div>
          </div>
        </div>

        {/* Growing Requirements */}
        <div className="bg-white rounded-3xl p-6 shadow-sm mb-6">
          <h2 className="text-[#1B5E20] text-xl mb-4">Growing Requirements</h2>
          <div className="space-y-4">
            <div className="flex items-start gap-3">
              <Calendar className="w-5 h-5 text-[#43A047] mt-1" />
              <div className="flex-1">
                <div className="text-[#1B5E20] font-medium">Growing Period</div>
                <div className="text-[#757575] text-sm">{detailedInfo.growingPeriod}</div>
              </div>
            </div>
            <div className="flex items-start gap-3">
              <Droplets className="w-5 h-5 text-[#43A047] mt-1" />
              <div className="flex-1">
                <div className="text-[#1B5E20] font-medium">Water Requirement</div>
                <div className="text-[#757575] text-sm">{detailedInfo.waterRequirement}</div>
              </div>
            </div>
            <div className="flex items-start gap-3">
              <Sun className="w-5 h-5 text-[#43A047] mt-1" />
              <div className="flex-1">
                <div className="text-[#1B5E20] font-medium">Temperature Range</div>
                <div className="text-[#757575] text-sm">{detailedInfo.temperature}</div>
              </div>
            </div>
            <div className="flex items-start gap-3">
              <div className="w-5 h-5 text-[#43A047] mt-1">🌍</div>
              <div className="flex-1">
                <div className="text-[#1B5E20] font-medium">Soil Type</div>
                <div className="text-[#757575] text-sm">{detailedInfo.soilType}</div>
              </div>
            </div>
            <div className="flex items-start gap-3">
              <div className="w-5 h-5 text-[#43A047] mt-1">🧪</div>
              <div className="flex-1">
                <div className="text-[#1B5E20] font-medium">pH Range</div>
                <div className="text-[#757575] text-sm">{detailedInfo.pHRange}</div>
              </div>
            </div>
            <div className="flex items-start gap-3">
              <div className="w-5 h-5 text-[#43A047] mt-1">🌧️</div>
              <div className="flex-1">
                <div className="text-[#1B5E20] font-medium">Rainfall</div>
                <div className="text-[#757575] text-sm">{detailedInfo.rainfall}</div>
              </div>
            </div>
          </div>
        </div>

        {/* Growing Stages */}
        <div className="bg-white rounded-3xl p-6 shadow-sm mb-6">
          <h2 className="text-[#1B5E20] text-xl mb-4">Growing Stages</h2>
          <div className="space-y-4">
            {stages.map((stage, idx) => (
              <div key={idx} className="flex items-start gap-4">
                <div className="text-3xl">{stage.icon}</div>
                <div className="flex-1">
                  <div className="flex items-center gap-2 mb-1">
                    <div className="text-[#1B5E20] font-medium">{stage.phase}</div>
                    <div className="text-[#43A047] text-sm">({stage.duration})</div>
                  </div>
                  <div className="text-[#757575] text-sm">{stage.tasks}</div>
                </div>
              </div>
            ))}
          </div>
        </div>

        {/* Fertilizer Plan */}
        <div className="bg-white rounded-3xl p-6 shadow-sm mb-6">
          <h2 className="text-[#1B5E20] text-xl mb-4">Stage-wise Fertilizer Plan</h2>
          <div className="space-y-3">
            {fertilizerPlan.map((plan, idx) => (
              <div key={idx} className="bg-[#FAFAF5] rounded-2xl p-4">
                <div className="flex items-center justify-between mb-2">
                  <div className="text-[#1B5E20] font-medium">{plan.stage}</div>
                  <div className="text-[#43A047] text-sm">{plan.timing}</div>
                </div>
                <div className="flex items-center justify-between text-sm">
                  <span className="text-[#757575]">{plan.fertilizer}</span>
                  <span className="text-[#1B5E20]">{plan.quantity}</span>
                </div>
              </div>
            ))}
          </div>
        </div>

        {/* Irrigation Schedule */}
        <div className="bg-white rounded-3xl p-6 shadow-sm mb-6">
          <div className="flex items-center gap-2 mb-4">
            <Droplets className="w-6 h-6 text-[#1B5E20]" />
            <h2 className="text-[#1B5E20] text-xl">Irrigation Schedule</h2>
          </div>
          <div className="space-y-3">
            {irrigationSchedule.map((schedule, idx) => (
              <div key={idx} className="bg-[#E8F5E9] rounded-2xl p-4">
                <div className="flex items-center justify-between mb-2">
                  <div className="text-[#1B5E20] font-medium">{schedule.stage}</div>
                  <div className="text-[#43A047] text-sm">{schedule.timing}</div>
                </div>
                <div className="flex items-center justify-between text-sm">
                  <span className="text-[#757575]">{schedule.frequency}</span>
                  <span className="text-[#1B5E20]">{schedule.water}</span>
                </div>
              </div>
            ))}
          </div>
        </div>

        {/* Market Information */}
        <div className="bg-gradient-to-br from-[#FFC107] to-[#FF9800] rounded-3xl p-6 text-white shadow-lg mb-6">
          <h2 className="text-xl mb-4">Market Information</h2>
          <div className="space-y-3">
            <div className="flex justify-between">
              <span>Current Price:</span>
              <span className="font-medium">{marketInfo.currentPrice}</span>
            </div>
            <div className="flex justify-between">
              <span>Market Trend:</span>
              <span className="font-medium">{marketInfo.trend}</span>
            </div>
            <div className="flex justify-between">
              <span>Demand:</span>
              <span className="font-medium">{marketInfo.demand}</span>
            </div>
            <div>
              <span>Major Buyers:</span>
              <div className="font-medium mt-1">{marketInfo.majorBuyers}</div>
            </div>
          </div>
        </div>

        {/* Action Buttons */}
        <div className="flex gap-3 mb-6">
          <button
            onClick={() => navigate('/crop-input')}
            className="flex-1 bg-white border-2 border-[#43A047] text-[#43A047] py-4 rounded-2xl hover:bg-[#FAFAF5] transition-colors"
          >
            Try Different Inputs
          </button>
          <button
            onClick={() => navigate('/market')}
            className="flex-1 bg-[#43A047] text-white py-4 rounded-2xl hover:bg-[#1B5E20] transition-colors"
          >
            View Market Prices
          </button>
        </div>
      </div>

      <FloatingIVR />
      <AppFooter />
    </div>
  );
}