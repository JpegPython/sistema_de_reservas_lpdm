import 'package:booking_app/modelos/propriedade.dart';
import 'package:booking_app/servicos/dataBase.dart';

class Propriedadeservice {
  static Future<int> criarPropriedade(Map<String, dynamic> propriedade) async {
    final db = await DatabaseService.getDB();
    return await db.insert('property', propriedade);
  }

  static Future<List<Propriedade>> buscarPropriedadesDeUsuario(int user_id) async {
    List<Propriedade> propriedades = [];
    final db = await DatabaseService.getDB();
    final List<Map<String, dynamic>> result = await db.rawQuery(
      'SELECT * FROM property WHERE user_id = ?',
      [user_id],
    );

    if (result.isNotEmpty) {
      for (var propriedade in result) {
        propriedades.add(Propriedade.fromJsonToPropriedade(propriedade));
      }
    }
    return propriedades;
  }

  static Future<int> deletarPropriedade(int propriedadeId) async {
    final db = await DatabaseService.getDB();
    return await db.delete(
      'property',
      where: 'id = ?',
      whereArgs: [propriedadeId],
    );
  }

  /// Atualiza uma propriedade no banco de dados pelo ID
  static Future<int> atualizarPropriedade(propriedade) async {
    final db = await DatabaseService.getDB();
    return await db.update(
      'property',
      Propriedade.fromPropriedadeToJson(propriedade),  // Dados novos
      where: 'id = ?',
      whereArgs: [propriedade.id],
    );
  }
}
