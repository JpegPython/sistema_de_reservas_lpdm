import 'package:flutter/material.dart';
import 'package:booking_app_user/componentes/cardReservasDisponiveis.dart';
import 'package:booking_app_user/componentes/minhasReservas.dart';
import 'package:booking_app_user/modelos/propriedade.dart';
import 'package:booking_app_user/modelos/usuario.dart';
import 'package:booking_app_user/servicos/propriedadeService.dart';
import 'package:booking_app_user/utils/selecionarDate.dart';

class Home extends StatefulWidget {
  final Usuario usuario;
  Home({required this.usuario});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  List<Propriedade> propriedadesDisponiveis = [];
  DateTime? checkInDate;
  DateTime? checkOutDate;

  @override
  void initState() {
    super.initState();
    carregarPropriedades();
  }

  void carregarPropriedades() async {
    var propriedades = await Propriedadeservice.buscarTodasPropriedadesComMaiorRating();
    setState(() {
      propriedadesDisponiveis = propriedades;
    });
  }

  void selecionarData(bool isCheckInDate) async {
    DateTime? dataSelecionada = await SelecionarDate.selecionarData(context);
    if (dataSelecionada != null) {
      setState(() {
        isCheckInDate ? checkInDate = dataSelecionada : checkOutDate = dataSelecionada;
      });
    }
  }

  void filtrarPropriedades() async {
    if (checkInDate == null || checkOutDate == null) return;
    try{
      var propriedadesFiltradas = await Propriedadeservice.buscarPropriedadesDisponiveis(checkInDate!, checkOutDate!);
      setState(() {
        propriedadesDisponiveis = propriedadesFiltradas;
      });
    }
  catch (e) {
    // Resetando os filtros para o estado inicial
    setState(() {
      checkInDate = null;
      checkOutDate = null;
      propriedadesDisponiveis = [];
    });
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(e.toString()),
        backgroundColor: Colors.red,
      ),
    );
  }
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
                if (result == 'minhas_reservas') {
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
                  return <PopupMenuEntry<String>>[
                    const PopupMenuItem<String>(
                      value: 'minhas_reservas',
                      child: Text('Minhas Reservas'),
                    ),
                  ];
                } else {
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
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                ElevatedButton(
                  onPressed: () => selecionarData(true),
                  child: Text(checkInDate == null ? 'Check-in' : 'Entrada: ${checkInDate!.day}/${checkInDate!.month}/${checkInDate!.year}'),
                ),
                ElevatedButton(
                  onPressed: () => selecionarData(false),
                  child: Text(checkOutDate == null ? 'Check-out' : 'Saída: ${checkOutDate!.day}/${checkOutDate!.month}/${checkOutDate!.year}'),
                ),
                ElevatedButton(
                  onPressed: filtrarPropriedades,
                  child: const Text('Filtrar'),
                ),
              ],
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: propriedadesDisponiveis.length,
              itemBuilder: (context, index) {
                return CardReservasDisponiveis(usuario: widget.usuario, propriedade: propriedadesDisponiveis[index]);
              },
            ),
          ),
        ],
      ),
    );
  }
}

