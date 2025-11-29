import 'package:flutter/material.dart';
import '../models/app_state.dart';
import '../widgets/app_header.dart';

class AboutUsScreen extends StatelessWidget {
  const AboutUsScreen({super.key, required this.appState});
  final AppState appState;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            AppHeader(appState: appState, showBack: true),
            const Expanded(child: Center(child: Text('About Us'))),
          ],
        ),
      ),
    );
  }
}
