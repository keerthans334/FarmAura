import { useNavigate } from 'react-router-dom';
import { useState } from 'react';
import AppHeader from './AppHeader';
import AppFooter from './AppFooter';
import FloatingIVR from './FloatingIVR';
import { User, Phone, Mail, MapPin, Save, Camera } from 'lucide-react';
import { toast } from 'sonner@2.0.3';

interface ProfileEditProps {
  userData: any;
  setUserData: (data: any) => void;
  location: any;
}

export default function ProfileEdit({ userData, setUserData, location }: ProfileEditProps) {
  const navigate = useNavigate();
  const [formData, setFormData] = useState({
    name: userData.name || '',
    phone: userData.phone || '',
    email: userData.email || '',
    village: userData.village || '',
    district: userData.district || location?.district || '',
    state: userData.state || location?.state || 'Jharkhand',
    landSize: userData.landSize || '',
    irrigation: userData.irrigation || '',
    occupation: userData.occupation || 'Farmer'
  });

  const handleChange = (field: string, value: string) => {
    setFormData({ ...formData, [field]: value });
  };

  const handleSave = () => {
    setUserData(formData);
    toast.success('Profile updated successfully!');
    navigate('/profile');
  };

  return (
    <div className="min-h-screen bg-[#FAFAF5] pb-24 max-w-md mx-auto">
      <AppHeader title="Edit Profile" showBack={true} showProfile={false} />
      
      <div className="pt-20 px-4">
        {/* Profile Photo */}
        <div className="flex justify-center mb-6">
          <div className="relative">
            <div className="w-24 h-24 bg-gradient-to-br from-[#43A047] to-[#1B5E20] rounded-full flex items-center justify-center text-5xl shadow-lg">
              👨‍🌾
            </div>
            <button className="absolute bottom-0 right-0 w-8 h-8 bg-[#FFC107] rounded-full flex items-center justify-center shadow-lg hover:scale-110 transition-transform">
              <Camera className="w-4 h-4 text-white" />
            </button>
          </div>
        </div>

        {/* Personal Information */}
        <div className="mb-6">
          <h3 className="text-[#1B5E20] mb-3">Personal Information</h3>
          <div className="bg-white rounded-2xl p-4 shadow-sm space-y-4">
            {/* Name */}
            <div>
              <label className="flex items-center gap-2 text-[#757575] text-sm mb-2">
                <User className="w-4 h-4" />
                Full Name
              </label>
              <input
                type="text"
                value={formData.name}
                onChange={(e) => handleChange('name', e.target.value)}
                className="w-full px-4 py-3 bg-[#FAFAF5] border-2 border-transparent rounded-xl focus:border-[#43A047] focus:outline-none transition-colors text-[#1B5E20]"
                placeholder="Enter your name"
              />
            </div>

            {/* Phone */}
            <div>
              <label className="flex items-center gap-2 text-[#757575] text-sm mb-2">
                <Phone className="w-4 h-4" />
                Phone Number
              </label>
              <input
                type="tel"
                value={formData.phone}
                onChange={(e) => handleChange('phone', e.target.value)}
                className="w-full px-4 py-3 bg-[#FAFAF5] border-2 border-transparent rounded-xl focus:border-[#43A047] focus:outline-none transition-colors text-[#1B5E20]"
                placeholder="+91 XXXXXXXXXX"
              />
            </div>

            {/* Email */}
            <div>
              <label className="flex items-center gap-2 text-[#757575] text-sm mb-2">
                <Mail className="w-4 h-4" />
                Email (Optional)
              </label>
              <input
                type="email"
                value={formData.email}
                onChange={(e) => handleChange('email', e.target.value)}
                className="w-full px-4 py-3 bg-[#FAFAF5] border-2 border-transparent rounded-xl focus:border-[#43A047] focus:outline-none transition-colors text-[#1B5E20]"
                placeholder="your.email@example.com"
              />
            </div>

            {/* Occupation */}
            <div>
              <label className="text-[#757575] text-sm mb-2 block">Occupation</label>
              <select
                value={formData.occupation}
                onChange={(e) => handleChange('occupation', e.target.value)}
                className="w-full px-4 py-3 bg-[#FAFAF5] border-2 border-transparent rounded-xl focus:border-[#43A047] focus:outline-none transition-colors text-[#1B5E20]"
              >
                <option value="Farmer">Farmer</option>
                <option value="Agricultural Worker">Agricultural Worker</option>
                <option value="Farm Owner">Farm Owner</option>
                <option value="Tenant Farmer">Tenant Farmer</option>
              </select>
            </div>
          </div>
        </div>

        {/* Location Information */}
        <div className="mb-6">
          <h3 className="text-[#1B5E20] mb-3">Location Information</h3>
          <div className="bg-white rounded-2xl p-4 shadow-sm space-y-4">
            {/* Village */}
            <div>
              <label className="flex items-center gap-2 text-[#757575] text-sm mb-2">
                <MapPin className="w-4 h-4" />
                Village
              </label>
              <input
                type="text"
                value={formData.village}
                onChange={(e) => handleChange('village', e.target.value)}
                className="w-full px-4 py-3 bg-[#FAFAF5] border-2 border-transparent rounded-xl focus:border-[#43A047] focus:outline-none transition-colors text-[#1B5E20]"
                placeholder="Enter your village"
              />
            </div>

            {/* District */}
            <div>
              <label className="text-[#757575] text-sm mb-2 block">District</label>
              <input
                type="text"
                value={formData.district}
                onChange={(e) => handleChange('district', e.target.value)}
                className="w-full px-4 py-3 bg-[#FAFAF5] border-2 border-transparent rounded-xl focus:border-[#43A047] focus:outline-none transition-colors text-[#1B5E20]"
                placeholder="Enter your district"
              />
            </div>

            {/* State */}
            <div>
              <label className="text-[#757575] text-sm mb-2 block">State</label>
              <select
                value={formData.state}
                onChange={(e) => handleChange('state', e.target.value)}
                className="w-full px-4 py-3 bg-[#FAFAF5] border-2 border-transparent rounded-xl focus:border-[#43A047] focus:outline-none transition-colors text-[#1B5E20]"
              >
                <option value="Jharkhand">Jharkhand</option>
                <option value="Bihar">Bihar</option>
                <option value="West Bengal">West Bengal</option>
                <option value="Odisha">Odisha</option>
                <option value="Chhattisgarh">Chhattisgarh</option>
              </select>
            </div>
          </div>
        </div>

        {/* Farm Information */}
        <div className="mb-6">
          <h3 className="text-[#1B5E20] mb-3">Farm Information</h3>
          <div className="bg-white rounded-2xl p-4 shadow-sm space-y-4">
            {/* Land Size */}
            <div>
              <label className="text-[#757575] text-sm mb-2 block">Land Size</label>
              <select
                value={formData.landSize}
                onChange={(e) => handleChange('landSize', e.target.value)}
                className="w-full px-4 py-3 bg-[#FAFAF5] border-2 border-transparent rounded-xl focus:border-[#43A047] focus:outline-none transition-colors text-[#1B5E20]"
              >
                <option value="">Select land size</option>
                <option value="Less than 1 Acre">Less than 1 Acre</option>
                <option value="1-2 Acres">1-2 Acres</option>
                <option value="2-5 Acres">2-5 Acres</option>
                <option value="5-10 Acres">5-10 Acres</option>
                <option value="More than 10 Acres">More than 10 Acres</option>
              </select>
            </div>

            {/* Irrigation */}
            <div>
              <label className="text-[#757575] text-sm mb-2 block">Irrigation Method</label>
              <select
                value={formData.irrigation}
                onChange={(e) => handleChange('irrigation', e.target.value)}
                className="w-full px-4 py-3 bg-[#FAFAF5] border-2 border-transparent rounded-xl focus:border-[#43A047] focus:outline-none transition-colors text-[#1B5E20]"
              >
                <option value="">Select irrigation method</option>
                <option value="Borewell">Borewell</option>
                <option value="Canal">Canal</option>
                <option value="Drip Irrigation">Drip Irrigation</option>
                <option value="Sprinkler">Sprinkler</option>
                <option value="Rainfed">Rainfed</option>
              </select>
            </div>
          </div>
        </div>

        {/* Save Button */}
        <button
          onClick={handleSave}
          className="w-full bg-gradient-to-r from-[#43A047] to-[#1B5E20] text-white py-5 rounded-2xl shadow-xl hover:shadow-2xl transition-all hover:scale-105 flex items-center justify-center gap-3 mb-6"
        >
          <Save className="w-5 h-5" />
          Save Changes
        </button>
      </div>

      <FloatingIVR />
      <AppFooter />
    </div>
  );
}
