import 'package:flutter/material.dart';
import 'payment_gateway_type.dart';

/// Formulaire de saisie dynamique adapté à l'agrégateur sélectionné (Mobile Money vs Carte Bancaire)
class PaymentGatewayFormFields extends StatelessWidget {
  final PaymentGatewayType gatewayType;
  final TextEditingController telephoneController;
  final TextEditingController? numeroCarteController;
  final TextEditingController? expirationCarteController;
  final TextEditingController? cvcCarteController;
  final TextEditingController? nomTitulaireCarteController;

  const PaymentGatewayFormFields({
    Key? key,
    required this.gatewayType,
    required this.telephoneController,
    this.numeroCarteController,
    this.expirationCarteController,
    this.cvcCarteController,
    this.nomTitulaireCarteController,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final info = PaymentGatewayInfo.passerelles[gatewayType]!;

    if (info.estCarteBancaire) {
      return _buildFormulaireCarte(context, info);
    } else {
      return _buildFormulaireMobileMoney(context, info);
    }
  }

  // ===========================================================================
  // FORMULAIRE MOBILE MONEY (M-Pesa, Airtel Money, Orange Money)
  // ===========================================================================
  Widget _buildFormulaireMobileMoney(BuildContext context, PaymentGatewayInfo info) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: info.couleurPrimaire.withOpacity(0.04),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: info.couleurPrimaire.withOpacity(0.3)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.phonelink_ring, size: 18, color: info.couleurPrimaire),
              const SizedBox(width: 8),
              Text(
                'Numéro de compte ${info.nom}',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 14,
                  color: info.couleurPrimaire,
                ),
              ),
              const Spacer(),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                decoration: BoxDecoration(
                  color: info.couleurPrimaire,
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Text(
                  info.indicatifOperateur,
                  style: const TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.bold),
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          TextFormField(
            controller: telephoneController,
            keyboardType: TextInputType.phone,
            decoration: InputDecoration(
              labelText: 'Numéro de téléphone (+243)',
              hintText: 'Ex: 0812345678 ou +243812345678',
              prefixIcon: Icon(Icons.phone_android, color: info.couleurPrimaire),
              border: const OutlineInputBorder(),
              filled: true,
              fillColor: Colors.white,
            ),
            validator: (val) {
              if (val == null || val.trim().isEmpty) {
                return 'Veuillez saisir votre numéro ${info.nom}';
              }
              final clean = val.replaceAll(' ', '').replaceAll('-', '');
              if (clean.length < 9) {
                return 'Numéro de téléphone incomplet';
              }
              return null;
            },
          ),
          const SizedBox(height: 6),
          Text(
            'Un message de confirmation USSD apparaîtra sur votre téléphone pour valider avec votre code secret.',
            style: TextStyle(fontSize: 11, color: Colors.grey.shade600, fontStyle: FontStyle.italic),
          ),
        ],
      ),
    );
  }

  // ===========================================================================
  // FORMULAIRE CARTE BANCAIRE (Visa, MasterCard)
  // ===========================================================================
  Widget _buildFormulaireCarte(BuildContext context, PaymentGatewayInfo info) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: const Color(0xFFFAFAFA),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: info.couleurPrimaire.withOpacity(0.3)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.lock, size: 16, color: info.couleurPrimaire),
              const SizedBox(width: 8),
              Text(
                'Paiement sécurisé par ${info.nom}',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 14,
                  color: info.couleurPrimaire,
                ),
              ),
              const Spacer(),
              const Icon(Icons.verified_user, size: 16, color: Colors.green),
              const SizedBox(width: 4),
              const Text('SSL 256-bit', style: TextStyle(fontSize: 10, color: Colors.green, fontWeight: FontWeight.bold)),
            ],
          ),
          const SizedBox(height: 12),
          // Nom sur la carte
          if (nomTitulaireCarteController != null)
            TextFormField(
              controller: nomTitulaireCarteController,
              textCapitalization: TextCapitalization.characters,
              decoration: InputDecoration(
                labelText: 'Nom du titulaire (sur la carte)',
                hintText: 'EX: JEAN KABAMBA',
                prefixIcon: Icon(Icons.person_outline, color: info.couleurPrimaire),
                border: const OutlineInputBorder(),
                filled: true,
                fillColor: Colors.white,
              ),
              validator: (val) {
                if (val == null || val.trim().isEmpty) return 'Nom du titulaire obligatoire';
                return null;
              },
            ),
          const SizedBox(height: 10),
          // Numéro de carte
          TextFormField(
            controller: numeroCarteController,
            keyboardType: TextInputType.number,
            maxLength: 19,
            decoration: InputDecoration(
              labelText: 'Numéro de carte (16 chiffres)',
              hintText: '4000 1234 5678 9010',
              prefixIcon: Icon(Icons.credit_card, color: info.couleurPrimaire),
              border: const OutlineInputBorder(),
              filled: true,
              fillColor: Colors.white,
              counterText: '',
            ),
            validator: (val) {
              if (val == null || val.trim().isEmpty) return 'Numéro de carte obligatoire';
              final clean = val.replaceAll(' ', '');
              if (clean.length < 16) return 'Le numéro doit comporter 16 chiffres';
              return null;
            },
          ),
          const SizedBox(height: 10),
          // Date d'expiration et CVC
          Row(
            children: [
              Expanded(
                child: TextFormField(
                  controller: expirationCarteController,
                  keyboardType: TextInputType.datetime,
                  maxLength: 5,
                  decoration: const InputDecoration(
                    labelText: 'Expiration',
                    hintText: 'MM/AA',
                    prefixIcon: Icon(Icons.calendar_today, size: 18),
                    border: OutlineInputBorder(),
                    filled: true,
                    fillColor: Colors.white,
                    counterText: '',
                  ),
                  validator: (val) {
                    if (val == null || val.trim().isEmpty) return 'MM/AA requis';
                    return null;
                  },
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: TextFormField(
                  controller: cvcCarteController,
                  keyboardType: TextInputType.number,
                  obscureText: true,
                  maxLength: 4,
                  decoration: const InputDecoration(
                    labelText: 'CVC / CVV',
                    hintText: '123',
                    prefixIcon: Icon(Icons.security, size: 18),
                    border: OutlineInputBorder(),
                    filled: true,
                    fillColor: Colors.white,
                    counterText: '',
                  ),
                  validator: (val) {
                    if (val == null || val.trim().isEmpty) return 'CVC requis';
                    return null;
                  },
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
