class Usuario {
  int? id;
  String name;
  String email;
  String password;
  Usuario({this.id, required this.name, required this.email, required this.password});

  static Usuario fromJsonToUsuario(Map<String, dynamic> json) {
    return Usuario(
      id: json['id'],
      name : json['name'],
      email: json['email'],
      password: json['password']
    );
  }

  static Map<String, dynamic> fromUsuarioToJson(Usuario usuario) {
    return {
      'id': usuario.id,
      'name': usuario.name,
      'email': usuario.email,
      'password': usuario.password
    };
  }


  // Entrar sem login
  static Usuario getUsuarioNaoLogado() {
    return Usuario(
        id: -1,
        name: "Usuário não está logado",
        email: "",
        password: ""
    );
  }
}