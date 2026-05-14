import 'package:dio_api_products/ui/viewmodels/update_product_view_model.dart';
import 'package:dio_api_products/data/repositories/product_repository_interface.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:get_it/get_it.dart';

class UpdateProductScreen extends StatefulWidget {
  final int id;
  final String title;
  final String price;
  final String description;
  final String image;
  final String category;

  const UpdateProductScreen({
    super.key,
    required this.id,
    required this.title,
    required this.price,
    required this.description,
    required this.image,
    required this.category,
  });

  @override
  State<UpdateProductScreen> createState() => _UpdateProductScreenState();
}

class _UpdateProductScreenState extends State<UpdateProductScreen> {
  late TextEditingController titleController;
  late TextEditingController priceController;
  late TextEditingController descriptionController;
  late TextEditingController imageController;
  late TextEditingController categoryController;

  @override
  void initState() {
    super.initState();
    titleController = TextEditingController(text: widget.title);
    priceController = TextEditingController(text: widget.price);
    descriptionController = TextEditingController(text: widget.description);
    imageController = TextEditingController(text: widget.image);
    categoryController = TextEditingController(text: widget.category);
  }

  @override
  void dispose() {
    titleController.dispose();
    priceController.dispose();
    descriptionController.dispose();
    imageController.dispose();
    categoryController.dispose();
    super.dispose();
  }

  void _handleUpdate(
    BuildContext context,
    UpdateProductViewModel viewModel,
  ) async {
    final messenger = ScaffoldMessenger.of(context);
    final navigator = Navigator.of(context);
    final success = await viewModel.updateProduct(
      widget.id,
      titleController.text,
      priceController.text,
      descriptionController.text,
      imageController.text,
      categoryController.text,
    );

    if (!mounted) return;

    if (success) {
      messenger.showSnackBar(
        const SnackBar(
          content: Text('Product updated successfully'),
          duration: Duration(seconds: 2),
        ),
      );
      navigator.pop();
    } else {
      messenger.showSnackBar(
        SnackBar(
          content: Text('Error: ${viewModel.error}'),
          duration: const Duration(seconds: 2),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) =>
          UpdateProductViewModel(GetIt.instance<ProductRepository>()),
      child: Scaffold(
        appBar: AppBar(
          title: const Text("Update Product"),
          foregroundColor: Colors.white,
          backgroundColor: Colors.deepOrangeAccent,
        ),
        body: Consumer<UpdateProductViewModel>(
          builder: (context, viewModel, child) {
            return Padding(
              padding: const EdgeInsets.all(30.0),
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    const SizedBox(height: 10),
                    TextFormField(
                      controller: titleController,
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: 'Enter a title',
                      ),
                      enabled: !viewModel.isLoading,
                    ),
                    const SizedBox(height: 10),
                    TextFormField(
                      controller: priceController,
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: 'Enter a price',
                      ),
                      enabled: !viewModel.isLoading,
                    ),
                    const SizedBox(height: 10),
                    TextFormField(
                      maxLines: 10,
                      controller: descriptionController,
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: 'Enter a description',
                      ),
                      enabled: !viewModel.isLoading,
                    ),
                    const SizedBox(height: 10),
                    TextFormField(
                      controller: imageController,
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: 'Enter an image URL',
                      ),
                      enabled: !viewModel.isLoading,
                    ),
                    const SizedBox(height: 10),
                    TextFormField(
                      controller: categoryController,
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: 'Enter a category',
                      ),
                      enabled: !viewModel.isLoading,
                    ),
                    const SizedBox(height: 20),
                    ElevatedButton(
                      onPressed: viewModel.isLoading
                          ? null
                          : () => _handleUpdate(context, viewModel),
                      child: viewModel.isLoading
                          ? const SizedBox(
                              height: 20,
                              width: 20,
                              child: CircularProgressIndicator(strokeWidth: 2),
                            )
                          : const Text("Update Product"),
                    ),
                    if (viewModel.error != null)
                      Padding(
                        padding: const EdgeInsets.only(top: 16.0),
                        child: Text(
                          'Error: ${viewModel.error}',
                          style: const TextStyle(color: Colors.red),
                        ),
                      ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
