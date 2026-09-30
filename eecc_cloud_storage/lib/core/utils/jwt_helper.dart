import 'package:dart_jsonwebtoken/dart_jsonwebtoken.dart';

class JwtHelper {
  /// Crée un JWT signé pour l'authentification Service Account Google
  static String createServiceAccountJwt(Map<String, dynamic> credentials) {
    final clientEmail = credentials['client_email'] as String;
    final privateKeyStr = credentials['private_key'] as String;
    final tokenUri = credentials['token_uri'] as String;

    // Définir la durée de validité du token (max 1 heure pour Google)
    final now = DateTime.now();
    final iat = (now.millisecondsSinceEpoch / 1000).floor();
    final exp = iat + 3600;

    // Créer le JWT
    final jwt = JWT(
      {
        'iss': clientEmail,
        'scope': 'https://www.googleapis.com/auth/drive.file https://www.googleapis.com/auth/drive.metadata.readonly',
        'aud': tokenUri,
        'exp': exp,
        'iat': iat,
      },
    );

    // Charger la clé privée RSA
    final key = RSAPrivateKey(privateKeyStr);

    // Signer le JWT
    final token = jwt.sign(key, algorithm: JWTAlgorithm.RS256);
    
    return token;
  }
}
