# Guía: construir dio_api_products desde cero

Esta guía describe paso a paso cómo implementar este proyecto Flutter desde cero, en el orden recomendado (de abajo hacia arriba: red → datos → estado → UI).

## Lo que vas a construir

Una app Flutter que:

- Lista productos de [Fake Store API](https://fakestoreapi.com/)
- Muestra el detalle de uno
- Permite borrar deslizando
- Usa **Dio**, **GetIt**, **Provider** y arquitectura por capas

---

## Fase 0 — Requisitos previos

1. Instala [Flutter SDK](https://docs.flutter.dev/get-started/install) y verifica:

   ```bash
   flutter doctor
   ```

2. Editor con extensión Dart/Flutter (VS Code, Android Studio o Cursor).
3. Emulador Android o dispositivo físico con depuración USB.
4. Navegador o Postman para probar la API:
   - `GET https://fakestoreapi.com/products`
   - `GET https://fakestoreapi.com/products/1`
   - `DELETE https://fakestoreapi.com/products/1`

---

## Fase 1 — Crear el proyecto Flutter

1. En terminal:

   ```bash
   flutter create dio_api_products
   cd dio_api_products
   ```

2. Abre la carpeta en el IDE.
3. Ejecuta una vez para comprobar que compila:

   ```bash
   flutter run
   ```

4. Borra o ignora el contador de ejemplo en `lib/main.dart` (lo reemplazarás).

---

## Fase 2 — Dependencias (`pubspec.yaml`)

1. En `dependencies`, agrega:

   ```yaml
   dio: ^5.9.2
   get_it: ^9.2.1
   provider: ^6.1.5
   ```

2. Ejecuta:

   ```bash
   flutter pub get
   ```

**Por qué cada una:**

| Paquete | Uso |
| :--- | :--- |
| `dio` | Cliente HTTP |
| `get_it` | Inyectar el repositorio (singleton) |
| `provider` | Exponer ViewModels a las pantallas |

---

## Fase 3 — Estructura de carpetas

Dentro de `lib/`, crea esta estructura:

```
lib/
├── main.dart
├── core/
│   ├── helpers/
│   └── routes/
├── data/
│   ├── api/
│   ├── models/
│   └── repositories/
└── ui/
    ├── screens/
    ├── viewmodels/
    └── widgets/
```

**Regla:** cada capa solo habla con la de abajo:

`UI → ViewModel → Repository → API → BaseHttpDio → Dio`

---

## Fase 4 — Capa Core (infraestructura)

### Paso 4.1 — `http_error.dart`

Crea `lib/core/helpers/http_error.dart`:

- Clase con `statusCode`, `message`, `data`.
- Representa un fallo HTTP sin lanzar excepciones a la UI.

### Paso 4.2 — `http_response.dart`

Crea `lib/core/helpers/http_response.dart`:

- Clase genérica `HttpResponse<T>` con `data` y `error`.
- Métodos estáticos `success(data)` y `fail(statusCode, message, data)`.
- Toda la app usará esto en lugar de manejar `DioException` en cada pantalla.

### Paso 4.3 — `base_http_dio.dart`

Crea `lib/core/helpers/base_http_dio.dart`:

1. Recibe un `Dio` en el constructor.
2. Método `resquest<T>(pathUrl, { method, data, parser })`:
   - Llama `dio.request(...)`.
   - Si hay `parser`, convierte `response.data` y devuelve `HttpResponse.success`.
   - En `catch`, si es `DioException`, arma `HttpResponse.fail` con código y mensaje.
3. Centraliza aquí **todos** los try/catch de red.

### Paso 4.4 — Rutas

**`lib/core/routes/app_routes.dart`** — constantes:

- `productDetail = '/product-detail'`
- El listado usará `home` en `MaterialApp`, no hace falta ruta obligatoria para la raíz.

**`lib/core/routes/app_router.dart`** — `onGenerateRoute`:

- Caso `productDetail`: lee `settings.arguments as int` y devuelve `ProductDetailScreen(productID: id)`.
- `default`: lanza excepción o redirige al home.

---

## Fase 5 — Capa Data (modelos)

### Paso 5.1 — Inspeccionar el JSON de la API

Abre `https://fakestoreapi.com/products` y anota campos:

`id`, `title`, `price`, `description`, `category`, `image`, `rating` (`rate`, `count`).

### Paso 5.2 — Modelos (de abajo hacia arriba)

1. **`rating_model.dart`** — `rate`, `count`, `fromJson`.
2. **`product_model.dart`** — clase `Product` con `fromJson` / `toJson`.
   - `price` como `double` (`json["price"]?.toDouble()`).
   - `category` puede ser `String` o enum.
3. **`products_response_model.dart`** — envuelve `List<Product>`:
   - `ProductsResponse.fromJson(List<dynamic> json)` mapeando cada item a `Product`.
4. **`delete_product_response_model.dart`** — lo que devuelve DELETE (por ejemplo `id`).

**Prueba mental:** si el JSON encaja con tus clases, el parser de la API funcionará.

---

## Fase 6 — Capa Data (API)

### Paso 6.1 — Contrato `product_api_interface.dart`

```dart
abstract class ProductAPI {
  Future<HttpResponse<ProductsResponse>> getAllProducts();
  Future<HttpResponse<Product>> getSingleProduct(int id);
  Future<HttpResponse<DeleteProductResponse>> deleteProduct(int id);
}
```

### Paso 6.2 — Implementación `product_api_impl.dart`

1. Constructor: recibe `BaseHttpDio`.
2. `getAllProducts` → `GET /products`, parser: `ProductsResponse.fromJson(data)`.
3. `getSingleProduct` → `GET /products/$id`, parser: `Product.fromJson(data)`.
4. `deleteProduct` → `DELETE products/$id`, parser del modelo de borrado.

**Detalle:** usa rutas con `/` de forma consistente respecto a `baseUrl`.

---

## Fase 7 — Capa Data (Repository)

### Paso 7.1 — `product_repository_interface.dart`

Mismos tres métodos que la API (la UI solo conocerá el repositorio).

### Paso 7.2 — `product_repository_impl.dart`

- Recibe `ProductAPI`.
- Cada método delega: `return productAPI.getAllProducts();` etc.

**Por qué existe:** si mañana cambias Dio por otro cliente, solo tocas API + DI, no las pantallas.

---

## Fase 8 — Inyección de dependencias

### `dependency_injection.dart`

Orden de construcción:

```
Dio(BaseOptions(baseUrl: 'https://fakestoreapi.com/'))
  → BaseHttpDio(dio)
    → ProductAPIImpl(baseHttpDio)
      → ProductRepositoryImpl(productAPI)
        → GetIt.registerSingleton<ProductRepository>(...)
```

En `main()`:

```dart
void main() {
  DependencyInjection.initialize();
  runApp(const MyApp());
}
```

---

## Fase 9 — ViewModels (estado)

### Paso 9.1 — `products_listview_model.dart`

Clase `ProductsViewModel extends ChangeNotifier`:

| Campo privado | Getter público |
| :--- | :--- |
| `_products` | `products` |
| `_isLoading` | `isLoading` |
| `_error` | `error` |

**`loadProducts()`:**

1. `_isLoading = true`, `_error = null`, `notifyListeners()`.
2. `await productRepository.getAllProducts()`.
3. Si `response.data != null` → asignar lista; si no → `_error`.
4. `finally`: `_isLoading = false`, `notifyListeners()`.

**`deleteProduct(id)`:**

1. Llama al repositorio.
2. Si OK → quita el item de `_products` y `notifyListeners()`.
3. Devuelve `bool` para que la pantalla muestre SnackBar.

### Paso 9.2 — `product_detail_view_model.dart`

- Recibe `ProductRepository` y `productId`.
- `loadProduct()` similar: loading, error, `_product`, `notifyListeners()`.

---

## Fase 10 — UI (widgets y pantallas)

### Paso 10.1 — `product_widget.dart` (presentacional)

- Parámetros: `Product product`, `Function onTap`, `Function onSwipe`.
- `GestureDetector`:
  - `onTap` → `onTap(product.id)`
  - `onHorizontalDragEnd` → `onSwipe(product.id)`
- Muestra título, imagen (`Image.network`), descripción.

**No uses Provider aquí** — solo UI + callbacks.

### Paso 10.2 — `products_listview_screen.dart`

1. `StatefulWidget`.
2. En `initState`, post-frame callback: `context.read<ProductsViewModel>().loadProducts()`.
3. `Scaffold` + `AppBar` (`automaticallyImplyLeading: false` en la raíz).
4. `body: Consumer<ProductsViewModel>`:
   - loading → `CircularProgressIndicator`
   - error → `Text`
   - lista → `ListView.builder` con `ProductWidget`
5. `onTap` → `Navigator.pushNamed(context, AppRoutes.productDetail, arguments: id)`.
6. `onSwipe` → `viewModel.deleteProduct(id)` + SnackBar si `true`.

### Paso 10.3 — `product_detail_screen.dart`

1. Recibe `productID`.
2. `ChangeNotifierProvider` crea `ProductDetailViewModel` con `GetIt.instance<ProductRepository>()`.
3. Hijo stateful: en `initState` → `loadProduct()`.
4. `Consumer<ProductDetailViewModel>` muestra datos o error.
5. AppBar: "Detalle del producto" (la flecha atrás es normal en esta pantalla).

---

## Fase 11 — `main.dart` (ensamblar todo)

```dart
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
```

**Importante:**

- `home` para el listado (evita doble pantalla y flecha atrás confusa).
- `GetIt` en `main` y en `ProductDetailScreen` para el repositorio.
- `Provider` para los ViewModels.

---

## Fase 12 — Permisos y red (Android)

En `android/app/src/main/AndroidManifest.xml`, dentro de `<manifest>`:

```xml
<uses-permission android:name="android.permission.INTERNET"/>
```

Sin esto, Dio falla en dispositivo real.

---

## Fase 13 — Orden de pruebas recomendado

| Orden | Qué probar | Cómo |
| :---: | :--- | :--- |
| 1 | Dio / API | Breakpoint en `getAllProducts` |
| 2 | Listado | App arranca y muestra productos |
| 3 | Detalle | Tap en un producto |
| 4 | Borrar | Swipe horizontal en un ítem |
| 5 | Errores | Modo avión o URL incorrecta |
| 6 | Navegación | Detalle → atrás → listado |

Comandos:

```bash
flutter pub get
flutter analyze
flutter run
```

---

## Fase 14 — Checklist por archivo (orden de escritura)

```
 1. pubspec.yaml
 2. lib/core/helpers/http_error.dart
 3. lib/core/helpers/http_response.dart
 4. lib/core/helpers/base_http_dio.dart
 5. lib/core/routes/app_routes.dart
 6. lib/core/routes/app_router.dart
 7. lib/data/models/rating_model.dart
 8. lib/data/models/product_model.dart
 9. lib/data/models/products_response_model.dart
10. lib/data/models/delete_product_response_model.dart
11. lib/data/api/product_api_interface.dart
12. lib/data/api/product_api_impl.dart
13. lib/data/repositories/product_repository_interface.dart
14. lib/data/repositories/product_repository_impl.dart
15. lib/core/helpers/dependency_injection.dart
16. lib/ui/viewmodels/products_listview_model.dart
17. lib/ui/viewmodels/product_detail_view_model.dart
18. lib/ui/widgets/product_widget.dart
19. lib/ui/screens/products_listview_screen.dart
20. lib/ui/screens/product_detail_screen.dart
21. lib/main.dart
```

---

## Errores frecuentes al empezar desde cero

| Problema | Causa habitual | Solución |
| :--- | :--- | :--- |
| Lista vacía sin error | Parser JSON mal tipado | Revisa `fromJson` con un producto real |
| `Provider not found` | Pantalla fuera del `Provider` | Envuelve con `ChangeNotifierProvider` arriba en el árbol |
| `GetIt: Object not registered` | No llamaste `initialize()` | DI antes de `runApp` |
| Imágenes no cargan | Sin internet / permiso | `INTERNET` en manifest |
| Flecha atrás en listado | `initialRoute` + `home` duplicados | Solo `home` para la raíz |
| DELETE no actualiza UI | Sin `notifyListeners()` | Tras modificar `_products` |

---

## Resumen del flujo de una petición

```
Usuario abre app
  → ProductsListViewScreen
  → ProductsViewModel.loadProducts()
  → ProductRepository.getAllProducts()
  → ProductAPI.getAllProducts()
  → BaseHttpDio → Dio GET /products
  → JSON → ProductsResponse → List<Product>
  → notifyListeners() → Consumer redibuja ListView
```

---

## GetIt vs Provider en este proyecto

| Herramienta | Rol |
| :--- | :--- |
| **GetIt** | Inyecta `ProductRepository` (singleton) en `main` y `ProductDetailScreen` |
| **Provider** | Expone `ProductsViewModel` y `ProductDetailViewModel`; `Consumer` y `context.read` en pantallas |

---

## Referencias

- [Flutter Documentation](https://docs.flutter.dev)
- [dio](https://pub.dev/packages/dio)
- [provider](https://pub.dev/packages/provider)
- [get_it](https://pub.dev/packages/get_it)
- [Fake Store API](https://fakestoreapi.com/)
