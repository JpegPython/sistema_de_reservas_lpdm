import 'dart:io';

import 'package:booking_app_user/modelos/image.dart';
import 'package:booking_app_user/servicos/dataBase.dart';

class Imagemservice {

  /// Insere uma nova imagem no banco de dados
  static Future<void> criarImagem(Map<String, dynamic> imagem) async {
    final db = await DatabaseService.getDB();
    await db.insert('images', imagem);
  }

  /// Remove todas as imagens associadas a uma propriedade
  static Future<int> apagarImagens(int idPropriedade) async {
    final db = await DatabaseService.getDB();
    return await db.delete(
      'images',
      where: 'property_id = ?',
      whereArgs: [idPropriedade],
    );
  }

  static Future<List<File>> pegarImagensPeloIdPropriedade(int idPropriedade) async {
    final db = await DatabaseService.getDB();

    // Consulta as imagens no banco de dados
    final List<Map<String, dynamic>> imagensJson = await db.query(
      'images',
      where: 'property_id = ?',
      whereArgs: [idPropriedade],
    );

    // Converte os dados JSON em objetos Imagem
    final List<Imagem> imagens = imagensJson.map((json) => Imagem.fromJsonToImage(json)).toList();

    // Converte os objetos Imagem em uma lista de File
    final List<File> arquivosDeImagem = imagens.map((imagem) => File(imagem.path)).toList();

    return arquivosDeImagem;
  }
}