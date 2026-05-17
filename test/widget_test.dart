import 'package:dio_api_products/core/helpers/dependency_injection.dart';
import 'package:dio_api_products/main.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('App muestra la pantalla de productos', (WidgetTester tester) async {
    DependencyInjection.initialize();
    await tester.pumpWidget(const MyApp());

    expect(find.text('Fake Store API'), findsOneWidget);
  });
}
