import 'dart:convert';
import 'package:dio_api_products/data/models/rating_model.dart';

DeleteProductResponse deleteProductResponseFromJson(String str) =>
    DeleteProductResponse.fromJson(json.decode(str));

String deleteProductResponseToJson(DeleteProductResponse data) =>
    json.encode(data.toJson());

class DeleteProductResponse {
  int id;
  String title;
  double price;
  String description;
  String category;
  String image;
  Rating rating;

  DeleteProductResponse({
    required this.id,
    required this.title,
    required this.price,
    required this.description,
    required this.category,
    required this.image,
    required this.rating,
  });

  factory DeleteProductResponse.fromJson(Map<String, dynamic> json) =>
      DeleteProductResponse(
        id: json["id"],
        title: json["title"],
        price: json["price"]?.toDouble(),
        description: json["description"],
        category: json["category"],
        image: json["image"],
        rating: Rating.fromJson(json["rating"]),
      );

  Map<String, dynamic> toJson() => {
    "id": id,
    "title": title,
    "price": price,
    "description": description,
    "category": category,
    "image": image,
    "rating": rating.toJson(),
  };
}
