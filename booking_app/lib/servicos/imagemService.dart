import 'package:booking_app/servicos/dataBase.dart';

class Imagemservice {
  
  static void criarImagem(Map<String, dynamic> imagem) async {
     final db = await DatabaseService.getDB();
    await db.insert('images', imagem);
  }
}