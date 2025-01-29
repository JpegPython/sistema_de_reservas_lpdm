import 'dart:io';

import 'package:booking_app/modelos/endereco.dart';
import 'package:booking_app/modelos/propriedade.dart';
import 'package:booking_app/modelos/usuario.dart';
import 'package:booking_app/servicos/cepService.dart';
import 'package:booking_app/servicos/enderecoService.dart';
import 'package:booking_app/servicos/propriedadeService.dart';
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
  TextEditingController titleController = new TextEditingController();
  TextEditingController descriptionController = new TextEditingController();
  TextEditingController numberController =  new TextEditingController();
  TextEditingController complementController =  new TextEditingController();
  TextEditingController priceController =  new TextEditingController();
  TextEditingController maxguestController =  new TextEditingController();
  TextEditingController cepController =  new TextEditingController();
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
                      'Máx. ${propriedade.max_guest} hóspedes',
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
    type: FileType.image, // Permite selecionar apenas imagens
  );

  if (result != null) {
    PlatformFile file = result.files.first;
    _image = File(file.path!);
    print("Imagem selecionada: ${_image!.path}");

  } 

}
  
_salvarPropriedade() async {
  Endereco enderecoViaApi = await Cepservice.buscarCep(cepController.text);
  Endereco enderecoBancoDeDados = await Enderecoservice.precisaSalvarEnderecoNoBanco(enderecoViaApi);

  Propriedade propriedade = Propriedade(address_id: enderecoBancoDeDados.id!, user_id: widget.usuario.id!, title: titleController.text, description: descriptionController.text, price: double.parse(priceController.text), 
                max_guest: int.parse(maxguestController.text), number: int.parse(numberController.text) , complement: complementController.text, thumbnail: 'text');
  Propriedadeservice.criarPropriedade(Propriedade.fromPropriedadeToJson(propriedade));

  setState(() {
    propriedades.add(propriedade);
  });
}
void salvarOuAtualizarModal(int operation, {int index = -1}) {
  String operationStr = "Adicionar";
  
  
  if (operation == 1) {
    operationStr = "Atualizar";
    //taskController.text = taskList[index]["title"];
  }

  showDialog(
    context: context,
    builder: (context) {
      return StatefulBuilder(
        builder: (BuildContext context, StateSetter setState) {
          return AlertDialog(
            title: Text("$operationStr Propriedade"),
            content: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextField(
                    decoration: InputDecoration(labelText: "Título"),
                    controller: titleController,
                  ),
                  TextField(
                    decoration: InputDecoration(labelText: "Descrição"),
                    controller: descriptionController,
                  ),
                  TextField(
                    decoration: InputDecoration(labelText: "Preço"),
                    controller: priceController,
                    keyboardType: TextInputType.number,
                  ),
                  TextField(
                    decoration: InputDecoration(labelText: "Máx. Hóspedes"),
                    controller: maxguestController,
                    keyboardType: TextInputType.number,
                  ),
                  TextField(
                    decoration: InputDecoration(labelText: "Número"),
                    controller: numberController,
                    keyboardType: TextInputType.number,
                  ),
                  TextField(
                    decoration: InputDecoration(labelText: "Complemento"),
                    controller: complementController,
                    keyboardType: TextInputType.text,
                  ),
                  TextField(
                    controller: cepController,
                    keyboardType: TextInputType.text,
                    decoration: InputDecoration(labelText: "Cep"),
                  ),
                  const SizedBox(height: 16),
                  _image == null
                      ? Text("Nenhuma imagem selecionada")
                      : Image.file(_image!, height: 100),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () async {
                      await pickImage();
                      setState(() {}); // Reconstruir o conteúdo do AlertDialog
                    },
                    child: Text("Anexar Imagem"),
                  ),
                ],
              ),
            ),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: Text("Cancelar"),
              ),
              TextButton(
                onPressed: () {
                  if (operation == 0) {
                    _salvarPropriedade();
                  } else if (operation == 1) {
                    //_atualizarPropriedade(index);
                  }
                  Navigator.pop(context);
                },
                child: Text("$operationStr"),
              ),
            ],
          );
        },
      );
    },
  );
  }
  @override
  void initState() {
    super.initState();
    Propriedadeservice.buscarPropriedadesDeUsuario(widget.usuario.id!).then((p) {
        propriedades = p;
        setState(() {
          
        });
    });
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Home Page'),
        ),
        floatingActionButton: FloatingActionButton(
            child: Icon(Icons.add),
            onPressed: () {
              salvarOuAtualizarModal(0);
            }),
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
        ));
  }
}
