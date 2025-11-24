import { useNavigate, useLocation } from 'react-router-dom';
import { useState } from 'react';
import { Phone, IdCard } from 'lucide-react';
import FloatingIVR from './FloatingIVR';
import { t } from '../utils/translations';

interface PhoneLoginProps {
  userLanguage?: string;
}

export default function PhoneLogin({ userLanguage = 'English' }: PhoneLoginProps) {
  const navigate = useNavigate();
  const location = useLocation();
  const [phone, setPhone] = useState('');
  const [shcNumber, setShcNumber] = useState('');
  const [loginType, setLoginType] = useState<'phone' | 'shc'>('phone');
  const isNewUser = location.state?.isNewUser || false;

  const handleSendOTP = () => {
    if (loginType === 'phone' && phone.length === 10) {
      navigate('/otp', { state: { phoneNumber: phone, isNewUser } });
    } else if (loginType === 'shc' && shcNumber.length >= 8) {
      // Navigate with SHC number
      navigate('/otp', { state: { shcNumber: shcNumber, isNewUser } });
    }
  };

  const isValid = loginType === 'phone' ? phone.length === 10 : shcNumber.length >= 8;

  return (
    <div className="min-h-screen bg-[#FAFAF5] flex flex-col items-center justify-center p-6 max-w-md mx-auto">
      <div className="w-full">
        <div className="text-center mb-8">
          <div className="w-24 h-24 bg-[#43A047] rounded-full flex items-center justify-center mx-auto mb-4">
            {loginType === 'phone' ? (
              <Phone className="w-12 h-12 text-white" />
            ) : (
              <IdCard className="w-12 h-12 text-white" />
            )}
          </div>
          <h2 className="text-[#1B5E20] text-3xl mb-2">{t('welcomeBack', userLanguage)}</h2>
          <p className="text-[#757575]">
            {loginType === 'phone' 
              ? t('enterPhone', userLanguage)
              : t('enterSHC', userLanguage)}
          </p>
        </div>

        <div className="bg-white rounded-3xl p-6 shadow-lg">
          {/* Toggle between Phone and SHC */}
          <div className="grid grid-cols-2 gap-2 mb-6 bg-[#FAFAF5] p-1 rounded-2xl">
            <button
              onClick={() => setLoginType('phone')}
              className={`flex items-center justify-center gap-2 py-3 rounded-xl transition-all ${
                loginType === 'phone'
                  ? 'bg-[#43A047] text-white shadow-md'
                  : 'text-[#757575] hover:text-[#1B5E20]'
              }`}
            >
              <Phone className="w-5 h-5" />
              <span>{t('phone', userLanguage)}</span>
            </button>
            <button
              onClick={() => setLoginType('shc')}
              className={`flex items-center justify-center gap-2 py-3 rounded-xl transition-all ${
                loginType === 'shc'
                  ? 'bg-[#43A047] text-white shadow-md'
                  : 'text-[#757575] hover:text-[#1B5E20]'
              }`}
            >
              <IdCard className="w-5 h-5" />
              <span>{t('shcID', userLanguage)}</span>
            </button>
          </div>

          {/* Phone Number Input */}
          {loginType === 'phone' && (
            <>
              <label className="block text-[#1B5E20] mb-2">{t('phoneNumber', userLanguage)}</label>
              <div className="flex gap-2 mb-6 w-full">
                <div className="w-[50px] flex-shrink-0 bg-[#FAFAF5] rounded-xl flex items-center justify-center border-2 border-[#43A047]">
                  <span className="text-[#1B5E20]">+91</span>
                </div>
                <div className="flex-1 relative">
                  <input
                    type="tel"
                    maxLength={10}
                    value={phone}
                    onChange={(e) => setPhone(e.target.value.replace(/\D/g, ''))}
                    placeholder="Enter 10 digit number"
                    className="w-full px-4 py-3 pr-12 bg-[#FAFAF5] rounded-xl border-2 border-[#43A047] focus:outline-none focus:border-[#1B5E20]"
                  />
                </div>
              </div>
            </>
          )}

          {/* SHC Registration Number Input */}
          {loginType === 'shc' && (
            <>
              <label className="block text-[#1B5E20] mb-2">{t('shcNumber', userLanguage)}</label>
              <div className="mb-6 w-full relative">
                <input
                  type="text"
                  maxLength={15}
                  value={shcNumber}
                  onChange={(e) => setShcNumber(e.target.value.toUpperCase())}
                  placeholder="Enter SHC registration number"
                  className="w-full px-4 py-3 pr-12 bg-[#FAFAF5] rounded-xl border-2 border-[#43A047] focus:outline-none focus:border-[#1B5E20] tracking-wider"
                />
              </div>
            </>
          )}

          <button
            onClick={handleSendOTP}
            disabled={!isValid}
            className="w-full bg-[#43A047] text-white py-4 rounded-2xl disabled:opacity-50 disabled:cursor-not-allowed hover:bg-[#1B5E20] transition-colors"
          >
            {t('sendOTP', userLanguage)}
          </button>

          <p className="text-center text-[#757575] text-sm mt-4">
            {t('termsAgree', userLanguage)}
          </p>
        </div>
      </div>

      <FloatingIVR />
    </div>
  );
}