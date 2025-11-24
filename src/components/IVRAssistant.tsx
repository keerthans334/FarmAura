import { useState, useEffect } from 'react';
import { Mic, MicOff, Volume2, X } from 'lucide-react';

interface IVRAssistantProps {
  pageName?: string;
}

export default function IVRAssistant({ pageName = 'current page' }: IVRAssistantProps) {
  const [isListening, setIsListening] = useState(false);
  const [isExpanded, setIsExpanded] = useState(false);
  const [transcript, setTranscript] = useState('');
  const [isSpeaking, setIsSpeaking] = useState(false);

  const helpTexts: { [key: string]: string } = {
    dashboard: "Welcome to your dashboard. You can check weather, soil health, crop recommendations, and market prices here.",
    'crop-rec': "This is the crop recommendation page. I can help you find the best crops for your farm based on soil and weather conditions.",
    market: "Here you can check current market prices for various crops in your area.",
    weather: "This page shows weather information and forecasts for your location.",
    soil: "View your soil health details and get recommendations for soil improvement.",
    pest: "Upload a photo of the affected plant to detect pests and diseases.",
    community: "Connect with other farmers, ask questions, and share your experiences.",
    videos: "Watch educational videos about farming techniques and best practices.",
    profile: "Manage your profile, view crop history, and saved recommendations.",
    default: "I'm your AI voice assistant. How can I help you navigate this page?"
  };

  const startListening = () => {
    setIsListening(true);
    setIsExpanded(true);
    // Simulate voice recognition
    setTimeout(() => {
      setTranscript("आपको किस जानकारी की आवश्यकता है?");
      setIsListening(false);
    }, 2000);
  };

  const stopListening = () => {
    setIsListening(false);
  };

  const speakHelp = () => {
    setIsSpeaking(true);
    const pageKey = window.location.pathname.split('/').pop() || 'default';
    const helpText = helpTexts[pageKey] || helpTexts.default;
    setTranscript(helpText);
    
    // Simulate speaking
    setTimeout(() => {
      setIsSpeaking(false);
    }, 3000);
  };

  return (
    <>
      {/* Floating IVR Button */}
      <button
        onClick={() => setIsExpanded(!isExpanded)}
        className={`fixed bottom-24 left-4 z-40 w-14 h-14 rounded-full shadow-lg transition-all flex items-center justify-center ${
          isListening 
            ? 'bg-red-600 animate-pulse' 
            : 'bg-gradient-to-br from-[#FFC107] to-[#FF9800]'
        }`}
        aria-label="Voice Assistant"
      >
        {isListening ? (
          <MicOff className="w-6 h-6 text-white" />
        ) : (
          <Mic className="w-6 h-6 text-white" />
        )}
      </button>

      {/* Expanded IVR Panel */}
      {isExpanded && (
        <div className="fixed bottom-40 left-4 right-4 z-50 max-w-md mx-auto animate-scale-in">
          <div className="bg-white rounded-3xl shadow-2xl p-6 border-2 border-[#FFC107]">
            <div className="flex items-center justify-between mb-4">
              <div className="flex items-center gap-2">
                <div className="w-10 h-10 bg-gradient-to-br from-[#FFC107] to-[#FF9800] rounded-full flex items-center justify-center">
                  <Mic className="w-5 h-5 text-white" />
                </div>
                <div>
                  <h3 className="text-[#1B5E20]">Voice Assistant</h3>
                  <p className="text-xs text-[#757575]">
                    {isListening ? 'Listening...' : 'Tap to speak'}
                  </p>
                </div>
              </div>
              <button
                onClick={() => setIsExpanded(false)}
                className="p-2 hover:bg-[#FAFAF5] rounded-full transition-colors"
              >
                <X className="w-5 h-5 text-[#757575]" />
              </button>
            </div>

            {/* Transcript Display */}
            {transcript && (
              <div className="bg-[#FAFAF5] rounded-2xl p-4 mb-4 min-h-[80px]">
                <p className="text-[#1B5E20] text-sm">{transcript}</p>
              </div>
            )}

            {/* Control Buttons */}
            <div className="grid grid-cols-2 gap-3">
              <button
                onClick={isListening ? stopListening : startListening}
                className={`py-3 rounded-2xl transition-all flex items-center justify-center gap-2 ${
                  isListening
                    ? 'bg-red-600 text-white'
                    : 'bg-gradient-to-r from-[#43A047] to-[#1B5E20] text-white'
                }`}
              >
                {isListening ? (
                  <>
                    <MicOff className="w-5 h-5" />
                    <span>Stop</span>
                  </>
                ) : (
                  <>
                    <Mic className="w-5 h-5" />
                    <span>Speak</span>
                  </>
                )}
              </button>
              
              <button
                onClick={speakHelp}
                disabled={isSpeaking}
                className={`py-3 rounded-2xl transition-all flex items-center justify-center gap-2 ${
                  isSpeaking
                    ? 'bg-[#FAFAF5] text-[#757575]'
                    : 'bg-[#FFC107] text-white hover:bg-[#FF9800]'
                }`}
              >
                <Volume2 className={`w-5 h-5 ${isSpeaking ? 'animate-pulse' : ''}`} />
                <span>{isSpeaking ? 'Speaking...' : 'Help'}</span>
              </button>
            </div>

            {/* Language Support Info */}
            <div className="mt-4 text-center">
              <p className="text-xs text-[#757575]">
                Supports: Hindi, English, Bengali, Nagpuri, Kurmali, Santhali
              </p>
            </div>
          </div>
        </div>
      )}
    </>
  );
}
