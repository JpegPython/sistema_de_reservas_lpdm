import 'package:booking_app_user/modelos/usuario.dart';
import 'package:booking_app_user/servicos/dataBase.dart';

class Usuarioservice {
  static void criarUsuario(Map<String, dynamic> usuario) async {
    final db = await DatabaseService.getDB();
    await db.insert('user', usuario);
  }

  static Future<Usuario?> usuarioExiste(String username, String senha) async {
    final db = await DatabaseService.getDB();
    final List<Map<String, dynamic>> result = await db.rawQuery(
      'SELECT * FROM user WHERE name = ? AND password = ?',
      [username, senha], // Use parâmetros para evitar SQL Injection
    );

    if (result.isNotEmpty) {
      return Usuario.fromJsonToUsuario(result.first);
    } else {
      return null;
    }
  }
}
