import 'dart:io';

import 'package:booking_app_user/componentes/cardWidget.dart';
import 'package:booking_app_user/componentes/detalhesPropriedade.dart';
import 'package:booking_app_user/login/login.dart';
import 'package:booking_app_user/modelos/endereco.dart';
import 'package:booking_app_user/modelos/propriedade.dart';
import 'package:booking_app_user/modelos/reserva.dart';
import 'package:booking_app_user/modelos/usuario.dart';
import 'package:booking_app_user/servicos/enderecoService.dart';
import 'package:booking_app_user/utils/selecionarDate.dart';
import 'package:flutter/material.dart';

class CardReservasDisponiveis extends StatefulWidget {
  final Usuario usuario;
  final Propriedade propriedade;
  const CardReservasDisponiveis({super.key, required this.usuario, required this.propriedade});

  @override
  State<CardReservasDisponiveis> createState() => _CardReservasDisponiveisState();
}

class _CardReservasDisponiveisState extends State<CardReservasDisponiveis> implements CardWidget {
  DateTime? checkInDate;
  DateTime? checkOutDate;
  bool conflitoDatasReserva = false;

  @override
  Widget build(BuildContext context) {
    return criarCrad(widget.propriedade, context);
  }

  void selecionarData(bool isCheckInDate, int property_id) async{
  DateTime? dataSelecionada = await Selecionardate.selecionarData(context);
  if(dataSelecionada != null ){
    isCheckInDate == true ? checkInDate = dataSelecionada : checkOutDate = dataSelecionada;
    if(!Selecionardate.validaDataSelecionada(isCheckInDate, checkInDate, checkOutDate)){
        isCheckInDate == true ? checkInDate = null : checkOutDate = null;
    } 
    if(!await Selecionardate.verificarConflitoComReserva(checkInDate, checkOutDate, property_id)){
        conflitoDatasReserva = true;
      }else {
        conflitoDatasReserva = false;
      }
  }
  setState(() {
    
  });
}
  @override
  Widget criarCrad(Propriedade propriedade, BuildContext context, [Reserva? reserva]) {
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
                    onPressed: () => selecionarData(true, propriedade.id!),
                    child: Text(checkInDate == null
                        ? 'Check-in'
                        : 'Entrada: ${checkInDate!.day}/${checkInDate!.month}/${checkInDate!.year}'),
                  ),
                  ElevatedButton(
                    onPressed: () => selecionarData(false, propriedade.id!),
                    child: Text(checkOutDate == null
                        ? 'Check-out'
                        : 'Saída: ${checkOutDate!.day}/${checkOutDate!.month}/${checkOutDate!.year}'),
                  ),
                ],
              ),
              const SizedBox(height: 16.0),
              widget.usuario.id != -1 ?
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
                    if (!conflitoDatasReserva){
                      ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text('Datas conflitantes com outra reserva, troque as datas.'),
                              ),
                            );
                            return;
                    }
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => DetalhesPropriedade(propriedade: propriedade, usuario: widget.usuario, checkin: checkInDate!, checkout: checkOutDate!,),
                      ),
                    );
                    
                  },
                  child: Text("Detalhes"),
                ),
              ) :
               Center(
                child: TextButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => Login(),
                      ),
                    );
                  },
                  child: Text("Fazer login"),
                ),
              )
            ],
          ),
        );
      },
    );
  }
  }
