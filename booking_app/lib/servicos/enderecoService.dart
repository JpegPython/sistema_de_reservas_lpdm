import 'package:booking_app/modelos/endereco.dart';
import 'package:booking_app/servicos/dataBase.dart';

class Enderecoservice {

  static Future<Endereco?> buscarEndereco(String cep) async{
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

  static Future<Endereco> precisaSalvarEnderecoNoBanco(Endereco enderecoViaApi) async{
    Endereco? endereco = await Enderecoservice.buscarEndereco(enderecoViaApi.cep);
    
    if(endereco == null){
      criarEndereco(Endereco.fromEnderecoToJson(enderecoViaApi));
      return enderecoViaApi;
    }
    return endereco;
  }

  static void criarEndereco(Map<String, dynamic> endereco) async {
    final db = await DatabaseService.getDB();
     await db.insert('address', endereco);
  }
}