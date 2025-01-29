class Propriedade {
  int? id;
  int user_id; 
  int address_id; 
  String title;
  String description;
  int number;
  String complement;
  double price; 
  int max_guest;
  String thumbnail;
  
  Propriedade({this.id, required this.user_id, required this.address_id, required this.title, required this.description, required this.number, required this.complement, required this.price, required this.max_guest, required this.thumbnail});
  
  static Propriedade fromJsonToPropriedade(Map<String, dynamic> json){
    return Propriedade(
      id: json['id'],
      user_id: json['user_id'],
      address_id: json['address_id'],
      title: json['title'],
      description: json['description'],
      number: json['number'],
      complement: json['complement'],
      price: json['price'],
      max_guest: json['max_guest'],
      thumbnail: json['thumbnail']
    );
  }
  
  static Map<String, dynamic> fromPropriedadeToJson(Propriedade propriedade){
    return {
      'id': propriedade.id,
      'user_id': propriedade.user_id,
      'address_id': propriedade.address_id,
      'title': propriedade.title,
      'description': propriedade.description,
      'number': propriedade.number,
      'complement': propriedade.complement,
      'price': propriedade.price,
      'max_guest': propriedade.max_guest,
      'thumbnail': propriedade.thumbnail
    };
  }
}