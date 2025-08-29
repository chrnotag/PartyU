import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:provider/provider.dart';
import 'package:partyu/providers/auth_provider.dart';
import 'package:partyu/providers/app_provider.dart';
import 'package:partyu/utils/app_theme.dart';
import 'package:partyu/utils/settings_constants.dart';
import 'package:partyu/utils/settings_helpers.dart';

class ProfileSection extends StatelessWidget {
  const ProfileSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<AuthProvider>(
      builder: (context, authProvider, child) {
        final user = authProvider.user;
        if (user == null) return const SizedBox.shrink();

        return Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.05),
                blurRadius: 10,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Row(
            children: [
              // Avatar
              Container(
                width: 60,
                height: 60,
                decoration: BoxDecoration(
                  color: AppTheme.primaryPurple.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Center(
                  child: Text(
                    user.name.isNotEmpty ? user.name[0].toUpperCase() : 'U',
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: AppTheme.primaryPurple,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 16),

              // User Info
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      user.name,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                        color: AppTheme.gray900,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      user.email,
                      style: const TextStyle(
                        color: AppTheme.gray600,
                      ),
                    ),
                    if (user.isDemo) ...[
                      const SizedBox(height: 4),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                        decoration: BoxDecoration(
                          color: AppTheme.primaryPurple.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: const Text(
                          '🎯 Demo',
                          style: TextStyle(
                            color: AppTheme.primaryPurple,
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ],
                  ],
                ),
              ),

              // Edit Button
              IconButton(
                onPressed: () {
                  SettingsHelpers.showEditProfileDialog(context, user.name, user.email);
                },
                icon: const Icon(
                  LucideIcons.edit,
                  color: AppTheme.gray400,
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

class AccountSettingsSection extends StatelessWidget {
  const AccountSettingsSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Padding(
            padding: EdgeInsets.all(20),
            child: Text(
              'Conta',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: AppTheme.gray900,
              ),
            ),
          ),
          ...SettingsConstants.accountItems.map((item) {
            return ListTile(
              leading: Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: AppTheme.gray100,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(
                  item['icon'] as IconData,
                  color: AppTheme.gray600,
                  size: 20,
                ),
              ),
              title: Text(
                item['title'] as String,
                style: const TextStyle(
                  fontWeight: FontWeight.w500,
                  color: AppTheme.gray900,
                ),
              ),
              subtitle: Text(
                item['subtitle'] as String,
                style: const TextStyle(
                  color: AppTheme.gray600,
                  fontSize: 14,
                ),
              ),
              trailing: const Icon(
                LucideIcons.chevronRight,
                color: AppTheme.gray400,
                size: 20,
              ),
              onTap: () {
                switch (item['key']) {
                  case 'edit_profile':
                    SettingsHelpers.showEditProfileDialog(context, '', '');
                    break;
                  case 'change_password':
                    SettingsHelpers.showChangePasswordDialog(context);
                    break;
                  case 'notifications':
                    SettingsHelpers.showNotificationSettings(context);
                    break;
                  case 'privacy':
                    SettingsHelpers.showPrivacySettings(context);
                    break;
                }
              },
            );
          }).toList(),
        ],
      ),
    );
  }
}

class AppSettingsSection extends StatelessWidget {
  const AppSettingsSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Padding(
            padding: EdgeInsets.all(20),
            child: Text(
              'Aplicativo',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: AppTheme.gray900,
              ),
            ),
          ),

          // Dark Mode Toggle
          Consumer<AppProvider>(
            builder: (context, appProvider, child) {
              return ListTile(
                leading: Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: AppTheme.gray100,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(
                    appProvider.isDarkMode ? LucideIcons.moon : LucideIcons.sun,
                    color: AppTheme.gray600,
                    size: 20,
                  ),
                ),
                title: const Text(
                  'Modo Escuro',
                  style: TextStyle(
                    fontWeight: FontWeight.w500,
                    color: AppTheme.gray900,
                  ),
                ),
                subtitle: const Text(
                  'Aparência do aplicativo',
                  style: TextStyle(
                    color: AppTheme.gray600,
                    fontSize: 14,
                  ),
                ),
                trailing: Switch(
                  value: appProvider.isDarkMode,
                  onChanged: (_) {
                    appProvider.toggleDarkMode();
                  },
                  activeColor: AppTheme.primaryPurple,
                ),
              );
            },
          ),

          ListTile(
            leading: Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: AppTheme.gray100,
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Icon(
                LucideIcons.globe,
                color: AppTheme.gray600,
                size: 20,
              ),
            ),
            title: const Text(
              'Idioma',
              style: TextStyle(
                fontWeight: FontWeight.w500,
                color: AppTheme.gray900,
              ),
            ),
            subtitle: const Text(
              'Português (Brasil)',
              style: TextStyle(
                color: AppTheme.gray600,
                fontSize: 14,
              ),
            ),
            trailing: const Icon(
              LucideIcons.chevronRight,
              color: AppTheme.gray400,
              size: 20,
            ),
            onTap: () {
              SettingsHelpers.showLanguageSettings(context);
            },
          ),
        ],
      ),
    );
  }
}

class SupportSection extends StatelessWidget {
  const SupportSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Padding(
            padding: EdgeInsets.all(20),
            child: Text(
              'Suporte',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: AppTheme.gray900,
              ),
            ),
          ),
          ...SettingsConstants.supportItems.map((item) {
            return ListTile(
              leading: Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: AppTheme.gray100,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(
                  item['icon'] as IconData,
                  color: AppTheme.gray600,
                  size: 20,
                ),
              ),
              title: Text(
                item['title'] as String,
                style: const TextStyle(
                  fontWeight: FontWeight.w500,
                  color: AppTheme.gray900,
                ),
              ),
              trailing: const Icon(
                LucideIcons.chevronRight,
                color: AppTheme.gray400,
                size: 20,
              ),
              onTap: () {
                switch (item['key']) {
                  case 'help':
                    SettingsHelpers.showHelp(context);
                    break;
                  case 'contact':
                    SettingsHelpers.showContact(context);
                    break;
                  case 'terms':
                    SettingsHelpers.showTerms(context);
                    break;
                  case 'privacy_policy':
                    SettingsHelpers.showPrivacy(context);
                    break;
                }
              },
            );
          }).toList(),
        ],
      ),
    );
  }
}

class LogoutSection extends StatelessWidget {
  const LogoutSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          ElevatedButton.icon(
            onPressed: () => SettingsHelpers.showLogoutDialog(context),
            icon: const Icon(LucideIcons.logOut),
            label: const Text('Sair da Conta'),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 24),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
          ),
          const SizedBox(height: 12),
          Text(
            'Versão ${SettingsConstants.version}',
            style: const TextStyle(
              color: AppTheme.gray500,
              fontSize: 12,
            ),
          ),
        ],
      ),
    );
  }
}