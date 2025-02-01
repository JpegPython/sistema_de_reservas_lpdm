import 'dart:io';

import 'package:booking_app_user/componentes/cardMinhasReservas.dart';
import 'package:booking_app_user/modelos/endereco.dart';
import 'package:booking_app_user/modelos/propriedade.dart';
import 'package:booking_app_user/modelos/reserva.dart';
import 'package:booking_app_user/modelos/usuario.dart';
import 'package:booking_app_user/servicos/enderecoService.dart';
import 'package:booking_app_user/servicos/propriedadeService.dart';
import 'package:booking_app_user/servicos/reservaService.dart';
import 'package:flutter/material.dart';

class Minhasreservas extends StatefulWidget {
  final Usuario usuario;
  const Minhasreservas({super.key, required this.usuario});

  @override
  State<Minhasreservas> createState() => _MinhasreservasState();
}

class _MinhasreservasState extends State<Minhasreservas> {
  List<Reserva> reservas = [];

  @override
  void initState() {
    super.initState();
    ReservaService.buscarReservasUsuario(widget.usuario.id!).then((r) {
      setState(() {
        reservas = r;
      });
    });
  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Minhas reservas"),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ListView.builder(
              shrinkWrap: true, 
              physics: NeverScrollableScrollPhysics(),
              itemCount: reservas.length,
              itemBuilder: (context, index) {
                return FutureBuilder<Propriedade>(
                  future: Propriedadeservice.buscarPropriedadePorId(reservas[index].property_id),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return CircularProgressIndicator();
                    } else if (snapshot.hasError) {
                      return Text("Erro ao carregar propriedade");
                    } else if (!snapshot.hasData) {
                      return Text("Nenhuma propriedade encontrada");
                    }

                    Propriedade propriedade = snapshot.data!;
                    return CardMinhasReservas().criarCrad(propriedade, context, reservas[index]);
                  },
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}

