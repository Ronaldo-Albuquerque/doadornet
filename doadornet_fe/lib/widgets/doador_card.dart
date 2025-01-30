import 'package:flutter/material.dart';
import '../models/doador.dart';

class DoadorCard extends StatelessWidget {
  final Doador doador;

  const DoadorCard({Key? key, required this.doador}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.all(8.0),
      elevation: 3,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              doador.nome,
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text('Tipo Sanguíneo: ${doador.tipoSanguineo}'),
            Text('Cidade: ${doador.cidade}'),
          ],
        ),
      ),
    );
  }
}
