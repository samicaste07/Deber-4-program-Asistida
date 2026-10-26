<!-- Sync Impact Report
Version change: 0.0.0 → 1.0.0 (Ratificación inicial)
List of modified principles:
  - Definición formal de principios rectores sin inventar principios adicionales.
Added sections:
  - I. Calidad de Código (Principios SOLID)
  - II. Arquitectura Limpia y Reglas de Dependencia
  - III. Seguridad
  - IV. Calidad y Pruebas
  - V. Regla de la Materia (Explicabilidad Estudiantil)
  - Governance
Removed sections:
  - Placeholders de plantilla genérica.
Follow-up TODOs: Ninguno.
-->

# Divisor de Cuenta Constitution

## Core Principles

### I. Calidad de Código (Principios SOLID)
Todo el código del proyecto DEBE respetar estrictamente los principios SOLID:
- **SRP (Single Responsibility Principle):** Una clase, una única razón de cambio. La lógica de cálculo NO valida entradas ni formatea cadenas visuales.
- **OCP (Open/Closed Principle):** Abierto a extensión, cerrado a modificación. Agregar una nueva regla de redondeo o cálculo no obliga a editar las clases preexistentes.
- **LSP (Liskov Substitution Principle):** Cualquier implementación de una interfaz DEBE poder sustituir a otra sin que quien la consume requiera comprobar de qué tipo concreto se trata.
- **ISP (Interface Segregation Principle):** Interfaces pequeñas y específicas; ningún cliente ni componente DEBE depender de métodos que no utiliza.
- **DIP (Dependency Inversion Principle):** La capa `presentation` depende exclusivamente de abstracciones de `domain`, nunca de clases concretas de `data`.

### II. Arquitectura Limpia y Reglas de Dependencia
La aplicación DEBE estructurarse de acuerdo con las siguientes directrices arquitectónicas:
- **Capas:** Organización estricta en `lib/presentation/`, `lib/domain/` y `lib/data/`.
- **Regla de Dependencia:** Flujo unidireccional `presentation` -> `domain` <- `data`.
- **Aislamiento de Dominio:** `lib/domain/` es Dart puro y NO importa bajo ninguna circunstancia `package:flutter`.
- **Inyección y Composición:** `main.dart` es el ÚNICO punto de entrada y ensamblaje donde se instancian implementaciones concretas.

### III. Seguridad
- Prohibición absoluta de almacenar secretos, credenciales o API keys dentro del repositorio.

### IV. Calidad y Pruebas
- Toda funcionalidad crítica DEBE contar con pruebas automatizadas.
- Los criterios de aceptación de cada especificación (spec) DEBEN transformarse obligatoriamente en pruebas ejecutables que verifiquen el cumplimiento del sistema.

### V. Regla de la Materia (Explicabilidad Estudiantil)
- Toda función generada por el agente DEBE poder ser explicada en su totalidad por el estudiante:
  1. Qué hace.
  2. Por qué existe.
  3. Qué recibe (parámetros y tipos).
  4. Qué devuelve (tipo de retorno y significado).
  5. Qué errores o excepciones produce y cómo se manejan.

## Governance
Esta constitución establece las normas no negociables del proyecto `divisor_cuenta` y rige todas las especificaciones, planes y tareas implementadas por agentes o desarrolladores. Cualquier cambio o enmienda a estos principios requiere justificación explícita, actualización de la versión semántica y aprobación formal.

**Version**: 1.0.0 | **Ratified**: 2026-10-07 | **Last Amended**: 2026-10-07
