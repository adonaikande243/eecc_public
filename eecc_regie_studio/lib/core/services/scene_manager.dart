import 'package:flutter/material.dart';
import '../models/scene.dart';

class SceneManager extends ChangeNotifier {
  List<Scene> scenes = [
    Scene(id: '1', nom: 'Intro', estActive: false),
    Scene(id: '2', nom: 'Culte Principal', estActive: true),
    Scene(id: '3', nom: 'Louanges', estActive: false),
    Scene(id: '4', nom: 'Prédication', estActive: false),
    Scene(id: '5', nom: 'Outro', estActive: false),
  ];

  Scene get sceneActive => scenes.firstWhere((s) => s.estActive, orElse: () => scenes.first);

  void activerScene(String id) {
    for (var scene in scenes) {
      scene.estActive = (scene.id == id);
    }
    notifyListeners();
  }

  void ajouterScene(Scene scene) {
    scenes.add(scene);
    notifyListeners();
  }
}
