import { useNavigate } from 'react-router-dom';
import { useState } from 'react';
import { ArrowLeft, Mic, Send } from 'lucide-react';

export default function AIChatbot() {
  const navigate = useNavigate();
  const [message, setMessage] = useState('');
  const [messages, setMessages] = useState([
    {
      type: 'bot',
      text: 'Hello! I am FarmAura AI. How can I help you with your farming today?',
      time: 'Just now'
    }
  ]);

  const quickQuestions = [
    'How to test soil?',
    'Tell me about cotton farming',
    'Weather information',
    'What are current market rates?'
  ];

  const handleSend = () => {
    if (!message.trim()) return;
    
    setMessages([
      ...messages,
      { type: 'user', text: message, time: 'Just now' }
    ]);
    
    // Simulate AI response
    setTimeout(() => {
      setMessages(prev => [
        ...prev,
        { 
          type: 'bot', 
          text: 'I am helping you. Please give me a moment...', 
          time: 'Just now' 
        }
      ]);
    }, 500);
    
    setMessage('');
  };

  return (
    <div className="min-h-screen bg-[#FAFAF5] max-w-md mx-auto flex flex-col animate-fade-in">
      {/* Header */}
      <div className="bg-gradient-to-r from-[#43A047] to-[#1B5E20] text-white p-4 shadow-lg">
        <div className="flex items-center gap-3">
          <button 
            onClick={() => navigate(-1)}
            className="p-2 hover:bg-white/20 rounded-full transition-colors"
          >
            <ArrowLeft className="w-6 h-6" />
          </button>
          <div className="flex items-center gap-3 flex-1">
            <div className="w-12 h-12 bg-white/20 rounded-full flex items-center justify-center">
              <span className="text-2xl">🤖</span>
            </div>
            <div>
              <h2 className="text-lg">FarmAura AI Assistant</h2>
              <p className="text-sm opacity-90">Always here to help</p>
            </div>
          </div>
        </div>
      </div>

      {/* Messages */}
      <div className="flex-1 overflow-y-auto p-4 space-y-4">
        {messages.map((msg, idx) => (
          <div 
            key={idx}
            className={`flex ${msg.type === 'user' ? 'justify-end' : 'justify-start'} animate-scale-in`}
          >
            <div className={`max-w-[80%] rounded-2xl p-4 shadow-sm ${
              msg.type === 'user'
                ? 'bg-gradient-to-r from-[#43A047] to-[#1B5E20] text-white'
                : 'bg-white text-[#1B5E20]'
            }`}>
              <p className="text-sm">{msg.text}</p>
              <p className={`text-xs mt-1 ${
                msg.type === 'user' ? 'text-white/70' : 'text-[#757575]'
              }`}>
                {msg.time}
              </p>
            </div>
          </div>
        ))}

        {/* Quick Questions */}
        {messages.length === 1 && (
          <div className="mt-4">
            <p className="text-[#757575] text-sm mb-3">Quick Questions:</p>
            <div className="space-y-2">
              {quickQuestions.map((q, idx) => (
                <button
                  key={idx}
                  onClick={() => setMessage(q)}
                  className="w-full bg-white rounded-xl p-3 text-left text-[#1B5E20] text-sm shadow-sm hover:shadow-md transition-all card-hover"
                >
                  {q}
                </button>
              ))}
            </div>
          </div>
        )}
      </div>

      {/* Input */}
      <div className="p-4 bg-white border-t border-[#FAFAF5]">
        <div className="flex items-center gap-2">
          <button className="p-3 bg-[#FAFAF5] rounded-full hover:bg-[#E8F5E9] transition-colors">
            <Mic className="w-5 h-5 text-[#43A047]" />
          </button>
          <input
            type="text"
            value={message}
            onChange={(e) => setMessage(e.target.value)}
            onKeyPress={(e) => e.key === 'Enter' && handleSend()}
            placeholder="Type your question..."
            className="flex-1 px-4 py-3 bg-[#FAFAF5] rounded-full focus:outline-none focus:ring-2 focus:ring-[#43A047]"
          />
          <button 
            onClick={handleSend}
            className="p-3 bg-gradient-to-r from-[#43A047] to-[#1B5E20] rounded-full shadow-lg hover:shadow-xl transition-all hover:scale-105"
          >
            <Send className="w-5 h-5 text-white" />
          </button>
        </div>
      </div>
    </div>
  );
}