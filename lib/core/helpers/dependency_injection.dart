import 'package:dio/dio.dart';
import 'package:dio_api_products/core/helpers/base_http_dio.dart';
import 'package:dio_api_products/data/api/product_api_impl.dart';
import 'package:dio_api_products/data/api/product_api_interface.dart';
import 'package:dio_api_products/data/repositories/product_repository_impl.dart';
import 'package:dio_api_products/data/repositories/product_repository_interface.dart';
import 'package:get_it/get_it.dart';

abstract class DependencyInjection {
  static void initialize() {
    final Dio dio = Dio(BaseOptions(baseUrl: 'https://fakestoreapi.com/'));
    final BaseHttpDio baseHttpDio = BaseHttpDio(dio);

    final ProductAPI productAPI = ProductAPIImpl(baseHttpDio);
    final ProductRepository productRepository = ProductRepositoryImpl(
      productAPI,
    );

    GetIt.instance.registerSingleton<ProductRepository>(productRepository);
  }
}
