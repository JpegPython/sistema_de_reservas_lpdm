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
  TextEditingController ufController = TextEditingController();
  TextEditingController cidadeController = TextEditingController();
  TextEditingController bairroController = TextEditingController();

  DateTime? checkInDate;
  DateTime? checkOutDate;
  int maxHospedesFiltro = 1;

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

void filtrarPropriedades({
  DateTime? checkInDate,
  DateTime? checkOutDate,
  String? uf,
  String? cidade,
  String? bairro,
  int? maxHospedes,
}) async {
  //if (checkInDate == null || checkOutDate == null) return;

  try {
    var propriedadesFiltradas = await Propriedadeservice.buscarPropriedadesDisponiveis(
      checkInDate: checkInDate,
      checkOutDate: checkOutDate,
      uf: uf,
      cidade: cidade,
      bairro: bairro,
      maxHospedes: maxHospedes,
    );

    setState(() {
      propriedadesDisponiveis = propriedadesFiltradas;
    });
  } catch (e) {
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
            child:
              Column(
                children: [
                  Row(
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
                    ],
                  ),

                const SizedBox(height: 10), 

          // Dropdown para selecionar UF
                TextField(
                  controller: ufController,
                  decoration: const InputDecoration(
                    labelText: 'Estado (UF)',
                    border: OutlineInputBorder(),
                  ),
                ),

                const SizedBox(height: 10), 

                TextField(
                  controller: cidadeController,
                  decoration: const InputDecoration(
                    labelText: 'Cidade',
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 10), 
                TextField(
                  controller: bairroController,
                  decoration: const InputDecoration(
                    labelText: 'Bairro',
                    border: OutlineInputBorder(),
                  ),
                ),

                const SizedBox(height: 10), 

                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text("Quantidade de hóspedes"),
                    Slider(
                      value: maxHospedesFiltro.toDouble(),
                      min: 1,
                      max: 12,
                      divisions: 12,
                      label: maxHospedesFiltro.toString(),
                      onChanged: (double value) {
                        setState(() {
                          maxHospedesFiltro = value.toInt();
                        });
                      },
                    ),
                  ],
                ),

                const SizedBox(height: 10), 

                ElevatedButton(
                  onPressed: () => filtrarPropriedades(
                      checkInDate: checkInDate,
                      checkOutDate: checkOutDate,
                      uf: ufController.text,
                      cidade: cidadeController.text,
                      bairro: bairroController.text,
                      maxHospedes: maxHospedesFiltro,
                    ),
                  child: Text("Filtrar"),
                  )
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

