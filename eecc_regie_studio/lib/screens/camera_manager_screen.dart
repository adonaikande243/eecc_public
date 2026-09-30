import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:qr_flutter/qr_flutter.dart';
import '../core/services/hdmi_camera_service.dart';
import '../core/services/webrtc_camera_service.dart';

class CameraManagerScreen extends StatefulWidget {
  const CameraManagerScreen({Key? key}) : super(key: key);

  @override
  State<CameraManagerScreen> createState() => _CameraManagerScreenState();
}

class _CameraManagerScreenState extends State<CameraManagerScreen> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      context.read<HdmiCameraService>().scannerCameras();
    });
  }

  @override
  Widget build(BuildContext context) {
    final webrtcService = context.watch<WebRtcCameraService>();
    final hdmiService = context.watch<HdmiCameraService>();

    return Scaffold(
      appBar: AppBar(title: const Text('Gestion des Caméras')),
      body: Row(
        children: [
          // Section HDMI
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Caméras HDMI / Physiques', style: Theme.of(context).textTheme.titleLarge),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () => hdmiService.scannerCameras(),
                    child: const Text('Scanner les caméras'),
                  ),
                  const SizedBox(height: 16),
                  Expanded(
                    child: ListView.builder(
                      itemCount: hdmiService.camerasDisponibles.length,
                      itemBuilder: (context, index) {
                        final cam = hdmiService.camerasDisponibles[index];
                        return Card(
                          child: ListTile(
                            leading: const Icon(Icons.videocam),
                            title: Text(cam.nom),
                            subtitle: Text('Type: ${cam.type}'),
                            trailing: ElevatedButton(
                              onPressed: () => hdmiService.demarrerCapture(cam),
                              child: const Text('+ Ajouter'),
                            ),
                          ),
                        );
                      },
                    ),
                  )
                ],
              ),
            ),
          ),
          const VerticalDivider(),
          // Section WebRTC Téléphone
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text('Caméras Téléphone (via Eecc Comité)', style: Theme.of(context).textTheme.titleLarge),
                  const SizedBox(height: 16),
                  if (webrtcService.codeSession == null)
                    ElevatedButton(
                      onPressed: () => webrtcService.demarrerServeur('192.168.1.50'),
                      child: const Text('Démarrer le serveur local'),
                    )
                  else
                    Column(
                      children: [
                        QrImageView(
                          data: webrtcService.urlConnexion!,
                          version: QrVersions.auto,
                          size: 200.0,
                          backgroundColor: Colors.white,
                        ),
                        const SizedBox(height: 16),
                        Text('Code de session : ${webrtcService.codeSession}', 
                             style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold, letterSpacing: 5)),
                        const SizedBox(height: 8),
                        Text('URL : ${webrtcService.urlConnexion}'),
                        const SizedBox(height: 16),
                        ElevatedButton(
                          onPressed: () => webrtcService.stopperServeur(),
                          style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
                          child: const Text('Arrêter le serveur'),
                        ),
                      ],
                    ),
                  const Divider(),
                  Expanded(
                    child: ListView.builder(
                      itemCount: webrtcService.telephones.length,
                      itemBuilder: (context, index) {
                        final tel = webrtcService.telephones[index];
                        return ListTile(
                          leading: const Icon(Icons.smartphone),
                          title: Text(tel.nomAppareil),
                          trailing: IconButton(
                            icon: const Icon(Icons.close, color: Colors.red),
                            onPressed: () => webrtcService.deconnecterTelephone(tel.id),
                          ),
                        );
                      },
                    ),
                  )
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}
