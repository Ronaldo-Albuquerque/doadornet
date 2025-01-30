import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/doador.dart';

class DoadorService {
  final String apiUrl = 'http://seu-servidor.com/api/doadores';

  Future<List<Doador>> fetchDoadores() async {
    final response = await http.get(Uri.parse(apiUrl));

    if (response.statusCode == 200) {
      List<dynamic> jsonData = json.decode(response.body);
      return jsonData.map((json) => Doador.fromJson(json)).toList();
    } else {
      throw Exception('Falha ao carregar doadores');
    }
  }
}
