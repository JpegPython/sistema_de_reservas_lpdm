import 'package:booking_app/login/login.dart';
import 'package:booking_app/modelos/usuario.dart';
import 'package:booking_app/servicos/usuarioService.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class Cadastro extends StatefulWidget {
  const Cadastro();

  @override
  State<Cadastro> createState() => _CadastroState();
}

class _CadastroState extends State<Cadastro> {

  void showToastMessage(String message) => Fluttertoast.showToast(msg: message);

  TextEditingController _usuarioController = TextEditingController();
  TextEditingController _senhaController = TextEditingController();
  TextEditingController _emailController = TextEditingController();
  void criarConta() {
    Usuario usuario = Usuario(name: _usuarioController.text, email: _emailController.text, password: _senhaController.text);
    Usuarioservice.criarUsuario(Usuario.fromUsuarioToJson(usuario));

    Navigator.push(context, MaterialPageRoute(builder: (context) => Login()));
  }

  @override
  Widget build(BuildContext context) {
     return Scaffold(
      appBar: AppBar(
        title: Text('Cadastro'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              'Criar conta',
              style: TextStyle(fontSize: 24),
            ),
            SizedBox(height: 20),
            TextField(
              controller: _emailController,
              decoration: InputDecoration(
                labelText: 'Email',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 20),
            TextField(
              controller: _usuarioController,
              decoration: InputDecoration(
                labelText: 'Usuário',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 20),
            TextField(
              controller: _senhaController,
              decoration: InputDecoration(
                labelText: 'Senha',
                border: OutlineInputBorder(),
              ),
              obscureText: true,
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
              if(_usuarioController.text.isEmpty || _senhaController.text.isEmpty || _emailController.text.isEmpty) {
                return showToastMessage("Campos vazios!");
              } else {
                criarConta();
              }
              },
              child: Text('Cadastrar'),
            ),
            
          ],
        ),
      ),
    );
  }
}
