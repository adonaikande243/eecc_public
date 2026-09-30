import 'package:flutter/material.dart';
import 'package:ffmpeg_kit_flutter_full_gpl/ffmpeg_kit.dart';
import 'package:ffmpeg_kit_flutter_full_gpl/ffmpeg_session.dart';
import 'package:ffmpeg_kit_flutter_full_gpl/return_code.dart';
import '../models/destination_stream.dart';

class FfmpegStreamingService extends ChangeNotifier {
  FFmpegSession? _sessionDirect;
  FFmpegSession? _sessionEnregistrement;
  
  bool estEnDirect = false;
  bool estEnregistrement = false;
  String? cheminEnregistrement;
  
  Future<void> demarrerDiffusion({
    required List<String> sourceDevicesHdmi,
    required List<String> sourceWebRtcUrls,
    required List<DestinationStream> destinations,
    required String qualite,
  }) async {
    if (estEnDirect) return;
    
    final cmd = _construireCommandeRtmp(
      sourcesHdmi: sourceDevicesHdmi,
      sourcesWebRtc: sourceWebRtcUrls,
      destinations: destinations,
      qualite: qualite,
    );
    
    _sessionDirect = await FFmpegKit.executeAsync(cmd,
      (session) async {
        final returnCode = await session.getReturnCode();
        if (ReturnCode.isSuccess(returnCode)) {
          debugPrint('Diffusion RTMP terminée avec succès.');
        } else {
          debugPrint('Erreur FFmpeg diffusion RTMP.');
        }
        estEnDirect = false;
        notifyListeners();
      },
      (log) => debugPrint('[FFmpeg] ${log.getMessage()}'),
      (statistics) {
        // Mise à jour des stats (FPS, bitrate, etc.)
      },
    );
    
    estEnDirect = true;
    notifyListeners();
  }
  
  Future<void> demarrerEnregistrement(String outputDir) async {
    if (estEnregistrement) return;
    
    final filename = 'EECC_Culte_${DateTime.now().toIso8601String().replaceAll(":", "-")}.mp4';
    cheminEnregistrement = '$outputDir\\$filename';
    
    String cmd = "-f dshow -i video=\"Integrated Camera\" -c:v h264 -c:a aac -y \"$cheminEnregistrement\"";
    
    _sessionEnregistrement = await FFmpegKit.executeAsync(cmd,
      (session) async {
        estEnregistrement = false;
        notifyListeners();
      },
    );
    
    estEnregistrement = true;
    notifyListeners();
  }
  
  Future<void> stopperTout() async {
    await FFmpegKit.cancel();
    estEnDirect = false;
    estEnregistrement = false;
    notifyListeners();
  }
  
  String _construireCommandeRtmp({
    required List<String> sourcesHdmi,
    required List<String> sourcesWebRtc,
    required List<DestinationStream> destinations,
    required String qualite,
  }) {
    StringBuffer cmd = StringBuffer();
    // Inputs
    for (var hdmi in sourcesHdmi) {
      cmd.write('-f dshow -i video="$hdmi" ');
    }
    // Filter complex (simple concat or mix for demonstration)
    cmd.write('-c:v libx264 -preset veryfast -maxrate 3000k -bufsize 6000k -pix_fmt yuv420p -g 50 -c:a aac -b:a 160k -ar 44100 ');
    
    // Outputs (tee muxer)
    if (destinations.isNotEmpty) {
      cmd.write('-f tee "');
      for (int i = 0; i < destinations.length; i++) {
        cmd.write('[f=flv]${destinations[i].fullUrl}');
        if (i < destinations.length - 1) cmd.write('|');
      }
      cmd.write('"');
    }
    return cmd.toString();
  }
}
