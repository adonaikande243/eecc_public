import 'package:flutter/material.dart';

enum OverlayPosition {
  hautGauche,
  hautDroit,
  basGauche,
  basDroit,
  bandeauDefilant, // Bandeau d'actualité continu en bas
  pleinEcranCentre,
}

class OverlayConfigDialog extends StatefulWidget {
  final OverlayPosition positionInitiale;
  final String titreInitial;
  final String sousTitreInitial;
  final String? permanentImageUrl;
  final bool permanentImageActive;
  final bool modeDefilant;
  final Function({
    required OverlayPosition position,
    required String titre,
    required String sousTitre,
    required String? imageUrl,
    required bool imageActive,
    required bool modeDefilant,
  }) onSave;

  const OverlayConfigDialog({
    Key? key,
    required this.positionInitiale,
    required this.titreInitial,
    required this.sousTitreInitial,
    this.permanentImageUrl,
    required this.permanentImageActive,
    required this.modeDefilant,
    required this.onSave,
  }) : super(key: key);

  @override
  State<OverlayConfigDialog> createState() => _OverlayConfigDialogState();
}

class _OverlayConfigDialogState extends State<OverlayConfigDialog> {
  late OverlayPosition _selectedPosition;
  late TextEditingController _titreCtrl;
  late TextEditingController _sousTitreCtrl;
  late TextEditingController _imageCtrl;
  late bool _imageActive;
  late bool _modeDefilant;

  @override
  void initState() {
    super.initState();
    _selectedPosition = widget.positionInitiale;
    _titreCtrl = TextEditingController(text: widget.titreInitial);
    _sousTitreCtrl = TextEditingController(text: widget.sousTitreInitial);
    _imageCtrl = TextEditingController(text: widget.permanentImageUrl ?? '');
    _imageActive = widget.permanentImageActive;
    _modeDefilant = widget.modeDefilant;
  }

