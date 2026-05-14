import 'dart:convert';

CreateProductResponse createProductFromJson(String str) =>
    CreateProductResponse.fromJson(json.decode(str));

String createProductToJson(CreateProductResponse data) =>
    json.encode(data.toJson());

class CreateProductResponse {
  int id;
  String title;
  String price;
  String description;
  String image;
  String category;

  CreateProductResponse({
    required this.id,
    required this.title,
    required this.price,
    required this.description,
    required this.image,
    required this.category,
  });

  factory CreateProductResponse.fromJson(Map<String, dynamic> json) =>
      CreateProductResponse(
        id: json["id"],
        title: json["title"],
        price: json["price"],
        description: json["description"],
        image: json["image"],
        category: json["category"],
      );

  Map<String, dynamic> toJson() => {
    "id": id,
    "title": title,
    "price": price,
    "description": description,
    "image": image,
    "category": category,
  };
}
