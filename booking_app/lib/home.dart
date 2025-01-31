import 'dart:async';
import 'dart:io';

import 'package:booking_app/criarCard.dart';
import 'package:booking_app/modelos/endereco.dart';
import 'package:booking_app/modelos/image.dart';
import 'package:booking_app/modelos/propriedade.dart';
import 'package:booking_app/modelos/usuario.dart';
import 'package:booking_app/servicos/cepService.dart';
import 'package:booking_app/servicos/enderecoService.dart';
import 'package:booking_app/servicos/imagemService.dart';
import 'package:booking_app/servicos/propriedadeService.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

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
  TextEditingController numberController =  TextEditingController();
  TextEditingController complementController = TextEditingController();
  TextEditingController priceController = TextEditingController();
  TextEditingController maxguestController = TextEditingController();
  TextEditingController cepController = TextEditingController();
  List<File>? _images;

  Widget criarCard(Propriedade propriedade, int index) {
    return FutureBuilder<Endereco?>(
      future: Enderecoservice.buscarEnderecoPorId(propriedade.address_id),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return CircularProgressIndicator(); // Exibe um indicador de carregamento
        }
        Endereco endereco = snapshot.data!;

        return Dismissible(
          key: Key(propriedade.id.toString()),
          onDismissed: (direction) async {
            if (direction == DismissDirection.startToEnd) {
              setState(() {

              });
              _images = await Imagemservice.pegarImagensPeloIdPropriedade(propriedades[index].id!);
              cepController.text = endereco.cep.toString();

              salvarOuAtualizarModal(1, index: index);

            } else if (direction == DismissDirection.endToStart) {
              // Excluir
              Propriedade lastRemoved = propriedade;
              int removedIndex = index;
              setState(() {
                propriedades.removeAt(index);
              });

              bool isUndone = false;

              final snackBar = SnackBar(
                content: Text("Propriedade excluída!"),
                duration: Duration(seconds: 5),
                action: SnackBarAction(
                  label: "Desfazer",
                  onPressed: () {
                    isUndone = true;
                    setState(() {
                      propriedades.insert(removedIndex, lastRemoved);
                    });
                  },
                ),
              );

              ScaffoldMessenger.of(context).showSnackBar(snackBar);

              Timer(Duration(seconds: 5), () {
                if (!isUndone) {
                  Propriedadeservice.deletarPropriedade(lastRemoved.id!).then((_) {
                    Propriedadeservice.buscarPropriedadesDeUsuario(widget.usuario.id!).then((p) {
                      setState(() {
                        propriedades = p;
                      });
                    });
                  });
                }
              });
            }
          },
          background: Container(
            color: Colors.green,
            padding: EdgeInsets.all(14),
            margin: EdgeInsets.only(top: 7, bottom: 7),
            alignment: Alignment.centerLeft,
            child: Icon(Icons.edit, color: Colors.white, size: 37),
          ),
          secondaryBackground: Container(
            color: Colors.red,
            padding: EdgeInsets.all(14),
            margin: EdgeInsets.only(top: 7, bottom: 7),
            alignment: Alignment.centerRight,
            child: Icon(Icons.delete, color: Colors.white, size: 37),
          ),
          child: Criarcard.criarCard(propriedade, endereco)
        );
      },
    );
  }

  Future<void> pickImages() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.image, // Permite selecionar apenas imagens
      allowMultiple: true,  // Permite selecionar múltiplas imagens
    );

    if (result != null) {
      setState(() {
        _images = result.files.map((file) => File(file.path!)).toList();
      });
    }
  }

void limpaFormulario() {
  titleController.clear();
  descriptionController.clear();
  priceController.clear();
  maxguestController.clear();
  numberController.clear();
  complementController.clear();
  cepController.clear();
  _images = null;
}

