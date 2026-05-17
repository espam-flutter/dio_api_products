import 'package:dio_api_products/core/routes/app_routes.dart';
import 'package:dio_api_products/ui/screens/product_detail_screen.dart';
import 'package:dio_api_products/ui/screens/products_listview_screen.dart';
import 'package:flutter/material.dart';

abstract class AppRouter {
  static Route<dynamic> onGenerateRoute(RouteSettings routeSettings) {
    switch (routeSettings.name) {
      case AppRoutes.products:
        return MaterialPageRoute(
          settings: routeSettings,
          builder: (_) => const ProductsListViewScreen(),
        );
      case AppRoutes.productDetail:
        final productId = routeSettings.arguments as int;
        return MaterialPageRoute(
          settings: routeSettings,
          builder: (_) => ProductDetailScreen(productID: productId),
        );
      default:
        throw Exception('Ruta no definida: ${routeSettings.name}');
    }
  }
}
