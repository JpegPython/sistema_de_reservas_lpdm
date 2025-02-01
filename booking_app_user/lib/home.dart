import 'package:booking_app_user/componentes/cardReservasDisponiveis.dart';
import 'package:booking_app_user/componentes/minhasReservas.dart';
import 'package:booking_app_user/modelos/propriedade.dart';
import 'package:booking_app_user/modelos/usuario.dart';
import 'package:booking_app_user/servicos/propriedadeService.dart';
import 'package:flutter/material.dart';

class Home extends StatefulWidget {
  Usuario usuario;
  Home({required this.usuario});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  List<Propriedade> propriedadesDisponiveis = [];
  
  @override
  void initState() {
    super.initState();
      Propriedadeservice.buscarTodasPropriedadesComMaiorRating().then((p) {
        propriedadesDisponiveis = p;
        setState(() {
        });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text('Propriedades Disponíveis'),
            PopupMenuButton<String>(
              icon: const CircleAvatar(
                child: Icon(Icons.person),
              ),
              onSelected: (String result) {
                if (result != 'minhas_propriedades') {
                  Navigator.pop(context);
                }
                if(result == 'minhas_propriedades'){
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => Minhasreservas(usuario: widget.usuario),
                      ),
                    );
                }
              },
              itemBuilder: (BuildContext context) {
                if (widget.usuario.id != -1) {
                  // Usuário está logado
                  return <PopupMenuEntry<String>>[
                    const PopupMenuItem<String>(
                      value: 'minhas_propriedades',
                      child: Text('Minhas Propriedades'),
                    ),
                    const PopupMenuItem<String>(
                      value: 'deslogar',
                      child: Text('Deslogar'),
                    ),
                  ];
                } else {
                  // Usuário não está logado
                  return <PopupMenuEntry<String>>[
                    const PopupMenuItem<String>(
                      value: 'login',
                      child: Text('Fazer Login'),
                    ),
                  ];
                }
              },
            ),
          ],
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: propriedadesDisponiveis.length,
              itemBuilder: (context, index) {
                return CardReservasDisponiveis(usuario: widget.usuario, propriedade: propriedadesDisponiveis[index],);
              },
            ),
          ),
        ],
      ),
    );
  }
}
