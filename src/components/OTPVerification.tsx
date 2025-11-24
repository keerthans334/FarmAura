import { useState } from 'react';
import { useNavigate, useLocation } from 'react-router-dom';
import AppHeader from './AppHeader';
import { ArrowLeft, CreditCard } from 'lucide-react';

interface OTPVerificationProps {
  phoneNumber?: string;
  setUserData?: (data: any) => void;
  setLocation?: (location: any) => void;
}

export default function OTPVerification({ phoneNumber: propPhoneNumber, setUserData, setLocation }: OTPVerificationProps) {
  const navigate = useNavigate();
  const location = useLocation();
  const phoneNumber = location.state?.phoneNumber || propPhoneNumber || '';
  const isNewUser = location.state?.isNewUser || false;
  const [otp, setOtp] = useState('');
  const [shcNumber, setShcNumber] = useState('');
  const [timer, setTimer] = useState(30);
  const [canResend, setCanResend] = useState(false);
  const [isLoading, setIsLoading] = useState(false);

  const handleChange = (value: string) => {
    // Only allow numbers and max 6 digits
    const numericValue = value.replace(/[^0-9]/g, '').slice(0, 6);
    setOtp(numericValue);
  };

  const handleShcChange = (value: string) => {
    // Allow alphanumeric SHC registration number
    const alphanumericValue = value.toUpperCase().slice(0, 15);
    setShcNumber(alphanumericValue);
  };

  const fetchDataFromSHC = (shcRegNumber: string) => {
    // Mock data fetched from SHC database
    const shcData = {
      name: 'Ramesh Kumar',
      village: 'Kargil',
      district: 'Ranchi',
      state: 'Jharkhand',
      phone: phoneNumber,
      email: '',
      landSize: '2.5',
      irrigation: 'Canal',
      occupation: 'Farmer',
      crops: ['Rice', 'Wheat'],
      previousCrops: ['Rice', 'Wheat', 'Maize'],
      soilType: 'Loamy',
      soilHealth: {
        nitrogen: 'Medium',
        phosphorus: 'High',
        potassium: 'Low',
        pH: '6.8',
        organicCarbon: '0.65%'
      },
      shcNumber: shcRegNumber,
      lastTestDate: '15-08-2024'
    };

    const locationData = {
      district: 'Ranchi',
      state: 'Jharkhand',
      village: 'Kargil',
      detected: true
    };

    // Set location data
    if (setLocation) {
      setLocation(locationData);
      console.log('Location set:', locationData);
    }

    // Set user data
    if (setUserData) {
      setUserData(shcData);
      console.log('User data set:', shcData);
    }

    return { shcData, locationData };
  };

  const handleVerify = () => {
    if (otp.length === 6) {
      // If SHC number is provided, fetch data and go to dashboard
      if (shcNumber.trim().length > 0) {
        console.log('SHC Number provided:', shcNumber);
        const { shcData, locationData } = fetchDataFromSHC(shcNumber);
        console.log('Data fetched, navigating to dashboard...');
        
        // Navigate with state to ensure data is passed
        navigate('/dashboard', { 
          replace: true,
          state: { 
            userData: shcData, 
            location: locationData,
            fromSHC: true 
          } 
        });
        return;
      }

      // New user: go to profile setup
      // Existing user: go directly to dashboard
      if (isNewUser) {
        navigate('/profile-setup');
      } else {
        navigate('/dashboard');
      }
    }
  };

  const handleKeyPress = (e: React.KeyboardEvent) => {
    if (e.key === 'Enter' && otp.length === 6) {
      handleVerify();
    }
  };

  const handleResend = () => {
    if (canResend) {
      setTimer(30);
      setCanResend(false);
      // Add resend OTP logic here
    }
  };

  return (
    <div className="min-h-screen bg-white flex items-center justify-center p-4 max-w-md mx-auto">
      <AppHeader title="" showBack={false} showProfile={false} />
      
      <div className="w-full animate-fade-in">
        <button 
          onClick={() => navigate(-1)}
          className="text-[#1B5E20] mb-6 flex items-center gap-2 hover:gap-3 transition-all"
        >
          <ArrowLeft className="w-5 h-5" />
          Back
        </button>

        <div className="bg-[#FAFAF5] rounded-3xl p-6 shadow-lg border-2 border-[#43A047]">
          <div className="mb-4">
            <p className="text-center text-[#1B5E20] mb-1">Enter 6-digit OTP</p>
          </div>
          
          <div className="mb-6">
            <input
              type="tel"
              inputMode="numeric"
              pattern="\d*"
              maxLength={6}
              value={otp}
              onChange={(e) => handleChange(e.target.value)}
              placeholder="000000"
              className="w-full px-6 py-4 text-center bg-white rounded-2xl border-2 border-[#43A047] focus:outline-none focus:border-[#1B5E20] text-3xl font-mono tracking-[0.5em] placeholder:tracking-normal"
              onKeyPress={handleKeyPress}
            />
          </div>

          <div className="text-center mb-6">
            {timer > 0 ? (
              <p className="text-[#757575]">Resend OTP in {timer}s</p>
            ) : (
              <button className="text-[#43A047] underline" onClick={handleResend}>
                Resend OTP
              </button>
            )}
          </div>

          <button
            onClick={handleVerify}
            disabled={otp.length !== 6}
            className="w-full bg-[#43A047] text-white py-4 rounded-2xl disabled:opacity-50 disabled:cursor-not-allowed hover:bg-[#1B5E20] transition-colors"
          >
            {shcNumber.trim().length > 0 ? 'Verify & Go to Dashboard' : 'Verify & Continue'}
          </button>

          {/* Divider */}
          <div className="flex items-center gap-3 my-6">
            <div className="flex-1 h-[1px] bg-[#43A047]/20"></div>
            <span className="text-[#757575] text-sm">Optional</span>
            <div className="flex-1 h-[1px] bg-[#43A047]/20"></div>
          </div>

          {/* SHC Registration Number */}
          <div className="mb-4">
            <label className="block text-[#1B5E20] mb-2 text-sm flex items-center gap-2">
              <CreditCard className="w-4 h-4" />
              <span>Have SHC Registration Number?</span>
            </label>
            <input
              type="text"
              value={shcNumber}
              onChange={(e) => handleShcChange(e.target.value)}
              placeholder="Enter SHC Number (e.g., JH12345678)"
              className="w-full px-4 py-3 bg-white rounded-2xl border-2 border-[#43A047]/30 focus:outline-none focus:border-[#1B5E20] text-[#1B5E20] placeholder:text-[#757575]"
            />
            {shcNumber.trim().length > 0 && (
              <p className="text-xs text-[#43A047] mt-2 flex items-center gap-1">
                ✓ SHC number entered - Your farm details will be auto-filled!
              </p>
            )}
            {shcNumber.trim().length === 0 && (
              <p className="text-xs text-[#757575] mt-2">
                Enter your Soil Health Card number to auto-fill your farm details
              </p>
            )}
          </div>
        </div>
      </div>
    </div>
  );
}