import 'package:flutter/material.dart';
import '../models/app_state.dart';
import '../theme/app_theme.dart';
import '../widgets/app_header.dart';
import '../widgets/app_footer.dart';
import '../widgets/floating_ivr.dart';

class FarmerVideosScreen extends StatelessWidget {
  const FarmerVideosScreen({super.key, required this.appState});
  final AppState appState;

  @override
  Widget build(BuildContext context) {
    final videos = const [
      {'title': 'Organic Pest Control Guide', 'duration': '08:32', 'thumb': 'https://images.unsplash.com/photo-1441974231531-c6227db76b6e?w=400'},
      {'title': 'Drip Irrigation Setup', 'duration': '06:45', 'thumb': 'https://images.unsplash.com/photo-1489515217757-5fd1be406fef?w=400'},
      {'title': 'Soil Health Card Explained', 'duration': '05:10', 'thumb': 'https://images.unsplash.com/photo-1506807803488-8eafc15323c1?w=400'},
    ];

    return Scaffold(
      body: SafeArea(
        child: Stack(
          children: [
            Column(
              children: [
                AppHeader(title: 'Videos', showBack: true, showProfile: false, appState: appState),
                Expanded(
                  child: ListView.builder(
                    padding: const EdgeInsets.fromLTRB(16, 16, 16, 120),
                    itemCount: videos.length,
                    itemBuilder: (context, index) {
                      final video = videos[index];
                      return Container(
                        margin: const EdgeInsets.only(bottom: 12),
                        decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(16), boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10, offset: const Offset(0, 8))]),
                        child: Row(
                          children: [
                            ClipRRect(
                              borderRadius: const BorderRadius.only(topLeft: Radius.circular(16), bottomLeft: Radius.circular(16)),
                              child: Image.network(video['thumb']!, width: 120, height: 90, fit: BoxFit.cover),
                            ),
                            const SizedBox(width: 10),
                            Expanded(
                              child: Padding(
                                padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 6),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(video['title']!, style: const TextStyle(color: AppColors.primaryDark, fontWeight: FontWeight.w700)),
                                    const SizedBox(height: 6),
                                    Row(
                                      children: [
                                        const Icon(Icons.play_circle_outline, color: AppColors.muted, size: 16),
                                        const SizedBox(width: 4),
                                        Text(video['duration']!, style: const TextStyle(color: AppColors.muted, fontSize: 12)),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
            const Positioned(bottom: 0, left: 0, right: 0, child: AppFooter()),
            const FloatingIVR(),
          ],
        ),
      ),
    );
  }
}
