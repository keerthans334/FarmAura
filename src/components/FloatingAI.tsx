import { Bot } from 'lucide-react';
import { useNavigate } from 'react-router-dom';

export default function FloatingAI() {
  const navigate = useNavigate();

  return (
    <button 
      onClick={() => navigate('/ai-chat')}
      className="fixed bottom-24 right-4 w-14 h-14 bg-gradient-to-br from-[#43A047] to-[#1B5E20] rounded-full shadow-lg flex items-center justify-center z-40 hover:scale-110 transition-transform animate-bounce-subtle max-w-md"
      style={{ right: 'max(1rem, calc((100vw - 28rem) / 2 + 1rem))' }}
    >
      <Bot className="w-7 h-7 text-white" />
    </button>
  );
}