import { useState } from 'react';
import { Volume2, Mic, X, Maximize2 } from 'lucide-react';
import { useNavigate } from 'react-router-dom';

export default function FloatingIVR() {
  const navigate = useNavigate();
  const [isOpen, setIsOpen] = useState(false);
  const [isListening, setIsListening] = useState(false);
  const [messages, setMessages] = useState<Array<{ type: 'user' | 'assistant', text: string }>>([]);
  const [currentResponse, setCurrentResponse] = useState('');

  const handleIVRClick = () => {
    setIsOpen(true);
  };

  const handleClose = () => {
    setIsOpen(false);
    setMessages([]);
    setCurrentResponse('');
  };

  const handleMaximize = () => {
    navigate('/ai-chat');
  };

  const handleMicClick = () => {
    if (isListening) return;
    
    setIsListening(true);
    
    // Simulate voice recognition
    setTimeout(() => {
      const userQuery = "How do I control pests on my wheat crop?";
      setMessages(prev => [...prev, { type: 'user', text: userQuery }]);
      setIsListening(false);
      
      // Simulate AI typing response
      const response = "For wheat pest control, I recommend:\n\n1. Use neem-based organic pesticides\n2. Spray early morning or evening\n3. Monitor for aphids and termites\n4. Apply fungicides if rust appears\n5. Maintain proper field drainage\n\nWould you like specific product recommendations?";
      
      let index = 0;
      const typingInterval = setInterval(() => {
        if (index < response.length) {
          setCurrentResponse(response.substring(0, index + 1));
          index++;
        } else {
          clearInterval(typingInterval);
          setMessages(prev => [...prev, { type: 'assistant', text: response }]);
          setCurrentResponse('');
        }
      }, 30);
    }, 2000);
  };

  return (
    <>
      {/* Floating IVR Button */}
      {!isOpen && (
        <button
          onClick={handleIVRClick}
          className="fixed bottom-24 right-4 w-14 h-14 bg-gradient-to-br from-[#43A047] to-[#1B5E20] rounded-full shadow-xl flex items-center justify-center z-50 hover:scale-110 transition-transform"
          style={{ right: 'max(1rem, calc((100vw - 28rem) / 2 + 1rem))' }}
          aria-label="Voice Assistant"
        >
          <Volume2 className="w-7 h-7 text-white" />
        </button>
      )}

      {/* Floating Window - Fixed Position */}
      {isOpen && (
        <div
          className="fixed bg-white rounded-3xl shadow-2xl z-50 transition-all h-96"
          style={{
            bottom: '6rem',
            right: 'max(1rem, calc((100vw - 28rem) / 2 + 1rem))',
            width: 'min(calc(100vw - 2rem), 24rem)'
          }}
        >
          {/* Header */}
          <div className="bg-gradient-to-r from-[#43A047] to-[#1B5E20] rounded-t-3xl p-4 flex items-center justify-between">
            <div className="flex items-center gap-2">
              <Volume2 className="w-5 h-5 text-white" />
              <h3 className="text-white">AI Voice Assistant</h3>
            </div>
            <div className="flex items-center gap-2">
              <button
                onClick={handleMaximize}
                className="p-1 hover:bg-white/20 rounded-lg transition-colors"
                aria-label="Maximize to full chat"
              >
                <Maximize2 className="w-4 h-4 text-white" />
              </button>
              <button
                onClick={handleClose}
                className="p-1 hover:bg-white/20 rounded-lg transition-colors"
                aria-label="Close"
              >
                <X className="w-4 h-4 text-white" />
              </button>
            </div>
          </div>

          {/* Content */}
          <div className="flex flex-col h-[calc(100%-5rem)]">
            {/* Messages Area */}
            <div className="flex-1 overflow-y-auto p-4 space-y-3">
              {messages.length === 0 && !currentResponse && (
                <div className="text-center text-[#757575] py-8">
                  <Mic className="w-12 h-12 mx-auto mb-3 text-[#43A047]" />
                  <p className="text-sm">Tap the microphone to speak</p>
                  <p className="text-xs mt-1">Ask me anything about farming!</p>
                </div>
              )}
              
              {messages.map((message, index) => (
                <div
                  key={index}
                  className={`${
                    message.type === 'user'
                      ? 'bg-[#E8F5E9] ml-8 rounded-2xl rounded-br-sm'
                      : 'bg-[#F5F5F5] mr-8 rounded-2xl rounded-bl-sm'
                  } p-3`}
                >
                  <p className="text-sm text-[#1B5E20] whitespace-pre-line">{message.text}</p>
                </div>
              ))}
              
              {currentResponse && (
                <div className="bg-[#F5F5F5] mr-8 rounded-2xl rounded-bl-sm p-3">
                  <p className="text-sm text-[#1B5E20] whitespace-pre-line">{currentResponse}</p>
                  <span className="inline-block w-2 h-4 bg-[#43A047] animate-pulse ml-1"></span>
                </div>
              )}
              
              {isListening && (
                <div className="flex items-center justify-center gap-2 py-4">
                  <div className="flex gap-1">
                    <div className="w-2 h-6 bg-[#43A047] rounded-full animate-pulse"></div>
                    <div className="w-2 h-6 bg-[#43A047] rounded-full animate-pulse" style={{ animationDelay: '0.2s' }}></div>
                    <div className="w-2 h-6 bg-[#43A047] rounded-full animate-pulse" style={{ animationDelay: '0.4s' }}></div>
                  </div>
                  <span className="text-sm text-[#757575]">Listening...</span>
                </div>
              )}
            </div>

            {/* Input Area */}
            <div className="border-t border-gray-200 p-4">
              <div className="flex items-center gap-3">
                <button
                  onClick={handleMicClick}
                  disabled={isListening}
                  className={`w-12 h-12 rounded-full flex items-center justify-center shadow-lg transition-all ${
                    isListening
                      ? 'bg-gradient-to-br from-[#FF5722] to-[#E64A19] animate-pulse'
                      : 'bg-gradient-to-br from-[#43A047] to-[#1B5E20] hover:scale-110'
                  }`}
                >
                  <Mic className="w-6 h-6 text-white" />
                </button>
                <div className="flex-1 bg-[#F5F5F5] rounded-full px-4 py-3">
                  <p className="text-sm text-[#757575]">
                    {isListening ? 'Listening to your voice...' : 'Tap mic to speak'}
                  </p>
                </div>
              </div>
            </div>
          </div>
        </div>
      )}
    </>
  );
}