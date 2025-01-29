import 'package:booking_app/modelos/propriedade.dart';
import 'package:booking_app/servicos/dataBase.dart';

class Propriedadeservice {

  static void criarPropriedade(Map<String, dynamic> prorpiedade) async {
    final db = await DatabaseService.getDB();
    await db.insert('property', prorpiedade);
  }

  static Future<List<Propriedade>> buscarPropriedadesDeUsuario(int user_id) async{
    List<Propriedade> propriedades = [];
    final db = await DatabaseService.getDB();
     final List<Map<String, dynamic>> result = await db.rawQuery(
      'SELECT * FROM property WHERE user_id = ?',
      [user_id], 
    );

    if (result.isNotEmpty) {
      for(var propriedade in result){
        propriedades.add(Propriedade.fromJsonToPropriedade(propriedade));
      }
    } 
    return propriedades;
    
  }
}