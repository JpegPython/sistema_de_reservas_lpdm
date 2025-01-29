import 'dart:io';

import 'package:booking_app_user/modelos/propriedade.dart';
import 'package:booking_app_user/modelos/usuario.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';

class Home extends StatefulWidget {
  Usuario usuario;
  Home({required this.usuario});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  List<Propriedade> propriedades = [];
  TextEditingController titleController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();
  TextEditingController numberController = TextEditingController();
  TextEditingController complementController = TextEditingController();
  TextEditingController priceController = TextEditingController();
  TextEditingController maxguestController = TextEditingController();
  TextEditingController cepController = TextEditingController();
  File? _image;

  Card criarCard(Propriedade propriedade) {
    return Card(
      elevation: 4.0,
      margin: const EdgeInsets.all(8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Image.network(
            propriedade.thumbnail,
            width: 150,
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
                  '${propriedade.number}, ${propriedade.complement}',
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
        ],
      ),
    );
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
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text('Propriedades'),
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
              itemCount: propriedades.length,
              itemBuilder: (context, index) {
                return criarCard(propriedades[index]);
              },
            ),
          ),
        ],
      ),
    );
  }
}
