import 'package:booking_app_user/modelos/propriedade.dart';
import 'package:booking_app_user/servicos/dataBase.dart';

class Propriedadeservice {
  
  static Future<List<Propriedade>> buscarTodasPropriedadesDisponiveis() async {
    List<Propriedade> propriedades = [];
    final db = await DatabaseService.getDB();
     final List<Map<String, dynamic>> result = await db.rawQuery(
      '''
      SELECT property.* FROM property 
      LEFT JOIN booking ON property.id = booking.property_id
      WHERE booking.property_id IS NULL
      '''
    );

    if (result.isNotEmpty) {
      for (var propriedade in result) {
        propriedades.add(Propriedade.fromJsonToPropriedade(propriedade));
      }
    }
    return propriedades;
  }



}
