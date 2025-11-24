import { useNavigate, useLocation } from 'react-router-dom';
import { useRef, useEffect, useState } from 'react';
import { Zap, RefreshCw, Camera, Image as ImageIcon, X, AlertCircle } from 'lucide-react';
import { toast } from 'sonner@2.0.3';

export default function CameraInterface() {
  const navigate = useNavigate();
  const location = useLocation();
  const existingImages = location.state?.images || [];
  const videoRef = useRef<HTMLVideoElement>(null);
  const fileInputRef = useRef<HTMLInputElement>(null);
  const [stream, setStream] = useState<MediaStream | null>(null);
  const [hasPermission, setHasPermission] = useState<boolean | null>(null);
  const [error, setError] = useState<string>('');

  useEffect(() => {
    startCamera();
    return () => {
      // Cleanup: stop camera when component unmounts
      if (stream) {
        stream.getTracks().forEach(track => track.stop());
      }
    };
  }, []);

  const startCamera = async () => {
    try {
      // Check if mediaDevices is supported
      if (!navigator.mediaDevices || !navigator.mediaDevices.getUserMedia) {
        setHasPermission(false);
        setError('Camera not supported on this device. Please use the upload option below.');
        return;
      }

      const mediaStream = await navigator.mediaDevices.getUserMedia({ 
        video: { facingMode: 'environment' },
        audio: false 
      });
      setStream(mediaStream);
      setHasPermission(true);
      setError('');
      if (videoRef.current) {
        videoRef.current.srcObject = mediaStream;
      }
    } catch (error: any) {
      // Silently handle camera errors - we show UI feedback instead
      setHasPermission(false);
      
      if (error.name === 'NotAllowedError') {
        setError('Camera access denied. Please allow camera permission in your browser settings, or use the upload option below.');
      } else if (error.name === 'NotFoundError') {
        setError('No camera found on this device. Please use the upload option below.');
      } else if (error.name === 'NotReadableError') {
        setError('Camera is being used by another application. Please close other apps and try again, or use the upload option below.');
      } else {
        setError('Unable to access camera. Please use the upload option below.');
      }
    }
  };

  const handleCapture = () => {
    if (videoRef.current && stream) {
      const canvas = document.createElement('canvas');
      canvas.width = videoRef.current.videoWidth;
      canvas.height = videoRef.current.videoHeight;
      const ctx = canvas.getContext('2d');
      if (ctx) {
        ctx.drawImage(videoRef.current, 0, 0);
        canvas.toBlob((blob) => {
          if (blob) {
            toast.success('Photo captured!');
            // Stop the camera
            if (stream) {
              stream.getTracks().forEach(track => track.stop());
            }
            // Navigate to preview with captured image and existing images
            navigate('/camera-preview', { state: { imageBlob: blob, imageUrl: canvas.toDataURL(), existingImages } });
          }
        }, 'image/jpeg');
      }
    }
  };

  const handleFileSelect = (e: React.ChangeEvent<HTMLInputElement>) => {
    const file = e.target.files?.[0];
    if (file) {
      const reader = new FileReader();
      reader.onloadend = () => {
        toast.success('Image selected!');
        // Stop camera if running
        if (stream) {
          stream.getTracks().forEach(track => track.stop());
        }
        navigate('/camera-preview', { state: { imageBlob: file, imageUrl: reader.result, existingImages } });
      };
      reader.readAsDataURL(file);
    }
  };

  return (
    <div className="min-h-screen bg-black max-w-md mx-auto relative overflow-hidden">
      {/* Video Element - Background */}
      <video
        ref={videoRef}
        autoPlay
        playsInline
        muted
        className="absolute inset-0 w-full h-full object-cover"
      />

      {/* Overlay for no permission */}
      {hasPermission === false && (
        <div className="absolute inset-0 bg-gradient-to-b from-gray-900 to-gray-800 flex flex-col items-center justify-center z-5 p-6">
          <div className="text-center max-w-sm">
            <div className="w-24 h-24 bg-red-500/20 rounded-full flex items-center justify-center mx-auto mb-6">
              <AlertCircle className="w-12 h-12 text-red-400" />
            </div>
            <h3 className="text-white text-xl mb-3">Camera Access Needed</h3>
            <p className="text-white/70 text-sm mb-6">{error}</p>
            
            <div className="space-y-3">
              <button
                onClick={startCamera}
                className="w-full bg-[#43A047] text-white py-3 px-6 rounded-xl hover:bg-[#1B5E20] transition-colors flex items-center justify-center gap-2"
              >
                <Camera className="w-5 h-5" />
                Try Again
              </button>
              
              <label htmlFor="fallback-upload" className="block">
                <div className="w-full bg-white/10 border-2 border-white/30 text-white py-3 px-6 rounded-xl hover:bg-white/20 transition-colors cursor-pointer flex items-center justify-center gap-2">
                  <ImageIcon className="w-5 h-5" />
                  Upload Image Instead
                </div>
              </label>
              <input
                id="fallback-upload"
                type="file"
                accept="image/*"
                className="hidden"
                onChange={handleFileSelect}
              />
              
              <button
                onClick={() => navigate('/pest')}
                className="w-full text-white/70 py-3 hover:text-white transition-colors"
              >
                Cancel
              </button>
            </div>
          </div>
        </div>
      )}

      {/* Top Controls */}
      <div className="absolute top-0 left-0 right-0 p-6 flex justify-between items-start z-10">
        {/* Flash Toggle */}
        <button className="w-12 h-12 bg-black/40 backdrop-blur-sm rounded-full flex items-center justify-center text-white border-2 border-white/30 hover:bg-black/60 transition-all">
          <Zap className="w-6 h-6" />
        </button>

        {/* Switch Camera */}
        <button className="w-12 h-12 bg-black/40 backdrop-blur-sm rounded-full flex items-center justify-center text-white border-2 border-white/30 hover:bg-black/60 transition-all">
          <RefreshCw className="w-6 h-6" />
        </button>
      </div>

      {/* Bottom Controls */}
      <div className="absolute bottom-0 left-0 right-0 p-6 z-10">
        <div className="flex items-center justify-between">
          {/* Gallery Shortcut */}
          <button 
            onClick={() => fileInputRef.current?.click()}
            className="w-14 h-14 bg-white/20 backdrop-blur-sm rounded-xl flex items-center justify-center text-white border-2 border-white/40"
          >
            <ImageIcon className="w-6 h-6" />
          </button>

          {/* Capture Button */}
          <button
            onClick={handleCapture}
            className="w-20 h-20 bg-white rounded-full flex items-center justify-center shadow-xl hover:scale-110 transition-all border-4 border-white/50"
          >
            <div className="w-16 h-16 bg-[#43A047] rounded-full"></div>
          </button>

          {/* Cancel/Close */}
          <button
            onClick={() => navigate('/pest')}
            className="w-14 h-14 bg-white/20 backdrop-blur-sm rounded-xl flex items-center justify-center text-white border-2 border-white/40"
          >
            <X className="w-6 h-6" />
          </button>
        </div>
      </div>

      {/* Guide Frame */}
      <div className="absolute inset-0 flex items-center justify-center pointer-events-none">
        <div className="w-72 h-72 border-4 border-[#43A047] rounded-3xl shadow-2xl">
          <div className="absolute top-0 left-0 w-8 h-8 border-t-4 border-l-4 border-[#FFC107]"></div>
          <div className="absolute top-0 right-0 w-8 h-8 border-t-4 border-r-4 border-[#FFC107]"></div>
          <div className="absolute bottom-0 left-0 w-8 h-8 border-b-4 border-l-4 border-[#FFC107]"></div>
          <div className="absolute bottom-0 right-0 w-8 h-8 border-b-4 border-r-4 border-[#FFC107]"></div>
        </div>
      </div>

      {/* File Input */}
      <input
        ref={fileInputRef}
        type="file"
        accept="image/*"
        className="hidden"
        onChange={handleFileSelect}
      />
    </div>
  );
}