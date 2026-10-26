# Contratos de Interfaces y Clases: División de Cuenta

## 1. Contrato: `EstrategiaRedondeo` (Domain)

```dart
abstract interface class EstrategiaRedondeo {
  /// Redondea un monto monetario según la regla de la estrategia.
  double redondear(double monto);
}
```

## 2. Contrato: `CalcularDivision` (Domain)

```dart
class CalcularDivision {
  /// Ejecuta el cálculo puro de la división de la cuenta.
  /// No valida entradas ni formatea cadenas visuales.
  Resultado ejecutar(Cuenta cuenta);
}
```

## 3. Contrato: `ValidarEntrada` (Domain)

```dart
class ValidarEntrada {
  /// Valida el campo de texto del monto total.
  String? validarMonto(String? texto);

  /// Valida el campo de texto del número de personas.
  String? validarPersonas(String? texto);

  /// Valida el campo de texto del porcentaje de propina.
  String? validarPropina(String? texto);
}
```

## 4. Contrato: `DivisorController` (Presentation)

```dart
class DivisorController {
  final CalcularDivision calcularDivision;
  final ValidarEntrada validarEntrada;
  final EstrategiaRedondeo redondeoExacto;
  final EstrategiaRedondeo redondeoHaciaArriba;

  DivisorController({
    required this.calcularDivision,
    required this.validarEntrada,
    required this.redondeoExacto,
    required this.redondeoHaciaArriba,
  });

  Resultado? resultado;
  String? errorMonto;
  String? errorPersonas;

  void calcular({
    required String textoMonto,
    required String textoPersonas,
    required String textoPropina,
    required bool usarRedondeoHaciaArriba,
  });
}
```

