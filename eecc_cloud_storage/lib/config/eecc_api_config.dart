/// Configuration centralisée des APIs et services pour la plateforme EECC.
/// 
/// Ce fichier regroupe les identifiants pour Supabase, Google Drive, Brevo et Maishapay.
class EeccApiConfig {
  EeccApiConfig._();

  static String _x(List<int> bytes) =>
      String.fromCharCodes(bytes.map((b) => b ^ 0x5A));

  // ===========================================================================
  // SUPABASE (Base de données, Auth & Realtime)
  // ===========================================================================
  static const String supabaseUrl = 'https://ywbtdvlsbzmiedxydepl.supabase.co';
  
  /// Clé publique / anonyme pour les clients mobiles et desktop
  static const String supabaseAnonKey =
      'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6Inl3YnRkdmxzYnptaWVkeHlkZXBsIiwicm9sZSI6ImFub24iLCJpYXQiOjE3OTA1NzkzOTEsImV4cCI6MjEwNjE1NTM5MX0.wYnLhAM3sNNnkteisCfJMigBRC3lImPgQkgejOu88Qs';

  /// Clé secrète d'administration (service_role) - À réserver au backend ou tâches d'administration
  static const String supabaseServiceRoleKey =
      'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6Inl3YnRkdmxzYnptaWVkeHlkZXBsIiwicm9sZSI6InNlcnZpY2Vfcm9sZSIsImlhdCI6MTc5MDU3OTM5MSwiZXhwIjoyMTA2MTU1MzkxfQ.LQcJRbkdNuhjbW5Kpm0P1Q2yYnCmJmqaTtxc7-DH4Zo';

  // ===========================================================================
  // GOOGLE DRIVE (Sauvegardes et Archives de cultes)
  // ===========================================================================
  /// Compte Drive 1 (Principal)
  static String get googleDrive1ClientId => _x(const [
        107, 110, 110, 110, 109, 105, 104, 107, 111, 105, 106, 111, 119, 50,
        50, 56, 44, 47, 37, 42, 44, 106, 110, 108, 98, 47, 40, 60, 60, 37,
        36, 58, 36, 98, 109, 57, 54, 51, 46, 48, 43, 58, 51, 44, 58, 116,
        59, 42, 42, 41, 116, 61, 37, 37, 61, 54, 63, 47, 41, 63, 40, 57,
        37, 36, 46, 63, 36, 46, 116, 57, 37, 39
      ]);

  static String get googleDrive1ClientSecret => _x(const [
        29, 21, 25, 9, 10, 2, 119, 34, 16, 41, 43, 18, 21, 24, 40, 48, 29,
        63, 59, 47, 47, 5, 29, 9, 17, 42, 4, 29, 63, 54, 50, 61, 58, 47, 31
      ]);

  /// Compte Drive 2 (Secondaire / Backup)
  static String get googleDrive2ClientId => _x(const [
        111, 110, 99, 109, 104, 104, 104, 106, 98, 104, 105, 104, 119, 107,
        111, 37, 63, 58, 107, 51, 48, 54, 107, 46, 63, 44, 61, 36, 56, 106,
        47, 57, 54, 110, 111, 57, 56, 40, 60, 43, 106, 39, 36, 99, 57, 116,
        59, 42, 42, 41, 116, 61, 37, 37, 61, 54, 63, 47, 41, 63, 40, 57,
        37, 36, 46, 63, 36, 46, 116, 57, 37, 39
      ]);

  static String get googleDrive2ClientSecret => _x(const [
        29, 21, 25, 9, 10, 2, 119, 16, 43, 9, 63, 2, 49, 111, 32, 17, 43,
        30, 54, 57, 48, 25, 24, 35, 4, 98, 37, 20, 111, 58, 30, 9, 2, 0,
        35, 10, 2, 119, 16, 43, 9, 63, 2, 49, 111, 32, 17, 43, 30, 54, 57,
        48, 25, 24, 35, 4, 98, 37, 20, 111, 58, 30, 9, 2, 0, 35
      ]);

  // ===========================================================================
  // BREVO / SENDINBLUE (E-mails transactionnels & SMS)
  // ===========================================================================
  static String get brevoApiKey => _x(const [
        34, 49, 63, 35, 41, 51, 56, 119, 99, 106, 110, 108, 106, 63, 98, 111,
        58, 58, 110, 59, 98, 57, 57, 60, 104, 109, 104, 58, 99, 107, 111, 57,
        98, 59, 58, 63, 107, 99, 60, 57, 58, 57, 109, 107, 106, 63, 110, 98,
        99, 111, 104, 58, 59, 108, 63, 108, 99, 99, 105, 107, 56, 106, 104,
        105, 59, 107, 58, 56, 60, 99, 63, 110, 119, 35, 30, 56, 25, 111, 44,
        108, 37, 63, 36, 19, 2, 99, 37, 10, 48
      ]);

  // ===========================================================================
  // MAISHAPAY (Paiements, Dîmes & Offrandes)
  // ===========================================================================
  static const String maishapaySecretKey =
      'MP-LIVESK-.QR7cOsKCy6GE8f2lue2J.uF8MgITIRNzPzC1I\$XDj\$h2R7lF1\$aZ0i0B.Md0nJZD0AUrqeQR.Ld8U.cPMHTGfCbLB\$SV3FfH/jd6Btyah\$eiCQ5Y\$7r2uu2';

  static const String maishapayPublicKey =
      'MP-LIVEPK-DOw\$T0SnM/SekDy32h0M5\$A6Z2H350e.TJSq1HIRT70jndZdocX.v53cSIcxy65\$qD2ThvocUy\$EYn10vD\$3S80\$Mh4SnfByyHSH.Fazv1Dfmc2uy9sjE7VG';
}
