import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/services/storage_orchestrator.dart';
import '../../core/utils/file_utils.dart';

class GoogleAuthScreen extends StatefulWidget {
  const GoogleAuthScreen({super.key});

  @override
  State<GoogleAuthScreen> createState() => _GoogleAuthScreenState();
}

class _GoogleAuthScreenState extends State<GoogleAuthScreen> {
  bool _isAuthenticated = false;
  int? _availableSpace;

  @override
  void initState() {
    super.initState();
    _checkStatus();
  }

  Future<void> _checkStatus() async {
    final orchestrator = Provider.of<StorageOrchestrator>(context, listen: false);
    final isAuth = await orchestrator.googleOAuth.isAuthenticated();
    int? space;
    if (isAuth) {
      space = await orchestrator.googleOAuth.getAvailableSpace();
    }
    setState(() {
      _isAuthenticated = isAuth;
      _availableSpace = space;
    });
  }

  @override
  Widget build(BuildContext context) {
    final orchestrator = Provider.of<StorageOrchestrator>(context, listen: false);

    return Scaffold(
      appBar: AppBar(title: const Text('Google Drive OAuth')),
      body: Center(
        child: _isAuthenticated
            ? Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.check_circle, color: Colors.green, size: 64),
                  const SizedBox(height: 16),
                  const Text('Connecté à Google Drive', style: TextStyle(fontSize: 18)),
                  if (_availableSpace != null)
                    Text('Espace disponible : ${FileUtils.formatFileSize(_availableSpace!)}'),
                  const SizedBox(height: 32),
                  ElevatedButton(
                    onPressed: () async {
                      await orchestrator.googleOAuth.signOut();
                      _checkStatus();
                    },
                    child: const Text('Se déconnecter'),
                  )
                ],
              )
            : ElevatedButton.icon(
                icon: const Icon(Icons.login),
                label: const Text('Se connecter avec Google'),
                onPressed: () async {
                  await orchestrator.googleOAuth.signIn();
                  _checkStatus();
                },
              ),
      ),
    );
  }
}
