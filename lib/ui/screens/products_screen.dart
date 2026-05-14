import 'package:dio_api_products/ui/screens/product_detail_screen.dart';
import 'package:dio_api_products/ui/viewmodels/products_view_model.dart';
import 'package:dio_api_products/ui/widgets/product_widget.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ProductsScreen extends StatefulWidget {
  const ProductsScreen({super.key});

  @override
  State<ProductsScreen> createState() => _ProductsScreenState();
}

class _ProductsScreenState extends State<ProductsScreen> {
  @override
  void initState() {
    super.initState();
    // Load products when screen initializes
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      context.read<ProductsViewModel>().loadProducts();
    });
  }

  void showDetail(int id) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) {
          return ProductDetailScreen(productID: id);
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Fake Store API"),
        foregroundColor: Colors.white,
        backgroundColor: Colors.deepOrangeAccent,
      ),
      backgroundColor: Colors.orangeAccent,
      body: Consumer<ProductsViewModel>(
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

          if (viewModel.products.isEmpty) {
            return const Center(child: Text('No products found'));
          }

          return ListView.builder(
            itemCount: viewModel.products.length,
            itemBuilder: (context, index) {
              return ProductWidget(
                product: viewModel.products[index],
                onTap: showDetail,
                onSwipe: (id) async {
                  final messenger = ScaffoldMessenger.of(context);
                  final deleted = await viewModel.deleteProduct(id);
                  if (deleted && mounted) {
                    messenger.showSnackBar(
                      const SnackBar(
                        content: Text('Product deleted successfully'),
                        duration: Duration(seconds: 2),
                      ),
                    );
                  }
                },
              );
            },
          );
        },
      ),
    );
  }
}
