import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'router/app_router.dart';
import 'theme/app_theme.dart';
import 'models/app_state.dart';

void main() {
  runApp(
    ChangeNotifierProvider(
      create: (_) => AppState(),
      child: const FarmauraApp(),
    ),
  );
}

class FarmauraApp extends StatelessWidget {
  const FarmauraApp({super.key});

  @override
  Widget build(BuildContext context) {
    final appState = Provider.of<AppState>(context, listen: false);
    return MaterialApp.router(
      title: 'Farmaura',
      debugShowCheckedModeBanner: false,
      theme: buildAppTheme(),
      routerConfig: createRouter(appState),
    );
  }
}
