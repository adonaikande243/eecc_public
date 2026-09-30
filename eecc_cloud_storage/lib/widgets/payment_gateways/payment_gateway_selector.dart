import 'package:flutter/material.dart';
import 'payment_gateway_type.dart';
import 'payment_gateway_logos.dart';

/// Sélecteur officiel et séparé des agrégateurs de paiement pour tout l'écosystème EECC
class PaymentGatewaySelector extends StatelessWidget {
  final PaymentGatewayType selectionActuelle;
  final ValueChanged<PaymentGatewayType> onSelectionChange;

  const PaymentGatewaySelector({
    Key? key,
    required this.selectionActuelle,
    required this.onSelectionChange,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // --- 1. SOUS-GROUPE : MOBILE MONEY RDC ---
        Row(
          children: const [
            Icon(Icons.phone_android, size: 16, color: Colors.blueGrey),
            SizedBox(width: 6),
            Text(
              'MOBILE MONEY (RDC)',
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.bold,
                color: Colors.blueGrey,
                letterSpacing: 0.8,
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        Row(
          children: [
            Expanded(child: _buildItem(PaymentGatewayType.mpesa)),
            const SizedBox(width: 8),
            Expanded(child: _buildItem(PaymentGatewayType.airtelMoney)),
            const SizedBox(width: 8),
            Expanded(child: _buildItem(PaymentGatewayType.orangeMoney)),
          ],
        ),

        const SizedBox(height: 16),

        // --- 2. SOUS-GROUPE : CARTES INTERNATIONALES ---
        Row(
          children: const [
            Icon(Icons.credit_card, size: 16, color: Colors.blueGrey),
            SizedBox(width: 6),
            Text(
              'CARTES BANCAIRES & INTERNATIONAL',
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.bold,
                color: Colors.blueGrey,
                letterSpacing: 0.8,
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        Row(
          children: [
            Expanded(child: _buildItem(PaymentGatewayType.visa)),
            const SizedBox(width: 8),
            Expanded(child: _buildItem(PaymentGatewayType.mastercard)),
          ],
        ),
      ],
    );
  }

  Widget _buildItem(PaymentGatewayType type) {
    final info = PaymentGatewayInfo.passerelles[type]!;
    final estSelectionne = selectionActuelle == type;

    return InkWell(
      onTap: () => onSelectionChange(type),
      borderRadius: BorderRadius.circular(12),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 10),
        decoration: BoxDecoration(
          color: estSelectionne ? info.couleurPrimaire.withOpacity(0.06) : Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: estSelectionne ? info.couleurPrimaire : Colors.grey.shade300,
            width: estSelectionne ? 2.2 : 1.0,
          ),
          boxShadow: [
            if (estSelectionne)
              BoxShadow(
                color: info.couleurPrimaire.withOpacity(0.18),
                blurRadius: 8,
                offset: const Offset(0, 3),
              )
            else
              BoxShadow(
                color: Colors.black.withOpacity(0.02),
                blurRadius: 3,
                offset: const Offset(0, 1),
              ),
          ],
        ),
        child: Column(
          children: [
            // Logo officiel
            PaymentGatewayLogo(type: type, width: 56, height: 34),
            const SizedBox(height: 6),
            // Nom de l'agrégateur
            Text(
              info.nom,
              style: TextStyle(
                fontSize: 12,
                fontWeight: estSelectionne ? FontWeight.bold : FontWeight.w600,
                color: estSelectionne ? info.couleurPrimaire : Colors.black87,
              ),
              textAlign: TextAlign.center,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(height: 2),
            // Indicateur de sélection
            Container(
              width: 8,
              height: 8,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: estSelectionne ? info.couleurPrimaire : Colors.transparent,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
