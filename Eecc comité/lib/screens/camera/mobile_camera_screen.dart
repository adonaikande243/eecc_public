import 'package:flutter/material.dart';
import 'package:flutter_webrtc/flutter_webrtc.dart';
import 'dart:convert';
import 'package:web_socket_channel/web_socket_channel.dart';

class MobileCameraScreen extends StatefulWidget {
  const MobileCameraScreen({Key? key}) : super(key: key);

  @override
  State<MobileCameraScreen> createState() => _MobileCameraScreenState();
}

class _MobileCameraScreenState extends State<MobileCameraScreen> {
  final _codeCtrl = TextEditingController();
  RTCVideoRenderer _localRenderer = RTCVideoRenderer();
  RTCPeerConnection? _peerConnection;
  MediaStream? _localStream;
  WebSocketChannel? _channel;
  bool _estConnecte = false;
  String _qualite = '720p';

  @override
  void initState() {
    super.initState();
    _localRenderer.initialize();
  }

  @override
  void dispose() {
    _localRenderer.dispose();
    _localStream?.dispose();
    _peerConnection?.close();
    _channel?.sink.close();
    super.dispose();
  }

  Future<void> _seConnecter(String ip) async {
    final wsUrl = Uri.parse('ws://$ip:8765');
    _channel = WebSocketChannel.connect(wsUrl);

    _peerConnection = await createPeerConnection({
      'iceServers': [{'urls': 'stun:stun.l.google.com:19302'}]
    });

    final constraints = {
      'audio': true,
      'video': {
        'facingMode': 'environment',
        'width': _qualite == '1080p' ? 1920 : (_qualite == '720p' ? 1280 : 640),
        'height': _qualite == '1080p' ? 1080 : (_qualite == '720p' ? 720 : 480),
      }
    };

    _localStream = await navigator.mediaDevices.getUserMedia(constraints);
    _localRenderer.srcObject = _localStream;
    _localStream!.getTracks().forEach((track) {
      _peerConnection!.addTrack(track, _localStream!);
    });

    _peerConnection!.onIceCandidate = (candidate) {
      _channel!.sink.add(jsonEncode({
        'type': 'candidate',
        'candidate': candidate.candidate,
        'sdpMid': candidate.sdpMid,
        'sdpMLineIndex': candidate.sdpMLineIndex
      }));
    };

    _channel!.stream.listen((message) async {
      final data = jsonDecode(message);
      if (data['type'] == 'answer') {
        await _peerConnection!.setRemoteDescription(
            RTCSessionDescription(data['sdp'], data['type']));
      } else if (data['type'] == 'candidate') {
        await _peerConnection!.addCandidate(RTCIceCandidate(
            data['candidate'], data['sdpMid'], data['sdpMLineIndex']));
      }
    });

    RTCSessionDescription offer = await _peerConnection!.createOffer();
    await _peerConnection!.setLocalDescription(offer);
    
    _channel!.sink.add(jsonEncode({
      'type': 'offer',
      'sdp': offer.sdp,
      'deviceName': 'Téléphone de la régie',
    }));

    setState(() { _estConnecte = true; });
  }

  @override
  Widget build(BuildContext context) {
    if (_estConnecte) {
      return Scaffold(
        body: Stack(
          children: [
            RTCVideoView(_localRenderer, objectFit: RTCVideoViewObjectFit.RTCVideoViewObjectFitCover),
            Positioned(
              bottom: 40,
              left: 0,
              right: 0,
              child: Center(
                child: ElevatedButton.icon(
                  onPressed: () {
                    _channel?.sink.close();
                    _peerConnection?.close();
                    setState(() { _estConnecte = false; });
                  },
                  icon: const Icon(Icons.stop),
                  label: const Text('Déconnecter'),
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
                ),
              ),
            )
          ],
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(title: const Text('Devenir Caméra WebRTC')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _codeCtrl,
              decoration: const InputDecoration(labelText: 'IP du Studio (ex: 192.168.1.50)'),
            ),
            const SizedBox(height: 16),
            DropdownButtonFormField<String>(
              value: _qualite,
              items: const [
                DropdownMenuItem(value: '1080p', child: Text('Full HD 1080p')),
                DropdownMenuItem(value: '720p', child: Text('HD 720p')),
                DropdownMenuItem(value: '480p', child: Text('SD 480p')),
              ],
              onChanged: (v) => setState(() => _qualite = v!),
              decoration: const InputDecoration(labelText: 'Qualité Vidéo'),
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: () => _seConnecter(_codeCtrl.text),
              child: const Text('Se connecter comme caméra'),
            ),
            const Divider(height: 40),
            ElevatedButton.icon(
              onPressed: () {
                // Intégration mobile_scanner à faire pour lire le QR Code
              },
              icon: const Icon(Icons.qr_code_scanner),
              label: const Text('Scanner le QR Code'),
            )
          ],
        ),
      ),
    );
  }
}
