import 'dart:io';

import 'package:booking_app_user/componentes/cardWidget.dart';
import 'package:booking_app_user/modelos/propriedade.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';

class CardMinhasReservas implements CardWidget {
  @override
  Widget criarCrad(Propriedade propriedade, BuildContext context, [reserva] ) {
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
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'R\$ ${reserva!.total_price.toStringAsFixed(2)}',
                      style: const TextStyle(
                        fontSize: 18.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      '${reserva.amount_guest} hóspedes',
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
                onPressed: () => {},
                child: Text(
                    'Entrada: ${reserva.checkin_date.day}/${reserva.checkin_date.month}/${reserva.checkin_date.year}'),
              ),
              ElevatedButton(
                onPressed: () => {},
                child: Text(
                    'Saída: ${reserva.checkout_date.day}/${reserva.checkout_date.month}/${reserva.checkout_date.year}'),
              ),
            ],
          ),
        ],
      ),
    );
  }
  }