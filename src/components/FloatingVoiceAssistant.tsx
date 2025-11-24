import { useState } from 'react';
import { Mic } from 'lucide-react';
import { useNavigate } from 'react-router-dom';

export default function FloatingVoiceAssistant() {
  const navigate = useNavigate();
  const [isListening, setIsListening] = useState(false);

  const handleVoiceClick = () => {
    setIsListening(true);
    
    // Simulate voice listening for 2 seconds
    setTimeout(() => {
      setIsListening(false);
      // Navigate to AI chat after listening
      navigate('/ai-chat');
    }, 2000);
  };

  return (
    <button
      onClick={handleVoiceClick}
      className={`fixed bottom-24 right-4 w-14 h-14 rounded-full shadow-lg flex items-center justify-center z-40 transition-all ${
        isListening 
          ? 'bg-gradient-to-br from-[#FF5722] to-[#E64A19] animate-pulse scale-110' 
          : 'bg-gradient-to-br from-[#43A047] to-[#1B5E20] hover:scale-110'
      }`}
      style={{ right: 'max(1rem, calc((100vw - 28rem) / 2 + 1rem))' }}
      aria-label="Voice Assistant - Click to speak"
    >
      <Mic className={`w-7 h-7 text-white ${isListening ? 'animate-bounce' : ''}`} />
      {isListening && (
        <span className="absolute -top-10 left-1/2 transform -translate-x-1/2 bg-[#1B5E20] text-white px-3 py-1 rounded-lg text-xs whitespace-nowrap">
          Listening...
        </span>
      )}
    </button>
  );
}
