# Instrucciones del Proyecto: Divisor de Cuenta

## Descripción
Aplicación en Flutter de una sola pantalla diseñada para dividir una cuenta entre varias personas de forma equitativa y sencilla.

## Estructura del Proyecto
El código dentro de `lib/` debe organizarse siguiendo una arquitectura limpia en tres capas:

- `lib/presentation/`: Pantallas, widgets y gestión visual de estado.
- `lib/domain/`: Entidades, reglas de negocio y lógica pura de cálculo.
- `lib/data/`: Fuentes de datos o repositorios (si aplican).

### Reglas de Dependencia
- Flujo estricto: `presentation` -> `domain` <- `data`.
- La capa `domain/` debe ser **Dart puro**: está prohibido importar `package:flutter` dentro de `domain/`.

## Estándares de Código
- **Null safety:** Obligatorio en todo el proyecto.
- **Idioma:** Nombres de clases, variables, funciones y comentarios en español.
- **Sin dependencias externas:** No utilizar librerías de terceros; apoyarse únicamente en el SDK de Flutter y Dart.

## Qué NO Tocar
- **No modificar `test/`** a menos que se solicite explícitamente.
- **No agregar dependencias** a `pubspec.yaml` sin autorización previa.
- **No modificar** las carpetas de plataformas nativas (`android/` e `ios/`).

## Comandos Principales
- Obtener dependencias: `flutter pub get`
- Ejecutar la aplicación: `flutter run`
- Análisis estático de código: `flutter analyze`
- Ejecutar pruebas automatizadas: `flutter test`

