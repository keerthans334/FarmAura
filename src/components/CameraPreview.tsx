import { useNavigate, useLocation } from 'react-router-dom';
import { ImageWithFallback } from './figma/ImageWithFallback';
import { toast } from 'sonner@2.0.3';

export default function CameraPreview() {
  const navigate = useNavigate();
  const location = useLocation();
  const imageUrl = location.state?.imageUrl || location.state?.preview || 'https://images.unsplash.com/photo-1530836369250-ef72a3f5cda8?w=600&h=800&fit=crop';
  const existingImages = location.state?.existingImages || [];

  const handleUsePhoto = () => {
    const updatedImages = [...existingImages, imageUrl];
    toast.success(`Image ${updatedImages.length} added!`);
    navigate('/pest', { state: { images: updatedImages } });
  };

  return (
    <div className="min-h-screen bg-[#FAFAF5] max-w-md mx-auto">
      {/* Preview Image */}
      <div className="relative">
        <img
          src={imageUrl}
          alt="Captured plant image"
          className="w-full h-[70vh] object-cover"
        />
        <div className="absolute top-6 left-6 bg-black/50 backdrop-blur-sm px-4 py-2 rounded-full text-white text-sm">
          Preview {existingImages.length > 0 && `(Image ${existingImages.length + 1})`}
        </div>
      </div>

      {/* Actions */}
      <div className="p-6 space-y-3">
        <button
          onClick={handleUsePhoto}
          className="w-full bg-gradient-to-r from-[#43A047] to-[#1B5E20] text-white py-4 rounded-2xl shadow-lg hover:shadow-xl transition-all hover:scale-105 flex items-center justify-center gap-2"
        >
          <span className="text-xl">✓</span>
          Add This Photo
        </button>

        <button
          onClick={() => navigate('/camera')}
          className="w-full bg-white text-[#1B5E20] py-4 rounded-2xl shadow-lg border-2 border-[#43A047] hover:bg-[#FAFAF5] transition-all flex items-center justify-center gap-2"
        >
          <span className="text-xl">↻</span>
          Retake
        </button>

        <button
          onClick={() => navigate('/pest')}
          className="w-full text-[#757575] py-3 hover:text-[#1B5E20] transition-colors"
        >
          Cancel
        </button>
      </div>
    </div>
  );
}