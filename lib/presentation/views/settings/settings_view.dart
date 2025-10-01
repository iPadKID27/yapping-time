import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../providers/theme_provider.dart';
import '../../bloc/auth/auth_bloc.dart';
import '../../bloc/auth/auth_event.dart';
import 'widgets/settings_tile_widget.dart';

/// Settings page with theme toggle, account options, and logout
class SettingsView extends StatelessWidget {
  const SettingsView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      appBar: AppBar(
        title: const Text("Settings"),
        backgroundColor: Colors.transparent,
        foregroundColor: Colors.grey,
        elevation: 0,
      ),
      body: ListView(
        children: [
          const SizedBox(height: 20),
          
          // ============================================
          // THEME SETTINGS - Dark Mode Toggle
          // ============================================
          SettingsTileWidget(
            title: 'Dark Mode',
            icon: Icons.dark_mode,
            trailing: Consumer<ThemeProvider>(
              builder: (context, themeProvider, child) {
                return CupertinoSwitch(
                  value: themeProvider.isDarkMode,
                  onChanged: (value) {
                    themeProvider.toggleTheme();
                  },
                );
              },
            ),
          ),

          const SizedBox(height: 10),

          // ============================================
          // ACCOUNT SETTINGS
          // ============================================
          SettingsTileWidget(
            title: 'Account',
            icon: Icons.account_circle,
            onTap: () {
              // Navigate to account settings page
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Account settings coming soon')),
              );
            },
          ),

          const SizedBox(height: 10),

          // ============================================
          // NOTIFICATIONS SETTINGS
          // ============================================
          SettingsTileWidget(
            title: 'Notifications',
            icon: Icons.notifications,
            onTap: () {
              // Navigate to notification settings page
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Notification settings coming soon')),
              );
            },
          ),

          const SizedBox(height: 10),

          // ============================================
          // PRIVACY SETTINGS
          // ============================================
          SettingsTileWidget(
            title: 'Privacy',
            icon: Icons.privacy_tip,
            onTap: () {
              // Navigate to privacy settings page
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Privacy settings coming soon')),
              );
            },
          ),

          const SizedBox(height: 10),

          // ============================================
          // HELP & SUPPORT
          // ============================================
          SettingsTileWidget(
            title: 'Help & Support',
            icon: Icons.help,
            onTap: () {
              // Navigate to help page
              _showHelpDialog(context);
            },
          ),

          const SizedBox(height: 10),

          // ============================================
          // ABOUT APP
          // ============================================
          SettingsTileWidget(
            title: 'About',
            icon: Icons.info,
            onTap: () {
              showAboutDialog(
                context: context,
                applicationName: 'YappingTime',
                applicationVersion: '1.0.0',
                applicationIcon: const Icon(
                  Icons.message,
                  size: 48,
                  color: Colors.green,
                ),
                children: [
                  const SizedBox(height: 10),
                  const Text(
                    'A modern chat application built with Flutter, Firebase, and clean architecture.',
                    textAlign: TextAlign.center,
                  ),
                ],
              );
            },
          ),

          const SizedBox(height: 30),

          // ============================================
          // LOGOUT BUTTON
          // ============================================
          SettingsTileWidget(
            title: 'Logout',
            icon: Icons.logout,
            iconColor: Colors.red,
            titleColor: Colors.red,
            trailing: const SizedBox.shrink(), // No arrow for logout
            onTap: () {
              _showLogoutConfirmation(context);
            },
          ),
          
          const SizedBox(height: 20),
        ],
      ),
    );
  }

  /// Show help dialog with support information
  void _showHelpDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Row(
          children: [
            Icon(Icons.help, color: Colors.blue),
            SizedBox(width: 10),
            Text('Help & Support'),
          ],
        ),
        content: const Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Need help? Contact us:',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10),
            Text('📧 Email: support@yappingtime.com'),
            SizedBox(height: 5),
            Text('🌐 Website: www.yappingtime.com'),
            SizedBox(height: 5),
            Text('📱 Phone: +1 (555) 123-4567'),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }

  /// Show logout confirmation dialog
  void _showLogoutConfirmation(BuildContext context) {
    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Logout'),
        content: const Text('Are you sure you want to logout?'),
        actions: [
          // Cancel button
          TextButton(
            onPressed: () => Navigator.pop(dialogContext),
            child: const Text('Cancel'),
          ),
          // Confirm logout button
          TextButton(
            onPressed: () {
              Navigator.pop(dialogContext);
              // Trigger logout event in AuthBloc
              context.read<AuthBloc>().add(AuthSignOutRequested());
            },
            child: const Text(
              'Logout',
              style: TextStyle(color: Colors.red),
            ),
          ),
        ],
      ),
    );
  }
}