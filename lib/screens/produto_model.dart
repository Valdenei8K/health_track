class Produto {
  final String nomeProduto;
  final String numeroRegistro;
  final String razaoSocial;
  final String cnpj;
  final String numProcesso;
  final String dataAtualizacao;
  final String idPacienteProtegido; // Novo campo

  Produto({
    required this.nomeProduto,
    required this.numeroRegistro,
    required this.razaoSocial,
    required this.cnpj,
    required this.numProcesso,
    required this.dataAtualizacao,
    required this.idPacienteProtegido, // Inicialização do novo campo
  });

  // Método para criar um objeto Produto a partir de um mapa de dados
  factory Produto.fromJson(Map<String, dynamic> json) {
    return Produto(
      nomeProduto: json['nomeProduto'] ?? 'Não informado',
      numeroRegistro: json['numeroRegistro'] ?? 'Não informado',
      razaoSocial: json['razaoSocial'] ?? 'Não informado',
      cnpj: json['cnpj'] ?? 'Não informado',
      numProcesso: json['numProcesso'] ?? 'Não informado',
      dataAtualizacao: json['dataAtualizacao'] ?? 'Não informado',
      idPacienteProtegido: json['idBulaPacienteProtegido'] ?? 'Não informado', // Mapear o idBulaPacienteProtegido
    );
  }

  // Método para converter um objeto Produto em um mapa de dados (por exemplo, para envio para a API)
  Map<String, dynamic> toJson() {
    return {
      'nomeProduto': nomeProduto,
      'numeroRegistro': numeroRegistro,
      'razaoSocial': razaoSocial,
      'cnpj': cnpj,
      'numProcesso': numProcesso,
      'dataAtualizacao': dataAtualizacao,
      'idBulaPacienteProtegido': idPacienteProtegido, // Adicionando ao mapa
    };
  }
}
