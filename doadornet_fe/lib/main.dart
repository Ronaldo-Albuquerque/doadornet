import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'dart:io';
import 'dart:convert';

void main() {
  runApp(DoadorNetApp());
}

class DoadorNetApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Doador Net',
      theme: ThemeData(
        primarySwatch: Colors.red,
      ),
      home: HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _selectedIndex = 0;
  String _status = "Selecione um arquivo JSON";
  List<Widget> _cards = [];
  TextEditingController _serverController =
      TextEditingController(text: "192.168.2.103:8080");

  @override
  void initState() {
    super.initState();
    _resetInterface();
  }

  @override
  void dispose() {
    _serverController.dispose();
    super.dispose();
  }

  void _onItemTapped(int index) async {
    switch (index) {
      case 0:
        await _selectAndUploadJson();
        break;
      case 1:
        await _processFile();
        break;
      case 2:
        _resetInterface();
        break;
    }
  }

  String getBaseUrl() {
    String serverAddress = _serverController.text.trim();
    return serverAddress.isNotEmpty ? "http://$serverAddress/api" : "";
  }

  Future<void> _selectAndUploadJson() async {
    String baseUrl = getBaseUrl();
    _selectedIndex = 0;

    if (baseUrl.isEmpty) {
      setState(() {
        _status = "Por favor, insira o endereço do servidor.";
      });
      return;
    }

    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['json'],
    );

    if (result != null) {
      File file = File(result.files.single.path!);
      String content = await file.readAsString();

      setState(() {
        _status = "Enviando JSON...";
      });

      bool success = await _sendJsonToBackend(content, baseUrl);
    } else {
      setState(() {
        _status = "Nenhum arquivo selecionado";
      });
    }
  }

  Future<bool> _sendJsonToBackend(String jsonContent, String baseUrl) async {
    try {
      var url = Uri.parse("$baseUrl/doadores");
      var response = await http.post(
        url,
        headers: {"Content-Type": "application/json"},
        body: jsonContent,
      );

      if (response.statusCode == 200) {
        setState(() {
          _status = "Arquivo enviado com sucesso! Resposta: ${response.body}";
          print("Arquivo enviado com sucesso! Resposta: ${response.body}");
        });
        return true;
      } else {
        setState(() {
          _status = "Erro ao enviar arquivo. Resposta: ${response.body}";
          print("Erro ao enviar arquivo. Resposta: ${response.body}");
        });
        return false;
      }
    } catch (e) {
      print("Erro ao enviar JSON: $e");
      setState(() {
        _status = "Erro ao enviar JSON: $e";
      });
      return false;
    }
  }

  Future<void> _resetInterface() async {
    String baseUrl = getBaseUrl();
    _selectedIndex = 2;

    if (baseUrl.isEmpty) {
      setState(() {
        _status = "Por favor, insira o endereço do servidor.";
      });
      return;
    }

    try {
      var url = Uri.parse("$baseUrl/doadores");
      var response = await http.delete(url);

      if (response.statusCode == 200) {
        setState(() {
          _status =
              "Todos os registros foram excluídos!\nSelecione um arquivo JSON para realizar nova análise";
          _cards = [];
        });
      } else {
        setState(() {
          _status = "Erro ao excluir os registros.";
        });
      }
    } catch (e) {
      print("Erro ao excluir os registros: $e");
      setState(() {
        _status = "Erro na comunicação com a API.";
      });
    }
  }

  Future<void> _processFile() async {
    String baseUrl = getBaseUrl();
    _selectedIndex = 1;

    if (baseUrl.isEmpty) {
      setState(() {
        _status = "Por favor, insira o endereço do servidor.";
      });
      return;
    }

    try {
      var response = await http.get(Uri.parse("$baseUrl/doadores"));
      if (response.body.isEmpty) {
        setState(() {
          _status = "Resposta vazia da API.";
        });
        return;
      }
      print("Response body ${response.body}");

      if (response.statusCode == 200) {
        try {
          Map<String, dynamic> data = json.decode(response.body);
          _generateStatistics(data);
        } catch (e) {
          print("Erro na decodificação do JSON: $e");
          setState(() {
            _status = "Erro ao processar os dados.";
          });
        }
      } else {
        setState(() {
          _status = "Erro ao processar arquivo.";
        });
      }
    } catch (e) {
      setState(() {
        _status = "Erro na comunicação com a API.";
      });
    }
  }

  void _generateStatistics(Map<String, dynamic> data) {
    setState(() {
      _cards = [
        _buildCard("Quantidade de registros", data['totalRegistros']),
        _buildCard("Candidatos por Estado", data['candidatosPorEstado']),
        _buildCard("IMC Médio por Faixa Etária", data['imcPorFaixaEtaria']),
        _buildCard("Percentual de Obesos", data['percentualObesos']),
        _buildCard("Média de Idade por Tipo Sanguíneo", data['idadePorSangue']),
        _buildCard(
            "Possíveis Doadores por Tipo Sanguíneo", data['possiveisDoadores']),
      ];
    });
  }

  Widget _buildCard(String title, Map<String, dynamic> content) {
    Map<String, dynamic> contentMap = content;

    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      color: Colors.grey[200],
      child: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              title,
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              textAlign: TextAlign.start,
            ),
            SizedBox(height: 8),
            Table(
              border: TableBorder.all(),
              children: [
                for (var entry in contentMap.entries)
                  TableRow(
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(entry.key,
                            style: TextStyle(fontWeight: FontWeight.bold)),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(entry.value.toString()),
                      ),
                    ],
                  ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Doador Net"),
          centerTitle: true,
          backgroundColor: Colors.blue[200],
          actions: [
            IconButton(
              icon: Icon(Icons.info_outline),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => AboutPage()),
                );
              },
            ),
          ],
        ),
        body: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            SizedBox(height: 16),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.0),
              child: TextField(
                controller: _serverController,
                decoration: InputDecoration(
                  labelText: "Endereço do servidor (ex: 192.168.2.103:8080)",
                  border: OutlineInputBorder(),
                ),
              ),
            ),
            SizedBox(height: 16),
            Expanded(
              child: Center(
                child: _selectedIndex == 1 && _cards.isNotEmpty
                    ? ListView(
                        children: _cards,
                      )
                    : Text(
                        _status,
                        style: TextStyle(fontSize: 18, color: Colors.black),
                        textAlign: TextAlign.center,
                      ),
              ),
            ),
          ],
        ),
        bottomNavigationBar: BottomNavigationBar(
            items: [
              BottomNavigationBarItem(
                  icon: Icon(Icons.add), label: "Novo Json"),
              BottomNavigationBarItem(
                  icon: Icon(Icons.file_upload), label: "Processar Json"),
              BottomNavigationBarItem(
                  icon: Icon(Icons.delete), label: "Limpar"),
            ],
            currentIndex: _selectedIndex,
            onTap: _onItemTapped,
            selectedItemColor: Colors.red,
            backgroundColor: Colors.blue[200]));
  }
}

class AboutPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Sobre o Doador Net"),
        backgroundColor: Colors.blue[200],
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Doador Net",
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 16),
            Text(
              "Doador Net é um aplicativo para análise e processamento de arquivos JSON contendo dados de doadores de sangue.",
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(height: 16),
            Text(
              "Objetivo: Teste técnico WK Tecnologia - Conciste em BackEnd usando Spring boot e MySql, Frontend através deste app em Flutter.",
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(height: 16),
            Text(
              "Requisitos: Conforme PDF descrevendo teste técnico.",
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(height: 16),
            Text(
              "Funcionalidades:",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8),
            Text("✔ Seleção e envio de arquivos JSON"),
            Text("✔ Processamento e exibição de estatísticas"),
            Text("✔ Comunicação com um servidor para análise de dados"),
            SizedBox(height: 16),
            Text(
              "Desenvolvido por Ronaldo Albuquerque\n+55 41 996777138\nronaldo.aa@gmail.com",
              style: TextStyle(fontSize: 16, fontStyle: FontStyle.italic),
            ),
          ],
        ),
      ),
    );
  }
}
