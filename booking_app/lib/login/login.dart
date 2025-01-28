import 'package:booking_app/home.dart';
import 'package:booking_app/login/cadastro.dart';
import 'package:booking_app/modelos/usuario.dart';
import 'package:booking_app/servicos/usuarioService.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {

   void showToastMessage(String message) => Fluttertoast.showToast(msg: message);

  TextEditingController _usuarioController = TextEditingController();
  TextEditingController _senhaController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Login'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              'Bem-vindo',
              style: TextStyle(fontSize: 24),
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
              onPressed: () async {
                if (_usuarioController.text.isEmpty || _senhaController.text.isEmpty) {
                  return showToastMessage("Nome ou senha vazios!");
                } else {
                  Usuario? usuario = await Usuarioservice.usuarioExiste(
                    _usuarioController.text,
                    _senhaController.text,
                  );
                  if (usuario != null) {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => Home(usuario: usuario),
                      ),
                    );
                  } else {
                    return showToastMessage("Usuário ou senha incorretos!");
                  }
                }
              },
              child: Text('Logar'),
            ),
            TextButton(
              onPressed: () {
                Navigator.push(context, MaterialPageRoute(builder: (context) => Cadastro()));
              },
              child: Text('Criar conta'),
            ),
          ],
        ),
      ),
    );
  }
}