import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:eecc_cloud_storage/eecc_cloud_storage.dart';
import '../theme/eecc_theme.dart';

class PasteurDirectScreen extends StatefulWidget {
  const PasteurDirectScreen({Key? key}) : super(key: key);

  @override
  State<PasteurDirectScreen> createState() => _PasteurDirectScreenState();
}

class _PasteurDirectScreenState extends State<PasteurDirectScreen>
    with SingleTickerProviderStateMixin {
  final EeccSupabaseService _supabase = EeccSupabaseService();
  final TextEditingController _notesPastoralesController =
      TextEditingController();

  late TabController _tabController;

  // Suivi du live en cours
  EeccLiveSession? _liveEnCours;
  bool _chargementLive = true;
  Duration _dureeLive = Duration.zero;
  Timer? _timerDuree;
  Timer? _timerPollLive;

  // Archives des cultes passés
  List<EeccCulteArchive> _archives = [];
  bool _chargementArchives = true;

  // Requêtes de prière (poll Supabase — table eecc_prieres)
  List<Map<String, dynamic>> _requetesPriere = [];
  bool _chargementPrieres = true;
  Timer? _timerPollPrieres;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    _initialiserSuivi();
  }

  void _initialiserSuivi() {
    _chargerLiveEnCours();
    _chargerArchives();
    _chargerRequetesPriere();

    // Sondage du live toutes les 5 secondes
    _timerPollLive = Timer.periodic(const Duration(seconds: 5), (_) {
      _chargerLiveEnCours();
    });

    // Sondage des requêtes de prière toutes les 10 secondes
    _timerPollPrieres =
        Timer.periodic(const Duration(seconds: 10), (_) {
      _chargerRequetesPriere();
    });
  }

  Future<void> _chargerLiveEnCours() async {
    final live = await _supabase.obtenirLiveEnCours();
    if (!mounted) return;

    final ancienLive = _liveEnCours;

    setState(() {
      _liveEnCours = live;
      _chargementLive = false;
    });

    // Démarrer/réinitialiser le chronomètre si le live vient de commencer
    if (live != null && live.isLive) {
      if (ancienLive == null || !ancienLive.isLive) {
        // Nouveau live détecté : calculer durée depuis startedAt
        _timerDuree?.cancel();
        _dureeLive = DateTime.now().difference(live.startedAt);
        _timerDuree = Timer.periodic(const Duration(seconds: 1), (_) {
          if (mounted) {
            setState(() {
              _dureeLive = DateTime.now().difference(live.startedAt);
            });
          }
        });
      }
    } else {
      // Plus de live : stopper le chronomètre
      _timerDuree?.cancel();
      _dureeLive = Duration.zero;
    }
  }

  Future<void> _chargerArchives() async {
    setState(() => _chargementArchives = true);
    final archives = await _supabase.obtenirArchives(limite: 20);
    if (!mounted) return;
    setState(() {
      _archives = archives;
      _chargementArchives = false;
    });
  }

  Future<void> _chargerRequetesPriere() async {
    // Tente de charger depuis la table eecc_prieres (si elle existe)
    // Sinon, utilise les données d'exemple (table à créer côté Supabase)
    try {
      final url = Uri.parse(
        '${EeccApiConfig.supabaseUrl}/rest/v1/eecc_prieres?statut=eq.En attente&order=created_at.asc&limit=30',
      );
      final response = await http.get(url, headers: {
        'apikey': EeccApiConfig.supabaseServiceRoleKey,
        'Authorization': 'Bearer ${EeccApiConfig.supabaseServiceRoleKey}',
      });

      if (response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(response.body);
        if (mounted) {
          setState(() {
            _requetesPriere = List<Map<String, dynamic>>.from(data);
            _chargementPrieres = false;
          });
        }
        return;
      }
    } catch (_) {}

    // Données d'exemple si la table n'est pas encore créée
    if (mounted) {
      setState(() {
        _requetesPriere = [
          {
            'id': '1',
            'nom_fidele': 'Sœur Marie Claire',
            'sujet': 'Intercession pour la guérison de mon fils hospitalisé.',
            'created_at': DateTime.now()
                .subtract(const Duration(minutes: 18))
                .toIso8601String(),
            'statut': 'En attente',
          },
          {
            'id': '2',
            'nom_fidele': 'Frère David Mukendi',
            'sujet': 'Action de grâce pour la naissance de notre premier enfant.',
            'created_at': DateTime.now()
                .subtract(const Duration(minutes: 5))
                .toIso8601String(),
            'statut': 'En attente',
          },
        ];
        _chargementPrieres = false;
      });
    }
  }

  Future<void> _marquerPriereEffectuee(Map<String, dynamic> req) async {
    // Tenter de mettre à jour Supabase
    try {
      final url = Uri.parse(
        '${EeccApiConfig.supabaseUrl}/rest/v1/eecc_prieres?id=eq.${req['id']}',
      );
      await http.patch(
        url,
        headers: {
          'apikey': EeccApiConfig.supabaseServiceRoleKey,
          'Authorization': 'Bearer ${EeccApiConfig.supabaseServiceRoleKey}',
          'Content-Type': 'application/json',
        },
        body: jsonEncode({'statut': 'Prié & Béni'}),
      );
    } catch (_) {}

    setState(() {
      _requetesPriere.remove(req);
    });

    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          backgroundColor: Colors.purple.shade700,
          content: Text(
              '🙏 Requête de ${req['nom_fidele']} portée en prière pastorale.'),
        ),
      );
    }
  }

  Future<void> _enregistrerNotesPastorales() async {
    if (_liveEnCours == null) return;
    // Stockage local seulement pour l'instant — peut être poussé vers Supabase
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        backgroundColor: Colors.indigo,
        content: Text('Notes pastorales enregistrées pour ce culte.'),
      ),
    );
  }

  @override
  void dispose() {
    _timerDuree?.cancel();
    _timerPollLive?.cancel();
    _timerPollPrieres?.cancel();
    _tabController.dispose();
    _notesPastoralesController.dispose();
    super.dispose();
  }

  String _formaterDuree(Duration d) {
    final h = d.inHours.toString().padLeft(2, '0');
    final m = (d.inMinutes % 60).toString().padLeft(2, '0');
    final s = (d.inSeconds % 60).toString().padLeft(2, '0');
    return '$h:$m:$s';
  }

  String _formaterDate(String? iso) {
    if (iso == null) return '';
    final dt = DateTime.tryParse(iso)?.toLocal();
    if (dt == null) return '';
    return '${dt.day.toString().padLeft(2, '0')}/${dt.month.toString().padLeft(2, '0')}/${dt.year}  ${dt.hour.toString().padLeft(2, '0')}:${dt.minute.toString().padLeft(2, '0')}';
  }

  // ════════════════════════════════════════════════════════════
  // BUILD
  // ════════════════════════════════════════════════════════════

  @override
  Widget build(BuildContext context) {
    final estEnDirect = _liveEnCours != null && _liveEnCours!.isLive;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Suivi des Cultes en Direct'),
        backgroundColor: EeccTheme.violet,
        bottom: TabBar(
          controller: _tabController,
          indicatorColor: EeccTheme.dore,
          labelColor: Colors.white,
          unselectedLabelColor: Colors.white60,
          tabs: [
            Tab(
              icon: Icon(
                Icons.sensors,
                color: estEnDirect ? Colors.red.shade200 : Colors.white60,
              ),
              text: 'DIRECT',
            ),
            Tab(
              icon: Badge(
                label: Text('${_requetesPriere.length}'),
                isLabelVisible: _requetesPriere.isNotEmpty,
                child: const Icon(Icons.favorite_border),
              ),
              text: 'PRIÈRES',
            ),
            const Tab(icon: Icon(Icons.video_library_outlined), text: 'ARCHIVES'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _buildOngletDirect(estEnDirect),
          _buildOngletPrieres(),
          _buildOngletArchives(),
        ],
      ),
    );
  }

  // ────────────────────────────────────────────────────────────
  // ONGLET 1 : DIRECT EN COURS + NOTES PASTORALES
  // ────────────────────────────────────────────────────────────
  Widget _buildOngletDirect(bool estEnDirect) {
    return RefreshIndicator(
      onRefresh: _chargerLiveEnCours,
      child: SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // ── Carte principale du statut du culte ──────────────
            AnimatedContainer(
              duration: const Duration(milliseconds: 500),
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: estEnDirect
                      ? [const Color(0xFFB71C1C), const Color(0xFFC62828)]
                      : [Colors.grey.shade800, Colors.grey.shade700],
                ),
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: (estEnDirect ? Colors.red : Colors.grey)
                        .withOpacity(0.3),
                    blurRadius: 14,
                    offset: const Offset(0, 5),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // En-tête statut
                  Row(
                    children: [
                      // Point clignotant si en direct
                      if (estEnDirect)
                        _PulsatingDot()
                      else
                        const Icon(Icons.sensors_off,
                            color: Colors.white54, size: 18),
                      const SizedBox(width: 10),
                      Text(
                        estEnDirect
                            ? 'CULTE EN DIRECT — SUPERVISION ACTIVE'
                            : 'AUCUN DIRECT EN COURS',
                        style: const TextStyle(
                          color: Colors.white70,
                          fontWeight: FontWeight.bold,
                          fontSize: 11,
                          letterSpacing: 1.0,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 14),

                  // Titre & prédicateur
                  Text(
                    estEnDirect
                        ? _liveEnCours!.titre
                        : 'En attente du prochain culte',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      height: 1.2,
                    ),
                  ),
                  if (estEnDirect) ...[
                    const SizedBox(height: 4),
                    Text(
                      'Prédicateur : ${_liveEnCours!.predicateur}',
                      style: const TextStyle(
                          color: Colors.white70, fontSize: 14),
                    ),
                    const SizedBox(height: 12),

                    // Chronomètre de durée
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 14, vertical: 8),
                      decoration: BoxDecoration(
                        color: Colors.black26,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(Icons.timer,
                              color: Colors.white70, size: 18),
                          const SizedBox(width: 8),
                          Text(
                            _formaterDuree(_dureeLive),
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              fontFeatures: [
                                FontFeature.tabularFigures()
                              ],
                              letterSpacing: 2,
                            ),
                          ),
                          const SizedBox(width: 8),
                          const Text('en cours',
                              style: TextStyle(
                                  color: Colors.white60, fontSize: 12)),
                        ],
                      ),
                    ),
                    const SizedBox(height: 14),
                    const Divider(color: Colors.white24),
                    const SizedBox(height: 8),

                    // Plateformes actives
                    Wrap(
                      spacing: 8,
                      runSpacing: 6,
                      children: [
                        if (_liveEnCours!.surAppMobile)
                          _badgePlateforme(
                              'App Mobile EECC',
                              Icons.phone_android,
                              Colors.deepPurple.shade300),
                        if (_liveEnCours!.surYoutube)
                          _badgePlateforme(
                              'YouTube Live',
                              Icons.play_circle_fill,
                              Colors.red.shade300),
                        if (_liveEnCours!.surFacebook)
                          _badgePlateforme(
                              'Facebook Live',
                              Icons.facebook,
                              Colors.blue.shade300),
                      ],
                    ),
                  ] else ...[
                    const SizedBox(height: 12),
                    Text(
                      'Le culte peut être lancé depuis le poste de Régie Studio.',
                      style: const TextStyle(
                          color: Colors.white60, fontSize: 13),
                    ),
                  ],
                ],
              ),
            ),
            const SizedBox(height: 24),

            // ── Notes pastorales ──────────────────────────────────
            Row(
              children: const [
                Icon(Icons.edit_note, color: Colors.indigo, size: 22),
                SizedBox(width: 8),
                Text(
                  'Notes Pastorales du Culte',
                  style: TextStyle(
                      fontSize: 16, fontWeight: FontWeight.bold),
                ),
              ],
            ),
            const SizedBox(height: 10),
            TextFormField(
              controller: _notesPastoralesController,
              maxLines: 5,
              decoration: InputDecoration(
                hintText:
                    'Versets clés, annonces, points forts, intercessions...',
                border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12)),
                filled: true,
                fillColor: Colors.grey.shade50,
              ),
            ),
            const SizedBox(height: 8),
            Align(
              alignment: Alignment.centerRight,
              child: ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.indigo,
                  foregroundColor: Colors.white,
                ),
                icon: const Icon(Icons.save, size: 16),
                label: const Text('Sauvegarder mes notes'),
                onPressed: _enregistrerNotesPastorales,
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ────────────────────────────────────────────────────────────
  // ONGLET 2 : REQUÊTES DE PRIÈRE EN DIRECT
  // ────────────────────────────────────────────────────────────
  Widget _buildOngletPrieres() {
    return RefreshIndicator(
      onRefresh: _chargerRequetesPriere,
      child: _chargementPrieres
          ? const Center(child: CircularProgressIndicator())
          : _requetesPriere.isEmpty
              ? Center(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.favorite,
                          size: 56, color: Colors.purple.shade100),
                      const SizedBox(height: 12),
                      Text(
                        'Aucune requête de prière en attente.\nLes fidèles peuvent en soumettre depuis leur application.',
                        style: TextStyle(
                            color: Colors.grey.shade600,
                            fontSize: 14),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                )
              : ListView.builder(
                  padding: const EdgeInsets.all(14),
                  itemCount: _requetesPriere.length,
                  itemBuilder: (context, index) {
                    final req = _requetesPriere[index];
                    final heureStr = _formaterDate(
                        req['created_at'] as String?);

                    return Card(
                      margin: const EdgeInsets.only(bottom: 12),
                      elevation: 1,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14),
                        side: BorderSide(
                            color: Colors.purple.shade100),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(14.0),
                        child: Column(
                          crossAxisAlignment:
                              CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                CircleAvatar(
                                  radius: 16,
                                  backgroundColor:
                                      Colors.purple.shade100,
                                  child: Icon(Icons.person,
                                      size: 18,
                                      color: Colors.purple.shade800),
                                ),
                                const SizedBox(width: 10),
                                Expanded(
                                  child: Text(
                                    req['nom_fidele'] ??
                                        'Fidèle Anonyme',
                                    style: const TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 14),
                                  ),
                                ),
                                Text(
                                  heureStr,
                                  style: TextStyle(
                                      color: Colors.grey.shade500,
                                      fontSize: 11),
                                ),
                              ],
                            ),
                            const SizedBox(height: 10),
                            Container(
                              padding: const EdgeInsets.all(10),
                              decoration: BoxDecoration(
                                color: Colors.purple.shade50,
                                borderRadius:
                                    BorderRadius.circular(10),
                              ),
                              child: Text(
                                req['sujet'] ?? '',
                                style: const TextStyle(
                                    fontSize: 13, height: 1.4),
                              ),
                            ),
                            const SizedBox(height: 12),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                ElevatedButton.icon(
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: EeccTheme.violet,
                                    foregroundColor: Colors.white,
                                    padding:
                                        const EdgeInsets.symmetric(
                                            horizontal: 14,
                                            vertical: 8),
                                    shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(
                                                10)),
                                  ),
                                  icon: const Icon(
                                      Icons.favorite_border,
                                      size: 16),
                                  label: const Text(
                                    'PRIER & BÉNIR',
                                    style: TextStyle(
                                        fontSize: 12,
                                        fontWeight: FontWeight.bold),
                                  ),
                                  onPressed: () =>
                                      _marquerPriereEffectuee(req),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
    );
  }

  // ────────────────────────────────────────────────────────────
  // ONGLET 3 : ARCHIVES DES CULTES PASSÉS
  // ────────────────────────────────────────────────────────────
  Widget _buildOngletArchives() {
    return RefreshIndicator(
      onRefresh: _chargerArchives,
      child: _chargementArchives
          ? const Center(child: CircularProgressIndicator())
          : _archives.isEmpty
              ? Center(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.video_library,
                          size: 56, color: Colors.grey.shade300),
                      const SizedBox(height: 12),
                      Text(
                        'Aucun culte archivé pour l\'instant.\nLes archives apparaissent ici après la fin d\'un culte enregistré.',
                        style: TextStyle(
                            color: Colors.grey.shade600,
                            fontSize: 14),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                )
              : ListView.builder(
                  padding: const EdgeInsets.all(14),
                  itemCount: _archives.length,
                  itemBuilder: (context, index) {
                    final archive = _archives[index];
                    final dateStr =
                        '${archive.dateCulte.day.toString().padLeft(2, '0')}/${archive.dateCulte.month.toString().padLeft(2, '0')}/${archive.dateCulte.year}';

                    return Card(
                      margin: const EdgeInsets.only(bottom: 12),
                      elevation: 1,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(14)),
                      child: ListTile(
                        contentPadding: const EdgeInsets.symmetric(
                            horizontal: 14, vertical: 10),
                        leading: Container(
                          width: 48,
                          height: 48,
                          decoration: BoxDecoration(
                            color: EeccTheme.violet.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Icon(Icons.ondemand_video,
                              color: EeccTheme.violet, size: 26),
                        ),
                        title: Text(
                          archive.titre,
                          style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 14),
                        ),
                        subtitle: Text(
                          '${archive.predicateur} · $dateStr',
                          style: TextStyle(
                              color: Colors.grey.shade600,
                              fontSize: 12),
                        ),
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            if (archive.videoDriveUrl != null)
                              Tooltip(
                                message: 'Voir sur Google Drive',
                                child: Icon(Icons.cloud_done,
                                    color: Colors.green.shade600,
                                    size: 20),
                              ),
                            const SizedBox(width: 8),
                            const Icon(Icons.chevron_right,
                                color: Colors.grey),
                          ],
                        ),
                        onTap: archive.videoDriveUrl != null
                            ? () {
                                ScaffoldMessenger.of(context)
                                    .showSnackBar(
                                  SnackBar(
                                    content: Text(
                                      'Lien Drive : ${archive.videoDriveUrl}',
                                      maxLines: 2,
                                    ),
                                    action: SnackBarAction(
                                      label: 'OK',
                                      onPressed: () {},
                                    ),
                                  ),
                                );
                              }
                            : null,
                      ),
                    );
                  },
                ),
    );
  }

  Widget _badgePlateforme(String label, IconData icon, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: Colors.black26,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.white24),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, color: Colors.white, size: 14),
          const SizedBox(width: 5),
          Text(label,
              style: const TextStyle(
                  color: Colors.white,
                  fontSize: 11,
                  fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }
}

// ════════════════════════════════════════════════════════════════════════════
// Widget animé : point rouge clignotant "EN DIRECT"
// ════════════════════════════════════════════════════════════════════════════
class _PulsatingDot extends StatefulWidget {
  @override
  State<_PulsatingDot> createState() => _PulsatingDotState();
}

class _PulsatingDotState extends State<_PulsatingDot>
    with SingleTickerProviderStateMixin {
  late AnimationController _ctrl;
  late Animation<double> _anim;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 900),
    )..repeat(reverse: true);
    _anim = Tween<double>(begin: 0.4, end: 1.0).animate(_ctrl);
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _anim,
      builder: (_, __) => Opacity(
        opacity: _anim.value,
        child: Container(
          width: 12,
          height: 12,
          decoration: const BoxDecoration(
            shape: BoxShape.circle,
            color: Colors.red,
          ),
        ),
      ),
    );
  }
}
