import 'package:dio_api_products/core/helpers/dependency_injection.dart';
import 'package:dio_api_products/core/routes/app_router.dart';
import 'package:dio_api_products/data/repositories/product_repository_interface.dart';
import 'package:dio_api_products/ui/screens/products_listview_screen.dart';
import 'package:dio_api_products/ui/viewmodels/products_listview_model.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:provider/provider.dart';

void main() {
  DependencyInjection.initialize();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => ProductsViewModel(GetIt.instance<ProductRepository>()),
      child: MaterialApp(
        title: 'Flutter Fake API Store',
        home: const ProductsListViewScreen(),
        onGenerateRoute: AppRouter.onGenerateRoute,
      ),
    );
  }
}
