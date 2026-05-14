import 'package:dio_api_products/core/helpers/base_http_dio.dart';
import 'package:dio_api_products/core/helpers/http_response.dart';
import 'package:dio_api_products/data/api/product_api_interface.dart';
import 'package:dio_api_products/data/models/create_product_response_model.dart';
import 'package:dio_api_products/data/models/delete_product_response_model.dart';
import 'package:dio_api_products/data/models/product_model.dart';
import 'package:dio_api_products/data/models/products_response_model.dart';

class ProductAPIImpl implements ProductAPI {
  final BaseHttpDio baseHttpDio;

  ProductAPIImpl(this.baseHttpDio);

  @override
  Future<HttpResponse<ProductsResponse>> getAllProducts() async {
    return baseHttpDio.resquest(
      '/products',
      method: 'GET',
      parser: (data) {
        return ProductsResponse.fromJson(data);
      },
    );
  }

  @override
  Future<HttpResponse<Product>> getSingleProduct(int id) async {
    return baseHttpDio.resquest(
      '/products/$id',
      method: 'GET',
      parser: (data) {
        return Product.fromJson(data);
      },
    );
  }

  @override
  Future<HttpResponse<DeleteProductResponse>> deleteProduct(int id) async {
    return baseHttpDio.resquest(
      'products/$id',
      method: 'DELETE',
      parser: (data) {
        return DeleteProductResponse.fromJson(data);
      },
    );
  }

  @override
  Future<HttpResponse<CreateProductResponse>> updateProduct(
    int id,
    String title,
    String price,
    String description,
    String image,
    String category,
  ) async {
    return baseHttpDio.resquest<CreateProductResponse>(
      'products/$id',
      method: 'PUT',
      data: {
        "title": title,
        "price": price.toString(),
        "description": description,
        "image": image,
        "category": "electronics",
      },
      parser: (data) {
        return CreateProductResponse.fromJson(data);
      },
    );
  }
}
