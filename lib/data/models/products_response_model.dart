import 'dart:convert';
import 'package:dio_api_products/data/models/product_model.dart';

ProductsResponse productsResponseFromJson(String str) =>
    ProductsResponse.fromJson(json.decode(str));

String eventsResponseToJson(ProductsResponse data) =>
    json.encode(data.toJson());

class ProductsResponse {
  ProductsResponse({required this.products});

  final List<Product> products;

  factory ProductsResponse.fromJson(List<dynamic> json) {
    List<Product> products = json
        .map((productJson) => Product.fromJson(productJson))
        .toList();
    return ProductsResponse(products: products);
  }

  Map<String, dynamic> toJson() => {
    "products": List<dynamic>.from(products.map((x) => x.toJson())),
  };
}
