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

static Future<List<Propriedade>> buscarPropriedadesDisponiveis({
  DateTime? checkInDate,
  DateTime? checkOutDate,
  String? uf,
  String? cidade,
  String? bairro,
  int? maxHospedes,
}) async {
  // Verifica se as datas foram fornecidas e se são válidas
  if (checkInDate != null && checkOutDate != null) {
    if (checkOutDate.isBefore(checkInDate) || checkOutDate.isAtSameMomentAs(checkInDate)) {
      throw Exception("A data de check-out deve ser posterior à data de check-in.");
    }
  }

  List<Propriedade> propriedades = [];
  final db = await DatabaseService.getDB();

  // Consulta SQL base
  String query = '''
    SELECT DISTINCT p.*
    FROM property p
    JOIN address a ON p.address_id = a.id
    WHERE 1 = 1
  ''';

  // Lista de parâmetros para a consulta SQL
  List<dynamic> params = [];

  // Adiciona filtro de datas (se fornecido)
  if (checkInDate != null && checkOutDate != null) {
    query += '''
      AND NOT EXISTS (
          SELECT 1 FROM booking b
          WHERE b.property_id = p.id
          AND (
              (b.checkin_date <= ? AND b.checkout_date >= ?) -- Check-in dentro de reserva existente
              OR (b.checkin_date <= ? AND b.checkout_date >= ?) -- Check-out dentro de reserva existente
              OR (b.checkin_date >= ? AND b.checkout_date <= ?) -- Reserva totalmente dentro do intervalo
          )
      )
    ''';
    params.addAll([
      checkOutDate.toIso8601String(),
      checkInDate.toIso8601String(),
      checkOutDate.toIso8601String(),
      checkInDate.toIso8601String(),
      checkInDate.toIso8601String(),
      checkOutDate.toIso8601String(),
    ]);
  }

  // Adiciona filtros opcionais
  if (uf != null && uf.isNotEmpty) {
    query += ' AND a.uf = ?';
    params.add(uf);
  }

  if (cidade != null && cidade.isNotEmpty) {
    query += ' AND a.localidade = ?';
    params.add(cidade);
  }

  if (bairro != null && bairro.isNotEmpty) {
    query += ' AND a.bairro = ?';
    params.add(bairro);
  }

  if (maxHospedes != null && maxHospedes > 0) {
    query += ' AND p.max_guest >= ?';
    params.add(maxHospedes);
  }

  // Ordenação
  query += ' ORDER BY (SELECT COALESCE(AVG(b.rating), 0) FROM booking b WHERE b.property_id = p.id) DESC';

  // Executa a consulta
  final List<Map<String, dynamic>> result = await db.rawQuery(query, params);

  if (result.isNotEmpty) {
    for (var propriedade in result) {
      propriedades.add(Propriedade.fromJsonToPropriedade(propriedade));
    }
  }

  return propriedades;
}
  
}
