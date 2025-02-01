import 'package:booking_app_user/modelos/propriedade.dart';
import 'package:booking_app_user/servicos/dataBase.dart';

class Propriedadeservice {
  static Future<List<Propriedade>>
      buscarTodasPropriedadesComMaiorRating() async {
    List<Propriedade> propriedades = [];
    final db = await DatabaseService.getDB();
    final List<Map<String, dynamic>> result = await db.rawQuery('''
      SELECT property.*, COALESCE(AVG(booking.rating), 0) AS avg_rating
      FROM property
      LEFT JOIN booking ON property.id = booking.property_id
      GROUP BY property.id
      ORDER BY avg_rating DESC
      ''');

    if (result.isNotEmpty) {
      for (var propriedade in result) {
        propriedades.add(Propriedade.fromJsonToPropriedade(propriedade));
      }
    }
    return propriedades;
  }

  static Future<Propriedade> buscarPropriedadePorId(int property_id) async {
    final db = await DatabaseService.getDB();
    final List<Map<String, dynamic>> result = await db.rawQuery('''
      SELECT property.*
      FROM property
      LEFT JOIN booking ON property.id = booking.property_id
      where property.id = ?
      ''', [property_id]);
    return Propriedade.fromJsonToPropriedade(result.first);
  }
}
