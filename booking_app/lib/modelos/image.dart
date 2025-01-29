class Image {
  int? id;
  String property_id;
  String path;


  Image({this.id, required this.property_id, required this.path});

  static Image fromJsonToImage(Map<String, dynamic> json){
    return Image(
      id: json['id'],
      property_id: json['property_id'],
      path: json['path'],
    );
  }

  static Map<String, dynamic> fromImageToJson(Image image){
    return {
      'id': image.id,
      'property_id': image.property_id,
      'path': image.path,
    };
  }
}