_salvarPropriedade() async {
  Endereco enderecoViaApi = await Cepservice.buscarCep(cepController.text);
  //Verifica se precisa salvar no banco de dados ou já está lá
  Endereco enderecoBancoDeDados = await Enderecoservice.precisaSalvarEnderecoNoBanco(enderecoViaApi);

  //Cria a propriedade e salva no banco de dados
  Propriedade propriedade = Propriedade(address_id: enderecoBancoDeDados.id!, user_id: widget.usuario.id!, title: titleController.text, description: descriptionController.text, price: double.parse(priceController.text),
                max_guest: int.parse(maxguestController.text), number: int.parse(numberController.text) , complement: complementController.text, thumbnail: _images![0].path);
  propriedade.id = await Propriedadeservice.criarPropriedade(Propriedade.fromPropriedadeToJson(propriedade));

  //Cria a imagem e salva no banco de dados
  _images?.forEach((image) {
    Imagem imagem = Imagem(path: image.path, property_id: propriedade.id!);
    Imagemservice.criarImagem(Imagem.fromImageToJson(imagem));
  });

  limpaFormulario();
  setState(() {
    propriedades.add(propriedade);
  });
}

  _atualizarPropriedade(index) async {
    Endereco enderecoViaApi = await Cepservice.buscarCep(cepController.text);
    //Verifica se precisa salvar no banco de dados ou já está lá
    Endereco enderecoBancoDeDados = await Enderecoservice.precisaSalvarEnderecoNoBanco(enderecoViaApi);

    //Cria a propriedade e salva no banco de dados
    Propriedade propriedade = Propriedade(id: propriedades[index].id, address_id: enderecoBancoDeDados.id!, user_id: widget.usuario.id!, title: titleController.text, description: descriptionController.text, price: double.parse(priceController.text),
        max_guest: int.parse(maxguestController.text), number: int.parse(numberController.text) , complement: complementController.text, thumbnail: _images![0].path);
    await Propriedadeservice.atualizarPropriedade(propriedade);

    await Imagemservice.apagarImagens(propriedade.id!);
    _images?.forEach((image) {
      Imagem imagem = Imagem(path: image.path, property_id: propriedade.id!);
      Imagemservice.criarImagem(Imagem.fromImageToJson(imagem));
    });

    limpaFormulario();
    setState(() {
      propriedades[index] = propriedade;
    });
  }

void salvarOuAtualizarModal(int operation, {int index = -1}) {
  String operationStr = "Adicionar";

  if (operation == 1) {
    operationStr = "Atualizar";
    titleController.text = propriedades[index].title;
    descriptionController.text = propriedades[index].description;
    priceController.text = propriedades[index].price.toString();
    maxguestController.text = propriedades[index].max_guest.toString();
    numberController.text = propriedades[index].number.toString();
    complementController.text = propriedades[index].complement;
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

                  // Exibir todas as imagens selecionadas
                  _images == null || _images!.isEmpty
                      ? Text("Nenhuma imagem selecionada")
                      : Wrap(
                    spacing: 8.0, // Espaçamento horizontal
                    runSpacing: 8.0, // Espaçamento vertical
                    children: _images!.map((image) {
                      return ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child: Image.file(image, height: 80, width: 80, fit: BoxFit.cover),
                      );
                    }).toList(),
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () async {
                      await pickImages();
                      setState(() {}); // Atualiza o modal para refletir as mudanças
                    },
                    child: Text("Anexar Imagens"),
                  ),
                ],
              ),
            ),
            actions: [
              TextButton(
                onPressed: () {
                  limpaFormulario();
                  Navigator.pop(context);
                },
                child: Text("Cancelar"),
              ),
              TextButton(
                onPressed: () {
                  if (titleController.text.isEmpty ||
                      descriptionController.text.isEmpty ||
                      priceController.text.isEmpty ||
                      maxguestController.text.isEmpty ||
                      numberController.text.isEmpty ||
                      complementController.text.isEmpty ||
                      cepController.text.isEmpty ||
                      (_images == null || _images!.isEmpty)) {
                    Fluttertoast.showToast(msg: "Todos os campos são obrigatórios!");
                  } else {
                    if (operation == 0) {
                      _salvarPropriedade();
                    } else if (operation == 1) {
                      _atualizarPropriedade(index);
                    }

                    Navigator.pop(context);
                  }
                },
                child: Text(operationStr),
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
                  return <PopupMenuEntry<String>>[
                    const PopupMenuItem<String>(
                      value: 'deslogar',
                      child: Text('Deslogar'),
                    ),
                  ];
                },
              ),
            ],
          ),
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
                  return criarCard(propriedades[index], index);
                },
              ),
            ),
          ],
        ));
  }
}
