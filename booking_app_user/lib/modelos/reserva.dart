class Reserva {
  int? id;
  int user_id; 
  int property_id;
  DateTime checkin_date;
  DateTime checkout_date;
  int total_days;
  double total_price;
  int amount_guest;
  double rating;

  Reserva({this.id, required this.user_id, required this.property_id, required this.checkin_date, required this.checkout_date, required this.total_days, required this.total_price
          , required this.amount_guest, required this.rating});

  static Reserva fromJsonToReserva(Map<String, dynamic> json){
    return Reserva(
      id: json['id'],
      user_id: json['user_id'],
      property_id: json['property_id'],
      checkin_date: DateTime.parse(json['checkin_date']),
      checkout_date: DateTime.parse(json['checkout_date']),
      total_days: json['total_days'],
      total_price: json['total_price'],
      amount_guest: json['amount_guest'],
      rating: json['rating'],
    );
  }
  
  static Map<String, dynamic> fromReservaToJson(Reserva reserva){
    return {
      'id': reserva.id,
      'user_id': reserva.user_id,
      'property_id': reserva.property_id,
      'checkin_date': reserva.checkin_date.toString(),
      'checkout_date': reserva.checkout_date.toString(),
      'total_days': reserva.total_days,
      'total_price': reserva.total_price,
      'amount_guest': reserva.amount_guest,
      'rating': reserva.rating,
      
    };
  }
}