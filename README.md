# dio_api_products

Aplicación móvil desarrollada con Flutter para la gestión y visualización de productos mediante el consumo de la [Fake Store API](https://fakestoreapi.com/). El proyecto demuestra integración REST con **Dio**, navegación por rutas nombradas y una arquitectura por capas con inversión de dependencias.

## Funcionalidades

| Módulo | Descripción |
| :--- | :--- |
| **Listado de productos** | Obtiene todos los productos (`GET /products`). |
| **Detalle de producto** | Muestra un producto por ID (`GET /products/{id}`). |
| **Eliminar producto** | Deslizar para borrar (`DELETE /products/{id}`). |

## Stack y dependencias

| Dependencia | Propósito | Versión |
| :--- | :--- | :--- |
| **Flutter SDK** | Framework multiplataforma | SDK ^3.11.5 |
| **dio** | Cliente HTTP para peticiones REST | ^5.9.2 |
| **provider** | Gestión de estado (`ChangeNotifier`) | ^6.1.5 |
| **get_it** | Service Locator / inyección de dependencias | ^9.2.1 |
| **cupertino_icons** | Iconografía estilo iOS | ^1.0.8 |
| **flutter_lints** | Análisis estático (dev) | ^6.0.0 |

## Arquitectura

El proyecto separa la UI de la lógica de negocio y el acceso a datos, facilitando pruebas y mantenimiento.

**Jerarquía de comunicación:**

`UI (Screens/Widgets)` → `ViewModel (ChangeNotifier)` → `Repository (Interface/Impl)` → `API (Interface/Impl)` → `BaseHttpDio` → `Dio`

**Estructura de carpetas en `lib/`:**

```
lib/
├── main.dart
├── core/
│   ├── helpers/
│   │   ├── base_http_dio.dart
│   │   ├── dependency_injection.dart
│   │   ├── http_error.dart
│   │   └── http_response.dart
│   └── routes/
│       ├── app_routes.dart
│       └── app_router.dart
├── data/
│   ├── api/                    # ProductAPI
│   ├── models/
│   └── repositories/           # ProductRepository
└── ui/
    ├── screens/                # Products, Detail
    ├── viewmodels/
    └── widgets/
```

### Capas principales

| Capa | Responsabilidad |
| :--- | :--- |
| **core/helpers** | DI, HTTP genérico y envoltorio de respuestas. |
| **core/routes** | Rutas nombradas y generación de pantallas. |
| **data/api** | Llamadas HTTP de productos. |
| **data/repository** | Mediador entre ViewModels y APIs. |
| **data/models** | Serialización JSON (`fromJson`). |
| **ui/viewmodels** | Estado, carga, errores; notifican con `notifyListeners()`. |
| **ui/screens** | Interfaz de usuario. |

## Navegación por rutas

La app usa rutas nombradas con `MaterialApp.onGenerateRoute`.

| Ruta | Pantalla | Argumentos |
| :--- | :--- | :--- |
| `/products` | `ProductsScreen` | — (pantalla inicial vía `home`) |
| `/product-detail` | `ProductDetailScreen` | `int` (id del producto) |

## Flujo de arranque

1. **`main()`** → `DependencyInjection.initialize()`.
2. **`runApp(MyApp)`** → `ChangeNotifierProvider` con `ProductsViewModel`.
3. **`MaterialApp`** → `home: ProductsScreen`; `onGenerateRoute` para el detalle.

## Conceptos para estudiar y dominar el proyecto

1. **Fundamentos de Dart y Flutter** — `Future`, `async` / `await`, Null Safety.
2. **JSON y modelado de datos** — `fromJson` / `toJson`.
3. **Dio y REST** — `BaseOptions`, `DioException`, `HttpResponse<T>`.
4. **Provider** — `ChangeNotifier`, `Consumer`, `context.read`.
5. **GetIt** — `registerSingleton`, `GetIt.instance`.
6. **Patrón Repository e interfaces** — `ProductAPI`, `ProductRepository`.
7. **Navegación** — Rutas nombradas y argumentos.
8. **Estados de UI** — Cargando, error y éxito.

## Cómo ejecutar el proyecto

```bash
flutter pub get
flutter run
flutter analyze
flutter test
```

## Guía para construir el proyecto desde cero

Paso a paso detallado (arquitectura, orden de archivos y pruebas): [docs/GUIA_DESDE_CERO.md](docs/GUIA_DESDE_CERO.md)

## Referencias

- [Flutter Documentation](https://docs.flutter.dev)
- [dio](https://pub.dev/packages/dio)
- [provider](https://pub.dev/packages/provider)
- [get_it](https://pub.dev/packages/get_it)
- [Fake Store API](https://fakestoreapi.com/)

## Licencia / estado del proyecto

Proyecto con fines educativos. Sin licencia formal declarada; uso orientado a aprendizaje y referencia de arquitectura Flutter.
