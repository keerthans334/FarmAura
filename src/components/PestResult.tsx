import { useNavigate } from 'react-router-dom';
import AppHeader from './AppHeader';
import AppFooter from './AppFooter';
import FloatingIVR from './FloatingIVR';
import { ImageWithFallback } from './figma/ImageWithFallback';
import { AlertTriangle, CheckCircle, TrendingUp } from 'lucide-react';

export default function PestResult() {
  const navigate = useNavigate();

  return (
    <div className="min-h-screen bg-[#FAFAF5] pb-24 max-w-md mx-auto">
      <AppHeader />
      <div className="pt-20 px-4">
        <h1 className="text-[#1B5E20] text-3xl mb-2">Detection Result</h1>
        <p className="text-[#757575] mb-6">AI-powered pest and disease analysis</p>

        {/* Analyzed Image */}
        <div className="bg-white rounded-3xl p-4 shadow-lg mb-4">
          <ImageWithFallback
            src="https://images.unsplash.com/photo-1530836369250-ef72a3f5cda8?w=600&h=400&fit=crop"
            alt="Analyzed plant"
            className="w-full h-48 object-cover rounded-2xl mb-4"
          />
          <div className="flex items-center justify-between">
            <div>
              <p className="text-[#757575] text-sm">Detection Confidence</p>
              <p className="text-[#1B5E20] text-2xl">94%</p>
            </div>
            <div className="w-16 h-16 bg-[#FFF3E0] rounded-full flex items-center justify-center">
              <AlertTriangle className="w-8 h-8 text-[#FFC107]" />
            </div>
          </div>
        </div>

        {/* Result Card */}
        <div className="bg-white rounded-3xl p-6 shadow-lg mb-4">
          <div className="flex items-start gap-3 mb-4">
            <div className="w-12 h-12 bg-[#FFEBEE] rounded-full flex items-center justify-center">
              <span className="text-2xl">🐛</span>
            </div>
            <div className="flex-1">
              <h3 className="text-[#1B5E20] text-xl mb-1">Leaf Blight Detected</h3>
              <p className="text-[#757575] text-sm">Common fungal disease affecting tomato plants</p>
            </div>
          </div>

          <div className="space-y-3">
            <div className="bg-[#FFEBEE] rounded-2xl p-4">
              <p className="text-[#1B5E20] mb-2">🔍 Symptoms:</p>
              <ul className="text-[#757575] text-sm space-y-1">
                <li>• Brown spots on leaves</li>
                <li>• Yellowing around edges</li>
                <li>• Wilting in advanced stages</li>
              </ul>
            </div>

            <div className="bg-[#E8F5E9] rounded-2xl p-4">
              <p className="text-[#1B5E20] mb-2">💊 Treatment:</p>
              <ul className="text-[#757575] text-sm space-y-1">
                <li>• Apply fungicide (Mancozeb)</li>
                <li>• Remove affected leaves</li>
                <li>• Improve air circulation</li>
                <li>• Reduce overhead watering</li>
              </ul>
            </div>

            <div className="bg-[#FFF8E1] rounded-2xl p-4">
              <p className="text-[#1B5E20] mb-2">🌱 Prevention:</p>
              <ul className="text-[#757575] text-sm space-y-1">
                <li>• Use resistant varieties</li>
                <li>• Crop rotation</li>
                <li>• Proper spacing between plants</li>
              </ul>
            </div>
          </div>
        </div>

        {/* Action Buttons */}
        <div className="space-y-3 mb-6">
          <button
            onClick={() => navigate('/ai-chat')}
            className="w-full bg-gradient-to-r from-[#43A047] to-[#1B5E20] text-white py-4 rounded-2xl shadow-lg hover:shadow-xl transition-all hover:scale-105 flex items-center justify-center gap-2"
          >
            <span className="text-xl">💬</span>
            Ask AI Expert
          </button>

          <button
            onClick={() => navigate('/pest')}
            className="w-full bg-white text-[#1B5E20] py-4 rounded-2xl shadow-lg border-2 border-[#43A047] hover:bg-[#FAFAF5] transition-all"
          >
            Scan Another Plant
          </button>
        </div>
      </div>

      <FloatingIVR />
      <AppFooter />
    </div>
  );
}
