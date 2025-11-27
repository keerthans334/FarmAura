import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../models/app_state.dart';
import '../theme/app_theme.dart';
import '../widgets/app_header.dart';
import '../widgets/app_footer.dart';
import '../widgets/floating_ivr.dart';

import 'package:farmaura/l10n/app_localizations.dart';

class CommunityFeedScreen extends StatelessWidget {
  const CommunityFeedScreen({super.key, required this.appState});
  final AppState appState;

  @override
  Widget build(BuildContext context) {
    final posts = const [
      {'name': 'Ravi Kumar', 'village': 'Ranchi', 'text': 'Tried new organic fertilizer and got great results!', 'likes': 48, 'comments': 12},
      {'name': 'Anita Devi', 'village': 'Dumka', 'text': 'What\'s the best crop for sandy soil this season?', 'likes': 30, 'comments': 8},
      {'name': 'Sunil Singh', 'village': 'Bokaro', 'text': 'Sharing my drip irrigation setup for small farms.', 'likes': 52, 'comments': 15},
    ];

    return Scaffold(
      body: SafeArea(
        child: Stack(
          children: [
            Column(
              children: [
                AppHeader(
                  title: AppLocalizations.of(context)!.community,
                  showBack: true,
                  showProfile: false,
                  appState: appState,
                  onBack: () => Navigator.canPop(context) ? context.pop() : context.go('/dashboard'),
                ),
                Expanded(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.fromLTRB(16, 16, 16, 100),
                    child: Column(
                      children: posts
                          .map(
                            (post) => Container(
                              margin: const EdgeInsets.only(bottom: 12),
                              padding: const EdgeInsets.all(14),
                              decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(18), boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 12, offset: const Offset(0, 10))]),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    children: [
                                      CircleAvatar(
                                        backgroundColor: AppColors.primary.withOpacity(0.15),
                                        child: Text((post['name'] as String)[0]),
                                      ),
                                      const SizedBox(width: 10),
                                      Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Text(post['name'] as String, style: const TextStyle(color: AppColors.primaryDark, fontWeight: FontWeight.w700)),
                                          Text(post['village'] as String, style: const TextStyle(color: AppColors.muted, fontSize: 12)),
                                        ],
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 10),
                                  Text(post['text'] as String, style: const TextStyle(color: AppColors.primaryDark)),
                                  const SizedBox(height: 12),
                                  Row(
                                    children: [
                                      Icon(Icons.favorite_border, color: Colors.red.shade400),
                                      const SizedBox(width: 4),
                                      Text('${post['likes']}'),
                                      const SizedBox(width: 16),
                                      const Icon(Icons.mode_comment_outlined, color: AppColors.muted),
                                      const SizedBox(width: 4),
                                      Text('${post['comments']}'),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          )
                          .toList(),
                    ),
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
