enum CloudProvider {
  googleDriveServiceAccount,
  googleDriveOAuth,
  oneDrive1,
  oneDrive2
}

class CloudFile {
  final String id;
  final String name;
  final int size;
  final String mimeType;
  final String? webUrl;
  final String? downloadUrl;
  final CloudProvider provider;
  final DateTime? createdAt;
  final String? thumbnailUrl;

  const CloudFile({
    required this.id,
    required this.name,
    required this.size,
    required this.mimeType,
    this.webUrl,
    this.downloadUrl,
    required this.provider,
    this.createdAt,
    this.thumbnailUrl,
  });

  CloudFile copyWith({
    String? id,
    String? name,
    int? size,
    String? mimeType,
    String? webUrl,
    String? downloadUrl,
    CloudProvider? provider,
    DateTime? createdAt,
    String? thumbnailUrl,
  }) {
    return CloudFile(
      id: id ?? this.id,
      name: name ?? this.name,
      size: size ?? this.size,
      mimeType: mimeType ?? this.mimeType,
      webUrl: webUrl ?? this.webUrl,
      downloadUrl: downloadUrl ?? this.downloadUrl,
      provider: provider ?? this.provider,
      createdAt: createdAt ?? this.createdAt,
      thumbnailUrl: thumbnailUrl ?? this.thumbnailUrl,
    );
  }

  factory CloudFile.fromJson(Map<String, dynamic> json) {
    return CloudFile(
      id: json['id'] as String,
      name: json['name'] as String,
      size: json['size'] as int,
      mimeType: json['mimeType'] as String,
      webUrl: json['webUrl'] as String?,
      downloadUrl: json['downloadUrl'] as String?,
      provider: CloudProvider.values.firstWhere(
        (e) => e.toString() == json['provider'],
        orElse: () => CloudProvider.googleDriveServiceAccount,
      ),
      createdAt: json['createdAt'] != null
          ? DateTime.parse(json['createdAt'] as String)
          : null,
      thumbnailUrl: json['thumbnailUrl'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'size': size,
      'mimeType': mimeType,
      'webUrl': webUrl,
      'downloadUrl': downloadUrl,
      'provider': provider.toString(),
      'createdAt': createdAt?.toIso8601String(),
      'thumbnailUrl': thumbnailUrl,
    };
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is CloudFile &&
          runtimeType == other.runtimeType &&
          id == other.id &&
          provider == other.provider;

  @override
  int get hashCode => id.hashCode ^ provider.hashCode;
}
