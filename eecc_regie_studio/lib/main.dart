import 'package:flutter/material.dart';
import 'package:media_kit/media_kit.dart';
import 'package:provider/provider.dart';
import 'package:window_manager/window_manager.dart';
import 'shared/theme/studio_theme.dart';
import 'core/services/hdmi_camera_service.dart';
import 'core/services/webrtc_camera_service.dart';
import 'core/services/scene_manager.dart';
import 'core/services/ffmpeg_streaming_service.dart';
import 'core/services/destination_manager_service.dart';
import 'screens/main_studio_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  MediaKit.ensureInitialized();
  
  await windowManager.ensureInitialized();
  WindowOptions windowOptions = const WindowOptions(
    size: Size(1280, 720),
    minimumSize: Size(1280, 720),
    center: true,
    backgroundColor: Colors.transparent,
    skipTaskbar: false,
    titleBarStyle: TitleBarStyle.normal,
    title: "EECC Régie Studio",
  );
  windowManager.waitUntilReadyToShow(windowOptions, () async {
    await windowManager.show();
    await windowManager.focus();
  });

  runApp(const EeccRegieStudioApp());
}

class EeccRegieStudioApp extends StatelessWidget {
  const EeccRegieStudioApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => DestinationManagerService()),
        ChangeNotifierProvider(create: (_) => HdmiCameraService()),
        ChangeNotifierProvider(create: (_) => WebRtcCameraService()),
        ChangeNotifierProvider(create: (_) => SceneManager()),
        ChangeNotifierProvider(create: (_) => FfmpegStreamingService()),
        ChangeNotifierProvider(create: (_) => RegieOrchestratorService()),
      ],
      child: MaterialApp(
        title: 'EECC Régie Studio',
        theme: StudioTheme.theme,
        home: const MainStudioScreen(),
        debugShowCheckedModeBanner: false,
      ),
    );
  }
}
