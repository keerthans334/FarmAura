import { useNavigate, useLocation } from 'react-router-dom';
import { useState, useEffect } from 'react';
import AppHeader from './AppHeader';
import AppFooter from './AppFooter';
import FloatingIVR from './FloatingIVR';
import { ArrowLeft, Camera, Upload, AlertTriangle, X } from 'lucide-react';
import { toast } from 'sonner@2.0.3';

export default function PestDetection() {
  const navigate = useNavigate();
  const location = useLocation();
  const [showResult, setShowResult] = useState(false);
  const [uploadedImages, setUploadedImages] = useState<string[]>([]);

  // Update images when returning from camera/upload
  useEffect(() => {
    if (location.state?.images) {
      setUploadedImages(location.state.images);
    }
  }, [location.state]);

  const handleDetect = () => {
    if (uploadedImages.length < 4) {
      toast.error('Please upload at least 4 images for accurate detection');
      return;
    }
    setShowResult(true);
  };

  const handleRemoveImage = (index: number) => {
    setUploadedImages(prev => prev.filter((_, i) => i !== index));
    toast.success('Image removed');
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

        <h1 className="text-[#1B5E20] text-3xl mb-2">Pest Detection</h1>
        <p className="text-[#757575] mb-6">Upload or capture plant image for AI analysis</p>

        {!showResult ? (
          <>
            {/* Image Upload Instructions */}
            <div className="bg-gradient-to-r from-[#FFC107]/20 to-[#FF9800]/20 border-2 border-[#FFC107] rounded-3xl p-5 mb-6">
              <div className="flex items-start gap-3">
                <div className="text-3xl">📷</div>
                <div>
                  <h3 className="text-[#1B5E20] mb-1">Upload 4-5 Images for Accurate Detection</h3>
                  <p className="text-[#757575] text-sm">
                    Please provide multiple photos from different angles and parts of the plant for better AI analysis
                  </p>
                  <div className="mt-3 bg-white/60 rounded-xl px-3 py-2 inline-block">
                    <span className="text-[#1B5E20] font-medium">{uploadedImages.length} / 5 images uploaded</span>
                  </div>
                </div>
              </div>
            </div>

            {/* Uploaded Images Preview */}
            {uploadedImages.length > 0 && (
              <div className="bg-white rounded-3xl p-6 shadow-lg mb-6">
                <h3 className="text-[#1B5E20] mb-4">Uploaded Images ({uploadedImages.length})</h3>
                <div className="grid grid-cols-3 gap-3 mb-4">
                  {uploadedImages.map((img, index) => (
                    <div key={index} className="relative group">
                      <img src={img} alt={`Upload ${index + 1}`} className="w-full h-24 object-cover rounded-xl" />
                      <button
                        onClick={() => handleRemoveImage(index)}
                        className="absolute -top-2 -right-2 w-6 h-6 bg-red-500 text-white rounded-full flex items-center justify-center opacity-0 group-hover:opacity-100 transition-opacity shadow-lg"
                      >
                        <X className="w-4 h-4" />
                      </button>
                    </div>
                  ))}
                </div>
                {uploadedImages.length >= 4 && (
                  <button
                    onClick={handleDetect}
                    className="w-full bg-gradient-to-r from-[#43A047] to-[#1B5E20] text-white py-4 rounded-2xl shadow-lg hover:shadow-xl hover:scale-105 transition-all flex items-center justify-center gap-2"
                  >
                    <AlertTriangle className="w-5 h-5" />
                    Analyze Images
                  </button>
                )}
              </div>
            )}

            <div className="bg-white rounded-3xl p-8 shadow-lg mb-6">
              <div className="text-center mb-6">
                <div className="w-32 h-32 bg-[#FAFAF5] rounded-full flex items-center justify-center mx-auto mb-4">
                  <Camera className="w-16 h-16 text-[#43A047]" />
                </div>
                <h3 className="text-[#1B5E20] mb-2">Add More Images</h3>
                <p className="text-[#757575] text-sm">
                  {uploadedImages.length === 0 
                    ? 'Start by taking or uploading plant photos'
                    : uploadedImages.length < 4
                    ? `Add ${4 - uploadedImages.length} more images (minimum 4 required)`
                    : 'You can add up to 5 images total'}
                </p>
              </div>

              <div className="space-y-3">
                <button
                  onClick={() => navigate('/camera', { state: { images: uploadedImages } })}
                  disabled={uploadedImages.length >= 5}
                  className="w-full bg-[#43A047] text-white py-4 rounded-2xl flex items-center justify-center gap-3 hover:bg-[#1B5E20] transition-colors shadow-lg hover:shadow-xl hover:scale-105 transition-all disabled:opacity-50 disabled:cursor-not-allowed disabled:hover:scale-100"
                >
                  <Camera className="w-5 h-5" />
                  Open Camera
                </button>
                <button
                  onClick={() => navigate('/upload-image', { state: { images: uploadedImages } })}
                  disabled={uploadedImages.length >= 5}
                  className="w-full border-2 border-[#43A047] text-[#43A047] py-4 rounded-2xl flex items-center justify-center gap-3 hover:bg-[#FAFAF5] transition-colors shadow-lg hover:shadow-xl hover:scale-105 transition-all disabled:opacity-50 disabled:cursor-not-allowed disabled:hover:scale-100"
                >
                  <Upload className="w-5 h-5" />
                  Upload Image
                </button>
              </div>
            </div>
          </>
        ) : (
          <>
            <div className="bg-white rounded-3xl p-6 shadow-lg mb-6">
              <div className="text-center mb-6">
                <div className="w-24 h-24 bg-red-100 rounded-full flex items-center justify-center mx-auto mb-4">
                  <AlertTriangle className="w-12 h-12 text-red-600" />
                </div>
                <h3 className="text-[#1B5E20] text-xl mb-2">Leaf Blight Detected</h3>
                <div className="inline-block bg-red-100 text-red-700 px-4 py-2 rounded-full text-sm">
                  Severity: High (85%)
                </div>
              </div>

              <div className="bg-[#FAFAF5] rounded-2xl p-4 mb-4">
                <h4 className="text-[#1B5E20] mb-2">Disease Details</h4>
                <p className="text-[#757575] text-sm">
                  Leaf blight is a fungal disease that causes brown spots on leaves, leading to premature leaf death. It thrives in humid conditions.
                </p>
              </div>

              <div className="space-y-3">
                <div className="flex items-start gap-3">
                  <div className="w-8 h-8 bg-[#43A047] rounded-full flex items-center justify-center text-white shrink-0">1</div>
                  <div>
                    <div className="text-[#1B5E20] mb-1">Remove Affected Leaves</div>
                    <div className="text-[#757575] text-sm">Immediately remove and burn infected leaves to prevent spread</div>
                  </div>
                </div>
                <div className="flex items-start gap-3">
                  <div className="w-8 h-8 bg-[#43A047] rounded-full flex items-center justify-center text-white shrink-0">2</div>
                  <div>
                    <div className="text-[#1B5E20] mb-1">Apply Fungicide</div>
                    <div className="text-[#757575] text-sm">Use copper-based fungicide or Mancozeb 75% WP @ 2g/liter</div>
                  </div>
                </div>
                <div className="flex items-start gap-3">
                  <div className="w-8 h-8 bg-[#43A047] rounded-full flex items-center justify-center text-white shrink-0">3</div>
                  <div>
                    <div className="text-[#1B5E20] mb-1">Improve Air Circulation</div>
                    <div className="text-[#757575] text-sm">Ensure proper spacing between plants and avoid overhead irrigation</div>
                  </div>
                </div>
              </div>
            </div>

            <div className="bg-blue-50 rounded-2xl p-4 border-2 border-blue-200 mb-6">
              <div className="flex items-start gap-3">
                <div className="text-2xl">🌿</div>
                <div>
                  <div className="text-[#1B5E20] mb-1">Organic Alternative</div>
                  <div className="text-[#757575] text-sm">
                    Spray neem oil solution (5ml/liter) mixed with garlic extract for organic treatment.
                  </div>
                </div>
              </div>
            </div>

            <div className="grid grid-cols-2 gap-3">
              <button
                onClick={() => setShowResult(false)}
                className="bg-white border-2 border-[#43A047] text-[#43A047] py-4 rounded-2xl hover:bg-[#FAFAF5] transition-colors"
              >
                Scan Again
              </button>
              <button className="bg-[#43A047] text-white py-4 rounded-2xl hover:bg-[#1B5E20] transition-colors">
                Save Report
              </button>
            </div>
          </>
        )}
      </div>

      <FloatingIVR />
      <AppFooter />
    </div>
  );
}