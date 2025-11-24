import { useNavigate } from 'react-router-dom';
import AppHeader from './AppHeader';
import AppFooter from './AppFooter';
import FloatingIVR from './FloatingIVR';
import { Heart, Target, Users, Award, Sprout, Lightbulb } from 'lucide-react';

export default function AboutUs() {
  const navigate = useNavigate();

  const features = [
    {
      icon: Sprout,
      title: 'AI-Powered Recommendations',
      desc: 'Get personalized crop suggestions based on soil, weather, and market data'
    },
    {
      icon: Target,
      title: 'Local Expertise',
      desc: 'Recommendations tailored for Jharkhand and surrounding regions'
    },
    {
      icon: Users,
      title: 'Community Support',
      desc: 'Connect with fellow farmers and share knowledge'
    },
    {
      icon: Award,
      title: 'Expert Guidance',
      desc: 'Access to agricultural experts and resources'
    }
  ];

  const stats = [
    { value: '50,000+', label: 'Active Farmers' },
    { value: '24/7', label: 'AI Assistance' },
    { value: '100+', label: 'Crop Varieties' },
    { value: '95%', label: 'Satisfaction' }
  ];

  return (
    <div className="min-h-screen bg-[#FAFAF5] pb-24 max-w-md mx-auto">
      <AppHeader title="About Us" showBack={true} showProfile={false} />
      
      <div className="pt-20 px-4">
        {/* Header Card */}
        <div className="bg-gradient-to-br from-[#43A047] to-[#1B5E20] rounded-3xl p-6 text-white shadow-lg mb-6">
          <div className="text-center">
            <div className="w-16 h-16 bg-white/20 rounded-full flex items-center justify-center mx-auto mb-3">
              <Sprout className="w-8 h-8" />
            </div>
            <h2 className="text-2xl mb-2">FarmAura</h2>
            <p className="text-sm opacity-90">Empowering Farmers with AI</p>
            <div className="flex items-center justify-center gap-2 mt-3">
              <Heart className="w-4 h-4 text-red-300" />
              <p className="text-xs opacity-75">Government of Jharkhand Initiative</p>
            </div>
          </div>
        </div>

        {/* Mission */}
        <div className="bg-white rounded-2xl p-6 shadow-sm mb-6">
          <div className="flex items-center gap-3 mb-4">
            <div className="w-12 h-12 bg-[#E8F5E9] rounded-full flex items-center justify-center">
              <Lightbulb className="w-6 h-6 text-[#43A047]" />
            </div>
            <h3 className="text-[#1B5E20] text-lg">Our Mission</h3>
          </div>
          <p className="text-[#757575] text-sm leading-relaxed">
            FarmAura is an innovative initiative by the Government of Jharkhand aimed at revolutionizing agriculture through artificial intelligence. Our mission is to empower farmers with data-driven insights, personalized recommendations, and modern farming techniques to increase productivity and income.
          </p>
        </div>

        {/* Vision */}
        <div className="bg-white rounded-2xl p-6 shadow-sm mb-6">
          <div className="flex items-center gap-3 mb-4">
            <div className="w-12 h-12 bg-[#E8F5E9] rounded-full flex items-center justify-center">
              <Target className="w-6 h-6 text-[#43A047]" />
            </div>
            <h3 className="text-[#1B5E20] text-lg">Our Vision</h3>
          </div>
          <p className="text-[#757575] text-sm leading-relaxed">
            To create a digitally empowered agricultural ecosystem in Jharkhand where every farmer has access to cutting-edge technology, expert guidance, and market intelligence. We envision a future where farming is not just sustainable but also profitable and technologically advanced.
          </p>
        </div>

        {/* Stats */}
        <div className="grid grid-cols-2 gap-3 mb-6">
          {stats.map((stat, idx) => (
            <div key={idx} className="bg-white rounded-2xl p-4 shadow-sm text-center">
              <div className="text-[#43A047] text-2xl mb-1">{stat.value}</div>
              <div className="text-[#757575] text-xs">{stat.label}</div>
            </div>
          ))}
        </div>

        {/* Features */}
        <div className="mb-6">
          <h3 className="text-[#1B5E20] mb-4">What We Offer</h3>
          <div className="space-y-3">
            {features.map((feature, idx) => {
              const Icon = feature.icon;
              return (
                <div key={idx} className="bg-white rounded-2xl p-4 shadow-sm">
                  <div className="flex items-start gap-3">
                    <div className="w-10 h-10 bg-[#E8F5E9] rounded-full flex items-center justify-center flex-shrink-0">
                      <Icon className="w-5 h-5 text-[#43A047]" />
                    </div>
                    <div>
                      <h4 className="text-[#1B5E20] mb-1">{feature.title}</h4>
                      <p className="text-[#757575] text-sm">{feature.desc}</p>
                    </div>
                  </div>
                </div>
              );
            })}
          </div>
        </div>

        {/* How It Works */}
        <div className="bg-white rounded-2xl p-6 shadow-sm mb-6">
          <h3 className="text-[#1B5E20] mb-4">How FarmAura Works</h3>
          <div className="space-y-4">
            <div className="flex gap-3">
              <div className="w-8 h-8 bg-[#43A047] text-white rounded-full flex items-center justify-center flex-shrink-0">1</div>
              <div>
                <h4 className="text-[#1B5E20] text-sm mb-1">Input Your Farm Details</h4>
                <p className="text-[#757575] text-xs">Share information about your land, location, and current conditions</p>
              </div>
            </div>
            <div className="flex gap-3">
              <div className="w-8 h-8 bg-[#43A047] text-white rounded-full flex items-center justify-center flex-shrink-0">2</div>
              <div>
                <h4 className="text-[#1B5E20] text-sm mb-1">AI Analysis</h4>
                <p className="text-[#757575] text-xs">Our AI analyzes soil, weather, and market data to find the best crops</p>
              </div>
            </div>
            <div className="flex gap-3">
              <div className="w-8 h-8 bg-[#43A047] text-white rounded-full flex items-center justify-center flex-shrink-0">3</div>
              <div>
                <h4 className="text-[#1B5E20] text-sm mb-1">Get Personalized Recommendations</h4>
                <p className="text-[#757575] text-xs">Receive crop suggestions with cultivation tips and profit estimates</p>
              </div>
            </div>
            <div className="flex gap-3">
              <div className="w-8 h-8 bg-[#43A047] text-white rounded-full flex items-center justify-center flex-shrink-0">4</div>
              <div>
                <h4 className="text-[#1B5E20] text-sm mb-1">Track & Optimize</h4>
                <p className="text-[#757575] text-xs">Monitor your crops and get ongoing support throughout the season</p>
              </div>
            </div>
          </div>
        </div>

        {/* Government Initiative */}
        <div className="bg-gradient-to-br from-blue-50 to-green-50 border-2 border-[#43A047]/20 rounded-2xl p-6 mb-6">
          <div className="text-center">
            <div className="text-4xl mb-3">🏛️</div>
            <h3 className="text-[#1B5E20] mb-2">Government of Jharkhand</h3>
            <p className="text-[#757575] text-sm leading-relaxed">
              FarmAura is developed and maintained by the Department of Agriculture, Animal Husbandry & Cooperative, Government of Jharkhand as part of the state's Digital Agriculture initiative.
            </p>
          </div>
        </div>

        {/* Contact */}
        <div className="bg-white rounded-2xl p-6 shadow-sm">
          <h3 className="text-[#1B5E20] mb-4">Get in Touch</h3>
          <div className="space-y-3 text-sm">
            <div className="flex items-start gap-3">
              <div className="text-xl">📧</div>
              <div>
                <div className="text-[#757575] text-xs mb-1">Email</div>
                <div className="text-[#1B5E20]">support@farmaura.jharkhand.gov.in</div>
              </div>
            </div>
            <div className="flex items-start gap-3">
              <div className="text-xl">📞</div>
              <div>
                <div className="text-[#757575] text-xs mb-1">Helpline</div>
                <div className="text-[#1B5E20]">1800-XXX-XXXX (Toll-Free)</div>
              </div>
            </div>
            <div className="flex items-start gap-3">
              <div className="text-xl">🏢</div>
              <div>
                <div className="text-[#757575] text-xs mb-1">Office</div>
                <div className="text-[#1B5E20]">Department of Agriculture<br/>Government of Jharkhand, Ranchi</div>
              </div>
            </div>
          </div>
        </div>

        {/* Version */}
        <div className="text-center mt-6 text-[#757575] text-xs">
          Version 1.0.0 • Made with ❤️ for Jharkhand Farmers
        </div>
      </div>

      <FloatingIVR />
      <AppFooter />
    </div>
  );
}