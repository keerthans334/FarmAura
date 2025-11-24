import { useNavigate } from 'react-router-dom';
import { useState } from 'react';
import AppHeader from './AppHeader';
import AppFooter from './AppFooter';
import FloatingIVR from './FloatingIVR';
import { HelpCircle, Phone, Mail, MessageCircle, BookOpen, Video, ChevronRight, Send } from 'lucide-react';
import { toast } from 'sonner@2.0.3';

export default function HelpSupport() {
  const navigate = useNavigate();
  const [selectedTopic, setSelectedTopic] = useState('');
  const [message, setMessage] = useState('');

  const quickHelp = [
    {
      icon: BookOpen,
      title: 'User Guide',
      desc: 'Learn how to use FarmAura',
      action: () => {}
    },
    {
      icon: Video,
      title: 'Video Tutorials',
      desc: 'Watch step-by-step guides',
      action: () => navigate('/videos')
    },
    {
      icon: MessageCircle,
      title: 'FAQs',
      desc: 'Common questions answered',
      action: () => {}
    }
  ];

  const faqs = [
    {
      question: 'How accurate are the crop recommendations?',
      answer: 'Our AI analyzes multiple data points including soil, weather, market prices, and historical data to provide highly accurate recommendations. However, we recommend consulting with local experts as well.'
    },
    {
      question: 'Is FarmAura free to use?',
      answer: 'Yes! FarmAura is completely free for all farmers in Jharkhand. It is a Government of Jharkhand initiative to support farmers.'
    },
    {
      question: 'How do I change my location?',
      answer: 'Go to Settings > Location and either auto-detect using GPS or manually select your state and district.'
    },
    {
      question: 'Can I use FarmAura offline?',
      answer: 'Some features like viewing saved recommendations work offline, but most features require internet connectivity for real-time data.'
    },
    {
      question: 'How do I update my farm details?',
      answer: 'Go to Profile > Edit Profile to update your personal and farm information at any time.'
    }
  ];

  const topics = [
    'Account & Profile',
    'Crop Recommendations',
    'Weather & Soil Data',
    'Market Prices',
    'Technical Issues',
    'Other'
  ];

  const handleSubmit = () => {
    if (!selectedTopic || !message.trim()) {
      toast.error('Please select a topic and enter your message');
      return;
    }
    toast.success('Your message has been sent! We will get back to you soon.');
    setSelectedTopic('');
    setMessage('');
  };

  return (
    <div className="min-h-screen bg-[#FAFAF5] pb-24 max-w-md mx-auto">
      <AppHeader title="Help & Support" showBack={true} showProfile={false} />
      
      <div className="pt-20 px-4">
        {/* Header Card */}
        <div className="bg-gradient-to-br from-[#43A047] to-[#1B5E20] rounded-3xl p-6 text-white shadow-lg mb-6">
          <div className="text-center">
            <div className="w-16 h-16 bg-white/20 rounded-full flex items-center justify-center mx-auto mb-3">
              <HelpCircle className="w-8 h-8" />
            </div>
            <h2 className="text-xl mb-1">We're Here to Help</h2>
            <p className="text-sm opacity-90">Get support from our team</p>
          </div>
        </div>

        {/* Quick Contact */}
        <div className="grid grid-cols-2 gap-3 mb-6">
          <a 
            href="tel:1800-XXX-XXXX"
            className="bg-white rounded-2xl p-4 shadow-sm hover:shadow-md transition-shadow"
          >
            <div className="w-12 h-12 bg-[#E8F5E9] rounded-full flex items-center justify-center mx-auto mb-3">
              <Phone className="w-6 h-6 text-[#43A047]" />
            </div>
            <div className="text-center">
              <div className="text-[#1B5E20] text-sm mb-1">Call Us</div>
              <div className="text-[#757575] text-xs">1800-XXX-XXXX</div>
            </div>
          </a>
          <a 
            href="mailto:support@farmaura.jharkhand.gov.in"
            className="bg-white rounded-2xl p-4 shadow-sm hover:shadow-md transition-shadow"
          >
            <div className="w-12 h-12 bg-[#E8F5E9] rounded-full flex items-center justify-center mx-auto mb-3">
              <Mail className="w-6 h-6 text-[#43A047]" />
            </div>
            <div className="text-center">
              <div className="text-[#1B5E20] text-sm mb-1">Email Us</div>
              <div className="text-[#757575] text-xs">Get Support</div>
            </div>
          </a>
        </div>

        {/* Quick Help */}
        <div className="mb-6">
          <h3 className="text-[#1B5E20] mb-3">Quick Help</h3>
          <div className="bg-white rounded-2xl shadow-sm overflow-hidden">
            {quickHelp.map((item, idx) => {
              const Icon = item.icon;
              return (
                <div key={idx}>
                  <button
                    onClick={item.action}
                    className="w-full p-4 flex items-center justify-between hover:bg-[#FAFAF5] transition-colors"
                  >
                    <div className="flex items-center gap-3">
                      <div className="w-10 h-10 bg-[#E8F5E9] rounded-full flex items-center justify-center">
                        <Icon className="w-5 h-5 text-[#43A047]" />
                      </div>
                      <div className="text-left">
                        <div className="text-[#1B5E20]">{item.title}</div>
                        <div className="text-[#757575] text-xs">{item.desc}</div>
                      </div>
                    </div>
                    <ChevronRight className="w-5 h-5 text-[#757575]" />
                  </button>
                  {idx < quickHelp.length - 1 && (
                    <div className="border-t border-[#FAFAF5] mx-4"></div>
                  )}
                </div>
              );
            })}
          </div>
        </div>

        {/* FAQs */}
        <div className="mb-6">
          <h3 className="text-[#1B5E20] mb-3">Frequently Asked Questions</h3>
          <div className="space-y-3">
            {faqs.map((faq, idx) => (
              <details key={idx} className="bg-white rounded-2xl shadow-sm overflow-hidden">
                <summary className="p-4 cursor-pointer hover:bg-[#FAFAF5] transition-colors text-[#1B5E20]">
                  {faq.question}
                </summary>
                <div className="px-4 pb-4 pt-2 text-[#757575] text-sm leading-relaxed border-t border-[#FAFAF5]">
                  {faq.answer}
                </div>
              </details>
            ))}
          </div>
        </div>

        {/* Contact Form */}
        <div className="bg-white rounded-2xl p-6 shadow-sm mb-6">
          <h3 className="text-[#1B5E20] mb-4">Send Us a Message</h3>
          <div className="space-y-4">
            {/* Topic Selection */}
            <div>
              <label className="text-[#757575] text-sm mb-2 block">Select Topic</label>
              <select
                value={selectedTopic}
                onChange={(e) => setSelectedTopic(e.target.value)}
                className="w-full px-4 py-3 bg-[#FAFAF5] border-2 border-transparent rounded-xl focus:border-[#43A047] focus:outline-none transition-colors text-[#1B5E20]"
              >
                <option value="">Choose a topic...</option>
                {topics.map((topic) => (
                  <option key={topic} value={topic}>{topic}</option>
                ))}
              </select>
            </div>

            {/* Message */}
            <div>
              <label className="text-[#757575] text-sm mb-2 block">Your Message</label>
              <textarea
                value={message}
                onChange={(e) => setMessage(e.target.value)}
                rows={5}
                className="w-full px-4 py-3 bg-[#FAFAF5] border-2 border-transparent rounded-xl focus:border-[#43A047] focus:outline-none transition-colors text-[#1B5E20] resize-none"
                placeholder="Describe your issue or question..."
              />
            </div>

            {/* Submit Button */}
            <button
              onClick={handleSubmit}
              className="w-full bg-gradient-to-r from-[#43A047] to-[#1B5E20] text-white py-4 rounded-2xl shadow-lg hover:shadow-xl transition-all hover:scale-105 flex items-center justify-center gap-2"
            >
              <Send className="w-5 h-5" />
              Send Message
            </button>
          </div>
        </div>

        {/* Support Hours */}
        <div className="bg-blue-50 border-2 border-blue-200 rounded-2xl p-4">
          <div className="flex items-start gap-3">
            <div className="text-2xl">🕐</div>
            <div>
              <div className="text-[#1B5E20] mb-1">Support Hours</div>
              <div className="text-[#757575] text-sm">
                Monday - Saturday: 9:00 AM - 6:00 PM IST<br/>
                Sunday: 10:00 AM - 2:00 PM IST<br/>
                <span className="text-xs mt-1 block">Emergency support available 24/7 via IVR Assistant</span>
              </div>
            </div>
          </div>
        </div>
      </div>

      <FloatingIVR />
      <AppFooter />
    </div>
  );
}