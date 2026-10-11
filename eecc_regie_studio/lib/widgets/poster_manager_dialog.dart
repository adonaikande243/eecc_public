import 'package:flutter/material.dart';
import 'package:eecc_cloud_storage/eecc_cloud_storage.dart';

class PosterManagerDialog extends StatefulWidget {
  const PosterManagerDialog({Key? key}) : super(key: key);

  @override
  State<PosterManagerDialog> createState() => _PosterManagerDialogState();
}

class _PosterManagerDialogState extends State<PosterManagerDialog> {
  final _formKey = GlobalKey<FormState>();
  final _titreCtrl = TextEditingController();
  final _sousTitreCtrl = TextEditingController();
  final _imageCtrl = TextEditingController();

  int _dureeMinutes = 15;
  bool _diffuserSurApp = true;
  bool _diffuserSurLive = true;
  bool _isPublishing = false;

  final List<int> _dureesOptions = [5, 10, 15, 30, 60, 120, 240, 1440];

  @override
  void dispose() {
    _titreCtrl.dispose();
    _sousTitreCtrl.dispose();
    _imageCtrl.dispose();
    super.dispose();
  }

  void _posterAffiche() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isPublishing = true);
    final succes = await EeccSupabaseService().posterAffiche(
      titre: _titreCtrl.text.trim(),
      sousTitre: _sousTitreCtrl.text.trim().isEmpty ? null : _sousTitreCtrl.text.trim(),
      imageUrl: _imageCtrl.text.trim().isEmpty ? null : _imageCtrl.text.trim(),
      dureeSecondes: _dureeMinutes * 60,
      actifSurAppPublic: _diffuserSurApp,
      actifSurProjectionLive: _diffuserSurLive,
    );

    if (!mounted) return;
    setState(() => _isPublishing = false);

    if (succes) {
      Navigator.pop(context);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          backgroundColor: const Color(0xFF059669),
          content: Text('Affiche publiée pour $_dureeMinutes minutes sur les supports sélectionnés !'),
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          backgroundColor: Colors.redAccent,
          content: Text('Erreur lors de la publication de l\'affiche.'),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: const Color(0xFF0F172A),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: const BorderSide(color: Color(0xFF1E293B), width: 1.5),
      ),
      child: Container(
        width: 650,
        padding: const EdgeInsets.all(22),
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Header
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: const [
                      Icon(Icons.campaign, color: Color(0xFF38BDF8), size: 24),
                      SizedBox(width: 10),
                      Text(
                        'PROGRAMMER UNE AFFICHE OU ANNONCE',
                        style: TextStyle(color: Colors.white, fontWeight: FontWeight.w900, fontSize: 14, letterSpacing: 0.8),
                      ),
                    ],
                  ),
                  IconButton(
                    icon: const Icon(Icons.close, color: Colors.white70),
                    onPressed: () => Navigator.pop(context),
                  ),
                ],
              ),
              const Divider(color: Colors.white12, height: 20),

              // Titre de l'affiche
              const Text('Titre de l\'affiche *', style: TextStyle(color: Colors.white70, fontSize: 12, fontWeight: FontWeight.bold)),
              const SizedBox(height: 6),
              TextFormField(
                controller: _titreCtrl,
                style: const TextStyle(color: Colors.white, fontSize: 13),
                decoration: InputDecoration(
                  hintText: 'Ex: Grand Séminaire des Couples ce samedi à 15h',
                  hintStyle: const TextStyle(color: Colors.white30, fontSize: 12),
                  filled: true,
                  fillColor: const Color(0xFF020617),
                  contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(6), borderSide: const BorderSide(color: Colors.white12)),
                ),
                validator: (val) => val == null || val.trim().isEmpty ? 'Le titre est requis' : null,
              ),
              const SizedBox(height: 14),

              // Sous-titre ou détails
              const Text('Sous-titre / Description', style: TextStyle(color: Colors.white70, fontSize: 12, fontWeight: FontWeight.bold)),
              const SizedBox(height: 6),
              TextFormField(
                controller: _sousTitreCtrl,
                maxLines: 2,
                style: const TextStyle(color: Colors.white, fontSize: 13),
                decoration: InputDecoration(
                  hintText: 'Ex: Orateur : Pasteur Jean Mukendi. Entrée libre.',
                  hintStyle: const TextStyle(color: Colors.white30, fontSize: 12),
                  filled: true,
                  fillColor: const Color(0xFF020617),
                  contentPadding: const EdgeInsets.all(12),
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(6), borderSide: const BorderSide(color: Colors.white12)),
                ),
              ),
              const SizedBox(height: 14),

              // URL Image (Optionnel)
              const Text('URL de l\'image (Optionnel)', style: TextStyle(color: Colors.white70, fontSize: 12, fontWeight: FontWeight.bold)),
              const SizedBox(height: 6),
              TextFormField(
                controller: _imageCtrl,
                style: const TextStyle(color: Colors.white, fontSize: 13),
                decoration: InputDecoration(
                  hintText: 'https://... (Lien direct vers le visuel)',
                  hintStyle: const TextStyle(color: Colors.white30, fontSize: 12),
                  filled: true,
                  fillColor: const Color(0xFF020617),
                  contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(6), borderSide: const BorderSide(color: Colors.white12)),
                ),
              ),
              const SizedBox(height: 16),

              // Sélecteur de temps de diffusion
              const Text('DURÉE DE DIFFUSION DE L\'AFFICHE', style: TextStyle(color: Colors.white70, fontSize: 12, fontWeight: FontWeight.bold)),
              const SizedBox(height: 8),
              Wrap(
                spacing: 8,
                runSpacing: 6,
                children: _dureesOptions.map((m) {
                  final isSel = _dureeMinutes == m;
                  String label = '$m min';
                  if (m >= 60) label = '${m ~/ 60} heure${m >= 120 ? "s" : ""}';
                  if (m == 1440) label = '24 heures';

                  return ChoiceChip(
                    label: Text(label, style: TextStyle(fontSize: 11, color: isSel ? Colors.white : Colors.white70, fontWeight: isSel ? FontWeight.bold : FontWeight.normal)),
                    selected: isSel,
                    selectedColor: const Color(0xFF2563EB),
                    backgroundColor: const Color(0xFF020617),
                    onSelected: (val) {
                      if (val) setState(() => _dureeMinutes = m);
                    },
                  );
                }).toList(),
              ),
              const SizedBox(height: 16),

              // Options de diffusion
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(color: const Color(0xFF020617), borderRadius: BorderRadius.circular(8)),
                child: Column(
                  children: [
                    CheckboxListTile(
                      title: const Text('Afficher sur l\'Application Public des fidèles', style: TextStyle(color: Colors.white, fontSize: 12.5)),
                      subtitle: const Text('Bannière active en tête d\'accueil pendant la durée choisie', style: TextStyle(color: Colors.white54, fontSize: 11)),
                      value: _diffuserSurApp,
                      activeColor: const Color(0xFF059669),
                      contentPadding: EdgeInsets.zero,
                      onChanged: (v) => setState(() => _diffuserSurApp = v ?? true),
                    ),
                    const Divider(color: Colors.white10),
                    CheckboxListTile(
                      title: const Text('Projeter dans le Live Studio & Régie', style: TextStyle(color: Colors.white, fontSize: 12.5)),
                      subtitle: const Text('Bandeau incrusté dans la diffusion en direct et l\'écran géant', style: TextStyle(color: Colors.white54, fontSize: 11)),
                      value: _diffuserSurLive,
                      activeColor: const Color(0xFF059669),
                      contentPadding: EdgeInsets.zero,
                      onChanged: (v) => setState(() => _diffuserSurLive = v ?? true),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),

              // Bouton Poster
              ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF059669),
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
                ),
                icon: _isPublishing
                    ? const SizedBox(width: 18, height: 18, child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white))
                    : const Icon(Icons.send, size: 18),
                label: Text(
                  _isPublishing ? 'PUBLICATION EN COURS...' : 'POSTER L\'AFFICHE MAINTENANT',
                  style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13, letterSpacing: 0.8),
                ),
                onPressed: _isPublishing ? null : _posterAffiche,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
