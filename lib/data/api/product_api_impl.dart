import 'package:dio_api_products/core/helpers/base_http_dio.dart';
import 'package:dio_api_products/core/helpers/http_response.dart';
import 'package:dio_api_products/data/api/product_api_interface.dart';
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
}
