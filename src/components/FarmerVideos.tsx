import { useNavigate } from 'react-router-dom';
import { useState } from 'react';
import AppHeader from './AppHeader';
import AppFooter from './AppFooter';
import FloatingIVR from './FloatingIVR';
import { ArrowLeft, Play, Clock, Search, X, Upload, Video } from 'lucide-react';
import { ImageWithFallback } from './figma/ImageWithFallback';
import { toast } from 'sonner';

export default function FarmerVideos() {
  const navigate = useNavigate();
  const [searchQuery, setSearchQuery] = useState('');
  const [showSubmitModal, setShowSubmitModal] = useState(false);
  const [submitForm, setSubmitForm] = useState({
    title: '',
    description: '',
    category: 'Success Stories'
  });

  const videoSections = [
    {
      title: 'Farming Tutorials',
      videos: [
        {
          title: 'Modern Wheat Cultivation',
          duration: '12:45',
          views: '45K',
          thumbnail: 'https://images.unsplash.com/photo-1625246333195-78d9c38ad449?w=400&h=250&fit=crop'
        },
        {
          title: 'Drip Irrigation Setup',
          duration: '8:30',
          views: '32K',
          thumbnail: 'https://images.unsplash.com/photo-1592982537447-7440770cbfc9?w=400&h=250&fit=crop'
        },
        {
          title: 'Organic Farming Basics',
          duration: '15:20',
          views: '56K',
          thumbnail: 'https://images.unsplash.com/photo-1574943320219-553eb213f72d?w=400&h=250&fit=crop'
        }
      ]
    },
    {
      title: 'Success Stories',
      videos: [
        {
          title: 'From ₹50K to ₹5 Lakh: A Farmer\'s Journey',
          duration: '10:15',
          views: '89K',
          thumbnail: 'https://images.unsplash.com/photo-1605000797499-95a51c5269ae?w=400&h=250&fit=crop'
        },
        {
          title: 'Organic Farming Success in Punjab',
          duration: '14:30',
          views: '67K',
          thumbnail: 'https://images.unsplash.com/photo-1464226184884-fa280b87c399?w=400&h=250&fit=crop'
        },
        {
          title: 'Greenhouse Farming Profits',
          duration: '11:45',
          views: '54K',
          thumbnail: 'https://images.unsplash.com/photo-1530836369250-ef72a3f5cda8?w=400&h=250&fit=crop'
        }
      ]
    },
    {
      title: 'Government Schemes',
      videos: [
        {
          title: 'PM-KISAN: Complete Guide',
          duration: '7:20',
          views: '125K',
          thumbnail: 'https://images.unsplash.com/photo-1560493676-04071c5f467b?w=400&h=250&fit=crop'
        },
        {
          title: 'Crop Insurance Explained',
          duration: '9:40',
          views: '98K',
          thumbnail: 'https://images.unsplash.com/photo-1454165804606-c3d57bc86b40?w=400&h=250&fit=crop'
        },
        {
          title: 'Subsidy Programs 2024',
          duration: '13:15',
          views: '76K',
          thumbnail: 'https://images.unsplash.com/photo-1450101499163-c8848c66ca85?w=400&h=250&fit=crop'
        }
      ]
    }
  ];

  // Filter videos based on search query
  const filteredSections = searchQuery.trim() === '' 
    ? videoSections 
    : videoSections.map(section => ({
        ...section,
        videos: section.videos.filter(video => 
          video.title.toLowerCase().includes(searchQuery.toLowerCase()) ||
          section.title.toLowerCase().includes(searchQuery.toLowerCase())
        )
      })).filter(section => section.videos.length > 0);

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

        <h1 className="text-[#1B5E20] text-3xl mb-4">Farmer Videos</h1>

        {/* Search Bar */}
        <div className="relative mb-6">
          <Search className="absolute left-4 top-1/2 transform -translate-y-1/2 w-5 h-5 text-[#757575]" />
          <input
            type="text"
            value={searchQuery}
            onChange={(e) => setSearchQuery(e.target.value)}
            placeholder="Search videos (tutorials, schemes, success stories...)"
            className="w-full pl-12 pr-4 py-3 bg-white rounded-2xl border-2 border-[#43A047]/20 focus:border-[#43A047] focus:outline-none text-[#1B5E20] shadow-sm"
          />
        </div>

        {filteredSections.length === 0 ? (
          <div className="text-center py-12">
            <p className="text-[#757575] text-lg">No videos found for "{searchQuery}"</p>
            <button 
              onClick={() => setSearchQuery('')}
              className="mt-4 text-[#43A047] hover:underline"
            >
              Clear search
            </button>
          </div>
        ) : (
          filteredSections.map((section, sectionIdx) => (
            <div key={sectionIdx} className="mb-8">
              <h3 className="text-[#1B5E20] mb-4">{section.title}</h3>
              <div className="flex gap-4 overflow-x-auto pb-2">
                {section.videos.map((video, videoIdx) => (
                  <div key={videoIdx} className="bg-white rounded-2xl overflow-hidden shadow-sm min-w-[280px]">
                    <div className="relative">
                      <ImageWithFallback
                        src={video.thumbnail}
                        alt={video.title}
                        className="w-full h-40 object-cover"
                      />
                      <div className="absolute inset-0 bg-black/30 flex items-center justify-center">
                        <button className="w-16 h-16 bg-white rounded-full flex items-center justify-center hover:scale-110 transition-transform">
                          <Play className="w-8 h-8 text-[#43A047] ml-1" />
                        </button>
                      </div>
                      <div className="absolute bottom-2 right-2 bg-black/80 text-white px-2 py-1 rounded text-xs flex items-center gap-1">
                        <Clock className="w-3 h-3" />
                        {video.duration}
                      </div>
                    </div>
                    <div className="p-4">
                      <h4 className="text-[#1B5E20] mb-2 line-clamp-2">{video.title}</h4>
                      <div className="flex items-center gap-2 text-[#757575] text-sm">
                        <span>{video.views} views</span>
                      </div>
                    </div>
                  </div>
                ))}
              </div>
            </div>
          ))
        )}

        <div className="bg-gradient-to-br from-[#43A047] to-[#1B5E20] rounded-2xl p-6 text-white">
          <h3 className="text-xl mb-2">Want to Share Your Story?</h3>
          <p className="text-sm opacity-90 mb-4">
            Help other farmers learn from your experience. Share your farming success story with the community.
          </p>
          <button className="bg-white text-[#43A047] px-6 py-3 rounded-xl hover:bg-[#FAFAF5] transition-colors" onClick={() => setShowSubmitModal(true)}>
            Submit Your Video
          </button>
        </div>
      </div>

      <FloatingIVR />
      <AppFooter />

      {/* Submit Video Modal */}
      {showSubmitModal && (
        <div className="fixed inset-0 bg-black/50 flex items-center justify-center z-50">
          <div className="bg-white rounded-2xl p-6 w-80">
            <div className="flex items-center justify-between mb-4">
              <h3 className="text-xl text-[#43A047]">Submit Your Video</h3>
              <button className="text-[#43A047] hover:text-[#1B5E20]" onClick={() => setShowSubmitModal(false)}>
                <X className="w-5 h-5" />
              </button>
            </div>
            <form onSubmit={(e) => {
              e.preventDefault();
              toast.success('Video submitted successfully!');
              setShowSubmitModal(false);
            }}>
              <div className="mb-4">
                <label className="block text-sm text-[#43A047] mb-2">Title</label>
                <input
                  type="text"
                  value={submitForm.title}
                  onChange={(e) => setSubmitForm({ ...submitForm, title: e.target.value })}
                  className="w-full px-4 py-3 bg-[#FAFAF5] rounded-2xl border-2 border-[#43A047]/20 focus:border-[#43A047] focus:outline-none text-[#1B5E20] shadow-sm"
                />
              </div>
              <div className="mb-4">
                <label className="block text-sm text-[#43A047] mb-2">Description</label>
                <textarea
                  value={submitForm.description}
                  onChange={(e) => setSubmitForm({ ...submitForm, description: e.target.value })}
                  className="w-full px-4 py-3 bg-[#FAFAF5] rounded-2xl border-2 border-[#43A047]/20 focus:border-[#43A047] focus:outline-none text-[#1B5E20] shadow-sm"
                />
              </div>
              <div className="mb-4">
                <label className="block text-sm text-[#43A047] mb-2">Category</label>
                <select
                  value={submitForm.category}
                  onChange={(e) => setSubmitForm({ ...submitForm, category: e.target.value })}
                  className="w-full px-4 py-3 bg-[#FAFAF5] rounded-2xl border-2 border-[#43A047]/20 focus:border-[#43A047] focus:outline-none text-[#1B5E20] shadow-sm"
                >
                  <option value="Success Stories">Success Stories</option>
                  <option value="Farming Tutorials">Farming Tutorials</option>
                  <option value="Government Schemes">Government Schemes</option>
                </select>
              </div>
              <div className="mb-4">
                <label className="block text-sm text-[#43A047] mb-2">Upload Video</label>
                <div className="flex items-center gap-2">
                  <Upload className="w-5 h-5 text-[#43A047]" />
                  <input
                    type="file"
                    accept="video/*"
                    className="w-full px-4 py-3 bg-[#FAFAF5] rounded-2xl border-2 border-[#43A047]/20 focus:border-[#43A047] focus:outline-none text-[#1B5E20] shadow-sm"
                  />
                </div>
              </div>
              <button type="submit" className="bg-[#43A047] text-white px-6 py-3 rounded-xl hover:bg-[#1B5E20] transition-colors">
                Submit
              </button>
            </form>
          </div>
        </div>
      )}
    </div>
  );
}