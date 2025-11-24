import { useNavigate } from 'react-router-dom';
import AppHeader from './AppHeader';
import AppFooter from './AppFooter';
import FloatingIVR from './FloatingIVR';
import { ArrowLeft, CheckCircle } from 'lucide-react';

export default function WhyThisCrop() {
  const navigate = useNavigate();

  const reasons = [
    {
      title: 'Excellent Soil Match',
      description: 'Your loamy soil with pH 6.5 is perfect for cotton cultivation. The NPK ratio matches cotton requirements.',
      icon: '🌱',
      color: 'bg-green-50 border-green-200'
    },
    {
      title: 'Weather Suitability',
      description: 'Current temperature (28-32°C) and upcoming rainfall pattern are ideal for cotton sowing season.',
      icon: '☀️',
      color: 'bg-yellow-50 border-yellow-200'
    },
    {
      title: 'Rotation Benefit',
      description: 'Cotton after wheat provides excellent crop rotation benefits, reducing pest pressure and improving soil health.',
      icon: '🔄',
      color: 'bg-blue-50 border-blue-200'
    },
    {
      title: 'Market Advantage',
      description: 'Current cotton prices are ₹7,200/quintal with 12% upward trend. MSP support available at ₹6,620/quintal.',
      icon: '💰',
      color: 'bg-orange-50 border-orange-200'
    }
  ];

  const growthTimeline = [
    { stage: 'Sowing', duration: 'Week 1-2', icon: '🌱' },
    { stage: 'Germination', duration: 'Week 2-3', icon: '🌿' },
    { stage: 'Vegetative', duration: 'Week 4-12', icon: '🌾' },
    { stage: 'Flowering', duration: 'Week 13-18', icon: '🌸' },
    { stage: 'Boll Formation', duration: 'Week 19-24', icon: '🫘' },
    { stage: 'Harvest', duration: 'Week 25-28', icon: '🌾' }
  ];

  return (
    <div className="min-h-screen bg-[#FAFAF5] pb-24 max-w-md mx-auto">
      <AppHeader />
      <div className="pt-20 px-4">
        <button
          onClick={() => navigate('/crop-results')}
          className="flex items-center gap-2 text-[#43A047] mb-4"
        >
          <ArrowLeft className="w-5 h-5" />
          Back
        </button>

        <div className="text-center mb-6">
          <div className="text-6xl mb-3">🌾</div>
          <h1 className="text-[#1B5E20] text-3xl mb-2">Why Cotton?</h1>
          <p className="text-[#757575]">Here's why cotton is perfect for your farm</p>
        </div>

        <div className="bg-gradient-to-br from-[#43A047] to-[#1B5E20] rounded-3xl p-6 text-white shadow-lg mb-6">
          <div className="text-center">
            <div className="text-5xl mb-2">95%</div>
            <div className="text-xl mb-1">Suitability Score</div>
            <div className="flex items-center justify-center gap-2 text-sm opacity-90">
              <CheckCircle className="w-4 h-4" />
              <span>Highly Recommended</span>
            </div>
          </div>
        </div>

        <h3 className="text-[#1B5E20] mb-4">Key Factors</h3>
        <div className="space-y-4 mb-6">
          {reasons.map((reason, idx) => (
            <div key={idx} className={`${reason.color} rounded-2xl p-5 border-2`}>
              <div className="flex items-start gap-3">
                <div className="text-4xl">{reason.icon}</div>
                <div className="flex-1">
                  <h4 className="text-[#1B5E20] mb-2">{reason.title}</h4>
                  <p className="text-[#757575] text-sm">{reason.description}</p>
                </div>
              </div>
            </div>
          ))}
        </div>

        <h3 className="text-[#1B5E20] mb-4">Growth Timeline</h3>
        <div className="bg-white rounded-3xl p-6 shadow-sm mb-6">
          <div className="space-y-4">
            {growthTimeline.map((stage, idx) => (
              <div key={idx} className="flex items-center gap-4">
                <div className="w-12 h-12 bg-[#FAFAF5] rounded-full flex items-center justify-center text-2xl shrink-0">
                  {stage.icon}
                </div>
                <div className="flex-1">
                  <div className="text-[#1B5E20]">{stage.stage}</div>
                  <div className="text-[#757575] text-sm">{stage.duration}</div>
                </div>
                {idx < growthTimeline.length - 1 && (
                  <div className="w-px h-8 bg-[#43A047] absolute left-10 mt-16"></div>
                )}
              </div>
            ))}
          </div>
        </div>

        <div className="bg-green-50 rounded-2xl p-4 border-2 border-green-200 mb-6">
          <div className="flex items-start gap-3">
            <div className="text-2xl">💡</div>
            <div>
              <div className="text-[#1B5E20] mb-1">Pro Tip</div>
              <div className="text-[#757575] text-sm">
                Ensure proper spacing of 2-3 feet between plants and maintain adequate irrigation during flowering stage for maximum yield.
              </div>
            </div>
          </div>
        </div>

        <div className="grid grid-cols-2 gap-3">
          <button
            onClick={() => navigate('/crop-results')}
            className="bg-white border-2 border-[#43A047] text-[#43A047] py-4 rounded-2xl hover:bg-[#FAFAF5] transition-colors"
          >
            Back to Results
          </button>
          <button className="bg-[#43A047] text-white py-4 rounded-2xl hover:bg-[#1B5E20] transition-colors">
            Save Plan
          </button>
        </div>
      </div>

      <FloatingIVR />
      <AppFooter />
    </div>
  );
}