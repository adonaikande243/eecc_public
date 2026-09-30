import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/services/storage_orchestrator.dart';
import '../../core/utils/file_utils.dart';

class MicrosoftAuthScreen extends StatefulWidget {
  const MicrosoftAuthScreen({super.key});

  @override
  State<MicrosoftAuthScreen> createState() => _MicrosoftAuthScreenState();
}

class _MicrosoftAuthScreenState extends State<MicrosoftAuthScreen> {
  bool _isAuth1 = false;
  bool _isAuth2 = false;
  int? _space1;
  int? _space2;

  @override
  void initState() {
    super.initState();
    _checkStatus();
  }

  Future<void> _checkStatus() async {
    final orchestrator = Provider.of<StorageOrchestrator>(context, listen: false);
    
    final auth1 = await orchestrator.oneDrive1.isAuthenticated();
    int? s1 = auth1 ? await orchestrator.oneDrive1.getAvailableSpace() : null;

    final auth2 = await orchestrator.oneDrive2.isAuthenticated();
    int? s2 = auth2 ? await orchestrator.oneDrive2.getAvailableSpace() : null;

    setState(() {
      _isAuth1 = auth1;
      _space1 = s1;
      _isAuth2 = auth2;
      _space2 = s2;
    });
  }

  Widget _buildAccountCard(String title, bool isAuth, int? space, VoidCallback onLogin) {
    return Card(
      margin: const EdgeInsets.all(16),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Text(title, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 16),
            isAuth
                ? Column(
                    children: [
                      const Icon(Icons.check_circle, color: Colors.green, size: 48),
                      const SizedBox(height: 8),
                      Text('Connecté\nEspace dispo: ${space != null ? FileUtils.formatFileSize(space) : "Inconnu"}', textAlign: TextAlign.center),
                    ],
                  )
                : ElevatedButton(
                    onPressed: onLogin,
                    child: const Text('Se connecter avec Microsoft'),
                  )
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Microsoft OneDrive Auth')),
      body: ListView(
        children: [
          _buildAccountCard('Compte OneDrive 1', _isAuth1, _space1, () {
            // Implémenter le flux MSAL login ici et appeler saveToken sur le service
            ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('MSAL Auth à implémenter')));
          }),
          _buildAccountCard('Compte OneDrive 2', _isAuth2, _space2, () {
            // Implémenter le flux MSAL login ici et appeler saveToken sur le service
            ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('MSAL Auth à implémenter')));
          }),
        ],
      ),
    );
  }
}
