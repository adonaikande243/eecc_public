import 'package:flutter/material.dart';
import 'payment_gateway_type.dart';

/// Logos officiels haute définition des agrégateurs de paiement
class PaymentGatewayLogo extends StatelessWidget {
  final PaymentGatewayType type;
  final double width;
  final double height;

  const PaymentGatewayLogo({
    Key? key,
    required this.type,
    this.width = 64,
    this.height = 42,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    switch (type) {
      case PaymentGatewayType.mpesa:
        return _buildMpesaLogo();
      case PaymentGatewayType.airtelMoney:
        return _buildAirtelMoneyLogo();
      case PaymentGatewayType.orangeMoney:
        return _buildOrangeMoneyLogo();
      case PaymentGatewayType.visa:
        return _buildVisaLogo();
      case PaymentGatewayType.mastercard:
        return _buildMastercardLogo();
    }
  }

  // ===========================================================================
  // 1. LOGO OFFICIEL M-PESA (Vodacom)
  // ===========================================================================
  Widget _buildMpesaLogo() {
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        color: const Color(0xFF007A3D), // Vert officiel M-Pesa
        borderRadius: BorderRadius.circular(8),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Stack(
        alignment: Alignment.center,
        children: [
          // Accent rouge Vodacom en arrière-plan
          Positioned(
            right: 0,
            top: 0,
            bottom: 0,
            width: width * 0.28,
            child: Container(
              decoration: const BoxDecoration(
                color: Color(0xFFE60000), // Rouge Vodacom
                borderRadius: BorderRadius.only(
                  topRight: Radius.circular(8),
                  bottomRight: Radius.circular(8),
                  topLeft: Radius.circular(16),
                  bottomLeft: Radius.circular(16),
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 6),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: const [
                Text(
                  'M-PESA',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w900,
                    fontSize: 11,
                    letterSpacing: 0.8,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ===========================================================================
  // 2. LOGO OFFICIEL AIRTEL MONEY
  // ===========================================================================
  Widget _buildAirtelMoneyLogo() {
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        color: const Color(0xFFED1C24), // Rouge officiel Airtel
        borderRadius: BorderRadius.circular(8),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFFED1C24).withOpacity(0.2),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 3),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: const [
          Text(
            'airtel',
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.w900,
              fontSize: 12,
              letterSpacing: -0.5,
              height: 1.0,
            ),
          ),
          SizedBox(height: 2),
          Text(
            'money',
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 9,
              letterSpacing: 0.5,
              height: 1.0,
            ),
          ),
        ],
      ),
    );
  }

  // ===========================================================================
  // 3. LOGO OFFICIEL ORANGE MONEY
  // ===========================================================================
  Widget _buildOrangeMoneyLogo() {
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        color: const Color(0xFFFF6600), // Orange officiel
        borderRadius: BorderRadius.circular(8),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFFFF6600).withOpacity(0.25),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 3),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text(
            'orange',
            style: TextStyle(
              color: Colors.black87,
              fontWeight: FontWeight.w900,
              fontSize: 10,
              height: 1.0,
            ),
          ),
          const SizedBox(height: 3),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 1),
            decoration: BoxDecoration(
              color: Colors.black87,
              borderRadius: BorderRadius.circular(3),
            ),
            child: const Text(
              'money',
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 8,
                letterSpacing: 0.5,
                height: 1.0,
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ===========================================================================
  // 4. LOGO OFFICIEL VISA
  // ===========================================================================
  Widget _buildVisaLogo() {
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: const Color(0xFF1A1F71).withOpacity(0.2), width: 1.2),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 3,
            offset: const Offset(0, 1),
          ),
        ],
      ),
      child: Center(
        child: RichText(
          text: const TextSpan(
            children: [
              TextSpan(
                text: 'V',
                style: TextStyle(
                  color: Color(0xFF1A1F71), // Bleu Visa
                  fontWeight: FontWeight.w900,
                  fontSize: 16,
                  fontStyle: FontStyle.italic,
                  letterSpacing: -1,
                ),
              ),
              TextSpan(
                text: 'ISA',
                style: TextStyle(
                  color: Color(0xFF1A1F71),
                  fontWeight: FontWeight.w900,
                  fontSize: 15,
                  fontStyle: FontStyle.italic,
                  letterSpacing: 0.5,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // ===========================================================================
  // 5. LOGO OFFICIEL MASTERCARD
  // ===========================================================================
  Widget _buildMastercardLogo() {
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        color: const Color(0xFF1F1F1F), // Fond sombre premium pour faire ressortir les cercles
        borderRadius: BorderRadius.circular(8),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.15),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 3),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Deux cercles imbriqués officiels Mastercard
          SizedBox(
            height: 18,
            width: 32,
            child: Stack(
              children: [
                // Cercle rouge à gauche
                Positioned(
                  left: 2,
                  child: Container(
                    width: 17,
                    height: 17,
                    decoration: const BoxDecoration(
                      shape: BoxShape.circle,
                      color: Color(0xFFEB001B), // Rouge officiel
                    ),
                  ),
                ),
                // Cercle orange à droite
                Positioned(
                  right: 2,
                  child: Container(
                    width: 17,
                    height: 17,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: const Color(0xFFF79E1B).withOpacity(0.92), // Jaune-Orange officiel
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 2),
          const Text(
            'mastercard',
            style: TextStyle(
              color: Colors.white,
              fontSize: 7,
              fontWeight: FontWeight.bold,
              letterSpacing: 0.2,
              height: 1.0,
            ),
          ),
        ],
      ),
    );
  }
}
