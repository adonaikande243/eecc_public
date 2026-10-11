import 'package:flutter/material.dart';
import '../models/scene.dart';
import '../models/source_media.dart';

class SceneManager extends ChangeNotifier {
  List<Scene> scenes = [
    Scene(
      id: '1',
      nom: '1. Plan Large Culte',
      estActive: true,
      sources: [
        SourceMedia(
          id: 'src_cam1',
          nom: 'Caméra Pupitre (HD)',
          type: TypeSource.hdmi,
          deviceId: 'cam1',
          estVisible: true,
          largeur: 1920,
          hauteur: 1080,
        ),
      ],
    ),
    Scene(
      id: '2',
      nom: '2. Prédication & Chaire',
      estActive: false,
      sources: [
        SourceMedia(
          id: 'src_cam2',
          nom: 'Caméra Prédicateur',
          type: TypeSource.hdmi,
          deviceId: 'cam2',
          estVisible: true,
          largeur: 1920,
          hauteur: 1080,
        ),
      ],
    ),
    Scene(
      id: '3',
      nom: '3. Chorale & Louanges',
      estActive: false,
      sources: [
        SourceMedia(
          id: 'src_cam3',
          nom: 'Caméra Chorale',
          type: TypeSource.hdmi,
          deviceId: 'cam3',
          estVisible: true,
          largeur: 1920,
          hauteur: 1080,
        ),
      ],
    ),
    Scene(
      id: '4',
      nom: '4. Projection Verset & Bible',
      estActive: false,
      sources: [
        SourceMedia(
          id: 'src_bible',
          nom: 'Diapositive Écritures',
          type: TypeSource.couleurSolide,
          couleur: const Color(0xFF0F172A),
          estVisible: true,
          largeur: 1920,
          hauteur: 1080,
        ),
      ],
    ),
    Scene(
      id: '5',
      nom: '5. Annonces & Fin de culte',
      estActive: false,
      sources: [
        SourceMedia(
          id: 'src_outro',
          nom: 'Bandeau Officiel EECC',
          type: TypeSource.couleurSolide,
          couleur: const Color(0xFF1E3A8A),
          estVisible: true,
          largeur: 1920,
          hauteur: 1080,
        ),
      ],
    ),
  ];

  int _selectedPreviewSceneIndex = 0;
  int _programSceneIndex = 0;

  int get selectedPreviewSceneIndex => _selectedPreviewSceneIndex;
  int get programSceneIndex => _programSceneIndex;

  Scene get previewScene => scenes[_selectedPreviewSceneIndex];
  Scene get programScene => scenes[_programSceneIndex];
  Scene get sceneActive => programScene;

  void selectionnerPreview(int index) {
    if (index >= 0 && index < scenes.length) {
      _selectedPreviewSceneIndex = index;
      notifyListeners();
    }
  }

  void activerScene(String id) {
    final idx = scenes.indexWhere((s) => s.id == id);
    if (idx != -1) {
      _selectedPreviewSceneIndex = idx;
      notifyListeners();
    }
  }

  /// Exécute la transition TAKE (bascule le Preview vers le Programme On Air)
  void executeTake() {
    _programSceneIndex = _selectedPreviewSceneIndex;
    for (int i = 0; i < scenes.length; i++) {
      scenes[i].estActive = (i == _programSceneIndex);
    }
    notifyListeners();
  }

  /// Exécute une coupe instantanée CUT vers un index donné
  void executeCut(int index) {
    if (index >= 0 && index < scenes.length) {
      _selectedPreviewSceneIndex = index;
      _programSceneIndex = index;
      for (int i = 0; i < scenes.length; i++) {
        scenes[i].estActive = (i == _programSceneIndex);
      }
      notifyListeners();
    }
  }

  void basculerVisibiliteSource(String sourceId) {
    for (var s in previewScene.sources) {
      if (s.id == sourceId) {
        s.estVisible = !s.estVisible;
        break;
      }
    }
    notifyListeners();
  }

  void ajouterScene(Scene scene) {
    scenes.add(scene);
    notifyListeners();
  }
}
