import 'package:dio_api_products/ui/viewmodels/product_detail_view_model.dart';
import 'package:dio_api_products/data/repositories/product_repository_interface.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:get_it/get_it.dart';

class ProductDetailScreen extends StatelessWidget {
  final int productID;
  const ProductDetailScreen({super.key, required this.productID});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => ProductDetailViewModel(
        productRepository: GetIt.instance<ProductRepository>(),
        productId: productID,
      ),
      child: _ProductDetailScreenContent(productID: productID),
    );
  }
}

class _ProductDetailScreenContent extends StatefulWidget {
  final int productID;
  const _ProductDetailScreenContent({required this.productID});

  @override
  State<_ProductDetailScreenContent> createState() =>
      _ProductDetailScreenContentState();
}

class _ProductDetailScreenContentState
    extends State<_ProductDetailScreenContent> {
  @override
  void initState() {
    super.initState();
    // Load product when screen initializes
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      context.read<ProductDetailViewModel>().loadProduct();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Detalle del producto"),
        foregroundColor: Colors.white,
        backgroundColor: Colors.deepOrangeAccent,
      ),
      body: Consumer<ProductDetailViewModel>(
        builder: (context, viewModel, child) {
          if (viewModel.isLoading) {
            return const Center(child: CircularProgressIndicator.adaptive());
          }

          if (viewModel.error != null) {
            return Center(
              child: Text(
                'Error: ${viewModel.error}',
                style: const TextStyle(color: Colors.red),
              ),
            );
          }

          if (viewModel.product == null) {
            return const Center(child: Text('Product not found'));
          }

          final product = viewModel.product!;

          return Padding(
            padding: const EdgeInsets.all(12.0),
            child: SingleChildScrollView(
              child: Column(
                children: [
                  Text(
                    product.title,
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: Colors.deepOrangeAccent,
                    ),
                  ),
                  Text(product.price.toString()),
                  Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: Image.network(
                      product.image,
                      width: 150,
                      height: 150,
                    ),
                  ),
                  Text(product.description),
                  Text(product.category.name),
                  Text(product.rating.rate.toString()),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
