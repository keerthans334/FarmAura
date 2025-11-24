import { X, ZoomIn, ZoomOut, MapPin } from 'lucide-react';
import { useState } from 'react';

interface LocationMapPopupProps {
  location: {
    district: string;
    state: string;
  };
  onClose: () => void;
}

export default function LocationMapPopup({ location, onClose }: LocationMapPopupProps) {
  const [zoom, setZoom] = useState(1);

  const handleZoomIn = () => {
    if (zoom < 2) setZoom(zoom + 0.2);
  };

  const handleZoomOut = () => {
    if (zoom > 0.5) setZoom(zoom - 0.2);
  };

  // Heatmap legend data
  const heatmapLegend = [
    { color: '#22c55e', label: 'High Fertility', gradient: 'from-green-500' },
    { color: '#84cc16', label: 'Good Moisture', gradient: 'from-lime-500' },
    { color: '#eab308', label: 'Moderate', gradient: 'from-yellow-500' },
    { color: '#f97316', label: 'Low Moisture', gradient: 'from-orange-500' },
    { color: '#ef4444', label: 'Poor Soil', gradient: 'from-red-500' },
  ];

  return (
    <div className="fixed inset-0 bg-black/50 backdrop-blur-sm z-50 flex items-center justify-center p-4 animate-fade-in">
      <div className="bg-white rounded-2xl shadow-2xl w-full max-w-sm overflow-hidden animate-scale-in">
        {/* Header */}
        <div className="bg-gradient-to-r from-[#43A047] to-[#1B5E20] text-white p-4 flex items-center justify-between">
          <div className="flex items-center gap-2">
            <MapPin className="w-5 h-5" />
            <div>
              <h3>Your Location</h3>
              <p className="text-xs opacity-90">{location.district}, {location.state}</p>
            </div>
          </div>
          <button
            onClick={onClose}
            className="p-2 hover:bg-white/20 rounded-full transition-colors"
          >
            <X className="w-5 h-5" />
          </button>
        </div>

        {/* Map Container */}
        <div className="relative bg-[#E8F5E9] h-96 overflow-hidden">
          {/* Mock Satellite Map with Heatmap */}
          <div 
            className="w-full h-full transition-transform duration-300"
            style={{ transform: `scale(${zoom})` }}
          >
            {/* Grid Pattern for Map Effect */}
            <div className="absolute inset-0" style={{
              backgroundImage: 'repeating-linear-gradient(0deg, rgba(27,94,32,0.05) 0px, rgba(27,94,32,0.05) 20px, transparent 20px, transparent 40px), repeating-linear-gradient(90deg, rgba(27,94,32,0.05) 0px, rgba(27,94,32,0.05) 20px, transparent 20px, transparent 40px)',
            }}></div>
            
            {/* Base Terrain */}
            <div className="absolute inset-0 bg-gradient-to-br from-green-100 via-yellow-50 to-green-200 opacity-70"></div>
            
            {/* Heatmap Overlay Zones */}
            <div className="absolute top-1/4 left-1/4 w-20 h-20 rounded-full bg-green-500/40 blur-xl"></div>
            <div className="absolute top-1/3 right-1/4 w-24 h-24 rounded-full bg-lime-500/40 blur-xl"></div>
            <div className="absolute bottom-1/3 left-1/3 w-16 h-16 rounded-full bg-yellow-500/40 blur-xl"></div>
            <div className="absolute top-2/3 right-1/3 w-20 h-20 rounded-full bg-orange-500/40 blur-xl"></div>
            <div className="absolute bottom-1/4 right-1/4 w-14 h-14 rounded-full bg-red-500/40 blur-xl"></div>
            
            {/* Mock Roads */}
            <div className="absolute top-1/3 left-0 right-0 h-1 bg-gray-400/50"></div>
            <div className="absolute top-0 bottom-0 left-1/2 w-1 bg-gray-400/50"></div>
            
            {/* Location Pin */}
            <div className="absolute top-1/2 left-1/2 transform -translate-x-1/2 -translate-y-full">
              <div className="relative animate-bounce">
                <div className="w-8 h-8 bg-red-500 rounded-full border-4 border-white shadow-lg flex items-center justify-center">
                  <div className="w-2 h-2 bg-white rounded-full"></div>
                </div>
                <div className="absolute top-full left-1/2 w-0 h-0 border-l-4 border-r-4 border-t-8 border-l-transparent border-r-transparent border-t-red-500 -translate-x-1/2"></div>
              </div>
            </div>

            {/* Location Label */}
            <div className="absolute top-1/2 left-1/2 transform -translate-x-1/2 translate-y-4">
              <div className="bg-white px-3 py-1 rounded-full shadow-lg text-xs text-[#1B5E20] whitespace-nowrap">
                📍 {location.district}
              </div>
            </div>
          </div>

          {/* Zoom Controls */}
          <div className="absolute bottom-4 right-4 bg-white rounded-full shadow-lg overflow-hidden">
            <button
              onClick={handleZoomIn}
              className="p-3 hover:bg-[#E8F5E9] transition-colors border-b border-gray-200"
            >
              <ZoomIn className="w-5 h-5 text-[#1B5E20]" />
            </button>
            <button
              onClick={handleZoomOut}
              className="p-3 hover:bg-[#E8F5E9] transition-colors"
            >
              <ZoomOut className="w-5 h-5 text-[#1B5E20]" />
            </button>
          </div>

          {/* Compass */}
          <div className="absolute top-4 left-4 w-12 h-12 bg-white/90 backdrop-blur-sm rounded-full shadow-lg flex items-center justify-center">
            <div className="text-red-500 text-xs font-bold">N</div>
          </div>
        </div>

        {/* Footer Info */}
        <div className="p-4 bg-[#FAFAF5]">
          <div className="text-[#1B5E20] text-xs font-bold mb-3 text-center">Soil Heatmap Legend</div>
          <div className="flex flex-wrap justify-center gap-3">
            {heatmapLegend.map((item, index) => (
              <div key={index} className="flex items-center gap-1.5">
                <div 
                  className="w-4 h-4 rounded-sm shadow-sm flex-shrink-0"
                  style={{ backgroundColor: item.color }}
                ></div>
                <span className="text-[10px] text-[#757575]">{item.label}</span>
              </div>
            ))}
          </div>
        </div>
      </div>
    </div>
  );
}