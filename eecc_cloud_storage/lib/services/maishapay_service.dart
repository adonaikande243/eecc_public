import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:uuid/uuid.dart';
import '../config/eecc_api_config.dart';
import 'brevo_notification_service.dart';
import 'eecc_supabase_service.dart';

enum ModePaiementMaishapay {
  mpesa,
  airtelMoney,
  orangeMoney,
  carteBancaire,
  visa,
  mastercard,
}

class ResultatPaiementMaishapay {
  final bool succes;
  final String reference;
  final String message;
  final String? paymentUrl;
  final Map<String, dynamic>? donnees;

  ResultatPaiementMaishapay({
    required this.succes,
    required this.reference,
    required this.message,
    this.paymentUrl,
    this.donnees,
  });
}

/// Service réel d'intégration de Maishapay pour le paiement des Dîmes, Offrandes et Dons
class MaishapayService {
  static final MaishapayService _instance = MaishapayService._internal();
  factory MaishapayService() => _instance;
  MaishapayService._internal();

  static const String _maishapayApiUrl = 'https://api.maishapay.online/v1/payments';

  final BrevoNotificationService _brevoService = BrevoNotificationService();

  /// Initie et traite le paiement d'une offrande ou d'une dîme
  Future<ResultatPaiementMaishapay> traiterOffrande({
    required double montant,
    required String devise, // 'USD' ou 'CDF'
    required String typeOffrande, // 'Dîme', 'Offrande ordinaire', 'Don de construction', etc.
    required String nomFidele,
    required String telephone,
    required String email,
    required ModePaiementMaishapay mode,
  }) async {
    final reference = 'EECC-${DateTime.now().year}-${const Uuid().v4().substring(0, 8).toUpperCase()}';

    try {
      final payload = {
        'public_key': EeccApiConfig.maishapayPublicKey,
        'secret_key': EeccApiConfig.maishapaySecretKey,
        'transaction_reference': reference,
        'amount': montant,
        'currency': devise,
        'channel': _obtenirCodeCanal(mode),
        'customer': {
          'name': nomFidele,
          'phone': telephone,
          'email': email,
        },
        'description': '$typeOffrande - Église EECC',
        'callback_url': 'https://ywbtdvlsbzmiedxydepl.supabase.co/rest/v1/rpc/maishapay_webhook',
      };

      debugPrint('[Maishapay] Lancement transaction $reference pour $montant $devise...');

      final response = await http.post(
        Uri.parse(_maishapayApiUrl),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
          'Authorization': 'Bearer ${EeccApiConfig.maishapaySecretKey}',
        },
        body: jsonEncode(payload),
      );

      final Map<String, dynamic> resData = response.statusCode == 200 || response.statusCode == 201
          ? jsonDecode(response.body)
          : {};

      // Si l'API renvoie succès ou status 'success'/'pending'
      final isSuccess = response.statusCode == 200 ||
          response.statusCode == 201 ||
          resData['status'] == 'success' ||
          resData['success'] == true;

      if (isSuccess) {
        // 1. Enregistrement dans Supabase
        await _enregistrerDansSupabase(
          reference: reference,
          montant: montant,
          devise: devise,
          typeOffrande: typeOffrande,
          nomFidele: nomFidele,
          telephone: telephone,
          email: email,
          statut: 'VALIDE',
        );

        // 2. Envoi automatique du reçu officiel par e-mail via Brevo
        if (email.isNotEmpty && email.contains('@')) {
          await _brevoService.envoyerRecuOffrandeEmail(
            destinataireEmail: email,
            nomFidele: nomFidele,
            montant: montant,
            devise: devise,
            typeOffrande: typeOffrande,
            referencePaiement: reference,
            datePaiement: DateTime.now(),
          );
        }

        // 3. Envoi du SMS de confirmation via Brevo
        if (telephone.isNotEmpty) {
          await _brevoService.envoyerConfirmationOffrandeSms(
            numeroTelephone: telephone,
            montant: montant,
            devise: devise,
            typeOffrande: typeOffrande,
            referencePaiement: reference,
          );
        }

        return ResultatPaiementMaishapay(
          succes: true,
          reference: reference,
          message: 'Paiement effectué avec succès ! Le reçu a été envoyé par e-mail et SMS.',
          paymentUrl: resData['payment_url'],
          donnees: resData,
        );
      } else {
        final errorMsg = resData['message'] ?? 'Erreur lors du traitement par l\'opérateur mobile.';
        debugPrint('[Maishapay] Échec paiement: $errorMsg');
        return ResultatPaiementMaishapay(
          succes: false,
          reference: reference,
          message: errorMsg,
          donnees: resData,
        );
      }
    } catch (e) {
      debugPrint('[Maishapay] Exception paiement: $e');
      // Pour assurer la continuité du culte même en cas de coupure réseau gateway, on journalise
      return ResultatPaiementMaishapay(
        succes: false,
        reference: reference,
        message: 'Impossible de contacter Maishapay: $e',
      );
    }
  }

  String _obtenirCodeCanal(ModePaiementMaishapay mode) {
    switch (mode) {
      case ModePaiementMaishapay.mpesa:
        return 'MPESA';
      case ModePaiementMaishapay.airtelMoney:
        return 'AIRTEL_MONEY';
      case ModePaiementMaishapay.orangeMoney:
        return 'ORANGE_MONEY';
      case ModePaiementMaishapay.visa:
        return 'VISA';
      case ModePaiementMaishapay.mastercard:
        return 'MASTERCARD';
      case ModePaiementMaishapay.carteBancaire:
        return 'CARD';
    }
  }

  Future<void> _enregistrerDansSupabase({
    required String reference,
    required double montant,
    required String devise,
    required String typeOffrande,
    required String nomFidele,
    required String telephone,
    required String email,
    required String statut,
  }) async {
    try {
      final url = Uri.parse('${EeccApiConfig.supabaseUrl}/rest/v1/eecc_offrandes');
      await http.post(
        url,
        headers: {
          'Content-Type': 'application/json',
          'apikey': EeccApiConfig.supabaseServiceRoleKey,
          'Authorization': 'Bearer ${EeccApiConfig.supabaseServiceRoleKey}',
          'Prefer': 'return=minimal',
        },
        body: jsonEncode({
          'reference': reference,
          'montant': montant,
          'devise': devise,
          'type_offrande': typeOffrande,
          'nom_fidele': nomFidele,
          'telephone': telephone,
          'email': email,
          'statut': statut,
          'created_at': DateTime.now().toIso8601String(),
        }),
      );
    } catch (e) {
      debugPrint('[Supabase] Erreur enregistrement offrande: $e');
    }
  }
}
