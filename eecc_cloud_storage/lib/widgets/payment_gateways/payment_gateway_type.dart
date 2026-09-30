import 'package:flutter/material.dart';

/// Types d'agrégateurs de paiement supportés dans l'écosystème EECC
enum PaymentGatewayType {
  mpesa,
  airtelMoney,
  orangeMoney,
  visa,
  mastercard,
}

/// Métadonnées et informations officielles de chaque agrégateur
class PaymentGatewayInfo {
  final PaymentGatewayType type;
  final String nom;
  final String sousTitre;
  final Color couleurPrimaire;
  final Color couleurSecondaire;
  final bool estCarteBancaire;
  final String codeCanalMaishapay;
  final String indicatifOperateur;

  const PaymentGatewayInfo({
    required this.type,
    required this.nom,
    required this.sousTitre,
    required this.couleurPrimaire,
    required this.couleurSecondaire,
    required this.estCarteBancaire,
    required this.codeCanalMaishapay,
    required this.indicatifOperateur,
  });

  static const Map<PaymentGatewayType, PaymentGatewayInfo> passerelles = {
    PaymentGatewayType.mpesa: PaymentGatewayInfo(
      type: PaymentGatewayType.mpesa,
      nom: 'M-Pesa',
      sousTitre: 'Vodacom RDC (081, 082, 083)',
      couleurPrimaire: Color(0xFF007A3D), // Vert officiel M-Pesa
      couleurSecondaire: Color(0xFFE60000), // Rouge Vodacom
      estCarteBancaire: false,
      codeCanalMaishapay: 'MPESA',
      indicatifOperateur: '081/082/083',
    ),
    PaymentGatewayType.airtelMoney: PaymentGatewayInfo(
      type: PaymentGatewayType.airtelMoney,
      nom: 'Airtel Money',
      sousTitre: 'Airtel RDC (097, 098, 099)',
      couleurPrimaire: Color(0xFFED1C24), // Rouge officiel Airtel
      couleurSecondaire: Color(0xFFB71C1C),
      estCarteBancaire: false,
      codeCanalMaishapay: 'AIRTEL_MONEY',
      indicatifOperateur: '097/098/099',
    ),
    PaymentGatewayType.orangeMoney: PaymentGatewayInfo(
      type: PaymentGatewayType.orangeMoney,
      nom: 'Orange Money',
      sousTitre: 'Orange RDC (084, 085, 089)',
      couleurPrimaire: Color(0xFFFF6600), // Orange officiel Orange
      couleurSecondaire: Color(0xFF1E1E1E),
      estCarteBancaire: false,
      codeCanalMaishapay: 'ORANGE_MONEY',
      indicatifOperateur: '084/085/089',
    ),
    PaymentGatewayType.visa: PaymentGatewayInfo(
      type: PaymentGatewayType.visa,
      nom: 'Visa Card',
      sousTitre: 'Débit / Crédit International',
      couleurPrimaire: Color(0xFF1A1F71), // Bleu officiel Visa
      couleurSecondaire: Color(0xFFF7B600), // Doré Visa
      estCarteBancaire: true,
      codeCanalMaishapay: 'VISA',
      indicatifOperateur: 'Numéro à 16 chiffres',
    ),
    PaymentGatewayType.mastercard: PaymentGatewayInfo(
      type: PaymentGatewayType.mastercard,
      nom: 'MasterCard',
      sousTitre: 'Paiement Sécurisé Mondial',
      couleurPrimaire: Color(0xFFEB001B), // Rouge officiel Mastercard
      couleurSecondaire: Color(0xFFF79E1B), // Orange Mastercard
      estCarteBancaire: true,
      codeCanalMaishapay: 'MASTERCARD',
      indicatifOperateur: 'Numéro à 16 chiffres',
    ),
  };
}
