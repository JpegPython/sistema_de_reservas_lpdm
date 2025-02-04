import 'package:booking_app/modelos/endereco.dart';
import 'package:booking_app/servicos/dataBase.dart';

class Enderecoservice {
  static Future<Endereco?> buscarEndereco(String cep) async {
    final db = await DatabaseService.getDB();
    final List<Map<String, dynamic>> result = await db.rawQuery(
      'SELECT * FROM address WHERE cep = ?',
      [cep],
    );

    if (result.isNotEmpty) {
      return Endereco.fromJsonToEndereco(result.first);
    } else {
      return null;
    }
  }

  static Future<Endereco?> buscarEnderecoPorId(int addressId) async {
    final db = await DatabaseService.getDB();
    final List<Map<String, dynamic>> result = await db.rawQuery(
      'SELECT * FROM address WHERE id = ?',
      [addressId],
    );

    if (result.isNotEmpty) {
      return Endereco.fromJsonToEndereco(result.first);
    } else {
      return null;
    }
  }

  static Future<Endereco> precisaSalvarEnderecoNoBanco(
      Endereco enderecoViaApi) async {
    Endereco? endereco =
        await Enderecoservice.buscarEndereco(enderecoViaApi.cep);

    if (endereco == null) {
      enderecoViaApi.id =
          await criarEndereco(Endereco.fromEnderecoToJson(enderecoViaApi));
      return enderecoViaApi;
    }
    return endereco;
  }

  static Future<int> criarEndereco(Map<String, dynamic> endereco) async {
    final db = await DatabaseService.getDB();
    return await db.insert('address', endereco);
  }
}
