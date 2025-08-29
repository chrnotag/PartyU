import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:provider/provider.dart';
import 'package:partyu/providers/app_provider.dart';
import 'package:partyu/utils/app_theme.dart';
import 'package:partyu/widgets/settings_sections.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.backgroundGray,
      appBar: AppBar(
        title: const Text('Configurações'),
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          onPressed: () {
            context.read<AppProvider>().navigateBack();
          },
          icon: const Icon(LucideIcons.arrowLeft),
        ),
      ),
      body: const SingleChildScrollView(
        padding: EdgeInsets.all(16),
        child: Column(
          children: [
            // Profile Section
            ProfileSection(),
            SizedBox(height: 16),

            // Account Settings
            AccountSettingsSection(),
            SizedBox(height: 16),

            // App Settings
            AppSettingsSection(),
            SizedBox(height: 16),

            // Support
            SupportSection(),
            SizedBox(height: 16),

            // Logout
            LogoutSection(),
          ],
        ),
      ),
    );
  }
}