import 'package:dio_api_products/core/helpers/dependency_injection.dart';
import 'package:dio_api_products/data/repositories/product_repository_interface.dart';
import 'package:dio_api_products/ui/screens/products_screen.dart';
import 'package:dio_api_products/ui/viewmodels/products_view_model.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:get_it/get_it.dart';

void main() {
  //Iniciar la inyección de dependencias
  DependencyInjection.initialize();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => ProductsViewModel(GetIt.instance<ProductRepository>()),
        ),
      ],
      child: MaterialApp(
        title: 'Flutter Demo',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
          useMaterial3: true,
        ),
        home: const ProductsScreen(),
      ),
    );
  }
}
