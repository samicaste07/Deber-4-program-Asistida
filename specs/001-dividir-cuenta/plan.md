# Implementation Plan: División de Cuenta de Restaurante

**Branch**: `001-dividir-cuenta` | **Date**: 2026-10-07 | **Spec**: [spec.md](spec.md)

**Input**: Feature specification from `specs/001-dividir-cuenta/spec.md`

## Summary

Implementar una aplicación móvil en Flutter de una sola pantalla para dividir la cuenta de un restaurante equitativamente, permitiendo ingresar monto, personas y porcentaje de propina, con dos estrategias de redondeo ("exacto" y "hacia arriba al entero"). Se adopta una arquitectura limpia en tres capas (`domain`, `data`, `presentation`) con principios SOLID estrictos, donde el dominio es Dart puro y `main.dart` actúa como el único punto de composición de dependencias.

## Technical Context

**Language/Version**: Dart 3.13+ / Flutter SDK estable (sin paquetes externos adicionales).

**Primary Dependencies**: Únicamente el SDK de Flutter (`flutter/material.dart` solo en `presentation/` y `main.dart`).

**Storage**: N/A (100% offline, aplicación sin persistencia ni base de datos).

**Testing**: `flutter_test` (pruebas unitarias para dominio/datos y pruebas de widgets para presentación).

**Target Platform**: Android, iOS, Web, Windows/macOS/Linux (multiplataforma Flutter nativa).

**Project Type**: Mobile Application (Single screen).

**Performance Goals**: Cálculo y renderizado instantáneo en pantalla en $< 50$ ms al presionar "Calcular".

**Constraints**:
- Capa `lib/domain/` 100% Dart puro (prohibido importar `package:flutter`).
- Cero dependencias externas en `pubspec.yaml`.
- Estado local mediante `setState` encapsulado con `DivisorController`.
- Cobertura completa de los 6 escenarios de aceptación en pruebas ejecutables.

**Scale/Scope**: 1 pantalla, 1 caso de uso principal, 2 estrategias de redondeo, 1 validador.

## Constitution Check

*GATE: Must pass before Phase 0 research. Re-check after Phase 1 design.*

| Principio | Regla Constitucional | Estado en el Diseño |
| :--- | :--- | :--- |
| **SOLID - SRP** | Cálculo no valida ni formatea; una clase, una responsabilidad. | **PASS**: `CalcularDivision` solo calcula. `ValidarEntrada` solo valida. `FormateadorMoneda` solo formatea. |
| **SOLID - OCP** | Extensión sin modificación de clases existentes. | **PASS**: `EstrategiaRedondeo` es una interfaz abstracta. Nuevos redondeos no modifican `CalcularDivision`. |
| **SOLID - LSP** | Sustitución transparente de implementaciones. | **PASS**: `RedondeoExacto` y `RedondeoHaciaArriba` implementan `EstrategiaRedondeo` de forma intercambiable. |
| **SOLID - ISP** | Interfaces cohesivas y pequeñas. | **PASS**: `EstrategiaRedondeo` expone un único método `double redondear(double monto)`. |
| **SOLID - DIP** | Presentation depende de abstracciones de domain, no de data concreta. | **PASS**: `DivisorController` recibe `EstrategiaRedondeo` y casos de uso por inyección de dependencias. |
| **Arquitectura** | Capas `presentation -> domain <- data`. | **PASS**: `domain` no depende de nadie; `data` y `presentation` dependen de `domain`. |
| **Dart Puro** | `domain/` no importa `package:flutter`. | **PASS**: Verificado en todos los contratos y entidades de dominio. |
| **Composición** | `main.dart` es el único lugar de instanciación concreta. | **PASS**: `main.dart` ensambla el grafo de dependencias y lo inyecta a la vista raíz. |
| **Seguridad** | Cero secretos/API keys en el repositorio. | **PASS**: App 100% offline sin servicios externos ni llaves. |
| **Pruebas** | Criterios de aceptación convertidos en pruebas ejecutables. | **PASS**: Los 6 escenarios de aceptación se diseñaron para tests automatizados. |
| **Regla Materia**| Explicabilidad total por el estudiante. | **PASS**: Diseño limpio, intuitivo y pedagógicamente justificable. |

## Project Structure

### Documentation (this feature)

```text
specs/001-dividir-cuenta/
├── plan.md              # Este plan de implementación
├── research.md          # Decisiones de investigación y alternativas evaluadas
├── data-model.md        # Definición de entidades, casos de uso y contratos
├── quickstart.md        # Guía de verificación de extremo a extremo
├── contracts/
│   └── divisor_contract.md # Contratos de interfaces del feature
└── checklists/
    └── requirements.md  # Checklist de calidad de la especificación
```

### Source Code (repository root)

```text
lib/
├── domain/
│   ├── entities/
│   │   ├── cuenta.dart
│   │   └── resultado.dart
│   ├── usecases/
│   │   ├── calcular_division.dart
│   │   └── validar_entrada.dart
│   └── strategies/
│       └── estrategia_redondeo.dart
├── data/
│   └── strategies/
│       ├── redondeo_exacto.dart
│       └── redondeo_hacia_arriba.dart
├── presentation/
│   ├── controllers/
│   │   └── divisor_controller.dart
│   ├── utils/
│   │   └── formateador_moneda.dart
│   └── views/
│       └── pantalla_divisor.dart
└── main.dart

test/
├── unit/
│   ├── domain/
│   │   ├── calcular_division_test.dart
│   │   └── validar_entrada_test.dart
│   └── data/
│       ├── redondeo_exacto_test.dart
│       └── redondeo_hacia_arriba_test.dart
└── widget/
    └── pantalla_divisor_test.dart
```

**Structure Decision**: Clean Architecture en tres capas estrictas (`domain`, `data`, `presentation`) con Dart puro en `domain/` y composición única en `main.dart`.

## Complexity Tracking

> **Sin violaciones ni complejidades no justificadas.** El diseño se apega 100% a las directrices de la Constitución y la solicitud del usuario.
