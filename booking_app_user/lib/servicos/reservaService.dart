import 'package:booking_app_user/modelos/reserva.dart';
import 'package:booking_app_user/servicos/dataBase.dart';

class ReservaService{
  static void reservarPropriedade(Reserva reserva){
    
  }

  static void criarReserva(Map<String, dynamic> reserva) async {
    final db = await DatabaseService.getDB();
     await db.insert('booking', reserva);
  }

  static Future<List<Reserva>> buscarReservasUsuario(int user_id) async{
    List<Reserva> reservas = [];
    final db = await DatabaseService.getDB();
    final List<Map<String, dynamic>> result = await db.rawQuery(
      '''
      SELECT * FROM booking
      WHERE user_id = ?
      ''',
      [user_id]
    );
    if (result.isNotEmpty) {
    for (var reserva in result) {
      reservas.add(Reserva.fromJsonToReserva(reserva));
    }
  }
  return reservas;
  }
  
  static Future<bool> verificarConflitoDataEntreReservas(int property_id, String checkin, String checkout) async{
      final db = await DatabaseService.getDB();
      final List<Map<String, dynamic>> result = await db.rawQuery(
        '''
        SELECT 1 FROM booking
        WHERE property_id = ?
        AND (
          (? BETWEEN checkin_date AND checkout_date) OR
          (? BETWEEN checkin_date AND checkout_date) OR
          (checkin_date <= ? AND checkout_date >= ?)
        )
        LIMIT 1
        ''',
        [property_id, checkin, checkout, checkin, checkout]
      );
      return result.isNotEmpty;
  }
}