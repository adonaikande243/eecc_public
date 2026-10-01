import 'package:flutter/material.dart';
import '../../theme/eecc_theme.dart';

/// Formulaire de demande de prière fidèle à la maquette 37_priere_formulaire.png
class PriereScreen extends StatefulWidget {
  const PriereScreen({Key? key}) : super(key: key);

  @override
  State<PriereScreen> createState() => _PriereScreenState();
}

class _PriereScreenState extends State<PriereScreen> {
  final _titreController = TextEditingController();
  final _descriptionController = TextEditingController();

  String _confidentialite = 'privee'; // 'privee' ou 'intercession'
  bool _suiviPastoral = true;
  bool _envoiEnCours = false;

  @override
  void dispose() {
    _titreController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  void _envoyerDemande() {
    final titre = _titreController.text.trim();
    final description = _descriptionController.text.trim();

    if (titre.isEmpty || description.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Veuillez renseigner le sujet et la description.')),
      );
      return;
    }

    setState(() => _envoiEnCours = true);

    Future.delayed(const Duration(milliseconds: 700), () {
      if (mounted) {
        setState(() => _envoiEnCours = false);
        showDialog(
          context: context,
          builder: (_) => AlertDialog(
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
            title: Row(
              children: const [
                Icon(Icons.check_circle, color: Colors.green, size: 28),
                SizedBox(width: 8),
                Text('Demande transmise', style: TextStyle(fontWeight: FontWeight.bold)),
              ],
            ),
            content: const Text(
              'Votre requête a été confiée aux pasteurs et à l\'équipe d\'intercession avec toute la discrétion requise.',
              style: TextStyle(fontSize: 13.5, color: EeccTheme.navyDark),
            ),
            actions: [
              ElevatedButton(
                style: ElevatedButton.styleFrom(backgroundColor: EeccTheme.navy),
                onPressed: () {
                  Navigator.pop(context);
                  Navigator.pop(context);
                },
                child: const Text('Fermer'),
              ),
            ],
          ),
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: EeccTheme.bgWhite,
      appBar: AppBar(
        title: const Text('Nouvelle demande de prière', style: TextStyle(fontWeight: FontWeight.bold)),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Text(
              'Demande de prière',
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.w800, color: EeccTheme.navyDark),
            ),
            const SizedBox(height: 4),
            const Text(
              'Confiez vos requêtes à l\'équipe pastorale dans la discrétion et la prière.',
              style: TextStyle(fontSize: 13, color: EeccTheme.textMuted),
            ),
            const SizedBox(height: 24),

            // Champ Sujet
            const Text('Titre ou sujet de prière', style: TextStyle(fontSize: 13.5, fontWeight: FontWeight.bold, color: EeccTheme.navyDark)),
            const SizedBox(height: 8),
            TextField(
              controller: _titreController,
              decoration: InputDecoration(
                hintText: 'Ex: Guérison d\'un proche, examen...',
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: const BorderSide(color: EeccTheme.borderGrey)),
                filled: true,
                fillColor: EeccTheme.bgGrey,
              ),
            ),
            const SizedBox(height: 18),

            // Champ Description détaillée
            const Text('Description détaillée', style: TextStyle(fontSize: 13.5, fontWeight: FontWeight.bold, color: EeccTheme.navyDark)),
            const SizedBox(height: 8),
            TextField(
              controller: _descriptionController,
              maxLines: 5,
              decoration: InputDecoration(
                hintText: 'Partagez ce qui vous tient à cœur...',
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: const BorderSide(color: EeccTheme.borderGrey)),
                filled: true,
                fillColor: EeccTheme.bgGrey,
              ),
            ),
            const SizedBox(height: 22),

            // Confidentialité
            const Text('Confidentialité', style: TextStyle(fontSize: 13.5, fontWeight: FontWeight.bold, color: EeccTheme.navyDark)),
            const SizedBox(height: 8),
            Container(
              decoration: BoxDecoration(
                border: Border.all(color: EeccTheme.borderGrey),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Column(
                children: [
                  RadioListTile<String>(
                    value: 'privee',
                    groupValue: _confidentialite,
                    activeColor: EeccTheme.navy,
                    dense: true,
                    title: const Text('Privée (uniquement les pasteurs)', style: TextStyle(fontSize: 13.5, fontWeight: FontWeight.w500)),
                    onChanged: (val) => setState(() => _confidentialite = val!),
                  ),
                  const Divider(height: 1),
                  RadioListTile<String>(
                    value: 'intercession',
                    groupValue: _confidentialite,
                    activeColor: EeccTheme.navy,
                    dense: true,
                    title: const Text('Équipe d\'intercession', style: TextStyle(fontSize: 13.5, fontWeight: FontWeight.w500)),
                    onChanged: (val) => setState(() => _confidentialite = val!),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 18),

            // Suivi pastoral Switch
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
              decoration: BoxDecoration(
                border: Border.all(color: EeccTheme.borderGrey),
                borderRadius: BorderRadius.circular(10),
                color: EeccTheme.bgGrey,
              ),
              child: Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: const [
                        Text('Recevoir un suivi pastoral', style: TextStyle(fontSize: 13.5, fontWeight: FontWeight.bold, color: EeccTheme.navyDark)),
                        SizedBox(height: 2),
                        Text('Un pasteur pourra vous contacter si nécessaire', style: TextStyle(fontSize: 11.5, color: EeccTheme.textMuted)),
                      ],
                    ),
                  ),
                  Switch(
                    value: _suiviPastoral,
                    activeColor: EeccTheme.navy,
                    onChanged: (val) => setState(() => _suiviPastoral = val),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 30),

            // Bouton Soumettre
            ElevatedButton(
              onPressed: _envoiEnCours ? null : _envoyerDemande,
              style: ElevatedButton.styleFrom(
                backgroundColor: EeccTheme.navy,
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
              ),
              child: _envoiEnCours
                  ? const SizedBox(
                      width: 22,
                      height: 22,
                      child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2),
                    )
                  : const Text('Envoyer la demande', style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold)),
            ),
          ],
        ),
      ),
    );
  }
}
