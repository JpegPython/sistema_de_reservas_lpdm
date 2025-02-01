import 'package:booking_app/servicos/dataBase.dart';

class Reservaservice {

    static Future<int> deletarReservasAssociadaPropriedade(int propriedadeId) async {
    final db = await DatabaseService.getDB();
    return await db.delete(
      'booking',
      where: 'property_id = ?',
      whereArgs: [propriedadeId],
    );
  }
}