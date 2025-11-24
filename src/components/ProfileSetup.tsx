import { useNavigate } from 'react-router-dom';
import { useState } from 'react';
import { UserCircle, ChevronDown, Check } from 'lucide-react';
import FloatingIVR from './FloatingIVR';

interface ProfileSetupProps {
  setUserData: (data: any) => void;
}

export default function ProfileSetup({ setUserData }: ProfileSetupProps) {
  const navigate = useNavigate();
  const [formData, setFormData] = useState({
    name: '',
    village: '',
    district: '',
    state: 'Jharkhand',
    email: '',
    occupation: 'Farmer'
  });
  const [showDistrictDropdown, setShowDistrictDropdown] = useState(false);
  const [showStateDropdown, setShowStateDropdown] = useState(false);
  const [showOccupationDropdown, setShowOccupationDropdown] = useState(false);

  const handleSubmit = () => {
    setUserData((prev: any) => ({ ...prev, ...formData }));
    navigate('/farm-setup');
  };

  const districts = [
    'Ranchi', 'Dhanbad', 'Jamshedpur', 'Bokaro', 'Deoghar', 'Giridih', 
    'Hazaribagh', 'Ramgarh', 'Dumka', 'Godda', 'Garhwa', 'Palamu',
    'Chatra', 'Koderma', 'Latehar', 'Lohardaga', 'Gumla', 'Simdega',
    'Khunti', 'West Singhbhum', 'East Singhbhum', 'Saraikela Kharsawan',
    'Jamtara', 'Pakur', 'Sahibganj'
  ];

  const states = [
    'Jharkhand', 'Bihar', 'West Bengal', 'Odisha', 'Chhattisgarh', 
    'Uttar Pradesh', 'Madhya Pradesh', 'Maharashtra', 'Andhra Pradesh',
    'Telangana', 'Karnataka', 'Tamil Nadu', 'Kerala', 'Punjab', 
    'Haryana', 'Rajasthan', 'Gujarat', 'Assam', 'Other'
  ];

  const occupations = [
    { value: 'Farmer', icon: '🌾' },
    { value: 'Agricultural Worker', icon: '👨‍🌾' },
    { value: 'Landowner', icon: '🏡' },
    { value: 'Tenant Farmer', icon: '🚜' },
    { value: 'Other', icon: '📝' }
  ];

  return (
    <div className="min-h-screen bg-gradient-to-b from-[#E8F5E9] to-[#FAFAF5] p-6 max-w-md mx-auto animate-fade-in pb-32">
      <div className="pt-6">
        {/* Header */}
        <div className="text-center mb-8 animate-scale-in">
          <div className="w-20 h-20 bg-gradient-to-br from-[#43A047] to-[#1B5E20] rounded-full flex items-center justify-center mx-auto mb-4 shadow-lg">
            <UserCircle className="w-10 h-10 text-white" />
          </div>
          <h1 className="text-[#1B5E20] mb-2">Personal Information</h1>
          <p className="text-[#757575] text-sm">Help us know you better</p>
        </div>

        {/* Form Card */}
        <div className="bg-white rounded-3xl p-6 shadow-xl space-y-5 animate-scale-in">
          {/* Full Name */}
          <div>
            <label className="block text-[#1B5E20] mb-2 text-sm">Full Name</label>
            <input
              type="text"
              value={formData.name}
              onChange={(e) => setFormData({ ...formData, name: e.target.value })}
              placeholder="Enter your full name"
              className="w-full px-4 py-3.5 bg-[#FAFAF5] rounded-2xl border-2 border-transparent focus:border-[#43A047] focus:outline-none transition-all"
            />
          </div>

          {/* Village */}
          <div>
            <label className="block text-[#1B5E20] mb-2 text-sm">Village Name</label>
            <input
              type="text"
              value={formData.village}
              onChange={(e) => setFormData({ ...formData, village: e.target.value })}
              placeholder="Enter your village"
              className="w-full px-4 py-3.5 bg-[#FAFAF5] rounded-2xl border-2 border-transparent focus:border-[#43A047] focus:outline-none transition-all"
            />
          </div>

          {/* Email - Optional */}
          <div>
            <label className="block text-[#1B5E20] mb-2 text-sm">
              Email Address <span className="text-[#757575] text-xs">(Optional)</span>
            </label>
            <input
              type="email"
              value={formData.email}
              onChange={(e) => setFormData({ ...formData, email: e.target.value })}
              placeholder="Enter your email (optional)"
              className="w-full px-4 py-3.5 bg-[#FAFAF5] rounded-2xl border-2 border-transparent focus:border-[#43A047] focus:outline-none transition-all"
            />
          </div>

          {/* District - Custom Dropdown */}
          <div>
            <label className="block text-[#1B5E20] mb-2 text-sm">District</label>
            <div className="relative">
              <button
                type="button"
                onClick={() => setShowDistrictDropdown(!showDistrictDropdown)}
                className="w-full px-4 py-3.5 bg-[#FAFAF5] rounded-2xl border-2 border-transparent focus:border-[#43A047] text-left flex items-center justify-between"
              >
                <span className={formData.district ? 'text-[#1B5E20]' : 'text-[#757575]'}>
                  {formData.district || 'Select your district'}
                </span>
                <ChevronDown className={`w-5 h-5 text-[#43A047] transition-transform ${showDistrictDropdown ? 'rotate-180' : ''}`} />
              </button>
              
              {showDistrictDropdown && (
                <div className="absolute top-full left-0 right-0 mt-2 bg-white rounded-2xl shadow-2xl max-h-60 overflow-y-auto z-50 border-2 border-[#E8F5E9]">
                  {districts.map((district) => (
                    <button
                      key={district}
                      onClick={() => {
                        setFormData({ ...formData, district });
                        setShowDistrictDropdown(false);
                      }}
                      className="w-full px-4 py-3 text-left hover:bg-[#E8F5E9] transition-colors flex items-center justify-between"
                    >
                      <span className="text-[#1B5E20]">{district}</span>
                      {formData.district === district && <Check className="w-5 h-5 text-[#43A047]" />}
                    </button>
                  ))}
                </div>
              )}
            </div>
          </div>

          {/* State - Custom Dropdown */}
          <div>
            <label className="block text-[#1B5E20] mb-2 text-sm">State</label>
            <div className="relative">
              <button
                type="button"
                onClick={() => setShowStateDropdown(!showStateDropdown)}
                className="w-full px-4 py-3.5 bg-[#FAFAF5] rounded-2xl border-2 border-transparent focus:border-[#43A047] text-left flex items-center justify-between"
              >
                <span className={formData.state ? 'text-[#1B5E20]' : 'text-[#757575]'}>
                  {formData.state || 'Select your state'}
                </span>
                <ChevronDown className={`w-5 h-5 text-[#43A047] transition-transform ${showStateDropdown ? 'rotate-180' : ''}`} />
              </button>
              
              {showStateDropdown && (
                <div className="absolute top-full left-0 right-0 mt-2 bg-white rounded-2xl shadow-2xl max-h-60 overflow-y-auto z-50 border-2 border-[#E8F5E9]">
                  {states.map((state) => (
                    <button
                      key={state}
                      onClick={() => {
                        setFormData({ ...formData, state });
                        setShowStateDropdown(false);
                      }}
                      className="w-full px-4 py-3 text-left hover:bg-[#E8F5E9] transition-colors flex items-center justify-between"
                    >
                      <span className="text-[#1B5E20]">{state}</span>
                      {formData.state === state && <Check className="w-5 h-5 text-[#43A047]" />}
                    </button>
                  ))}
                </div>
              )}
            </div>
          </div>

          {/* Occupation - Icon Buttons */}
          <div>
            <label className="block text-[#1B5E20] mb-2 text-sm">Occupation</label>
            <div className="grid grid-cols-2 gap-3">
              {occupations.map((occ) => (
                <button
                  key={occ.value}
                  type="button"
                  onClick={() => setFormData({ ...formData, occupation: occ.value })}
                  className={`p-4 rounded-2xl border-2 transition-all card-hover ${
                    formData.occupation === occ.value
                      ? 'bg-gradient-to-br from-[#43A047] to-[#1B5E20] text-white border-[#43A047] shadow-lg scale-105'
                      : 'bg-[#FAFAF5] text-[#1B5E20] border-[#E8F5E9]'
                  }`}
                >
                  <div className="text-2xl mb-1">{occ.icon}</div>
                  <div className="text-xs">{occ.value}</div>
                </button>
              ))}
            </div>
          </div>

          {/* Submit Button */}
          <button
            onClick={handleSubmit}
            disabled={!formData.name || !formData.village || !formData.district}
            className="w-full bg-gradient-to-r from-[#43A047] to-[#1B5E20] text-white py-4 rounded-2xl disabled:opacity-50 disabled:cursor-not-allowed shadow-lg hover:shadow-xl transition-all hover:scale-105 mt-6 disabled:hover:scale-100"
          >
            Continue
          </button>
        </div>

        {/* Progress Indicator */}
        <div className="mt-6 flex items-center justify-center gap-2">
          <div className="w-8 h-2 bg-[#43A047] rounded-full"></div>
          <div className="w-2 h-2 bg-[#C8E6C9] rounded-full"></div>
          <div className="w-2 h-2 bg-[#C8E6C9] rounded-full"></div>
        </div>
      </div>

      <FloatingIVR />
    </div>
  );
}