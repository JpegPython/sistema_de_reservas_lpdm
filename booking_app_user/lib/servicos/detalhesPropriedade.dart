import 'dart:io';
import 'package:booking_app_user/modelos/propriedade.dart';
import 'package:booking_app_user/servicos/imagemService.dart'; // Importe o serviço de imagem
import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart'; // Importe o pacote carousel_slider

class DetalhesPropriedade extends StatefulWidget {
  final Propriedade propriedade;
  const DetalhesPropriedade({super.key, required this.propriedade});

  @override
  State<DetalhesPropriedade> createState() => _DetalhesPropriedadeState();
}

class _DetalhesPropriedadeState extends State<DetalhesPropriedade> {
  late Future<List<File>> imagensFuture;
  final CarouselSliderController _controller = CarouselSliderController(); // Novo controlador
  int _currentIndex = 0; // Variável para rastrear a posição atual do carrossel

  @override
  void initState() {
    super.initState();
    // Busca as imagens associadas à propriedade ao inicializar o estado
    imagensFuture = Imagemservice.pegarImagensPeloIdPropriedade(widget.propriedade.id!);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.propriedade.title),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Carrossel de imagens
            FutureBuilder<List<File>>(
              future: imagensFuture,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return Center(child: Text('Erro ao carregar imagens: ${snapshot.error}'));
                } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return const Center(child: Text('Nenhuma imagem disponível.'));
                } else {
                  final imagens = snapshot.data!;
                  return Column(
                    children: [
                      CarouselSlider(
                        carouselController: _controller, // Use o novo controlador aqui
                        options: CarouselOptions(
                          height: 250.0,
                          autoPlay: true,
                          enlargeCenterPage: true,
                          viewportFraction: 0.9,
                          onPageChanged: (index, reason) {
                            // Atualiza o índice atual quando a página muda
                            setState(() {
                              _currentIndex = index;
                            });
                          },
                        ),
                        items: imagens.map((imagem) {
                          return Builder(
                            builder: (BuildContext context) {
                              return ClipRRect(
                                borderRadius: BorderRadius.circular(16.0), // Arredonda as bordas da imagem
                                child: Image.file(
                                  imagem,
                                  width: double.infinity,
                                  fit: BoxFit.cover,
                                ),
                              );
                            },
                          );
                        }).toList(),
                      ),
                      const SizedBox(height: 10),
                      // Indicadores de página (bolinhas)
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: imagens.asMap().entries.map((entry) {
                          int index = entry.key;
                          return Container(
                            width: 8.0,
                            height: 8.0,
                            margin: const EdgeInsets.symmetric(horizontal: 4.0),
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: _currentIndex == index ? Colors.purple : Colors.grey, // Cor da bolinha ativa
                            ),
                          );
                        }).toList(),
                      ),
                    ],
                  );
                }
              },
            ),
            const SizedBox(height: 20),
            // Lista de detalhes
            _buildDetalheItem('Título', widget.propriedade.title),
            _buildDetalheItem('Descrição', widget.propriedade.description),
            _buildDetalheItem('Número', widget.propriedade.number.toString()),
            _buildDetalheItem('Complemento', widget.propriedade.complement),
            _buildDetalheItem('Preço', widget.propriedade.price.toString()),
            _buildDetalheItem('Máx. Hóspedes', widget.propriedade.max_guest.toString()),
          ],
        ),
      ),
    );
  }

  Widget _buildDetalheItem(String titulo, String valor) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            titulo,
            style: const TextStyle(
              fontSize: 14,
              color: Colors.grey,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            valor,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}