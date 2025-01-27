class Endereco {
  int? id;
  String cep;
  String logradouro;
  String bairro;
  String localidade;
  String uf;
  String estado;

  Endereco({this.id, required this.cep, required this.logradouro, required this.bairro, required this.localidade, required this.uf, required this.estado});

  static Endereco fromJsonToEndereco(Map<String, dynamic> json){
    return Endereco(
      id: json['id'],
      cep: json['cep'],
      logradouro: json['logradouro'],
      bairro: json['bairro'],
      localidade: json['localidade'],
      uf: json['uf'],
      estado: json['estado']
    );
  }

  static Map<String, dynamic> fromEnderecoToJson(Endereco endereco){
    return {
      'id': endereco.id,
      'cep': endereco.cep,
      'logradouro': endereco.logradouro,
      'bairro': endereco.bairro,
      'localidade': endereco.localidade,
      'uf': endereco.uf,
      'estado': endereco.estado
    };
  }
}