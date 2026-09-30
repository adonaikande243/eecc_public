import 'package:flutter/material.dart';
import '../../theme/eecc_theme.dart';

class OffrandeScreen extends StatelessWidget {
  const OffrandeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Offrandes MaishaPay')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            DropdownButtonFormField<String>(
              decoration: const InputDecoration(labelText: 'Type d\'offrande'),
              items: const [
                DropdownMenuItem(value: 'dime', child: Text('Dîme')),
                DropdownMenuItem(value: 'action_de_grace', child: Text('Action de grâce')),
                DropdownMenuItem(value: 'construction', child: Text('Construction')),
              ],
              onChanged: (value) {},
            ),
            const SizedBox(height: 16),
            const TextField(
              keyboardType: TextInputType.number,
              decoration: InputDecoration(labelText: 'Montant', suffixText: 'USD'),
            ),
            const Spacer(),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: EeccTheme.dore,
                foregroundColor: EeccTheme.violet,
                minimumSize: const Size(double.infinity, 50),
              ),
              onPressed: () {},
              child: const Text('Confirmer avec MaishaPay'),
            )
          ],
        ),
      ),
    );
  }
}
