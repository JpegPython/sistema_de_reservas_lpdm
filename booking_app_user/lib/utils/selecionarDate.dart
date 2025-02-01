import 'package:booking_app_user/servicos/reservaService.dart';
import 'package:flutter/material.dart';

class SelecionarDate {
  
  static Future<DateTime?> selecionarData(BuildContext context) async {
    return await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 365)), // Até 1 ano no futuro
    );
  }

  static bool validaDataSelecionada(bool isCheckInDate, DateTime? checkIn, DateTime? checkout) {
    if (isCheckInDate && checkout != null && dataCheckInMaiorDataCheckOut(checkIn, checkout)) {
      return false;
    }
    if (!isCheckInDate && checkIn != null && checkout != null && dataCheckOutMenorDataCheckIn(checkIn, checkout)) {
      return false;
    }
    return true;
  }

  static bool dataCheckInMaiorDataCheckOut(DateTime? checkin, DateTime? checkout) {
    if (checkin == null || checkout == null) return false;
    return checkin.isAfter(checkout);
  }

  static bool dataCheckOutMenorDataCheckIn(DateTime? checkin, DateTime? checkout) {
    if (checkin == null || checkout == null) return false;
    return checkout.isBefore(checkin);
  }

  static Future<bool> verificarConflitoComReserva(DateTime? checkin, DateTime? checkout, int property_id) async {
    if (checkin != null && checkout != null) {
      return await ReservaService.verificarConflitoDataEntreReservas(property_id, checkin.toString(), checkout.toString());
    }
    return false;
  }
}

 