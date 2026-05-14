import 'package:flutter/material.dart';
import 'package:dio_api_products/core/helpers/http_response.dart';
import 'package:dio_api_products/data/models/create_product_response_model.dart';
import 'package:dio_api_products/data/repositories/product_repository_interface.dart';

class UpdateProductViewModel extends ChangeNotifier {
  final ProductRepository productRepository;

  bool _isLoading = false;
  String? _error;
  String? _successMessage;

  UpdateProductViewModel(this.productRepository);

  // Getters
  bool get isLoading => _isLoading;
  String? get error => _error;
  String? get successMessage => _successMessage;

  // Update product
  Future<bool> updateProduct(
    int id,
    String title,
    String price,
    String description,
    String image,
    String category,
  ) async {
    _isLoading = true;
    _error = null;
    _successMessage = null;
    notifyListeners();

    try {
      HttpResponse<CreateProductResponse> response = await productRepository
          .updateProduct(id, title, price, description, image, category);

      if (response.data != null) {
        _successMessage = 'Product updated successfully';
        notifyListeners();
        return true;
      } else {
        _error = response.error?.message ?? 'Failed to update product';
        notifyListeners();
        return false;
      }
    } catch (e) {
      _error = 'Error updating product: ${e.toString()}';
      notifyListeners();
      return false;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // Clear messages
  void clearMessages() {
    _error = null;
    _successMessage = null;
    notifyListeners();
  }
}
