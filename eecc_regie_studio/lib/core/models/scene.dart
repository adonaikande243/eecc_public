import 'source_media.dart';

enum TransitionType { coupe, fondu, glissement }

class Scene {
  final String id;
  String nom;
  final List<SourceMedia> sources;
  TransitionType transitionEntree;
  bool estActive;

  Scene({
    required this.id,
    required this.nom,
    List<SourceMedia>? sources,
    this.transitionEntree = TransitionType.coupe,
    this.estActive = false,
  }) : sources = sources ?? [];

  void ajouterSource(SourceMedia source) {
    sources.add(source);
  }

  void retirerSource(String sourceId) {
    sources.removeWhere((s) => s.id == sourceId);
  }
}
