import { useNavigate } from 'react-router-dom';
import { useState } from 'react';
import AppHeader from './AppHeader';
import AppFooter from './AppFooter';
import FloatingIVR from './FloatingIVR';
import { Heart, MessageCircle, Share2, Bookmark } from 'lucide-react';

export default function CommunityFeed() {
  const navigate = useNavigate();
  const [activeFilter, setActiveFilter] = useState('All');

  const filters = ['All', 'Subsidy', 'State News', 'Tips', 'Market'];

  const posts = [
    {
      type: 'Subsidy',
      title: 'New PM-KISAN Installment Released',
      content: 'The 16th installment of PM-KISAN scheme has been released. Check your account for ₹2,000 deposit.',
      time: '2 hours ago',
      likes: 245,
      comments: 38,
      tag: 'Government Scheme',
      icon: '💰'
    },
    {
      type: 'Tips',
      title: 'Best Time for Wheat Sowing',
      content: 'November is ideal for wheat sowing in North India. Ensure soil moisture is adequate before sowing.',
      time: '5 hours ago',
      likes: 182,
      comments: 24,
      tag: 'Farming Tip',
      icon: '🌾'
    },
    {
      type: 'State News',
      title: 'Maharashtra Crop Insurance Update',
      content: 'Extended deadline for crop insurance enrollment till November 30. Don\'t miss this opportunity.',
      time: '1 day ago',
      likes: 156,
      comments: 45,
      tag: 'Maharashtra',
      icon: '📋'
    },
    {
      type: 'Market',
      title: 'Cotton Prices Surge',
      content: 'Cotton prices reached ₹7,500/quintal in Gujarat mandis. Good time to sell if you have stock.',
      time: '1 day ago',
      likes: 298,
      comments: 67,
      tag: 'Market Alert',
      icon: '📈'
    },
    {
      type: 'Subsidy',
      title: 'Drip Irrigation Subsidy Available',
      content: '50% subsidy on drip irrigation systems. Apply through your nearest agriculture office.',
      time: '2 days ago',
      likes: 221,
      comments: 52,
      tag: 'Subsidy Scheme',
      icon: '💧'
    },
    {
      type: 'Tips',
      title: 'Organic Pest Control Methods',
      content: 'Use neem oil, garlic spray, and marigold companion planting for natural pest control.',
      time: '2 days ago',
      likes: 167,
      comments: 31,
      tag: 'Organic Farming',
      icon: '🌿'
    }
  ];

  const filteredPosts = activeFilter === 'All' 
    ? posts 
    : posts.filter(post => post.type === activeFilter);

  return (
    <div className="min-h-screen bg-[#FAFAF5] pb-24 max-w-md mx-auto">
      <AppHeader />
      <div className="pt-20 px-4">
        <h1 className="text-[#1B5E20] text-3xl mb-6">Community</h1>

        <div className="flex gap-2 overflow-x-auto pb-4 mb-6">
          {filters.map((filter) => (
            <button
              key={filter}
              onClick={() => setActiveFilter(filter)}
              className={`px-4 py-2 rounded-full whitespace-nowrap transition-all ${
                activeFilter === filter
                  ? 'bg-[#43A047] text-white'
                  : 'bg-white text-[#1B5E20] border-2 border-[#43A047]'
              }`}
            >
              {filter}
            </button>
          ))}
        </div>

        <div className="space-y-4">
          {filteredPosts.map((post, idx) => (
            <div key={idx} className="bg-white rounded-2xl p-5 shadow-sm">
              <div className="flex items-start gap-3 mb-3">
                <div className="w-12 h-12 bg-[#FAFAF5] rounded-full flex items-center justify-center text-2xl shrink-0">
                  {post.icon}
                </div>
                <div className="flex-1">
                  <div className="flex items-center gap-2 mb-1">
                    <span className="px-2 py-1 bg-[#FFC107] text-white text-xs rounded-full">
                      {post.tag}
                    </span>
                    <span className="text-[#757575] text-xs">{post.time}</span>
                  </div>
                  <h3 className="text-[#1B5E20] mb-2">{post.title}</h3>
                  <p className="text-[#757575] text-sm">{post.content}</p>
                </div>
              </div>

              <div className="flex items-center justify-between pt-3 border-t border-[#FAFAF5]">
                <button className="flex items-center gap-2 text-[#757575] hover:text-[#43A047] transition-colors">
                  <Heart className="w-5 h-5" />
                  <span className="text-sm">{post.likes}</span>
                </button>
                <button className="flex items-center gap-2 text-[#757575] hover:text-[#43A047] transition-colors">
                  <MessageCircle className="w-5 h-5" />
                  <span className="text-sm">{post.comments}</span>
                </button>
                <button className="flex items-center gap-2 text-[#757575] hover:text-[#43A047] transition-colors">
                  <Share2 className="w-5 h-5" />
                </button>
                <button className="flex items-center gap-2 text-[#757575] hover:text-[#43A047] transition-colors">
                  <Bookmark className="w-5 h-5" />
                </button>
              </div>
            </div>
          ))}
        </div>
      </div>

      <FloatingIVR />
      <AppFooter />
    </div>
  );
}