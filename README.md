# dio_api_products

Este proyecto consiste en una aplicación móvil desarrollada con Flutter diseñada para la gestión y visualización de productos mediante el consumo de una API REST. El objetivo principal es demostrar una implementación robusta de integración con servicios externos utilizando el paquete Dio, siguiendo principios de arquitectura limpia y desacoplamiento de componentes.

La aplicación permite listar productos, ver detalles específicos y gestionar operaciones CRUD conceptuales. El código hace un uso intensivo de las capacidades modernas de Dart, como Null Safety y programación asíncrona (async/await), garantizando un flujo de datos eficiente y un manejo de errores centralizado para mejorar la experiencia del usuario y la mantenibilidad del software.

## Stack y dependencias

A continuación se detallan las tecnologías y librerías principales utilizadas en el desarrollo:

| Dependencia | Propósito | Versión (aprox.) |
| :--- | :--- | :--- |
| **Flutter SDK** | Framework de desarrollo multiplataforma | ^3.0.0 |
| **Dart** | Lenguaje de programación (Null Safety) | ^3.0.0 |
| **dio** | Cliente HTTP para peticiones REST | ^5.0.0 |
| **provider** | Gestión de estado y provisión de datos | ^6.0.0 |
| **get_it** | Service Locator para inyección de dependencias | ^7.0.0 |
| **cupertino_icons** | Activos visuales para estilo iOS | ^1.0.0 |
| **flutter_lints** | Análisis estático y buenas prácticas (Dev) | ^3.0.0 |

## Arquitectura

El proyecto sigue una arquitectura por capas bien definidas para separar la lógica de negocio de la interfaz de usuario, facilitando las pruebas unitarias y el escalamiento.

**Jerarquía de comunicación:**
`UI (Screens/Widgets)` → `ViewModel (ChangeNotifier)` → `Repository (Interface/Impl)` → `API Service (Interface/Impl)` → `Dio Client`

**Estructura de carpetas en `lib/`:**
* **core/helpers:** Contiene la configuración global, como la inicialización del inyector de dependencias (`dependency_injection.dart`) y la configuración base de Dio (`base_http_dio.dart`).
* **data/models:** Definición de clases de datos y lógica de serialización JSON.
* **data/api:** Contratos (interfaces) e implementaciones de las fuentes de datos remotas.
* **data/repository:** Implementación del patrón Repository para actuar como mediador entre la lógica de datos y la UI.
* **ui/screens:** Pantallas principales de la aplicación.
* **ui/viewmodels:** Lógica de estado que orquesta los repositorios y notifica a la vista.
* **ui/widgets:** Componentes reutilizables de la interfaz.

## Conceptos para estudiar y dominar el proyecto

Para comprender a fondo la implementación de este repositorio, se recomienda revisar los siguientes puntos:

1.  **Fundamentos de Dart y Flutter**
    - [ ] Uso de `Future`, `async` y `await`.
    - [ ] Sistema de tipos y Null Safety.
2.  **JSON y Modelado de Datos**
    - [ ] Mapeo de respuestas de mapas (`Map<String, dynamic>`) a objetos Dart.
    - [ ] Métodos `fromJson` y `toJson`.
3.  **Dio y Servicios REST**
    - [ ] Configuración de `BaseOptions` (baseUrl, timeouts).
    - [ ] Manejo de objetos `Response` y captura de excepciones con `DioException`.
4.  **Provider y Gestión de Estado**
    - [ ] Implementación de `ChangeNotifier` en ViewModels.
    - [ ] Uso de `notifyListeners()` para actualizar la UI.
5.  **GetIt e Inyección de Dependencias**
    - [ ] Registro de Singletons (`registerSingleton`).
    - [ ] Acceso a servicios mediante `GetIt.instance`.
6.  **Capas y Contratos**
    - [ ] Uso de clases abstractas para definir contratos en API y Repositorios.
    - [ ] Inversión de dependencias.
7.  **Manejo de Errores y Estados de Carga**
    - [ ] Control de estados (Cargando, Error, Éxito) en la interfaz de usuario.

## Flujo de arranque

El ciclo de vida del inicio de la aplicación sigue estrictamente este orden:

1.  **`main()`**: Punto de entrada donde se asegura la inicialización de los bindings de Flutter.
2.  **`DependencyInjection.initialize()`**: Se ejecutan los registros en `GetIt`. Se instancian el cliente Dio, los servicios de API y los repositorios.
3.  **`runApp()`**: Lanza el widget principal de la aplicación.
4.  **`MultiProvider`**: Envuelve la aplicación (o rutas específicas) inyectando los ViewModels necesarios. Estos ViewModels obtienen sus dependencias (Repositorios) directamente desde `GetIt` al ser instanciados.

## Referencias oficiales y lecturas recomendadas

* **Flutter Documentation:** [https://docs.flutter.dev](https://docs.flutter.dev)
* **Dart Async/Await:** [https://dart.dev/guides/language/async-await](https://dart.dev/guides/language/async-await)
* **Paquete dio:** [https://pub.dev/packages/dio](https://pub.dev/packages/dio)
* **Paquete provider:** [https://pub.dev/packages/provider](https://pub.dev/packages/provider)
* **Paquete get_it:** [https://pub.dev/packages/get_it](https://pub.dev/packages/get_it)
* **FakeStore API (Referencia de datos):** [https://fakestoreapi.com/](https://fakestoreapi.com/)

## Cómo ejecutar el proyecto

Para poner en marcha el proyecto localmente, asegúrate de tener configurado el SDK de Flutter y ejecuta los siguientes comandos en tu terminal:

1.  **Obtener las dependencias:**
    ```bash
    flutter pub get
    ```

2.  **Ejecutar la aplicación (asegúrate de tener un emulador o dispositivo conectado):**
    ```bash
    flutter run
    ```

3.  **Ejecutar pruebas (si están disponibles):**
    ```bash
    flutter test
    ```

## Licencia / estado del proyecto

Este proyecto se encuentra actualmente en estado de desarrollo educativo. No cuenta con una licencia formal declarada, por lo que su uso está destinado principalmente a fines de aprendizaje, referencia técnica y demostración de arquitectura en Flutter.