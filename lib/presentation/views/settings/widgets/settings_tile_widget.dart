import 'package:flutter/material.dart';

/// A reusable widget for displaying individual settings items
/// Can be used with or without a trailing widget (like a switch)
class SettingsTileWidget extends StatelessWidget {
  final String title;
  final IconData icon;
  final VoidCallback? onTap;
  final Widget? trailing;
  final Color? iconColor;
  final Color? titleColor;

  const SettingsTileWidget({
    super.key,
    required this.title,
    required this.icon,
    this.onTap,
    this.trailing,
    this.iconColor,
    this.titleColor,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 5),
      child: ListTile(
        // Background color from theme
        tileColor: Theme.of(context).colorScheme.secondary,
        
        // Rounded corners
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        
        // Leading icon
        leading: Icon(
          icon,
          color: iconColor ?? Theme.of(context).colorScheme.primary,
        ),
        
        // Title text
        title: Text(
          title,
          style: TextStyle(
            color: titleColor,
            fontWeight: titleColor != null ? FontWeight.bold : FontWeight.normal,
          ),
        ),
        
        // Trailing widget (arrow or custom widget like switch)
        trailing: trailing ??
            Icon(
              Icons.arrow_forward_ios,
              size: 16,
              color: Theme.of(context).colorScheme.primary,
            ),
        
        // On tap callback
        onTap: onTap,
      ),
    );
  }
}