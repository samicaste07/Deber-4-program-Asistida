# Guía de Validación Rápida (Quickstart): División de Cuenta

Esta guía describe cómo verificar de extremo a extremo que la implementación cumple con todos los escenarios de aceptación y las reglas de arquitectura.

## Prerrequisitos
- Flutter SDK 3.x+ instalado.
- Terminal configurada en la raíz del proyecto `c:\Proyectos flutter\Repo-Samuel\divisor_cuenta`.

## Comandos de Verificación Automatizada

### 1. Análisis estático
Verifica que no existan advertencias de tipado, null safety ni violaciones de lint:
```bash
flutter analyze
```
*Resultado esperado*: `No issues found!`.

### 2. Pruebas Unitarias y de Widgets
Ejecuta la suite completa de pruebas:
```bash
flutter test
```
*Resultado esperado*: Todas las pruebas pasando (`All tests passed!`).

---

## Matriz de Verificación de Escenarios de Aceptación

| # | Escenario | Entradas | Modo Redondeo | Resultado Esperado |
|---|-----------|----------|---------------|--------------------|
| 1 | Básico con propina | Monto: `100.00`, Personas: `4`, Propina: `10%` | Exacto | Pago individual: `27.50` |
| 2 | Sin propina | Monto: `90.00`, Personas: `3`, Propina: `0%` | Exacto | Pago individual: `30.00` |
| 3 | Cero personas | Monto: `50.00`, Personas: `0` | Cualquier modo | Error: `"Debe haber al menos una persona"`, sin resultado |
| 4 | Monto alfanumérico | Monto: `"abc"` | Cualquier modo | Error: `"Monto inválido"`, sin resultado |
| 5 | Decimal periódico | Monto: `10.00`, Personas: `3`, Propina: `0%` | Exacto | Pago individual: `3.33` |
| 6 | Redondeo superior | Monto: `10.00`, Personas: `3`, Propina: `0%` | Hacia arriba | Pago individual: `4.00` |

---

## Verificación de Reglas Constitucionales
1. **Dart puro en `domain/`**: Inspeccionar archivos en `lib/domain/` y confirmar que ninguno importe `package:flutter`.
2. **Punto de composición único**: Inspeccionar `lib/main.dart` y confirmar que es allí donde se unen las implementaciones de `data/` y `domain/` para proveerlas a `PantallaDivisor`.

