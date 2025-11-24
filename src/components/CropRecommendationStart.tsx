import { useNavigate } from 'react-router-dom';
import AppHeader from './AppHeader';
import AppFooter from './AppFooter';
import FloatingIVR from './FloatingIVR';
import { ImageWithFallback } from './figma/ImageWithFallback';
import { Sprout, Sparkles, TrendingUp, Shield } from 'lucide-react';

export default function CropRecommendationStart() {
  const navigate = useNavigate();

  return (
    <div className="min-h-screen bg-[#FAFAF5] pb-24 max-w-md mx-auto">
      <AppHeader />
      <div className="pt-20 px-4">
        {/* Hero Section */}
        <div className="bg-gradient-to-br from-[#43A047] to-[#1B5E20] rounded-3xl p-6 text-white mb-6 shadow-xl relative overflow-hidden">
          <div className="absolute top-0 right-0 w-32 h-32 bg-white/10 rounded-full -mr-16 -mt-16"></div>
          <div className="absolute bottom-0 left-0 w-24 h-24 bg-white/10 rounded-full -ml-12 -mb-12"></div>
          
          <div className="relative z-10">
            <div className="flex items-center gap-2 mb-3">
              <Sparkles className="w-6 h-6" />
              <span className="text-sm opacity-90">AI-Powered</span>
            </div>
            <h1 className="text-3xl mb-3">Crop Advisory</h1>
            <p className="opacity-90 text-sm mb-6">Get personalized crop recommendations based on your farm's unique conditions</p>
            
            <button
              onClick={() => navigate('/crop-input')}
              className="w-full bg-white text-[#43A047] py-4 rounded-2xl shadow-lg hover:scale-105 transition-all font-medium"
            >
              Start Crop Advisory
            </button>
          </div>
        </div>

        {/* Image */}
        <ImageWithFallback
          src="https://images.unsplash.com/photo-1574943320219-553eb213f72d?w=600&h=300&fit=crop"
          alt="Crop recommendation illustration"
          className="w-full h-56 object-cover rounded-3xl mb-6 shadow-lg"
        />

        {/* Features Grid */}
        <div className="grid grid-cols-3 gap-3 mb-6">
          <div className="bg-white rounded-2xl p-4 text-center shadow-sm">
            <div className="w-12 h-12 bg-[#E8F5E9] rounded-full flex items-center justify-center mx-auto mb-2">
              <TrendingUp className="w-6 h-6 text-[#43A047]" />
            </div>
            <div className="text-2xl text-[#1B5E20] mb-1">98%</div>
            <div className="text-xs text-[#757575]">Accuracy</div>
          </div>
          <div className="bg-white rounded-2xl p-4 text-center shadow-sm">
            <div className="w-12 h-12 bg-[#FFF8E1] rounded-full flex items-center justify-center mx-auto mb-2">
              <span className="text-2xl">👨‍🌾</span>
            </div>
            <div className="text-2xl text-[#1B5E20] mb-1">50K+</div>
            <div className="text-xs text-[#757575]">Farmers</div>
          </div>
          <div className="bg-white rounded-2xl p-4 text-center shadow-sm">
            <div className="w-12 h-12 bg-[#E8F5E9] rounded-full flex items-center justify-center mx-auto mb-2">
              <Sprout className="w-6 h-6 text-[#43A047]" />
            </div>
            <div className="text-2xl text-[#1B5E20] mb-1">30+</div>
            <div className="text-xs text-[#757575]">Crops</div>
          </div>
        </div>

        {/* How It Works */}
        <div className="bg-white rounded-3xl p-6 shadow-sm mb-6">
          <h3 className="text-[#1B5E20] text-xl mb-5">How It Works</h3>
          <div className="space-y-5">
            <div className="flex items-start gap-4">
              <div className="w-12 h-12 bg-gradient-to-br from-[#43A047] to-[#1B5E20] rounded-full flex items-center justify-center text-white shrink-0 shadow-md">
                1
              </div>
              <div className="flex-1 pt-2">
                <div className="text-[#1B5E20] font-medium mb-1">Enter Farm Details</div>
                <div className="text-[#757575] text-sm">Provide information about your land size, irrigation, and location</div>
              </div>
            </div>
            <div className="flex items-start gap-4">
              <div className="w-12 h-12 bg-gradient-to-br from-[#FFC107] to-[#FF9800] rounded-full flex items-center justify-center text-white shrink-0 shadow-md">
                2
              </div>
              <div className="flex-1 pt-2">
                <div className="text-[#1B5E20] font-medium mb-1">Share Soil Data</div>
                <div className="text-[#757575] text-sm">Enter soil type, pH levels, and nutrient information</div>
              </div>
            </div>
            <div className="flex items-start gap-4">
              <div className="w-12 h-12 bg-gradient-to-br from-[#8D6E63] to-[#6D4C41] rounded-full flex items-center justify-center text-white shrink-0 shadow-md">
                3
              </div>
              <div className="flex-1 pt-2">
                <div className="text-[#1B5E20] font-medium mb-1">Get AI Recommendations</div>
                <div className="text-[#757575] text-sm">Receive top 3 crop suggestions with detailed yield and profit analysis</div>
              </div>
            </div>
          </div>
        </div>

        {/* Benefits */}
        <div className="bg-gradient-to-br from-[#E8F5E9] to-[#C8E6C9] rounded-3xl p-6">
          <div className="flex items-center gap-2 mb-4">
            <Shield className="w-6 h-6 text-[#1B5E20]" />
            <h3 className="text-[#1B5E20] text-xl">Why Use Crop Advisory?</h3>
          </div>
          <div className="space-y-3">
            <div className="flex items-center gap-3">
              <div className="w-2 h-2 bg-[#43A047] rounded-full"></div>
              <span className="text-[#1B5E20] text-sm">Maximize your farm profits with data-driven decisions</span>
            </div>
            <div className="flex items-center gap-3">
              <div className="w-2 h-2 bg-[#43A047] rounded-full"></div>
              <span className="text-[#1B5E20] text-sm">Reduce crop failure risk with suitable crop selection</span>
            </div>
            <div className="flex items-center gap-3">
              <div className="w-2 h-2 bg-[#43A047] rounded-full"></div>
              <span className="text-[#1B5E20] text-sm">Get market-demand based crop suggestions</span>
            </div>
            <div className="flex items-center gap-3">
              <div className="w-2 h-2 bg-[#43A047] rounded-full"></div>
              <span className="text-[#1B5E20] text-sm">Access detailed growing guides for each crop</span>
            </div>
          </div>
        </div>
      </div>

      <FloatingIVR />
      <AppFooter />
    </div>
  );
}