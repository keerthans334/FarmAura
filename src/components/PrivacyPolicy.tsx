import { useNavigate } from 'react-router-dom';
import AppHeader from './AppHeader';
import AppFooter from './AppFooter';
import FloatingIVR from './FloatingIVR';
import { Shield, Lock } from 'lucide-react';

export default function PrivacyPolicy() {
  const navigate = useNavigate();

  return (
    <div className="min-h-screen bg-[#FAFAF5] pb-24 max-w-md mx-auto">
      <AppHeader title="Privacy Policy" showBack={true} showProfile={false} />
      
      <div className="pt-20 px-4">
        {/* Header Card */}
        <div className="bg-gradient-to-br from-[#43A047] to-[#1B5E20] rounded-3xl p-6 text-white shadow-lg mb-6">
          <div className="text-center">
            <div className="w-16 h-16 bg-white/20 rounded-full flex items-center justify-center mx-auto mb-3">
              <Shield className="w-8 h-8" />
            </div>
            <h2 className="text-xl mb-1">Privacy Policy</h2>
            <p className="text-sm opacity-90">Your Data Protection</p>
            <p className="text-xs opacity-75 mt-2">Last Updated: November 22, 2024</p>
          </div>
        </div>

        {/* Content */}
        <div className="bg-white rounded-2xl p-6 shadow-sm mb-6">
          <div className="space-y-6 text-[#1B5E20]">
            {/* Introduction */}
            <div>
              <h3 className="text-lg mb-3 flex items-center gap-2">
                <Lock className="w-5 h-5 text-[#43A047]" />
                Our Commitment
              </h3>
              <p className="text-[#757575] text-sm leading-relaxed">
                The Government of Jharkhand is committed to protecting your privacy. This Privacy Policy explains how we collect, use, disclose, and safeguard your information when you use the FarmAura platform.
              </p>
            </div>

            {/* Information We Collect */}
            <div>
              <h3 className="text-lg mb-3 flex items-center gap-2">
                <Lock className="w-5 h-5 text-[#43A047]" />
                Information We Collect
              </h3>
              <p className="text-[#757575] text-sm leading-relaxed mb-2">
                We collect the following types of information:
              </p>
              <ul className="list-disc list-inside text-[#757575] text-sm space-y-2 ml-4">
                <li><strong>Personal Information:</strong> Name, phone number, email (optional), village, district, and state</li>
                <li><strong>Farm Information:</strong> Land size, irrigation methods, soil type, and crop history</li>
                <li><strong>Location Data:</strong> GPS coordinates for weather and local recommendations</li>
                <li><strong>Usage Data:</strong> App interactions, features used, and recommendation history</li>
                <li><strong>Device Information:</strong> Device type, OS version, and app version</li>
              </ul>
            </div>

            {/* How We Use Information */}
            <div>
              <h3 className="text-lg mb-3 flex items-center gap-2">
                <Lock className="w-5 h-5 text-[#43A047]" />
                How We Use Your Information
              </h3>
              <p className="text-[#757575] text-sm leading-relaxed mb-2">
                Your information is used to:
              </p>
              <ul className="list-disc list-inside text-[#757575] text-sm space-y-2 ml-4">
                <li>Provide personalized crop recommendations</li>
                <li>Show relevant weather and market information</li>
                <li>Improve AI model accuracy and recommendations</li>
                <li>Send important agricultural alerts and notifications</li>
                <li>Provide customer support and assistance</li>
                <li>Analyze usage patterns to improve the platform</li>
              </ul>
            </div>

            {/* Data Protection */}
            <div>
              <h3 className="text-lg mb-3 flex items-center gap-2">
                <Lock className="w-5 h-5 text-[#43A047]" />
                Data Protection & Security
              </h3>
              <p className="text-[#757575] text-sm leading-relaxed">
                We implement industry-standard security measures to protect your data. All data is encrypted during transmission and storage. Access to personal information is restricted to authorized personnel only. We comply with the Information Technology Act, 2000 and related data protection regulations.
              </p>
            </div>

            {/* Data Sharing */}
            <div>
              <h3 className="text-lg mb-3 flex items-center gap-2">
                <Lock className="w-5 h-5 text-[#43A047]" />
                Data Sharing & Disclosure
              </h3>
              <p className="text-[#757575] text-sm leading-relaxed mb-2">
                We do not sell your personal information. We may share data with:
              </p>
              <ul className="list-disc list-inside text-[#757575] text-sm space-y-2 ml-4">
                <li><strong>Government Departments:</strong> For agricultural planning and policy-making (anonymized data)</li>
                <li><strong>Service Providers:</strong> Third-party services that help us operate the platform</li>
                <li><strong>Legal Requirements:</strong> When required by law or to protect rights and safety</li>
              </ul>
            </div>

            {/* User Rights */}
            <div>
              <h3 className="text-lg mb-3 flex items-center gap-2">
                <Lock className="w-5 h-5 text-[#43A047]" />
                Your Rights
              </h3>
              <p className="text-[#757575] text-sm leading-relaxed mb-2">
                You have the right to:
              </p>
              <ul className="list-disc list-inside text-[#757575] text-sm space-y-2 ml-4">
                <li>Access your personal information</li>
                <li>Correct inaccurate or incomplete data</li>
                <li>Request deletion of your account and data</li>
                <li>Opt-out of non-essential communications</li>
                <li>Download your data in a portable format</li>
              </ul>
            </div>

            {/* Data Retention */}
            <div>
              <h3 className="text-lg mb-3 flex items-center gap-2">
                <Lock className="w-5 h-5 text-[#43A047]" />
                Data Retention
              </h3>
              <p className="text-[#757575] text-sm leading-relaxed">
                We retain your personal information for as long as your account is active or as needed to provide services. If you request account deletion, we will delete or anonymize your data within 30 days, except where retention is required by law.
              </p>
            </div>

            {/* Children's Privacy */}
            <div>
              <h3 className="text-lg mb-3 flex items-center gap-2">
                <Lock className="w-5 h-5 text-[#43A047]" />
                Children's Privacy
              </h3>
              <p className="text-[#757575] text-sm leading-relaxed">
                FarmAura is intended for users 18 years and older. We do not knowingly collect information from children under 18. If you believe we have collected such information, please contact us immediately.
              </p>
            </div>

            {/* Changes to Policy */}
            <div>
              <h3 className="text-lg mb-3 flex items-center gap-2">
                <Lock className="w-5 h-5 text-[#43A047]" />
                Changes to This Policy
              </h3>
              <p className="text-[#757575] text-sm leading-relaxed">
                We may update this Privacy Policy periodically. We will notify you of significant changes through the app or via email. Your continued use after such modifications constitutes acceptance of the updated policy.
              </p>
            </div>

            {/* Contact */}
            <div>
              <h3 className="text-lg mb-3 flex items-center gap-2">
                <Lock className="w-5 h-5 text-[#43A047]" />
                Contact Us
              </h3>
              <p className="text-[#757575] text-sm leading-relaxed">
                For privacy-related questions or to exercise your rights:<br/>
                Department of Agriculture, Government of Jharkhand<br/>
                Email: privacy@farmaura.jharkhand.gov.in<br/>
                Helpline: 1800-XXX-XXXX
              </p>
            </div>
          </div>
        </div>

        {/* Footer Note */}
        <div className="bg-green-50 border-2 border-green-200 rounded-2xl p-4">
          <div className="flex items-start gap-3">
            <div className="text-2xl">🔒</div>
            <div className="text-[#757575] text-sm">
              Your trust is important to us. We are committed to protecting your personal information and using it responsibly to serve you better.
            </div>
          </div>
        </div>
      </div>

      <FloatingIVR />
      <AppFooter />
    </div>
  );
}