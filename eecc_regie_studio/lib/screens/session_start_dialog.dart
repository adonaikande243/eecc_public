import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../core/services/regie_orchestrator_service.dart';

class SessionStartDialog extends StatefulWidget {
  const SessionStartDialog({Key? key}) : super(key: key);

  @override
  State<SessionStartDialog> createState() => _SessionStartDialogState();
}

class _SessionStartDialogState extends State<SessionStartDialog> {
  final _titreCtrl = TextEditingController();
  final _prediCtrl = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Lancer un Culte'),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: _titreCtrl,
              decoration: const InputDecoration(labelText: 'Titre du culte'),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _prediCtrl,
              decoration: const InputDecoration(labelText: 'Prédicateur'),
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Annuler'),
        ),
        ElevatedButton(
          onPressed: () {
            context.read<RegieOrchestratorService>().demarrerCulte(
              titre: _titreCtrl.text.isNotEmpty ? _titreCtrl.text : 'Culte du dimanche',
              predicateur: _prediCtrl.text,
            );
            Navigator.pop(context);
          },
          child: const Text('Démarrer le Direct'),
        ),
      ],
    );
  }
}
