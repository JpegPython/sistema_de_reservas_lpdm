import 'dart:io';

import 'package:booking_app/modelos/endereco.dart';
import 'package:booking_app/modelos/propriedade.dart';
import 'package:flutter/material.dart';

class Criarcard {
  static Widget criarCard(Propriedade propriedade, Endereco endereco){
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
                        '${endereco.logradouro} ${propriedade.number}, ${propriedade.complement}',
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
}