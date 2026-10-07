# Data Model & Entidades: División de Cuenta

## 1. Capa de Dominio (`lib/domain/`)

### Entidad: `Cuenta`
Representa los datos inmutables de una cuenta ingresada por el usuario.
- **Campos**:
  - `montoBase`: `double` (Monto total del consumo antes de propina, mayor a 0).
  - `numeroPersonas`: `int` (Cantidad de comensales, entero $\ge 1$).
  - `porcentajePropina`: `double` (Porcentaje de propina, $\ge 0$).
  - `estrategiaRedondeo`: `EstrategiaRedondeo` (Instancia de la estrategia seleccionada).

### Entidad: `Resultado`
Representa el resultado inmutable del cálculo de división.
- **Campos**:
  - `montoPorPersona`: `double` (Cuota final individual a pagar tras aplicar la estrategia de redondeo).
  - `totalPropina`: `double` (Monto total correspondiente a la propina calculada).
  - `totalPagar`: `double` (Suma del monto base más la propina).

### Interfaz Abstracta: `EstrategiaRedondeo`
Contrato para todas las estrategias de redondeo.
- **Métodos**:
  - `double redondear(double monto)`: Transforma el monto calculado según la regla matemática correspondiente.

### Caso de Uso: `CalcularDivision`
Responsable único de calcular la división de la cuenta.
- **Método**:
  - `Resultado ejecutar(Cuenta cuenta)`:
    - Calcula `totalPropina = cuenta.montoBase * (cuenta.porcentajePropina / 100)`.
    - Calcula `totalPagar = cuenta.montoBase + totalPropina`.
    - Calcula `montoSinRedondeo = totalPagar / cuenta.numeroPersonas`.
    - Aplica `montoPorPersona = cuenta.estrategiaRedondeo.redondear(montoSinRedondeo)`.
    - Retorna `Resultado(...)`.

### Validador: `ValidarEntrada`
Responsable único de verificar el formato y las restricciones de los datos de entrada sin realizar cálculos.
- **Métodos**:
  - `String? validarMonto(String? texto)`: Retorna `"Monto inválido"` si el texto es nulo, no numérico o menor/igual a 0; de lo contrario `null`.
  - `String? validarPersonas(String? texto)`: Retorna `"Debe haber al menos una persona"` si el texto es nulo, no entero o menor a 1; de lo contrario `null`.
  - `String? validarPropina(String? texto)`: Retorna `"Propina inválida"` si es negativo o no numérico; de lo contrario `null`.

---

## 2. Capa de Datos (`lib/data/`)

### Implementación: `RedondeoExacto`
Implementa `EstrategiaRedondeo`.
- **Comportamiento**:
  - Redondea a dos decimales estándar utilizando multiplicación por 100 y redondeo al entero más cercano: `(monto * 100).round() / 100`.
  - Ejemplo: `10.0 / 3 = 3.3333...` $\rightarrow$ `3.33`.

### Implementación: `RedondeoHaciaArriba`
Implementa `EstrategiaRedondeo`.
- **Comportamiento**:
  - Redondea hacia arriba al entero más cercano: `monto.ceilToDouble()`.
  - Ejemplo: `10.0 / 3 = 3.3333...` $\rightarrow$ `4.00`.

---

## 3. Capa de Presentación (`lib/presentation/`)

### Clase: `DivisorController`
Orquesta la interacción entre la pantalla y el dominio.
- **Dependencias (inyectadas vía constructor)**:
  - `CalcularDivision _calcularDivision`
  - `ValidarEntrada _validarEntrada`
  - `EstrategiaRedondeo _redondeoExacto`
  - `EstrategiaRedondeo _redondeoHaciaArriba`
- **Estado expuesto**:
  - `Resultado? resultadoActual`
  - `String? errorMonto`
  - `String? errorPersonas`
  - `String? errorGeneral`
  - `bool get tieneErrores`
- **Métodos**:
  - `void calcular({required String textoMonto, required String textoPersonas, required String textoPropina, required bool modoHaciaArriba})`

### Utilidad: `FormateadorMoneda`
Formatea números a texto visual.
- **Métodos**:
  - `String formatear(double valor)`: Devuelve el string numérico con dos decimales exactos (`valor.toStringAsFixed(2)`).

