# Feature Specification: División de Cuenta de Restaurante

**Feature Branch**: `001-dividir-cuenta`

**Created**: 2026-10-07

**Status**: Draft

**Input**: User description: "Una app de una sola pantalla para dividir la cuenta de un restaurante entre varias personas. El usuario ingresa el monto total, el número de personas y el porcentaje de propina, y al tocar 'Calcular' ve cuánto paga cada persona con dos decimales. Hay dos modos de redondeo que el usuario elige: exacto, o hacia arriba al entero más cercano. La app funciona sin conexión: no hay red ni base de datos."

## Clarifications

### Session 2026-10-07
- Q: ¿Qué valores iniciales deben tener la propina y el modo de redondeo al abrir la app? → A: Propina en 10% y modo de redondeo "Exacto" seleccionados por defecto.

## User Scenarios & Testing *(mandatory)*

### User Story 1 - Cálculo de División Equitativa en Modo Exacto (Priority: P1)

Como comensal en un restaurante, quiero ingresar el monto total de la cuenta, la cantidad de personas y el porcentaje de propina para conocer rápidamente la cantidad exacta que debe pagar cada persona con precisión de dos decimales.

**Why this priority**: Es el flujo fundamental de valor de la aplicación (MVP). Sin el cálculo básico de división y propina, la aplicación no tiene utilidad.

**Independent Test**: Puede probarse de forma independiente ingresando montos válidos con propina o sin ella y verificando el resultado numérico exacto tras presionar "Calcular".

**Acceptance Scenarios**:

1. **Given** un monto de 100.00, 4 personas, 10% de propina y modo de redondeo exacto, **When** el usuario presiona "Calcular", **Then** el sistema muestra "27.50" como monto por persona.
2. **Given** un monto de 90.00, 3 personas, 0% de propina y modo de redondeo exacto, **When** el usuario presiona "Calcular", **Then** el sistema muestra "30.00" como monto por persona.
3. **Given** un monto de 10.00, 3 personas, 0% de propina y modo de redondeo exacto, **When** el usuario presiona "Calcular", **Then** el sistema muestra "3.33" como monto por persona.

---

### User Story 2 - Redondeo hacia Arriba al Entero más Cercano (Priority: P2)

Como usuario que prefiere pagar con billetes redondos o simplificar el cobro en efectivo, quiero seleccionar la opción de redondear hacia arriba al entero más cercano para evitar centavos sueltos.

**Why this priority**: Permite flexibilidad en pagos en efectivo y satisface la regla de negocio de estrategias de redondeo sin alterar el flujo principal.

**Independent Test**: Puede probarse seleccionando el modo hacia arriba y verificando que valores fraccionarios se eleven al entero inmediato superior por persona.

**Acceptance Scenarios**:

1. **Given** un monto de 10.00, 3 personas, 0% de propina y modo de redondeo hacia arriba, **When** el usuario presiona "Calcular", **Then** el sistema muestra "4.00" como monto por persona.

---

### User Story 3 - Validación de Entradas y Manejo de Errores (Priority: P1)

Como usuario, quiero recibir retroalimentación clara e inmediata si ingreso datos erróneos o incompletos para corregirlos sin que la aplicación falle ni muestre cálculos incorrectos.

**Why this priority**: La robustez y confiabilidad son críticas; el sistema no debe producir divisiones por cero ni operar con cadenas inválidas.

**Independent Test**: Puede probarse ingresando datos inválidos (cero comensales o texto alfabético) y verificando que aparezca el mensaje de error correspondiente y no se visualice resultado.

**Acceptance Scenarios**:

1. **Given** un monto de 50.00 y 0 personas, **When** el usuario presiona "Calcular", **Then** el sistema muestra el mensaje de error "Debe haber al menos una persona" y NO muestra ningún resultado de cálculo.
2. **Given** un monto con valor "abc", **When** el usuario presiona "Calcular", **Then** el sistema muestra el mensaje de error "Monto inválido" y NO muestra ningún resultado de cálculo.

---

### Edge Cases

- **Monto negativo o vacío:** Si el usuario deja el monto vacío o ingresa números negativos, el sistema debe presentar el mensaje "Monto inválido".
- **Número de personas menor a 1:** Si se ingresan valores negativos o decimales en personas, el sistema debe indicar "Debe haber al menos una persona".
- **Propina en 0%:** Se calcula la división pura de la cuenta sin recargo de propina.
- **División con decimales periódicos:** En modo exacto, el redondeo estándar trunca o redondea a 2 decimales bancarios/estándar (e.g., 10 / 3 = 3.33).

## Requirements *(mandatory)*

### Functional Requirements

- **FR-001**: El sistema DEBE proveer campos para ingresar el monto total de la cuenta, el número de personas y el porcentaje de propina en una única pantalla.
- **FR-002**: El sistema DEBE proveer un selector para elegir entre dos modos de redondeo: "exacto" y "hacia arriba al entero más cercano".
- **FR-003**: El cálculo DEBE dispararse únicamente cuando el usuario presiona la acción o botón "Calcular".
- **FR-004**: El sistema DEBE mostrar el monto que paga cada persona con dos decimales cuando las entradas son válidas.
- **FR-005**: El sistema DEBE validar que el monto sea un valor numérico positivo válido. Si contiene caracteres inválidos (por ejemplo "abc") o formato no numérico, DEBE mostrar el mensaje "Monto inválido" y no mostrar resultado.
- **FR-006**: El sistema DEBE validar que el número de personas sea un entero mayor o igual a 1. Si es menor o igual a 0, DEBE mostrar el mensaje "Debe haber al menos una persona" y no mostrar resultado.
- **FR-007**: La aplicación DEBE funcionar 100% fuera de línea sin requerir conexión a internet, servicios web ni almacenamiento en base de datos.
- **FR-008**: La lógica de cálculo DEBE estar desacoplada de la interfaz gráfica y de las reglas de redondeo específicas para respetar los principios de arquitectura limpia y SOLID.
- **FR-009**: El sistema DEBE iniciar por defecto con 10% en el campo de propina y el modo de redondeo 'exacto' preseleccionado al abrir la aplicación.

### Key Entities

- **DatosCuenta**: Representa los datos de entrada para la operación (monto base, cantidad de personas, porcentaje de propina, estrategia de redondeo).
- **ResultadoDivision**: Representa el resultado del cálculo (monto total acumulado, total de propina, cuota individual por persona).
- **ReglaRedondeo**: Abstracción que define la política de redondeo aplicada al monto resultante (Exacto vs. Hacia arriba al entero).

## Success Criteria *(mandatory)*

### Measurable Outcomes

- **SC-001**: El 100% de los 6 escenarios de aceptación descritos se cumplen y validan de forma automatizada.
- **SC-002**: El resultado se presenta en pantalla en menos de 100 milisegundos tras accionar "Calcular".
- **SC-003**: Cero dependencia de conectividad de red o bases de datos externas para realizar la totalidad de las operaciones.
- **SC-004**: Los mensajes de validación ante entradas inválidas ("Monto inválido", "Debe haber al menos una persona") se muestran inmediatamente y suprimen la visualización de resultados numéricos erróneos.

## Assumptions

- Toda la interacción ocurre dentro de una única pantalla visual accesible y sencilla.
- La moneda se formatea numéricamente con dos decimales estándar.
- Los valores de porcentaje de propina son números no negativos (por defecto 0% o mayores).
- No se requiere persistencia histórica de cálculos anteriores entre sesiones de la app.

