import 'package:booking_app/modelos/usuario.dart';
import 'package:booking_app/servicos/dataBase.dart';

class Usuarioservice {

  static void criarUsuario(Map<String, dynamic> usuario) async {
    final db = await DatabaseService.getDB();
    await db.insert('user', usuario);

  }

  static Usuario? usuarioExiste(String username, String senha){
    dynamic usuario = DatabaseService.getDB().then((db) async {
      List<Map<String, dynamic>> result = await db.rawQuery('''
        SELECT * FROM user WHERE name = '$username' AND password = '$senha'
      ''');
      return result;
    });

    if(usuario.isNotEmpty){
        return Usuario.fromJsonToUsuario(usuario);
      } else {
        return null;
      }
  }
}