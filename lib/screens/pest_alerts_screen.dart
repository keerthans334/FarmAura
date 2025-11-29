import 'package:flutter/material.dart';
import '../models/app_state.dart';
import '../theme/app_theme.dart';
import '../widgets/app_header.dart';
import '../widgets/app_footer.dart';
import '../widgets/floating_ivr.dart';

class PestAlertsScreen extends StatelessWidget {
  const PestAlertsScreen({super.key, required this.appState});
  final AppState appState;

  @override
  Widget build(BuildContext context) {
    final alerts = const [
      {'title': 'Stem Borer risk in nearby fields', 'severity': 'High', 'area': 'Ranchi'},
      {'title': 'Aphid activity expected after rain', 'severity': 'Medium', 'area': 'Dhanbad'},
      {'title': 'Leaf blight cases reported', 'severity': 'Low', 'area': 'Bokaro'},
    ];

    return Scaffold(
      body: SafeArea(
        child: Stack(
          children: [
            Column(
              children: [
                AppHeader(title: 'Pest Alerts', showBack: true, showProfile: false, appState: appState),
                Expanded(
                  child: ListView.builder(
                    padding: const EdgeInsets.fromLTRB(16, 16, 16, 120),
                    itemCount: alerts.length,
                    itemBuilder: (context, index) {
                      final alert = alerts[index];
                      final color = alert['severity'] == 'High'
                          ? Colors.red.shade100
                          : alert['severity'] == 'Medium'
                              ? Colors.orange.shade100
                              : Colors.green.shade100;
                      final textColor = alert['severity'] == 'High'
                          ? Colors.red
                          : alert['severity'] == 'Medium'
                              ? Colors.orange.shade700
                              : Colors.green;
                      return Container(
                        margin: const EdgeInsets.only(bottom: 10),
                        padding: const EdgeInsets.all(14),
                        decoration: BoxDecoration(color: color, borderRadius: BorderRadius.circular(16)),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Icon(Icons.warning_amber_rounded, color: textColor),
                            const SizedBox(width: 10),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(alert['title'] as String, style: TextStyle(color: textColor, fontWeight: FontWeight.w700)),
                                  const SizedBox(height: 4),
                                  Text('Area: ${alert['area']}', style: const TextStyle(color: AppColors.primaryDark)),
                                ],
                              ),
                            ),
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                              decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(12)),
                              child: Text(alert['severity'] as String, style: TextStyle(color: textColor, fontWeight: FontWeight.w700)),
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
          ],
        ),
      ),
    );
  }
}
