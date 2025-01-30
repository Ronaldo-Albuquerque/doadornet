import 'package:flutter/material.dart';
import 'models/doador.dart';
import 'services/doador_service.dart';
import 'widgets/doador_card.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'DoadorNet',
      home: DoadorListScreen(),
    );
  }
}

class DoadorListScreen extends StatefulWidget {
  @override
  _DoadorListScreenState createState() => _DoadorListScreenState();
}

class _DoadorListScreenState extends State<DoadorListScreen> {
  final DoadorService _doadorService = DoadorService();
  late Future<List<Doador>> _doadores;

  @override
  void initState() {
    super.initState();
    _doadores = _doadorService.fetchDoadores();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Lista de Doadores')),
      body: FutureBuilder<List<Doador>>(
        future: _doadores,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Erro: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('Nenhum doador encontrado'));
          }

          return ListView.builder(
            itemCount: snapshot.data!.length,
            itemBuilder: (context, index) {
              return DoadorCard(doador: snapshot.data![index]);
            },
          );
        },
      ),
    );
  }
}
