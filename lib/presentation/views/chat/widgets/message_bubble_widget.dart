import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../../providers/theme_provider.dart';

class MessageBubbleWidget extends StatelessWidget {
  final String message;
  final bool isCurrentUser;
  final Timestamp? timestamp;

  const MessageBubbleWidget({
    super.key,
    required this.message,
    required this.isCurrentUser,
    this.timestamp,
  });

  @override
  Widget build(BuildContext context) {
    bool isDarkMode = Provider.of<ThemeProvider>(context, listen: false).isDarkMode;

    final timeString = timestamp != null
        ? DateTime.fromMillisecondsSinceEpoch(timestamp!.millisecondsSinceEpoch)
            .toLocal()
            .toString()
            .split(' ')[1]
            .substring(0, 5) 
        : '';

    return Container(
      decoration: BoxDecoration(
        color: isCurrentUser
            ? (isDarkMode ? Colors.green.shade600 : Colors.grey.shade500)
            : isDarkMode
                ? Colors.green.shade800
                : Colors.grey.shade200,
        borderRadius: BorderRadius.circular(12),
      ),
      padding: const EdgeInsets.all(16),
      margin: const EdgeInsets.symmetric(vertical: 5, horizontal: 25),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            message,
            style: TextStyle(
              color: isCurrentUser
                  ? Colors.white
                  : isDarkMode
                      ? Colors.white
                      : Colors.black,
            ),
          ),
          if (timeString.isNotEmpty)
            Padding(
              padding: const EdgeInsets.only(top: 4),
              child: Text(
                timeString,
                style: TextStyle(
                  fontSize: 12,
                  color: isCurrentUser
                      ? Colors.white70
                      : isDarkMode
                          ? Colors.white70
                          : Colors.black54,
                ),
              ),
            ),
        ],
      ),
    );
  }
}