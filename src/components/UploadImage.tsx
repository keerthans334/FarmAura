import { useNavigate, useLocation } from 'react-router-dom';
import { useState } from 'react';
import { Image as ImageIcon, FolderOpen, ArrowLeft } from 'lucide-react';
import { toast } from 'sonner@2.0.3';

export default function UploadImage() {
  const navigate = useNavigate();
  const location = useLocation();
  const existingImages = location.state?.images || [];
  const [selectedImage, setSelectedImage] = useState<File | null>(null);
  const [imagePreview, setImagePreview] = useState<string | null>(null);

  const handleImageSelect = (e: React.ChangeEvent<HTMLInputElement>) => {
    const file = e.target.files?.[0];
    if (file) {
      setSelectedImage(file);
      const reader = new FileReader();
      reader.onloadend = () => {
        setImagePreview(reader.result as string);
        toast.success('Image selected successfully!');
        // Navigate to preview with the image data and existing images
        setTimeout(() => {
          navigate('/camera-preview', { state: { image: file, preview: reader.result, existingImages } });
        }, 500);
      };
      reader.readAsDataURL(file);
    }
  };

  return (
    <div className="min-h-screen bg-[#FAFAF5] max-w-md mx-auto p-6">
      <div className="mb-6">
        <button
          onClick={() => navigate('/pest')}
          className="flex items-center gap-2 text-[#43A047]"
        >
          <ArrowLeft className="w-5 h-5" />
          Back
        </button>
      </div>

      <div className="text-center mb-8">
        <div className="w-24 h-24 bg-[#43A047] rounded-full flex items-center justify-center mx-auto mb-4">
          <ImageIcon className="w-12 h-12 text-white" />
        </div>
        <h2 className="text-[#1B5E20] text-3xl mb-2">Upload Image</h2>
        <p className="text-[#757575]">Choose an image from your device</p>
      </div>

      <div className="space-y-4">
        {/* Gallery Option - With actual file input */}
        <label htmlFor="gallery-upload" className="block">
          <div className="w-full bg-white rounded-3xl p-8 shadow-lg hover:shadow-xl transition-all hover:scale-105 border-2 border-[#43A047] cursor-pointer">
            <div className="flex flex-col items-center gap-4">
              <div className="w-20 h-20 bg-[#E8F5E9] rounded-2xl flex items-center justify-center">
                <ImageIcon className="w-10 h-10 text-[#43A047]" />
              </div>
              <div className="text-center">
                <h3 className="text-[#1B5E20] text-xl mb-2">Choose from Gallery</h3>
                <p className="text-[#757575] text-sm">Select a photo from your library</p>
              </div>
            </div>
          </div>
        </label>
        <input
          id="gallery-upload"
          type="file"
          accept="image/*"
          onChange={handleImageSelect}
          className="hidden"
        />
      </div>

      {/* Tips */}
      <div className="mt-8 bg-[#E8F5E9] rounded-2xl p-4">
        <p className="text-[#1B5E20] text-sm mb-2">📸 Tips for best results:</p>
        <ul className="text-[#757575] text-sm space-y-1">
          <li>• Use clear, well-lit photos</li>
          <li>• Focus on affected leaf or plant part</li>
          <li>• Avoid blurry images</li>
        </ul>
      </div>
    </div>
  );
}