import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:provider/provider.dart';
import 'package:partyu/providers/app_provider.dart';
import 'package:partyu/utils/app_theme.dart';

class BottomNavigation extends StatelessWidget {
  const BottomNavigation({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<AppProvider>(
      builder: (context, appProvider, child) {
        return Container(
          decoration: BoxDecoration(
            color: Colors.white,
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.05),
                blurRadius: 10,
                offset: const Offset(0, -2),
              ),
            ],
          ),
          child: SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  _buildTabItem(
                    context,
                    BottomTab.home,
                    LucideIcons.home,
                    'Home',
                    appProvider.activeTab == BottomTab.home,
                    () => appProvider.setActiveTab(BottomTab.home),
                  ),
                  _buildTabItem(
                    context,
                    BottomTab.search,
                    LucideIcons.search,
                    'Buscar',
                    appProvider.activeTab == BottomTab.search,
                    () => appProvider.setActiveTab(BottomTab.search),
                  ),
                  _buildTabItem(
                    context,
                    BottomTab.profile,
                    LucideIcons.user,
                    'Perfil',
                    appProvider.activeTab == BottomTab.profile,
                    () => appProvider.setActiveTab(BottomTab.profile),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildTabItem(
    BuildContext context,
    BottomTab tab,
    IconData icon,
    String label,
    bool isActive,
    VoidCallback onTap,
  ) {
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                gradient: isActive ? AppTheme.primaryGradient : null,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(
                icon,
                color: isActive ? Colors.white : AppTheme.gray400,
                size: 24,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              label,
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: isActive ? AppTheme.primaryPurple : AppTheme.gray500,
                fontWeight: isActive ? FontWeight.w600 : FontWeight.normal,
              ),
            ),
          ],
        ),
      ),
    );
  }
}