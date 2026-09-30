import 'package:flutter/material.dart';
import '../../core/models/cloud_file.dart';

class ProviderBadge extends StatelessWidget {
  final CloudProvider provider;

  const ProviderBadge({super.key, required this.provider});

  @override
  Widget build(BuildContext context) {
    Color bgColor;
    String label;

    switch (provider) {
      case CloudProvider.googleDriveServiceAccount:
        bgColor = Colors.blue.shade700;
        label = 'G-Drive (SA)';
        break;
      case CloudProvider.googleDriveOAuth:
        bgColor = Colors.blue.shade500;
        label = 'G-Drive (OAuth)';
        break;
      case CloudProvider.oneDrive1:
        bgColor = Colors.blueAccent.shade700;
        label = 'OneDrive 1';
        break;
      case CloudProvider.oneDrive2:
        bgColor = Colors.indigo;
        label = 'OneDrive 2';
        break;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(
        label,
        style: const TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.bold),
      ),
    );
  }
}
