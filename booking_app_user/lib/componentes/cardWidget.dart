import 'package:booking_app_user/modelos/propriedade.dart';
import 'package:booking_app_user/modelos/reserva.dart';
import 'package:flutter/material.dart';

abstract class CardWidget{
    Widget criarCrad(Propriedade propriedade, BuildContext context , [Reserva? reserva]);
}