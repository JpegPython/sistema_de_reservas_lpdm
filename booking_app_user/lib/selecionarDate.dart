import 'package:flutter/material.dart';

class Selecionardate {

  static Future<DateTime?> selecionarData(BuildContext context) async {
    DateTime? dataSelecionada = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 365)), // Até 1 ano no futuro
    );

    if (dataSelecionada != null) {
        return dataSelecionada;
      }
    }
  static bool validaDataSelecionada(bool isCheckInDate, DateTime? checkIn, DateTime? checkout){
     if(isCheckInDate && checkout != null && Selecionardate.dataCheckInMaiorDataCheckOut(checkIn, checkout)) {
      return false;
    }
    if( !isCheckInDate && checkIn != null && Selecionardate.dataCheckOutMenorDataCheckIn(checkIn, checkout)) {
      return false;
    }
    return true;
  }
  static bool dataCheckInMaiorDataCheckOut(DateTime? checkin, DateTime? checkout){
    print(checkin);
    print(checkout);
    return checkin!.isAfter(checkout!);
  }

  static bool dataCheckOutMenorDataCheckIn(DateTime? checkin, DateTime? checkout){
    return checkout!.isBefore(checkin!);
  }
  }
 