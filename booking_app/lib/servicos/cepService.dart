import 'package:booking_app/modelos/endereco.dart';
import 'package:booking_app/servicos/enderecoService.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class Cepservice {
  static final String url = 'https://viacep.com.br/ws/';


  static Future<Endereco> buscarCep(String cep) async {
    Endereco endereco;
    String urlComCep = '$url$cep/json/';
    http.Response response = await http.get(Uri.parse(urlComCep));
    Map<String, dynamic> cepData = jsonDecode(response.body);
    endereco = Endereco.fromJsonToEndereco(cepData);

    endereco.cep = endereco.cep.replaceAll("-", "");
    
    return endereco;
  }
}