import 'package:flutter/material.dart';

class JpcEcodimScreen extends StatelessWidget {
  const JpcEcodimScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('JPC & Ecodim'),
          bottom: const TabBar(
            tabs: [
              Tab(text: 'Jeunesse Pour Christ (JPC)'),
              Tab(text: 'École du Dimanche (Ecodim)'),
            ],
          ),
        ),
        body: const TabBarView(
          children: [
            Center(child: Text('Activités et événements JPC')),
            Center(child: Text('Leçons et supports Ecodim')),
          ],
        ),
      ),
    );
  }
}
