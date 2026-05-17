import 'package:dio_api_products/core/helpers/http_response.dart';
import 'package:dio_api_products/data/models/delete_product_response_model.dart';
import 'package:dio_api_products/data/models/product_model.dart';
import 'package:dio_api_products/data/models/products_response_model.dart';
import 'package:dio_api_products/data/api/product_api_interface.dart';
import 'package:dio_api_products/data/repositories/product_repository_interface.dart';

class ProductRepositoryImpl implements ProductRepository {
  final ProductAPI productAPI;

  ProductRepositoryImpl(this.productAPI);

  @override
  Future<HttpResponse<ProductsResponse>> getAllProducts() {
    return productAPI.getAllProducts();
  }

  @override
  Future<HttpResponse<Product>> getSingleProduct(int id) {
    return productAPI.getSingleProduct(id);
  }

  @override
  Future<HttpResponse<DeleteProductResponse>> deleteProduct(int id) {
    return productAPI.deleteProduct(id);
  }
}
