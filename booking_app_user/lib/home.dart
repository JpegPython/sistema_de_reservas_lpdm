import 'dart:io';

import 'package:booking_app_user/modelos/endereco.dart';
import 'package:booking_app_user/modelos/propriedade.dart';
import 'package:booking_app_user/modelos/usuario.dart';
import 'package:booking_app_user/selecionarDate.dart';
import 'package:booking_app_user/servicos/detalhesPropriedade.dart';
import 'package:booking_app_user/servicos/enderecoService.dart';
import 'package:booking_app_user/servicos/propriedadeService.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';

class Home extends StatefulWidget {
  Usuario usuario;
  Home({required this.usuario});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  List<Propriedade> propriedadesDisponiveis = [];
  TextEditingController titleController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();
  TextEditingController numberController = TextEditingController();
  TextEditingController complementController = TextEditingController();
  TextEditingController priceController = TextEditingController();
  TextEditingController maxguestController = TextEditingController();
  TextEditingController cepController = TextEditingController();
  File? _image;
  DateTime? checkInDate;
  DateTime? checkOutDate;

  Widget criarCard(Propriedade propriedade, BuildContext context) {
    return FutureBuilder<Endereco?>(
      future: Enderecoservice.buscarEnderecoPorId(propriedade.address_id),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        if (snapshot.hasError) {
          return const Center(child: Text("Erro ao carregar o endereço"));
        }

        Endereco? endereco = snapshot.data;

        return Card(
          elevation: 4.0,
          margin: const EdgeInsets.all(8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              propriedade.thumbnail.startsWith('http')
                  ? Image.network(
                propriedade.thumbnail,
                width: double.infinity,
                height: 150.0,
                fit: BoxFit.cover,
              )
                  : Image.file(
                File(propriedade.thumbnail),
                width: double.infinity,
                height: 150.0,
                fit: BoxFit.cover,
              ),
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      propriedade.title,
                      style: const TextStyle(
                        fontSize: 20.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8.0),
                    Text(
                      propriedade.description,
                      style: const TextStyle(
                        fontSize: 16.0,
                        color: Colors.grey,
                      ),
                    ),
                    const SizedBox(height: 8.0),
                    Text(
                      '${endereco?.logradouro ?? 'Rua desconhecida'} ${propriedade.number}, ${propriedade.complement}',
                      style: const TextStyle(
                        fontSize: 16.0,
                      ),
                    ),
                    const SizedBox(height: 8.0),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'R\$ ${propriedade.price.toStringAsFixed(2)}',
                          style: const TextStyle(
                            fontSize: 18.0,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          'Máximo ${propriedade.max_guest} hóspedes',
                          style: const TextStyle(
                            fontSize: 16.0,
                            color: Colors.grey,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16.0),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  ElevatedButton(
                    onPressed: () => selecionarData(true),
                    child: Text(checkInDate == null
                        ? 'Check-in'
                        : 'Entrada: ${checkInDate!.day}/${checkInDate!.month}/${checkInDate!.year}'),
                  ),
                  ElevatedButton(
                    onPressed: () => selecionarData(false),
                    child: Text(checkOutDate == null
                        ? 'Check-out'
                        : 'Saída: ${checkOutDate!.day}/${checkOutDate!.month}/${checkOutDate!.year}'),
                  ),
                ],
              ),
              const SizedBox(height: 16.0),
              Center(
                child: TextButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => DetalhesPropriedade(propriedade: propriedade),
                      ),
                    );
                  },
                  child: Text("Detalhes"),
                ),
              ),
              Center(
                child: TextButton(
                  onPressed: () {
                    if (checkInDate == null || checkOutDate == null) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Selecione as datas antes de reservar.'),
                        ),
                      );
                      return;
                    }
                    //TODO: lógica de criar a reserva do usuário
                  },
                  child: Text("Reservar"),
                ),
              ),
            ],
          ),
        );
      },
    );
  }


  void selecionarData(bool isCheckInDate) async{
    DateTime? dataSelecionada = await Selecionardate.selecionarData(context);
    if(dataSelecionada != null ){
      isCheckInDate == true ? checkInDate = dataSelecionada : checkOutDate = dataSelecionada;
      if(!Selecionardate.validaDataSelecionada(isCheckInDate, checkInDate, checkOutDate)){
          isCheckInDate == true ? checkInDate = null : checkOutDate = null;
      } 
    }
    setState(() {
      
    });
  }

  Future<void> pickImage() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.image,
    );

    if (result != null) {
      PlatformFile file = result.files.first;
      _image = File(file.path!);
      print("Imagem selecionada: ${_image!.path}");
    }
  }

  @override
  void initState() {
    super.initState();
      Propriedadeservice.buscarTodasPropriedadesDisponiveis().then((p) {
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
                return criarCard(propriedadesDisponiveis[index], context);
              },
            ),
          ),
        ],
      ),
    );
  }
}
