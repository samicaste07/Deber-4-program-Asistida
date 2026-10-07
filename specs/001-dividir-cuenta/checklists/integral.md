# Revisión Integral de Requisitos: División de Cuenta de Restaurante

**Purpose**: Evaluar la calidad, completitud, claridad y conformidad arquitectónica de la especificación y el plan de diseño antes y durante la implementación.
**Created**: 2026-10-07
**Feature**: [spec.md](../spec.md) | [plan.md](../plan.md)

**Note**: Este checklist personalizado fue generado mediante `/speckit-checklist`.
**Review Ownership**: Este es un artefacto de revisión de calidad de requerimientos propiedad del revisor. Marca un elemento `[x]` solo cuando determines que el criterio de calidad del requerimiento está completamente satisfecho.
**Marker Semantics**: `[x]` significa que el requerimiento fue revisado y validado en su redacción y diseño. No significa que la implementación esté completada.

## 1. Calidad de Requisitos Arquitectónicos y SOLID

- [ ] CHK001 ¿Se encuentra explícitamente delimitada la responsabilidad única (SRP) para que el caso de uso de cálculo no realice validaciones de texto ni formateo visual? [Plan §Technical Context, Constitution §I]
- [ ] CHK002 ¿Está especificado el principio Open/Closed (OCP) mediante una abstracción (`EstrategiaRedondeo`) que permita añadir futuras reglas sin modificar el código de cálculo existente? [Spec §FR-008, Plan §Constitution Check]
- [ ] CHK003 ¿La interfaz `EstrategiaRedondeo` está restringida a un contrato mínimo y cohesivo de un único método (ISP/LSP)? [Contracts §1, Plan §Constitution Check]
- [ ] CHK004 ¿Se establece con claridad que la capa `presentation` dependerá únicamente de abstracciones del `domain` y no de implementaciones concretas de `data` (DIP)? [Plan §Constitution Check]
- [ ] CHK005 ¿Está formalmente restringido que `main.dart` sea el único punto donde se construyen e inyectan las instancias concretas? [Plan §Structure Decision, Constitution §II]

## 2. Aislamiento de Capas y Reglas de Dependencia

- [ ] CHK006 ¿Se prohíbe de forma explícita cualquier importación de `package:flutter` dentro de la capa `lib/domain/` para garantizar Dart puro? [Plan §Constraints, Constitution §II]
- [ ] CHK007 ¿Está documentado el flujo unidireccional estricto de dependencias `presentation` -> `domain` <- `data`? [Plan §Project Structure]
- [ ] CHK008 ¿Se define con precisión que el controlador de presentación (`DivisorController`) recibirá todas sus dependencias mediante inyección en el constructor? [Contracts §4, Plan §Summary]

## 3. Completitud de Escenarios de Negocio y Cálculo

- [ ] CHK009 ¿Están definidos con precisión matemática los escenarios de cálculo con propina (100.00 con 4 personas y 10% de propina = 27.50)? [Spec §User Story 1]
- [ ] CHK010 ¿Está contemplado el caso de 0% de propina produciendo la división exacta de la cuenta (90.00 entre 3 personas = 30.00)? [Spec §User Story 1]
- [ ] CHK011 ¿Se especifica el comportamiento exacto de división fraccionaria periódica formateada a dos decimales (10.00 entre 3 personas con 0% = 3.33)? [Spec §User Story 1, §Edge Cases]
- [ ] CHK012 ¿Se define con exactitud la fórmula del redondeo hacia arriba al entero más cercano por persona (10.00 entre 3 personas con 0% = 4.00)? [Spec §User Story 2]
- [ ] CHK013 ¿Está especificado que el cálculo solo se ejecuta cuando el usuario acciona explícitamente el control "Calcular"? [Spec §FR-003]

## 4. Cobertura de Validaciones y Manejo de Errores

- [ ] CHK014 ¿Se exige textualmente el mensaje de error `"Debe haber al menos una persona"` cuando la cantidad de personas sea menor o igual a 0? [Spec §User Story 3, §FR-006]
- [ ] CHK015 ¿Se exige textualmente el mensaje de error `"Monto inválido"` ante entradas alfabéticas como `"abc"` o montos vacíos/negativos? [Spec §User Story 3, §FR-005]
- [ ] CHK016 ¿Está explícitamente documentado que ante cualquier error de validación NO se debe mostrar ningún resultado numérico en pantalla? [Spec §User Story 3, §SC-004]

## 5. Restricciones No Funcionales y Entorno

- [ ] CHK017 ¿Se garantiza que la aplicación opera 100% fuera de línea sin dependencias de red ni bases de datos locales/remotas? [Spec §FR-007, Plan §Storage]
- [ ] CHK018 ¿Se restringen las librerías a cero paquetes externos de terceros, utilizando exclusivamente el SDK de Flutter y Dart? [Plan §Technical Context, Constitution §Estándares]
- [ ] CHK019 ¿Se contempla el principio educativo de que cada función pueda ser explicada por el estudiante (qué hace, por qué existe, qué recibe, qué devuelve y qué errores produce)? [Constitution §V]

## Notes

- Este checklist debe ser completado por el revisor conforme se verifiquen los requerimientos y el diseño antes y durante el desarrollo.
- `/speckit-tasks` utilizará estas dimensiones para asegurar que cada tarea cuente con criterios de verificación claros.

