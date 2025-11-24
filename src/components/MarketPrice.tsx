import { useNavigate } from 'react-router-dom';
import { useState } from 'react';
import AppHeader from './AppHeader';
import AppFooter from './AppFooter';
import FloatingIVR from './FloatingIVR';
import { ArrowLeft, TrendingUp, TrendingDown, Award, MapPin, Navigation2, Star } from 'lucide-react';

export default function MarketPrice() {
  const navigate = useNavigate();

  const recommendedMandis = [
    {
      name: 'Ranchi APMC Mandi',
      price: '₹6,800/quintal',
      distance: '15 km',
      transportCost: '₹200',
      netProfit: '₹85,800',
      recommended: true,
      rating: 4.8
    },
    {
      name: 'Jamshedpur Agricultural Market',
      price: '₹6,500/quintal',
      distance: '45 km',
      transportCost: '₹600',
      netProfit: '₹84,400',
      recommended: false,
      rating: 4.5
    },
    {
      name: 'Dhanbad Krishi Mandi',
      price: '₹6,300/quintal',
      distance: '65 km',
      transportCost: '₹850',
      netProfit: '₹82,650',
      recommended: false,
      rating: 4.3
    }
  ];

  const prices = [
    {
      crop: 'Cotton',
      icon: '🌾',
      price: '₹7,200',
      msp: '₹6,620',
      trend: 12,
      mandi: 'Ahmedabad APMC',
      bestPrice: true
    },
    {
      crop: 'Wheat',
      icon: '🌾',
      price: '₹2,450',
      msp: '₹2,125',
      trend: 5,
      mandi: 'Local Mandi'
    },
    {
      crop: 'Rice',
      icon: '🌾',
      price: '₹3,100',
      msp: '₹2,183',
      trend: -3,
      mandi: 'Punjab Mandi'
    },
    {
      crop: 'Tomato',
      icon: '🍅',
      price: '₹45',
      msp: 'N/A',
      trend: 18,
      mandi: 'Vegetable Market',
      unit: 'kg'
    },
    {
      crop: 'Potato',
      icon: '🥔',
      price: '₹28',
      msp: 'N/A',
      trend: -8,
      mandi: 'Vegetable Market',
      unit: 'kg'
    },
    {
      crop: 'Soybean',
      icon: '🫘',
      price: '₹4,800',
      msp: '₹4,300',
      trend: 7,
      mandi: 'MP Mandi'
    }
  ];

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

        <h1 className="text-[#1B5E20] text-3xl mb-2">Market Prices</h1>
        <p className="text-[#757575] mb-6">Live prices from nearby mandis</p>

        <div className="bg-gradient-to-br from-[#FFC107] to-[#FF9800] rounded-2xl p-4 text-white shadow-lg mb-6">
          <div className="flex items-center justify-between">
            <div>
              <div className="text-sm opacity-90 mb-1">Updated</div>
              <div>Today, 3:30 PM</div>
            </div>
            <div className="w-12 h-12 bg-white/20 rounded-full flex items-center justify-center">
              <TrendingUp className="w-6 h-6" />
            </div>
          </div>
        </div>

        {/* Best Mandi To Sell Section */}
        <h3 className="text-[#1B5E20] mb-3 flex items-center gap-2">
          <Award className="w-5 h-5" />
          Best Mandi To Sell - Cotton
        </h3>
        
        <div className="space-y-3 mb-6">
          {recommendedMandis.map((mandi, idx) => (
            <div key={idx} className={`bg-white rounded-2xl p-4 shadow-sm relative border-2 ${
              mandi.recommended ? 'border-[#FFC107]' : 'border-transparent'
            }`}>
              {mandi.recommended && (
                <div className="absolute top-3 right-3 bg-[#FFC107] text-white px-2 py-1 rounded-full text-xs flex items-center gap-1">
                  <Award className="w-3 h-3" />
                  Recommended
                </div>
              )}
              
              <div className="flex items-start justify-between mb-3">
                <div>
                  <h4 className="text-[#1B5E20] mb-1">{mandi.name}</h4>
                  <div className="flex items-center gap-2 text-[#757575] text-sm">
                    <MapPin className="w-4 h-4" />
                    <span>{mandi.distance} away</span>
                  </div>
                </div>
                <div className="flex items-center gap-1 text-[#FFC107]">
                  <Star className="w-4 h-4 fill-current" />
                  <span className="text-sm">{mandi.rating}</span>
                </div>
              </div>

              <div className="grid grid-cols-2 gap-3 mb-3">
                <div>
                  <div className="text-[#757575] text-xs mb-1">Selling Price</div>
                  <div className="text-[#1B5E20]">{mandi.price}</div>
                </div>
                <div>
                  <div className="text-[#757575] text-xs mb-1">Transport Cost</div>
                  <div className="text-[#1B5E20]">{mandi.transportCost}</div>
                </div>
              </div>

              <div className="bg-[#E8F5E9] rounded-xl p-3">
                <div className="flex items-center justify-between">
                  <span className="text-[#1B5E20] text-sm">Estimated Net Profit</span>
                  <span className="text-[#43A047]">{mandi.netProfit}</span>
                </div>
              </div>
            </div>
          ))}
        </div>

        {/* All Market Prices */}
        <h3 className="text-[#1B5E20] mb-3">All Market Prices</h3>
        
        <div className="space-y-3 mb-6">
          {prices.map((item, idx) => (
            <div key={idx} className="bg-white rounded-2xl p-4 shadow-sm relative">
              {item.bestPrice && (
                <div className="absolute top-3 right-3 bg-green-100 text-green-700 px-2 py-1 rounded-full text-xs flex items-center gap-1">
                  <TrendingUp className="w-3 h-3" />
                  Best Price
                </div>
              )}
              
              <div className="flex items-start gap-4">
                <div className="text-4xl">{item.icon}</div>
                <div className="flex-1">
                  <h4 className="text-[#1B5E20] mb-1">{item.crop}</h4>
                  <p className="text-[#757575] text-sm mb-3">{item.mandi}</p>
                  
                  <div className="flex items-end justify-between">
                    <div>
                      <div className="text-[#757575] text-xs mb-1">Current Price</div>
                      <div className="text-[#1B5E20] text-xl">{item.price}</div>
                      {item.unit && <div className="text-[#757575] text-xs">per {item.unit}</div>}
                    </div>
                    
                    <div className="text-right">
                      <div className="text-[#757575] text-xs mb-1">MSP</div>
                      <div className="text-[#757575]">{item.msp}</div>
                    </div>
                    
                    <div className={`flex items-center gap-1 ${
                      item.trend > 0 ? 'text-green-600' : 'text-red-600'
                    }`}>
                      {item.trend > 0 ? (
                        <TrendingUp className="w-4 h-4" />
                      ) : (
                        <TrendingDown className="w-4 h-4" />
                      )}
                      <span className="text-sm">{Math.abs(item.trend)}%</span>
                    </div>
                  </div>
                </div>
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