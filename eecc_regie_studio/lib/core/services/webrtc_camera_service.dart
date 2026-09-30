import 'dart:math';
import 'package:flutter/foundation.dart';
import 'package:flutter_webrtc/flutter_webrtc.dart';
import 'package:shelf/shelf_io.dart' as shelf_io;
import 'package:shelf_web_socket/shelf_web_socket.dart';
import 'package:web_socket_channel/web_socket_channel.dart';
import 'dart:convert';
import 'dart:io';

class TelephoneCamera {
  final String id;
  final String nomAppareil;
  final RTCVideoRenderer renderer;
  RTCPeerConnection? connexion;
  bool estActif;

  TelephoneCamera({
    required this.id,
    required this.nomAppareil,
    required this.renderer,
    this.connexion,
    this.estActif = true,
  });

  Future<void> dispose() async {
    estActif = false;
    await connexion?.close();
    await renderer.dispose();
  }
}

class WebRtcCameraService extends ChangeNotifier {
  HttpServer? _signalingServer;
  final int _portSignaling = 8765;
  
  String? codeSession;
  String? urlConnexion;
  
  final Map<String, TelephoneCamera> _telephones = {};
  List<TelephoneCamera> get telephones => _telephones.values.toList();
  
  Future<void> demarrerServeur(String ipLocale) async {
    codeSession = (1000 + Random().nextInt(9000)).toString();
    urlConnexion = 'eecc-regie://$ipLocale:$_portSignaling/$codeSession';
    
    final handler = webSocketHandler((WebSocketChannel socket) {
      _handleNewConnection(socket);
    });
    
    _signalingServer = await shelf_io.serve(handler, '0.0.0.0', _portSignaling);
    notifyListeners();
  }
  
  Future<void> _handleNewConnection(WebSocketChannel socket) async {
    String peerId = DateTime.now().millisecondsSinceEpoch.toString();
    RTCVideoRenderer renderer = RTCVideoRenderer();
    await renderer.initialize();
    
    RTCPeerConnection pc = await createPeerConnection({
      'iceServers': [{'urls': 'stun:stun.l.google.com:19302'}]
    });
    
    pc.onAddStream = (MediaStream stream) {
      renderer.srcObject = stream;
      notifyListeners();
    };

    pc.onIceCandidate = (RTCIceCandidate candidate) {
      socket.sink.add(jsonEncode({
        'type': 'candidate',
        'candidate': candidate.candidate,
        'sdpMid': candidate.sdpMid,
        'sdpMLineIndex': candidate.sdpMLineIndex
      }));
    };

    socket.stream.listen((message) async {
      final data = jsonDecode(message);
      if (data['type'] == 'offer') {
        await pc.setRemoteDescription(RTCSessionDescription(data['sdp'], data['type']));
        RTCSessionDescription answer = await pc.createAnswer();
        await pc.setLocalDescription(answer);
        socket.sink.add(jsonEncode({'type': 'answer', 'sdp': answer.sdp}));
        
        _telephones[peerId] = TelephoneCamera(
          id: peerId,
          nomAppareil: data['deviceName'] ?? 'Téléphone Inconnu',
          renderer: renderer,
          connexion: pc,
        );
        notifyListeners();
      } else if (data['type'] == 'candidate') {
        await pc.addCandidate(RTCIceCandidate(
          data['candidate'],
          data['sdpMid'],
          data['sdpMLineIndex']
        ));
      }
    }, onDone: () {
      deconnecterTelephone(peerId);
    });
  }
  
  RTCVideoRenderer? getRenderer(String telephoneId) => _telephones[telephoneId]?.renderer;
  
  Future<void> deconnecterTelephone(String id) async {
    await _telephones[id]?.dispose();
    _telephones.remove(id);
    notifyListeners();
  }
  
  Future<void> stopperServeur() async {
    for (final t in _telephones.values) { await t.dispose(); }
    _telephones.clear();
    await _signalingServer?.close();
    codeSession = null;
    notifyListeners();
  }
}
