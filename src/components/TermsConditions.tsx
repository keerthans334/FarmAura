import { useNavigate } from 'react-router-dom';
import AppHeader from './AppHeader';
import AppFooter from './AppFooter';
import FloatingIVR from './FloatingIVR';
import { FileText, CheckCircle } from 'lucide-react';

export default function TermsConditions() {
  const navigate = useNavigate();

  return (
    <div className="min-h-screen bg-[#FAFAF5] pb-24 max-w-md mx-auto">
      <AppHeader title="Terms & Conditions" showBack={true} showProfile={false} />
      
      <div className="pt-20 px-4">
        {/* Header Card */}
        <div className="bg-gradient-to-br from-[#43A047] to-[#1B5E20] rounded-3xl p-6 text-white shadow-lg mb-6">
          <div className="text-center">
            <div className="w-16 h-16 bg-white/20 rounded-full flex items-center justify-center mx-auto mb-3">
              <FileText className="w-8 h-8" />
            </div>
            <h2 className="text-xl mb-1">Terms & Conditions</h2>
            <p className="text-sm opacity-90">FarmAura Platform</p>
            <p className="text-xs opacity-75 mt-2">Last Updated: November 22, 2024</p>
          </div>
        </div>

        {/* Content */}
        <div className="bg-white rounded-2xl p-6 shadow-sm mb-6">
          <div className="space-y-6 text-[#1B5E20]">
            {/* Introduction */}
            <div>
              <h3 className="text-lg mb-3 flex items-center gap-2">
                <CheckCircle className="w-5 h-5 text-[#43A047]" />
                1. Acceptance of Terms
              </h3>
              <p className="text-[#757575] text-sm leading-relaxed">
                By accessing and using FarmAura, you accept and agree to be bound by the terms and provision of this agreement. This platform is provided by the Government of Jharkhand for agricultural assistance and guidance.
              </p>
            </div>

            {/* Use of Service */}
            <div>
              <h3 className="text-lg mb-3 flex items-center gap-2">
                <CheckCircle className="w-5 h-5 text-[#43A047]" />
                2. Use of Service
              </h3>
              <p className="text-[#757575] text-sm leading-relaxed mb-2">
                FarmAura provides AI-powered agricultural recommendations and assistance. Users agree to:
              </p>
              <ul className="list-disc list-inside text-[#757575] text-sm space-y-2 ml-4">
                <li>Provide accurate information for better recommendations</li>
                <li>Use the platform for agricultural purposes only</li>
                <li>Not misuse or attempt to manipulate the system</li>
                <li>Respect other users in community features</li>
              </ul>
            </div>

            {/* Data Collection */}
            <div>
              <h3 className="text-lg mb-3 flex items-center gap-2">
                <CheckCircle className="w-5 h-5 text-[#43A047]" />
                3. Data Collection & Privacy
              </h3>
              <p className="text-[#757575] text-sm leading-relaxed">
                We collect location, farm details, and usage data to provide personalized recommendations. Your data is protected under Government of India's data protection regulations. For more details, please refer to our Privacy Policy.
              </p>
            </div>

            {/* Recommendations Disclaimer */}
            <div>
              <h3 className="text-lg mb-3 flex items-center gap-2">
                <CheckCircle className="w-5 h-5 text-[#43A047]" />
                4. AI Recommendations Disclaimer
              </h3>
              <p className="text-[#757575] text-sm leading-relaxed">
                While our AI provides data-driven crop recommendations, farmers should also consult local agricultural experts and consider their own experience. The Government of Jharkhand is not liable for any losses incurred from following recommendations.
              </p>
            </div>

            {/* User Responsibilities */}
            <div>
              <h3 className="text-lg mb-3 flex items-center gap-2">
                <CheckCircle className="w-5 h-5 text-[#43A047]" />
                5. User Responsibilities
              </h3>
              <p className="text-[#757575] text-sm leading-relaxed mb-2">
                Users are responsible for:
              </p>
              <ul className="list-disc list-inside text-[#757575] text-sm space-y-2 ml-4">
                <li>Maintaining confidentiality of their account</li>
                <li>All activities under their account</li>
                <li>Ensuring device security and internet connectivity</li>
                <li>Reporting any bugs or issues to support</li>
              </ul>
            </div>

            {/* Service Availability */}
            <div>
              <h3 className="text-lg mb-3 flex items-center gap-2">
                <CheckCircle className="w-5 h-5 text-[#43A047]" />
                6. Service Availability
              </h3>
              <p className="text-[#757575] text-sm leading-relaxed">
                We strive to keep FarmAura available 24/7, but we do not guarantee uninterrupted service. Maintenance, updates, or technical issues may cause temporary unavailability.
              </p>
            </div>

            {/* Intellectual Property */}
            <div>
              <h3 className="text-lg mb-3 flex items-center gap-2">
                <CheckCircle className="w-5 h-5 text-[#43A047]" />
                7. Intellectual Property
              </h3>
              <p className="text-[#757575] text-sm leading-relaxed">
                All content, features, and functionality on FarmAura are owned by the Government of Jharkhand and are protected by copyright, trademark, and other intellectual property laws.
              </p>
            </div>

            {/* Modifications */}
            <div>
              <h3 className="text-lg mb-3 flex items-center gap-2">
                <CheckCircle className="w-5 h-5 text-[#43A047]" />
                8. Modifications to Terms
              </h3>
              <p className="text-[#757575] text-sm leading-relaxed">
                The Government of Jharkhand reserves the right to modify these terms at any time. Users will be notified of significant changes. Continued use of the platform constitutes acceptance of modified terms.
              </p>
            </div>

            {/* Contact */}
            <div>
              <h3 className="text-lg mb-3 flex items-center gap-2">
                <CheckCircle className="w-5 h-5 text-[#43A047]" />
                9. Contact Information
              </h3>
              <p className="text-[#757575] text-sm leading-relaxed">
                For questions about these terms, please contact:<br/>
                Department of Agriculture, Government of Jharkhand<br/>
                Email: support@farmaura.jharkhand.gov.in<br/>
                Helpline: 1800-XXX-XXXX
              </p>
            </div>
          </div>
        </div>

        {/* Footer Note */}
        <div className="bg-blue-50 border-2 border-blue-200 rounded-2xl p-4">
          <div className="flex items-start gap-3">
            <div className="text-2xl">ℹ️</div>
            <div className="text-[#757575] text-sm">
              By using FarmAura, you acknowledge that you have read, understood, and agree to be bound by these Terms & Conditions.
            </div>
          </div>
        </div>
      </div>

      <FloatingIVR />
      <AppFooter />
    </div>
  );
}