import 'package:flutter/material.dart';

class BibleHomeScreen extends StatelessWidget {
  const BibleHomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Bible')),
      body: ListView(
        children: const [
          ListTile(title: Text('Genèse'), trailing: Icon(Icons.arrow_forward_ios)),
          ListTile(title: Text('Exode'), trailing: Icon(Icons.arrow_forward_ios)),
          ListTile(title: Text('Lévitique'), trailing: Icon(Icons.arrow_forward_ios)),
        ],
      ),
    );
  }
}
