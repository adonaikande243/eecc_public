import 'package:flutter/material.dart';
import 'live/live_screen.dart';

/// Redirection propre vers la version officielle LiveScreen
class DirectScreen extends StatelessWidget {
  const DirectScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const LiveScreen();
  }
}
