# Research & Architectural Decisions: División de Cuenta

## 1. Decisiones Técnicas y Arquitectura

### Decisión 1: Manejo de Estado Local
- **Decisión**: Utilizar `setState` en un widget con estado (`StatefulWidget`) en la capa de presentación (`PantallaDivisor`).
- **Razón**: La aplicación consta de una sola pantalla sin flujos de navegación complejos ni estado compartido entre módulos. `setState` es nativo del SDK de Flutter, ligero, sin dependencias de paquetes de terceros y completamente predecible.
- **Alternativas consideradas**:
  - `Provider` / `Riverpod`: Descartados por violar el principio de "sin paquetes externos".
  - `Bloc` / `Cubit`: Descartados por complejidad innecesaria para una sola pantalla (violación de YAGNI/KISS).

### Decisión 2: Desacoplamiento del Dominio (Dart Puro)
- **Decisión**: Toda la lógica de cálculo (`CalcularDivision`), validación (`ValidarEntrada`), entidades (`Cuenta`, `Resultado`) y la interfaz `EstrategiaRedondeo` residen en `lib/domain/` como código Dart puro sin importar `package:flutter`.
- **Razón**: Cumple estrictamente la Constitución del proyecto y las reglas de Clean Architecture. Permite ejecutar pruebas unitarias ultra-rápidas en milisegundos sin inicializar el motor de Flutter.
- **Alternativas consideradas**:
  - Poner la lógica en el widget: Rechazado rotundamente (violaba SRP y la constitución).

### Decisión 3: Patrón Estrategia (Strategy Pattern) para Redondeo
- **Decisión**: Crear la interfaz abstracta `EstrategiaRedondeo` en `domain/` con un único método `double redondear(double monto)`. Las implementaciones concretas `RedondeoExacto` y `RedondeoHaciaArriba` residen en `data/`.
- **Razón**: Cumple con OCP (Open/Closed Principle) y LSP (Liskov Substitution Principle). Agregar futuras estrategias (ej. redondeo al múltiplo de 5, redondeo bancario) no exigirá modificar la clase de cálculo `CalcularDivision`.
- **Alternativas consideradas**:
  - Condicional `switch/if-else` en `CalcularDivision`: Rechazado porque violaba OCP al forzar la modificación de la clase existente ante cada nueva regla de redondeo.

### Decisión 4: Controlador de Presentación (`DivisorController`)
- **Decisión**: Un controlador en `presentation/` que recibe sus dependencias (`CalcularDivision`, `ValidarEntrada`, estrategias) mediante inyección en el constructor.
- **Razón**: Respeta DIP (Dependency Inversion) y SRP. El widget solo se encarga de renderizar la UI y escuchar el controlador, mientras que el controlador orquesta la validación, la llamada al caso de uso y la notificación a la vista.
- **Alternativas consideradas**:
  - Instanciar casos de uso directamente en el State del Widget: Rechazado para preservar la testabilidad independiente de la lógica de presentación.

### Decisión 5: Composición e Inyección en `main.dart`
- **Decisión**: `main.dart` es el único lugar donde se crean las instancias concretas de `RedondeoExacto`, `RedondeoHaciaArriba`, `CalcularDivision`, `ValidarEntrada` y `DivisorController`.
- **Razón**: Mandato explícito de la Constitución del proyecto ("main.dart es el ÚNICO lugar donde se instancian implementaciones concretas"). Garantiza que ninguna capa cree dependencias duras.