  @override
  void dispose() {
    _titreCtrl.dispose();
    _sousTitreCtrl.dispose();
    _imageCtrl.dispose();
    super.dispose();
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
        width: 760,
        padding: const EdgeInsets.all(22),
        child: SingleChildScrollView(
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
                      Icon(Icons.dashboard_customize, color: Color(0xFF38BDF8), size: 24),
                      SizedBox(width: 10),
                      Text(
                        'POSITIONNEMENT DES TEXTES, VERSETS & IMAGE PERMANENTE',
                        style: TextStyle(color: Colors.white, fontWeight: FontWeight.w900, fontSize: 13, letterSpacing: 0.8),
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

              // 1. POSITION DU TEXTE / VERSET
              const Text('1. EMPLACEMENT SUR L\'ÉCRAN', style: TextStyle(color: Colors.white70, fontSize: 11.5, fontWeight: FontWeight.bold)),
              const SizedBox(height: 10),

              // Matrice des 4 coins + bandeau défilant
              Row(
                children: [
                  Expanded(
                    child: _buildPositionTile(
                      label: 'Coin Haut-Gauche',
                      pos: OverlayPosition.hautGauche,
                      icon: Icons.north_west,
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: _buildPositionTile(
                      label: 'Coin Haut-Droit',
                      pos: OverlayPosition.hautDroit,
                      icon: Icons.north_east,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              Row(
                children: [
                  Expanded(
                    child: _buildPositionTile(
                      label: 'Coin Bas-Gauche',
                      pos: OverlayPosition.basGauche,
                      icon: Icons.south_west,
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: _buildPositionTile(
                      label: 'Coin Bas-Droit',
                      pos: OverlayPosition.basDroit,
                      icon: Icons.south_east,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              _buildPositionTile(
                label: 'BANDEAU INFÉRIEUR DÉFILANT (NEWS TICKER / VERSET CONTINU)',
                pos: OverlayPosition.bandeauDefilant,
                icon: Icons.linear_scale,
              ),

              const SizedBox(height: 18),
              const Divider(color: Colors.white12),

              // 2. TEXTE & VERSET
              const Text('2. CONTENU DU TEXTE / VERSET', style: TextStyle(color: Colors.white70, fontSize: 11.5, fontWeight: FontWeight.bold)),
              const SizedBox(height: 8),

              TextField(
                controller: _titreCtrl,
                style: const TextStyle(color: Colors.white, fontSize: 13),
                decoration: InputDecoration(
                  labelText: 'Texte principal / Titre / Référence',
                  labelStyle: const TextStyle(color: Colors.white70, fontSize: 12),
                  filled: true,
                  fillColor: const Color(0xFF020617),
                  contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(6), borderSide: const BorderSide(color: Colors.white12)),
                ),
              ),
              const SizedBox(height: 10),

              TextField(
                controller: _sousTitreCtrl,
                maxLines: 2,
                style: const TextStyle(color: Colors.white, fontSize: 13),
                decoration: InputDecoration(
                  labelText: 'Détails / Prédicateur / Corps du verset biblique',
                  labelStyle: const TextStyle(color: Colors.white70, fontSize: 12),
                  filled: true,
                  fillColor: const Color(0xFF020617),
                  contentPadding: const EdgeInsets.all(12),
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(6), borderSide: const BorderSide(color: Colors.white12)),
                ),
              ),

              const SizedBox(height: 18),
              const Divider(color: Colors.white12),

              // 3. IMAGE / FILIGRANE PERMANENT TOUT AU LONG DU LIVE
              const Text('3. IMAGE PERMANENTE EN CONTINU (LOGO / FILIGRANE LIVE)', style: TextStyle(color: Colors.white70, fontSize: 11.5, fontWeight: FontWeight.bold)),
              const SizedBox(height: 8),

              SwitchListTile(
                title: const Text('Activer l\'image permanente tout au long du live', style: TextStyle(color: Colors.white, fontSize: 12.5)),
                subtitle: const Text('Reste affichée sans interruption sur toutes les scènes et caméras', style: TextStyle(color: Colors.white54, fontSize: 11)),
                value: _imageActive,
                activeColor: const Color(0xFF059669),
                contentPadding: EdgeInsets.zero,
                onChanged: (val) => setState(() => _imageActive = val),
              ),
              const SizedBox(height: 6),

              TextField(
                controller: _imageCtrl,
                style: const TextStyle(color: Colors.white, fontSize: 13),
                decoration: InputDecoration(
                  labelText: 'URL ou chemin de l\'image (PNG transparent recommandé)',
                  hintText: 'https://... (Ex: Logo officiel EECC ou filigrane thème de l\'année)',
                  hintStyle: const TextStyle(color: Colors.white30, fontSize: 12),
                  labelStyle: const TextStyle(color: Colors.white70, fontSize: 12),
                  filled: true,
                  fillColor: const Color(0xFF020617),
                  contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(6), borderSide: const BorderSide(color: Colors.white12)),
                ),
              ),

              const SizedBox(height: 24),

              // Bouton Enregistrer
              ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF059669),
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
                ),
                icon: const Icon(Icons.check_circle_outline, size: 20),
                label: const Text('APPLIQUER LA CONFIGURATION EN DIRECT', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
                onPressed: () {
                  widget.onSave(
                    position: _selectedPosition,
                    titre: _titreCtrl.text.trim(),
                    sousTitre: _sousTitreCtrl.text.trim(),
                    imageUrl: _imageCtrl.text.trim().isEmpty ? null : _imageCtrl.text.trim(),
                    imageActive: _imageActive,
                    modeDefilant: _selectedPosition == OverlayPosition.bandeauDefilant,
                  );
                  Navigator.pop(context);
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPositionTile({
    required String label,
    required OverlayPosition pos,
    required IconData icon,
  }) {
    final isSel = _selectedPosition == pos;

    return InkWell(
      onTap: () => setState(() => _selectedPosition = pos),
      borderRadius: BorderRadius.circular(8),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
        decoration: BoxDecoration(
          color: isSel ? const Color(0xFF2563EB).withOpacity(0.25) : const Color(0xFF020617),
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: isSel ? const Color(0xFF38BDF8) : Colors.white10,
            width: isSel ? 2.0 : 1.0,
          ),
        ),
        child: Row(
          children: [
            Icon(icon, color: isSel ? const Color(0xFF38BDF8) : Colors.white54, size: 20),
            const SizedBox(width: 8),
            Expanded(
              child: Text(
                label,
                style: TextStyle(
                  color: isSel ? Colors.white : Colors.white70,
                  fontSize: 11.5,
                  fontWeight: isSel ? FontWeight.bold : FontWeight.w500,
                ),
              ),
            ),
            if (isSel) const Icon(Icons.check_circle, color: Color(0xFF38BDF8), size: 16),
          ],
        ),
      ),
    );
  }
}
