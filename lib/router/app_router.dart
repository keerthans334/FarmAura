import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../models/app_state.dart';
import '../screens/welcome_screen.dart';
import '../screens/phone_login_screen.dart';
import '../screens/otp_verification_screen.dart';
import '../screens/profile_setup_screen.dart';
import '../screens/farm_setup_screen.dart';
import '../screens/dashboard_screen.dart';
import '../widgets/floating_ivr.dart';
import '../screens/soil_details_screen.dart';
import '../screens/weather_details_screen.dart';
import '../screens/crop_recommendation_start_screen.dart';
import '../screens/combined_input_screen.dart';
import '../screens/recommendation_results_screen.dart';
import '../screens/crop_details_screen.dart';
import '../screens/why_this_crop_screen.dart';
import '../screens/market_price_screen.dart';
import '../screens/pest_detection_screen.dart';
import '../screens/camera_interface_screen.dart';
import '../screens/upload_image_screen.dart';
import '../screens/camera_preview_screen.dart';
import '../screens/pest_result_screen.dart';
import '../screens/community_feed_screen.dart';
import '../screens/farmer_videos_screen.dart';
import '../screens/profile_screen.dart';
import '../screens/edit_profile_screen.dart';
import '../screens/settings_screen.dart';
import '../screens/ai_chatbot_screen.dart';
import '../screens/personal_finance_screen.dart';
import '../screens/pest_alerts_screen.dart';
import '../screens/terms_conditions_screen.dart';
import '../screens/privacy_policy_screen.dart';
import '../screens/about_us_screen.dart';
import '../screens/help_support_screen.dart';
import '../screens/farm_details_screen.dart';
import '../screens/search_screen.dart';

GoRouter createRouter(AppState appState) {
  return GoRouter(
    initialLocation: '/',
    routes: [
      ShellRoute(
        builder: (context, state, child) {
          return Stack(
            children: [
              child,
              FloatingIVR(currentRoute: state.fullPath),
            ],
          );
        },
        routes: [
      GoRoute(
        path: '/',
        builder: (context, state) => WelcomeScreen(appState: appState),
      ),
      GoRoute(
        path: '/preview_page_v2.html',
        redirect: (context, state) => '/',
      ),
      GoRoute(
        path: '/login',
        builder: (context, state) => PhoneLoginScreen(appState: appState, isNewUser: state.extra is Map && (state.extra as Map)['isNewUser'] == true),
      ),
      GoRoute(
        path: '/otp',
        builder: (context, state) => OtpVerificationScreen(
          appState: appState,
          phoneNumber: state.extra is Map ? (state.extra as Map)['phoneNumber'] as String? : null,
          isNewUser: state.extra is Map && (state.extra as Map)['isNewUser'] == true,
        ),
      ),
      GoRoute(
        path: '/profile-setup',
        builder: (context, state) => ProfileSetupScreen(appState: appState),
      ),
      GoRoute(
        path: '/farm-setup',
        builder: (context, state) => FarmSetupScreen(appState: appState),
      ),
      GoRoute(
        path: '/dashboard',
        builder: (context, state) => DashboardScreen(appState: appState),
      ),
      GoRoute(
        path: '/soil',
        builder: (context, state) => SoilDetailsScreen(appState: appState),
      ),
      GoRoute(
        path: '/weather',
        builder: (context, state) => WeatherDetailsScreen(appState: appState),
      ),
      GoRoute(
        path: '/crop-rec',
        builder: (context, state) => CropRecommendationStartScreen(appState: appState),
      ),
      GoRoute(
        path: '/crop-input',
        builder: (context, state) => CombinedInputScreen(appState: appState),
      ),
      GoRoute(
        path: '/crop-results',
        builder: (context, state) {
          final recommendations = state.extra as List<dynamic>? ?? [];
          return RecommendationResultsScreen(appState: appState, recommendations: recommendations);
        },
      ),
      GoRoute(
        path: '/crop-details',
        builder: (context, state) => CropDetailsScreen(appState: appState),
      ),
      GoRoute(
        path: '/why-crop',
        builder: (context, state) {
          final extra = state.extra as Map<String, dynamic>? ?? {};
          return WhyThisCropScreen(
            appState: appState,
            cropData: extra['cropData'] ?? {},
            contextData: extra['contextData'] ?? {},
          );
        },
      ),
      GoRoute(
        path: '/market',
        builder: (context, state) => MarketPriceScreen(appState: appState),
      ),
      GoRoute(
        path: '/pest',
        builder: (context, state) => PestDetectionScreen(appState: appState),
      ),
      GoRoute(
        path: '/camera',
        builder: (context, state) => CameraInterfaceScreen(appState: appState),
      ),
      GoRoute(
        path: '/camera-interface',
        builder: (context, state) => CameraInterfaceScreen(appState: appState),
      ),
      GoRoute(
        path: '/upload-image',
        builder: (context, state) => UploadImageScreen(appState: appState),
      ),
      GoRoute(
        path: '/camera-preview',
        builder: (context, state) => CameraPreviewScreen(appState: appState),
      ),
      GoRoute(
        path: '/pest-result',
        builder: (context, state) => PestResultScreen(appState: appState),
      ),
      GoRoute(
        path: '/community',
        builder: (context, state) => CommunityFeedScreen(appState: appState),
      ),
      GoRoute(
        path: '/videos',
        builder: (context, state) => FarmerVideosScreen(appState: appState),
      ),
      GoRoute(
        path: '/profile',
        builder: (context, state) => ProfileScreen(appState: appState),
      ),
      GoRoute(
        path: '/profile-edit',
        builder: (context, state) => EditProfileScreen(appState: appState),
      ),
      GoRoute(
        path: '/farm-details',
        builder: (context, state) => FarmDetailsScreen(appState: appState),
      ),
      GoRoute(
        path: '/settings',
        builder: (context, state) => SettingsScreen(appState: appState),
      ),
      GoRoute(
        path: '/ai-chat',
        builder: (context, state) => AiChatbotScreen(appState: appState),
      ),
      GoRoute(
        path: '/finance',
        builder: (context, state) => PersonalFinanceScreen(appState: appState),
      ),
      GoRoute(
        path: '/pest-alerts',
        builder: (context, state) => PestAlertsScreen(appState: appState),
      ),
      GoRoute(
        path: '/terms-conditions',
        builder: (context, state) => TermsConditionsScreen(appState: appState),
      ),
      GoRoute(
        path: '/privacy-policy',
        builder: (context, state) => PrivacyPolicyScreen(appState: appState),
      ),
      GoRoute(
        path: '/about-us',
        builder: (context, state) => AboutUsScreen(appState: appState),
      ),
      GoRoute(
        path: '/help-support',
        builder: (context, state) => HelpSupportScreen(appState: appState),
      ),
      GoRoute(
        path: '/search',
        builder: (context, state) {
          final extra = state.extra as Map<String, dynamic>?;
          return SearchScreen(initialQuery: extra?['query']);
        },
      ),
        ],
      ),
    ],
    errorBuilder: (context, state) => WelcomeScreen(appState: appState),
  );
}
