import 'package:dio_api_products/data/models/product_model.dart';
import 'package:flutter/material.dart';

class ProductWidget extends StatelessWidget {
  final Product product;
  final Function onTap;
  final Function onSwipe;
  const ProductWidget({
    super.key,
    required this.product,
    required this.onTap,
    required this.onSwipe,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        onTap(product.id);
      },
      onHorizontalDragEnd: (DragEndDetails dragEndDetails) {
        onSwipe(product.id);
      },
      child: Container(
        margin: const EdgeInsets.fromLTRB(10, 10, 10, 0),
        padding: const EdgeInsets.all(10.0),
        decoration: const BoxDecoration(
          color: Color.fromARGB(255, 255, 255, 255),
          borderRadius: BorderRadius.all(Radius.circular(20)),
        ),
        child: Column(
          children: [
            Text(
              product.title,
              style: const TextStyle(color: Colors.deepOrangeAccent),
            ),
            SizedBox(
              width: 100,
              height: 100,
              child: Padding(
                padding: const EdgeInsets.all(5.0),
                child: Image.network(product.image),
              ),
            ),
            Text(product.description),
          ],
        ),
      ),
    );
  }
}
