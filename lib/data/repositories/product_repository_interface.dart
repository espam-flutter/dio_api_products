import 'package:dio_api_products/core/helpers/http_response.dart';
import 'package:dio_api_products/data/models/create_product_response_model.dart';
import 'package:dio_api_products/data/models/delete_product_response_model.dart';
import 'package:dio_api_products/data/models/product_model.dart';
import 'package:dio_api_products/data/models/products_response_model.dart';

abstract class ProductRepository {
  Future<HttpResponse<ProductsResponse>> getAllProducts();
  Future<HttpResponse<Product>> getSingleProduct(int id);
  Future<HttpResponse<DeleteProductResponse>> deleteProduct(int id);
  Future<HttpResponse<CreateProductResponse>> updateProduct(
    int id,
    String title,
    String price,
    String description,
    String image,
    String category,
  );
}
