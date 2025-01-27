class Usuario {
  int? id;
  String nome;
  String email;
  String senha;
  Usuario({this.id, required this.nome, required this.email, required this.senha});

  static Usuario fromJsonToUsuario(Map<String, dynamic> json) {
    return Usuario(
      id: json['id'],
      nome : json['nome'],
      email: json['email'],
      senha: json['senha']
    );
  } 

  static Map<String, dynamic> fromUsuarioToJson(Usuario usuario) {
    return {
      'id': usuario.id,
      'nome': usuario.nome,
      'email': usuario.email,
      'senha': usuario.senha
    };
  }
}