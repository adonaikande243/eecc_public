import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import '../config/eecc_api_config.dart';

/// Service réel Brevo (Sendinblue) pour l'envoi d'e-mails et de SMS transactionnels
class BrevoNotificationService {
  static final BrevoNotificationService _instance = BrevoNotificationService._internal();
  factory BrevoNotificationService() => _instance;
  BrevoNotificationService._internal();

  static const String _brevoEmailUrl = 'https://api.brevo.com/v3/smtp/email';
  static const String _brevoSmsUrl = 'https://api.brevo.com/v3/transactionalSMS/sms';

  Map<String, String> get _headers => {
        'Accept': 'application/json',
        'Content-Type': 'application/json',
        'api-key': EeccApiConfig.brevoApiKey,
      };

  // ===========================================================================
  // 1. ENVOI DE CODE OTP (Inscription / Connexion / Sécurité)
  // ===========================================================================

  /// Envoie un code OTP par e-mail via Brevo
  Future<bool> envoyerOtpEmail({
    required String destinataireEmail,
    required String nomDestinataire,
    required String codeOtp,
  }) async {
    try {
      final payload = {
        'sender': {
          'name': 'Église EECC',
          'email': 'notifications@eecc-eglise.org',
        },
        'to': [
          {
            'email': destinataireEmail,
            'name': nomDestinataire,
          }
        ],
        'subject': 'Votre code de vérification EECC : $codeOtp',
        'htmlContent': '''
        <!DOCTYPE html>
        <html>
        <head>
          <meta charset="utf-8">
          <style>
            body { font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif; background-color: #f7f5fa; padding: 20px; color: #333; }
            .card { max-width: 520px; margin: 0 auto; background: #ffffff; border-radius: 12px; overflow: hidden; box-shadow: 0 4px 15px rgba(0,0,0,0.08); border-top: 6px solid #4A148C; }
            .header { background: #4A148C; padding: 24px; text-align: center; color: #ffffff; }
            .header h1 { margin: 0; font-size: 22px; color: #F9A825; letter-spacing: 1px; }
            .content { padding: 30px 24px; text-align: center; }
            .otp-box { display: inline-block; background: #f3e5f5; border: 2px dashed #7b1fa2; border-radius: 8px; padding: 14px 28px; font-size: 32px; font-weight: bold; letter-spacing: 8px; color: #4A148C; margin: 20px 0; }
            .footer { background: #fafafa; padding: 16px; text-align: center; font-size: 12px; color: #888; border-top: 1px solid #eee; }
          </style>
        </head>
        <body>
          <div class="card">
            <div class="header">
              <h1>ÉGLISE EECC</h1>
              <p style="margin: 4px 0 0 0; font-size: 13px; color: #e1bee7;">Plateforme Numérique Officielle</p>
            </div>
            <div class="content">
              <h2 style="color: #4A148C; margin-top: 0;">Code de Sécurité</h2>
              <p>Bonjour <strong>$nomDestinataire</strong>,</p>
              <p>Voici votre code de confirmation pour accéder à votre compte EECC :</p>
              <div class="otp-box">$codeOtp</div>
              <p style="font-size: 13px; color: #666;">Ce code expire dans <strong>10 minutes</strong>. Ne le partagez avec personne.</p>
            </div>
            <div class="footer">
              <p>Que Dieu vous bénisse abondamment.<br>&copy; ${DateTime.now().year} Église EECC. Tous droits réservés.</p>
            </div>
          </div>
        </body>
        </html>
        ''',
      };

      final response = await http.post(
        Uri.parse(_brevoEmailUrl),
        headers: _headers,
        body: jsonEncode(payload),
      );

      if (response.statusCode == 201 || response.statusCode == 200) {
        debugPrint('[Brevo] E-mail OTP envoyé avec succès à $destinataireEmail');
        return true;
      } else {
        debugPrint('[Brevo] Erreur envoi e-mail OTP: ${response.statusCode} - ${response.body}');
        return false;
      }
    } catch (e) {
      debugPrint('[Brevo] Exception envoi e-mail OTP: $e');
      return false;
    }
  }

  /// Envoie un code OTP par SMS via Brevo
  Future<bool> envoyerOtpSms({
    required String numeroTelephone,
    required String codeOtp,
  }) async {
    try {
      final payload = {
        'sender': 'EECC',
        'recipient': numeroTelephone,
        'content': 'EECC: Votre code de vérification est $codeOtp (valable 10 min). Que Dieu vous bénisse.',
        'type': 'transactional',
      };

      final response = await http.post(
        Uri.parse(_brevoSmsUrl),
        headers: _headers,
        body: jsonEncode(payload),
      );

      if (response.statusCode == 201 || response.statusCode == 200) {
        debugPrint('[Brevo] SMS OTP envoyé avec succès à $numeroTelephone');
        return true;
      } else {
        debugPrint('[Brevo] Erreur SMS OTP: ${response.statusCode} - ${response.body}');
        return false;
      }
    } catch (e) {
      debugPrint('[Brevo] Exception SMS OTP: $e');
      return false;
    }
  }

  // ===========================================================================
  // 2. CONFIRMATION & REÇU D'OFFRANDE (Dîme, Don, Action de Grâce)
  // ===========================================================================

