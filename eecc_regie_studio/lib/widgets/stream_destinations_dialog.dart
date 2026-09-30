import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../core/models/destination_stream.dart';
import '../core/services/destination_manager_service.dart';
import '../core/services/ffmpeg_streaming_service.dart';
import '../core/services/regie_orchestrator_service.dart';

class StreamDestinationsDialog extends StatefulWidget {
  const StreamDestinationsDialog({Key? key}) : super(key: key);

  @override
  State<StreamDestinationsDialog> createState() => _StreamDestinationsDialogState();
}

class _StreamDestinationsDialogState extends State<StreamDestinationsDialog> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _titreController;
  late TextEditingController _predicateurController;

  // Contrôleurs pour Facebook
  late TextEditingController _fbUrlController;
  late TextEditingController _fbKeyController;

  // Contrôleurs pour YouTube
  late TextEditingController _ytUrlController;
  late TextEditingController _ytKeyController;

  // Option d'enregistrement local sur disque & Google Drive
  bool _enregistrerSurDisque = true;
  late TextEditingController _dossierController;

  bool _initialized = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!_initialized) {
      final orchestrator = context.read<RegieOrchestratorService>();
      final destManager = context.read<DestinationManagerService>();

      _titreController = TextEditingController(
        text: orchestrator.sessionEnCours?.titreCulte ?? 'Culte Dominical',
      );
      _predicateurController = TextEditingController(
        text: orchestrator.sessionEnCours?.predicateur ?? 'Pasteur',
      );

      final fb = destManager.destinations.firstWhere(
        (d) => d.plateforme == TypePlateforme.facebook,
        orElse: () => DestinationStream(
          id: 'fb',
          nom: 'Facebook',
          plateforme: TypePlateforme.facebook,
          urlRtmp: 'rtmps://live-api-s.facebook.com:443/rtmp/',
          cleStream: '',
        ),
      );
      _fbUrlController = TextEditingController(text: fb.urlRtmp);
      _fbKeyController = TextEditingController(text: fb.cleStream);

      final yt = destManager.destinations.firstWhere(
        (d) => d.plateforme == TypePlateforme.youtube,
        orElse: () => DestinationStream(
          id: 'yt',
          nom: 'YouTube',
          plateforme: TypePlateforme.youtube,
          urlRtmp: 'rtmp://a.rtmp.youtube.com/live2',
          cleStream: '',
        ),
      );
      _ytUrlController = TextEditingController(text: yt.urlRtmp);
      _ytKeyController = TextEditingController(text: yt.cleStream);

      _dossierController = TextEditingController(text: r'C:\EECC_Archives');

      _initialized = true;
    }
  }

  @override
  void dispose() {
    _titreController.dispose();
    _predicateurController.dispose();
    _fbUrlController.dispose();
    _fbKeyController.dispose();
    _ytUrlController.dispose();
    _ytKeyController.dispose();
    _dossierController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final destManager = context.watch<DestinationManagerService>();
    final orchestrator = context.watch<RegieOrchestratorService>();
    final streaming = context.watch<FfmpegStreamingService>();

    final fbDest = destManager.destinations.firstWhere(
      (d) => d.plateforme == TypePlateforme.facebook,
      orElse: () => DestinationStream(
        id: 'fb',
        nom: 'Facebook',
        plateforme: TypePlateforme.facebook,
        urlRtmp: 'rtmps://live-api-s.facebook.com:443/rtmp/',
        cleStream: '',
      ),
    );

    final ytDest = destManager.destinations.firstWhere(
      (d) => d.plateforme == TypePlateforme.youtube,
      orElse: () => DestinationStream(
        id: 'yt',
        nom: 'YouTube',
        plateforme: TypePlateforme.youtube,
        urlRtmp: 'rtmp://a.rtmp.youtube.com/live2',
        cleStream: '',
      ),
    );

    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Container(
        width: 720,
        maxHeight: 780,
        padding: const EdgeInsets.all(24.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Titre Dialog
              Row(
                children: [
                  const Icon(Icons.live_tv, color: Colors.redAccent, size: 28),
                  const SizedBox(width: 12),
                  const Text(
                    'Configuration & Diffusion du Direct',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  const Spacer(),
                  IconButton(
                    icon: const Icon(Icons.close),
                    onPressed: () => Navigator.pop(context),
                  ),
                ],
              ),
              const Divider(height: 24),

              Expanded(
                child: ListView(
                  children: [
                    // Informations du Culte
                    const Text('Informations du Culte',
                        style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        Expanded(
                          flex: 2,
                          child: TextFormField(
                            controller: _titreController,
                            decoration: const InputDecoration(
                              labelText: 'Titre du culte',
                              border: OutlineInputBorder(),
                              prefixIcon: Icon(Icons.title),
                            ),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          flex: 1,
                          child: TextFormField(
                            controller: _predicateurController,
                            decoration: const InputDecoration(
                              labelText: 'Prédicateur',
                              border: OutlineInputBorder(),
                              prefixIcon: Icon(Icons.person),
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),

                    // Choix des plateformes
                    const Text('Plateformes de Diffusion',
                        style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                    const SizedBox(height: 10),

                    // 1. APPLICATION MOBILE EECC
                    Card(
                      elevation: 1,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                        side: BorderSide(
                          color: destManager.diffuserSurAppMobile
                              ? Theme.of(context).primaryColor
                              : Colors.grey.shade300,
                          width: destManager.diffuserSurAppMobile ? 2 : 1,
                        ),
                      ),
                      child: SwitchListTile(
                        value: destManager.diffuserSurAppMobile,
                        onChanged: (val) => destManager.setDiffuserSurAppMobile(val),
                        title: const Text('Application Mobile EECC (Fidèles & Membres)',
                            style: TextStyle(fontWeight: FontWeight.bold)),
                        subtitle: const Text(
                          'Affiche le culte en direct dans l\'application mobile publique et pasteur via Supabase Realtime.',
                        ),
                        secondary: const Icon(Icons.phone_android, color: Colors.deepPurple),
                      ),
                    ),
                    const SizedBox(height: 12),

                    // 2. YOUTUBE LIVE
                    Card(
                      elevation: 1,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                        side: BorderSide(
                          color: ytDest.estActive ? Colors.red : Colors.grey.shade300,
                          width: ytDest.estActive ? 2 : 1,
                        ),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(12.0),
                        child: Column(
                          children: [
                            SwitchListTile(
                              value: ytDest.estActive,
                              onChanged: (val) =>
                                  destManager.toggleDestinationActive(ytDest.id, val),
                              title: const Text('YouTube Live',
                                  style: TextStyle(fontWeight: FontWeight.bold)),
                              subtitle: const Text('Diffusion RTMP vers la chaîne YouTube'),
                              secondary: const Icon(Icons.play_circle_fill, color: Colors.red),
                              contentPadding: EdgeInsets.zero,
                            ),
                            if (ytDest.estActive) ...[
                              const SizedBox(height: 8),
                              TextFormField(
                                controller: _ytKeyController,
                                obscureText: true,
                                decoration: InputDecoration(
                                  labelText: 'Clé de flux YouTube (persistante)',
                                  border: const OutlineInputBorder(),
                                  prefixIcon: const Icon(Icons.vpn_key),
                                  suffixIcon: IconButton(
                                    icon: const Icon(Icons.save),
                                    tooltip: 'Enregistrer la clé',
                                    onPressed: () {
                                      destManager.mettreAJourDestination(
                                        id: ytDest.id,
                                        nom: ytDest.nom,
                                        urlRtmp: _ytUrlController.text.trim(),
                                        cleStream: _ytKeyController.text.trim(),
                                        estActive: true,
                                      );
                                      ScaffoldMessenger.of(context).showSnackBar(
                                        const SnackBar(content: Text('Clé YouTube enregistrée !')),
                                      );
                                    },
                                  ),
                                ),
                              ),
                            ],
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 12),

                    // 3. FACEBOOK LIVE (Clé persistante)
                    Card(
                      elevation: 1,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                        side: BorderSide(
                          color: fbDest.estActive ? Colors.blue.shade800 : Colors.grey.shade300,
                          width: fbDest.estActive ? 2 : 1,
                        ),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(12.0),
                        child: Column(
                          children: [
                            SwitchListTile(
                              value: fbDest.estActive,
                              onChanged: (val) =>
                                  destManager.toggleDestinationActive(fbDest.id, val),
                              title: const Text('Facebook Live (Clé persistante)',
                                  style: TextStyle(fontWeight: FontWeight.bold)),
                              subtitle: const Text(
                                  'Cocher "Clé persistante" dans Facebook Live Producer pour garder la même clé.'),
                              secondary: const Icon(Icons.facebook, color: Colors.blue),
                              contentPadding: EdgeInsets.zero,
                            ),
                            if (fbDest.estActive) ...[
                              const SizedBox(height: 8),
                              TextFormField(
                                controller: _fbUrlController,
                                decoration: const InputDecoration(
                                  labelText: 'URL du serveur Facebook RTMP',
                                  border: OutlineInputBorder(),
                                  prefixIcon: Icon(Icons.link),
                                ),
                              ),
                              const SizedBox(height: 8),
                              TextFormField(
                                controller: _fbKeyController,
                                obscureText: true,
                                decoration: InputDecoration(
                                  labelText: 'Clé de stream persistante Facebook',
                                  border: const OutlineInputBorder(),
                                  prefixIcon: const Icon(Icons.vpn_key),
                                  suffixIcon: IconButton(
                                    icon: const Icon(Icons.save),
                                    tooltip: 'Enregistrer la clé',
                                    onPressed: () {
                                      destManager.mettreAJourDestination(
                                        id: fbDest.id,
                                        nom: fbDest.nom,
                                        urlRtmp: _fbUrlController.text.trim(),
                                        cleStream: _fbKeyController.text.trim(),
                                        estActive: true,
                                      );
                                      ScaffoldMessenger.of(context).showSnackBar(
                                        const SnackBar(content: Text('Clé Facebook enregistrée !')),
                                      );
                                    },
                                  ),
                                ),
                              ),
                            ],
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),

                    // 4. OPTION D'ENREGISTREMENT SUR DISQUE & GOOGLE DRIVE
                    const Text('Option d\'Enregistrement & Archivage',
                        style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                    const SizedBox(height: 10),
                    Card(
                      elevation: 1,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                        side: BorderSide(
                          color: _enregistrerSurDisque ? Colors.teal : Colors.grey.shade300,
                          width: _enregistrerSurDisque ? 2 : 1,
                        ),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(12.0),
                        child: Column(
                          children: [
                            SwitchListTile(
                              value: _enregistrerSurDisque,
                              onChanged: (val) => setState(() => _enregistrerSurDisque = val),
                              title: const Text('Enregistrer sur le disque dur & Google Drive',
                                  style: TextStyle(fontWeight: FontWeight.bold)),
                              subtitle: Text(
                                _enregistrerSurDisque
                                    ? 'Génère un fichier MP4 sur le PC et le téléverse sur Google Drive à la fin du culte.'
                                    : 'Diffusion en streaming pur sans sauvegarde sur le disque (économise l\'espace PC).',
                              ),
                              secondary: Icon(
                                _enregistrerSurDisque ? Icons.save_alt : Icons.cloud_off,
                                color: _enregistrerSurDisque ? Colors.teal : Colors.grey,
                              ),
                              contentPadding: EdgeInsets.zero,
                            ),
                            if (_enregistrerSurDisque) ...[
                              const SizedBox(height: 8),
                              TextFormField(
                                controller: _dossierController,
                                decoration: const InputDecoration(
                                  labelText: 'Dossier d\'enregistrement local',
                                  hintText: r'C:\EECC_Archives',
                                  border: OutlineInputBorder(),
                                  prefixIcon: Icon(Icons.folder),
                                ),
                              ),
                            ],
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 16),

              // Résumé des sélections
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.grey.shade100,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.info_outline, size: 20, color: Colors.blueGrey),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        'Destinations : '
                        '${destManager.diffuserSurAppMobile ? "[App Mobile] " : ""}'
                        '${ytDest.estActive ? "[YouTube] " : ""}'
                        '${fbDest.estActive ? "[Facebook] " : ""}'
                        '${_enregistrerSurDisque ? " • [Enregistrement Disque & Drive]" : " • [Sans enregistrement]"}',
                        style: const TextStyle(fontWeight: FontWeight.w600),
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 16),

              // Boutons d'action
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextButton(
                    onPressed: () => Navigator.pop(context),
                    child: const Text('Fermer'),
                  ),
                  const SizedBox(width: 12),
                  if (streaming.estEnDirect)
                    ElevatedButton.icon(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.red.shade700,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
                      ),
                      icon: const Icon(Icons.stop),
                      label: Text(orchestrator.sessionEnCours?.enregistrerSurDisque == true
                          ? 'ARRÊTER & ARCHIVER SUR GOOGLE DRIVE'
                          : 'ARRÊTER LA DIFFUSION'),
                      onPressed: () async {
                        await orchestrator.terminerCulteEtArchiver(ffmpegService: streaming);
                        if (mounted) Navigator.pop(context);
                      },
                    )
                  else
                    ElevatedButton.icon(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.green.shade700,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
                      ),
                      icon: const Icon(Icons.play_arrow),
                      label: const Text('LANCER LA DIFFUSION'),
                      onPressed: () async {
                        // Enregistrer les clés actuelles
                        await destManager.mettreAJourDestination(
                          id: fbDest.id,
                          nom: fbDest.nom,
                          urlRtmp: _fbUrlController.text.trim(),
                          cleStream: _fbKeyController.text.trim(),
                          estActive: fbDest.estActive,
                        );
                        await destManager.mettreAJourDestination(
                          id: ytDest.id,
                          nom: ytDest.nom,
                          urlRtmp: _ytUrlController.text.trim(),
                          cleStream: _ytKeyController.text.trim(),
                          estActive: ytDest.estActive,
                        );

                        await orchestrator.demarrerCulte(
                          titre: _titreController.text.trim(),
                          predicateur: _predicateurController.text.trim(),
                          destinationManager: destManager,
                          ffmpegService: streaming,
                          qualite: '1080p',
                          enregistrerSurDisque: _enregistrerSurDisque,
                          dossierEnregistrement:
                              _enregistrerSurDisque ? _dossierController.text.trim() : null,
                        );

                        if (mounted) Navigator.pop(context);
                      },
                    ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
