import 'package:flutter/material.dart';
import 'package:dio_api_products/core/helpers/http_response.dart';
import 'package:dio_api_products/data/models/delete_product_response_model.dart';
import 'package:dio_api_products/data/models/product_model.dart';
import 'package:dio_api_products/data/models/products_response_model.dart';
import 'package:dio_api_products/data/repositories/product_repository_interface.dart';

class ProductsViewModel extends ChangeNotifier {
  final ProductRepository productRepository;

  List<Product> _products = [];
  bool _isLoading = false;
  String? _error;

  ProductsViewModel(this.productRepository);

  // Getters
  List<Product> get products => _products;
  bool get isLoading => _isLoading;
  String? get error => _error;

  // Load all products from API
  Future<void> loadProducts() async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      HttpResponse<ProductsResponse> response = await productRepository
          .getAllProducts();
      if (response.data != null) {
        _products = response.data!.products;
      } else {
        _error = response.error?.message ?? 'Unknown error';
      }
    } catch (e) {
      _error = 'Failed to load products: ${e.toString()}';
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // Delete a product by ID
  Future<bool> deleteProduct(int id) async {
    try {
      HttpResponse<DeleteProductResponse> response = await productRepository
          .deleteProduct(id);
      if (response.data != null) {
        // Remove from local list
        _products.removeWhere((product) => product.id == id);
        notifyListeners();
        return true;
      } else {
        _error = response.error?.message ?? 'Failed to delete product';
        notifyListeners();
        return false;
      }
    } catch (e) {
      _error = 'Error deleting product: ${e.toString()}';
      notifyListeners();
      return false;
    }
  }
}
