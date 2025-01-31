class Imagem {
  int? id;
  int property_id;
  String path;


  Imagem({this.id, required this.property_id, required this.path});

  static Imagem fromJsonToImage(Map<String, dynamic> json){
    return Imagem(
      id: json['id'],
      property_id: json['property_id'],
      path: json['path'],
    );
  }

  static Map<String, dynamic> fromImageToJson(Imagem image){
    return {
      'id': image.id,
      'property_id': image.property_id,
      'path': image.path,
    };
  }
}