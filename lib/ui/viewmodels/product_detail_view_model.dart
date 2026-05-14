import 'package:flutter/material.dart';
import 'package:dio_api_products/core/helpers/http_response.dart';
import 'package:dio_api_products/data/models/product_model.dart';
import 'package:dio_api_products/data/repositories/product_repository_interface.dart';

class ProductDetailViewModel extends ChangeNotifier {
  final ProductRepository productRepository;
  final int productId;

  Product? _product;
  bool _isLoading = false;
  String? _error;

  ProductDetailViewModel({
    required this.productRepository,
    required this.productId,
  });

  // Getters
  Product? get product => _product;
  bool get isLoading => _isLoading;
  String? get error => _error;

  // Load single product from API
  Future<void> loadProduct() async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      HttpResponse<Product> response = await productRepository.getSingleProduct(
        productId,
      );
      if (response.data != null) {
        _product = response.data;
      } else {
        _error = response.error?.message ?? 'Unknown error';
      }
    } catch (e) {
      _error = 'Failed to load product: ${e.toString()}';
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
