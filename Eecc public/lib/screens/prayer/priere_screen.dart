import 'package:flutter/material.dart';
import '../../theme/eecc_theme.dart';

/// Formulaire de demande de prière pixel-perfect conforme à la maquette 37_priere_formulaire.png
class PriereScreen extends StatefulWidget {
  const PriereScreen({Key? key}) : super(key: key);

  @override
  State<PriereScreen> createState() => _PriereScreenState();
}

class _PriereScreenState extends State<PriereScreen> {
  final TextEditingController _sujetController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();

  // Confidentialité : 'privee' ou 'pastorale' (Maquette 37_priere_formulaire.png)
  String _confidentialite = 'privee';

  // Souhaitez-vous un suivi ?
  bool _souhaiteSuivi = true;
  bool _envoiEnCours = false;

  @override
  void dispose() {
    _sujetController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  void _envoyerDemande() {
    final sujet = _sujetController.text.trim();
    final description = _descriptionController.text.trim();

    if (sujet.isEmpty || description.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Veuillez renseigner le sujet et la description de votre prière.'),
          backgroundColor: Color(0xFFDC2626),
        ),
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
                Icon(Icons.check_circle, color: Color(0xFF16A34A), size: 28),
                SizedBox(width: 10),
                Text('Demande envoyée', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
              ],
            ),
            content: Text(
              _confidentialite == 'privee'
                  ? 'Votre requête a été enregistrée en toute confidentialité.'
                  : 'Votre requête a été transmise à l\'équipe pastorale avec toute la discrétion requise.',
              style: const TextStyle(fontSize: 14, color: Color(0xFF334155), height: 1.4),
            ),
            actions: [
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF1E3A5F),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                ),
                onPressed: () {
                  Navigator.pop(context);
                  Navigator.pop(context);
                },
                child: const Text('Fermer', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
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
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Color(0xFF1E293B)),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Demande de prière',
          style: TextStyle(
            color: Color(0xFF1E293B),
            fontWeight: FontWeight.bold,
            fontSize: 18,
          ),
        ),
        centerTitle: false,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Champ Sujet
            const Text(
              'Sujet',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.bold,
                color: Color(0xFF0F172A),
              ),
            ),
            const SizedBox(height: 8),
            TextField(
              controller: _sujetController,
              decoration: InputDecoration(
                hintText: 'Guérison, famille, travail...',
                hintStyle: const TextStyle(color: Color(0xFF94A3B8), fontSize: 14),
                contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                filled: true,
                fillColor: Colors.white,
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: const BorderSide(color: Color(0xFFCBD5E1), width: 1.0),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: const BorderSide(color: Color(0xFF1E3A5F), width: 1.5),
                ),
              ),
            ),
            const SizedBox(height: 20),

            // Champ Description
            const Text(
              'Description',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.bold,
                color: Color(0xFF0F172A),
              ),
            ),
            const SizedBox(height: 8),
            TextField(
              controller: _descriptionController,
              maxLines: 5,
              decoration: InputDecoration(
                hintText: 'Partagez votre demande de prière en quelques mots...',
                hintStyle: const TextStyle(color: Color(0xFF94A3B8), fontSize: 14),
                contentPadding: const EdgeInsets.all(14),
                filled: true,
                fillColor: Colors.white,
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: const BorderSide(color: Color(0xFFCBD5E1), width: 1.0),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: const BorderSide(color: Color(0xFF1E3A5F), width: 1.5),
                ),
              ),
            ),
            const SizedBox(height: 24),

            // Section Confidentialité
            const Text(
              'Confidentialité',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.bold,
                color: Color(0xFF0F172A),
              ),
            ),
            const SizedBox(height: 10),

            // Option 1 : Privée
            _buildConfidentialityRadio(
              id: 'privee',
              title: 'Privée',
              subtitle: 'Visible uniquement par vous',
            ),
            const SizedBox(height: 10),

            // Option 2 : À l'équipe pastorale
            _buildConfidentialityRadio(
              id: 'pastorale',
              title: 'À l\'équipe pastorale',
              subtitle: 'Un pasteur autorisé pourra la consulter',
            ),
            const SizedBox(height: 24),

            // Souhaitez-vous un suivi ?
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Souhaitez-vous un suivi ?',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    color: Color(0xFF1E293B),
                  ),
                ),
                Switch(
                  value: _souhaiteSuivi,
                  activeColor: const Color(0xFF1E3A5F),
                  onChanged: (val) => setState(() => _souhaiteSuivi = val),
                ),
              ],
            ),
            const SizedBox(height: 30),
          ],
        ),
      ),
      bottomNavigationBar: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
          child: SizedBox(
            height: 52,
            width: double.infinity,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF1E3A5F),
                foregroundColor: Colors.white,
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              onPressed: _envoiEnCours ? null : _envoyerDemande,
              child: _envoiEnCours
                  ? const SizedBox(
                      width: 22,
                      height: 22,
                      child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2),
                    )
                  : const Text(
                      'Envoyer',
                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildConfidentialityRadio({
    required String id,
    required String title,
    required String subtitle,
  }) {
    final bool isSelected = _confidentialite == id;

    return InkWell(
      onTap: () => setState(() => _confidentialite = id),
      borderRadius: BorderRadius.circular(10),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(
            color: isSelected ? const Color(0xFF1E3A5F) : const Color(0xFFE2E8F0),
            width: isSelected ? 1.8 : 1.0,
          ),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 2),
              child: Container(
                width: 20,
                height: 20,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: isSelected ? const Color(0xFF1E3A5F) : const Color(0xFF94A3B8),
                    width: isSelected ? 6.0 : 1.5,
                  ),
                ),
              ),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: isSelected ? FontWeight.bold : FontWeight.w600,
                      color: const Color(0xFF0F172A),
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    subtitle,
                    style: const TextStyle(
                      fontSize: 12,
                      color: Color(0xFF64748B),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
