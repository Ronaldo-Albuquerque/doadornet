class Doador {
  final int id;
  final String nome;
  final String tipoSanguineo;
  final String cidade;

  Doador({
    required this.id,
    required this.nome,
    required this.tipoSanguineo,
    required this.cidade,
  });

  factory Doador.fromJson(Map<String, dynamic> json) {
    return Doador(
      id: json['id'],
      nome: json['nome'],
      tipoSanguineo: json['tipoSanguineo'],
      cidade: json['cidade'],
    );
  }
}

