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

static Future<List<Propriedade>> buscarPropriedadesDisponiveis(
    DateTime checkIn, DateTime checkOut) async {
  
  //Regra: Check-out deve ser após o Check-in
  if (checkOut.isBefore(checkIn) || checkOut.isAtSameMomentAs(checkIn)) {
    throw Exception("A data de check-out deve ser posterior à data de check-in.");
  }

  List<Propriedade> propriedades = [];
  final db = await DatabaseService.getDB();

  final List<Map<String, dynamic>> result = await db.rawQuery('''
    SELECT DISTINCT p.*
    FROM property p
    WHERE NOT EXISTS (
        SELECT 1 FROM booking b
        WHERE b.property_id = p.id
        AND (
            (b.checkin_date <= ? AND b.checkout_date >= ?) -- Check-in dentro de reserva existente
            OR (b.checkin_date <= ? AND b.checkout_date >= ?) -- Check-out dentro de reserva existente
            OR (b.checkin_date >= ? AND b.checkout_date <= ?) -- Reserva totalmente dentro do intervalo
        )
    )
    ORDER BY (SELECT COALESCE(AVG(b.rating), 0) FROM booking b WHERE b.property_id = p.id) DESC
  ''', [
    checkOut.toIso8601String(),
    checkIn.toIso8601String(),
    checkOut.toIso8601String(),
    checkIn.toIso8601String(),
    checkIn.toIso8601String(),
    checkOut.toIso8601String(),
  ]);

  if (result.isNotEmpty) {
    for (var propriedade in result) {
      propriedades.add(Propriedade.fromJsonToPropriedade(propriedade));
    }
  }

  return propriedades;
  }
}
