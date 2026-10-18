/// Main application widget.

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:citrus/app/theme.dart';
import 'package:citrus/features/dashboard/dashboard_screen.dart';
import 'package:citrus/services/job_queue_service.dart';
import 'package:citrus/features/settings/settings_provider.dart';

class CitrusApp extends StatelessWidget {
  const CitrusApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => SettingsProvider()..load()),
        Provider.value(value: jobQueueService),
      ],
      child: Consumer<SettingsProvider>(
        builder: (context, settings, _) {
          return MaterialApp(
            title: 'Citrus',
            debugShowCheckedModeBanner: false,
            theme: lightTheme,
            darkTheme: darkTheme,
            themeMode: settings.themeMode,
            home: const DashboardScreen(),
            routes: {
              '/settings': (context) => const SettingsScreen(),
              '/history': (context) => const HistoryScreen(),
            },
          );
        },
      ),
    );
  }
}

/// Settings screen placeholder.
class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Settings')),
      body: const Center(child: Text('Settings - Coming Soon')),
    );
  }
}

/// History screen placeholder.
class HistoryScreen extends StatelessWidget {
  const HistoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('History')),
      body: const Center(child: Text('History - Coming Soon')),
    );
  }
}