  /// Envoie le reçu officiel de confirmation d'offrande par e-mail
  Future<bool> envoyerRecuOffrandeEmail({
    required String destinataireEmail,
    required String nomFidele,
    required double montant,
    required String devise,
    required String typeOffrande,
    required String referencePaiement,
    DateTime? datePaiement,
  }) async {
    try {
      final date = datePaiement ?? DateTime.now();
      final dateStr =
          "${date.day.toString().padLeft(2, '0')}/${date.month.toString().padLeft(2, '0')}/${date.year} à ${date.hour.toString().padLeft(2, '0')}:${date.minute.toString().padLeft(2, '0')}";

      final payload = {
        'sender': {
          'name': 'Trésorerie EECC',
          'email': 'tresorerie@eecc-eglise.org',
        },
        'to': [
          {
            'email': destinataireEmail,
            'name': nomFidele,
          }
        ],
        'subject': 'Reçu de votre offrande : $referencePaiement - Église EECC',
        'htmlContent': '''
        <!DOCTYPE html>
        <html>
        <head>
          <meta charset="utf-8">
          <style>
            body { font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif; background-color: #f7f5fa; padding: 20px; color: #333; }
            .card { max-width: 550px; margin: 0 auto; background: #ffffff; border-radius: 12px; overflow: hidden; box-shadow: 0 4px 15px rgba(0,0,0,0.08); border-top: 6px solid #F9A825; }
            .header { background: #4A148C; padding: 24px; text-align: center; color: #ffffff; }
            .header h1 { margin: 0; font-size: 22px; color: #F9A825; letter-spacing: 1px; }
            .content { padding: 24px; }
            .receipt-table { width: 100%; border-collapse: collapse; margin: 20px 0; }
            .receipt-table td { padding: 10px 12px; border-bottom: 1px solid #f0f0f0; }
            .receipt-table td.label { color: #666; font-size: 14px; width: 45%; }
            .receipt-table td.value { font-weight: bold; color: #222; text-align: right; }
            .total-row { background: #fdf7e7; font-size: 16px; color: #4A148C !important; }
            .verse { font-style: italic; background: #f3e5f5; border-left: 4px solid #7b1fa2; padding: 12px; margin: 20px 0; font-size: 13px; color: #4A148C; }
            .footer { background: #fafafa; padding: 16px; text-align: center; font-size: 12px; color: #888; border-top: 1px solid #eee; }
          </style>
        </head>
        <body>
          <div class="card">
            <div class="header">
              <h1>ÉGLISE EECC</h1>
              <p style="margin: 4px 0 0 0; font-size: 13px; color: #e1bee7;">Reçu Électronique de Don & Offrande</p>
            </div>
            <div class="content">
              <p>Chère sœur, Cher frère <strong>$nomFidele</strong>,</p>
              <p>Nous vous remercions pour votre générosité et votre fidélité dans l'œuvre du Seigneur. Votre paiement a été validé avec succès par la plateforme <strong>Maishapay</strong>.</p>
              
              <table class="receipt-table">
                <tr>
                  <td class="label">Référence :</td>
                  <td class="value">$referencePaiement</td>
                </tr>
                <tr>
                  <td class="label">Type de contribution :</td>
                  <td class="value">$typeOffrande</td>
                </tr>
                <tr>
                  <td class="label">Date & Heure :</td>
                  <td class="value">$dateStr</td>
                </tr>
                <tr>
                  <td class="label">Passerelle :</td>
                  <td class="value">Maishapay Mobile Money</td>
                </tr>
                <tr class="total-row">
                  <td class="label" style="font-weight: bold; color: #4A148C;">Montant total versé :</td>
                  <td class="value" style="font-size: 18px; color: #2e7d32;">$montant $devise</td>
                </tr>
              </table>

              <div class="verse">
                « Que chacun donne comme il l'a résolu en son cœur, sans tristesse ni contrainte; car Dieu aime celui qui donne avec joie. »<br>
                <strong>— 2 Corinthiens 9:7</strong>
              </div>
            </div>
            <div class="footer">
              <p>Département des Finances & Trésorerie EECC<br>&copy; ${DateTime.now().year} Église EECC.</p>
            </div>
          </div>
        </body>
        </html>
        ''',
      };

      final response = await http.post(
        Uri.parse(_brevoEmailUrl),
        headers: _headers,
        body: jsonEncode(payload),
      );

      return response.statusCode == 201 || response.statusCode == 200;
    } catch (e) {
      debugPrint('[Brevo] Erreur envoi reçu e-mail: $e');
      return false;
    }
  }

  /// Envoie un SMS court de confirmation d'offrande
  Future<bool> envoyerConfirmationOffrandeSms({
    required String numeroTelephone,
    required double montant,
    required String devise,
    required String typeOffrande,
    required String referencePaiement,
  }) async {
    try {
      final payload = {
        'sender': 'EECC',
        'recipient': numeroTelephone,
        'content':
            'EECC: Votre $typeOffrande de $montant $devise (Ref: $referencePaiement) a bien ete recue. Que le Seigneur vous benisse abondamment !',
        'type': 'transactional',
      };

      final response = await http.post(
        Uri.parse(_brevoSmsUrl),
        headers: _headers,
        body: jsonEncode(payload),
      );

      return response.statusCode == 201 || response.statusCode == 200;
    } catch (e) {
      debugPrint('[Brevo] Erreur envoi SMS reçu: $e');
      return false;
    }
  }
}
