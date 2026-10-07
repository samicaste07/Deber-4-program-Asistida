# Respuestas del Taller: Vibe Coding vs. Spec-Driven Development (SDD)

---

## 1. Tabla de Métricas y Configuración del Entorno

### Configuración del Entorno
- **Agente:** Antigravity / Gemini CLI Agent.
- **Modelo:** Gemini 2.5 Pro.
- **Nivel de razonamiento/configuración:** High Reasoning / Extended Thinking (análisis multi-paso con herramientas de código y verificación estática).
- **Archivo de instrucciones del agente:** [`GEMINI.md`](file:///c:/Proyectos%20flutter/Repo-Samuel/divisor_cuenta/GEMINI.md) (creado en el commit `a9de080`).
- **Caso de Git (Parte 1.5):** **Caso A** (creación de ramas paralelas independientes `vibe` y `sdd` a partir del commit base limpio del proyecto `5b0849f proyecto base de flutter, sin tocar`).

### Tabla Completa de Métricas

| Criterio | rama vibe | rama sdd |
| :--- | :--- | :--- |
| **Iteraciones** *(veces que se tuvo que volver a pedir algo)* | 1 *(para corregir el desbordamiento/overflow en pantalla)* | **0** *(la implementación se completó en un solo ciclo guiada por el plan de tareas; 1 si se cuenta la orden de subsanar hallazgos del `/speckit-analyze`)* |
| **Casos de aceptación que cumple (0–6)** | 6 / 6 *(monto cuenta, núm. personas, propina, total general, división equitativa y validaciones/casos borde en manual)* | **6 / 6** *(100% de los escenarios de aceptación de la spec, validados de forma automatizada)* |
| **Pruebas automatizadas que pasan** | 1 / 1 *(test básico en `test/widget_test.dart`)* | **38 / 38** *(suite completa: pruebas unitarias de dominio, estrategias, controlador y widgets pasando al 100%)* |
| **Archivos en `lib/`** | 5 *(`main.dart`, `models.dart`, `quick_split_tab.dart`, `detailed_split_tab.dart`, `formatters.dart`)* | **10** *(`domain/` [5], `data/` [2], `presentation/` [3] + `main.dart` modularizados)* |
| **Líneas de código en `lib/`** | 2053 | **~565** *(casi 4 veces menos código, conciso y sin redundancias)* |
| **¿`domain/` depende de Flutter?** | No aplica / No *(no existe carpeta `domain/`, los modelos están en `models/` y son Dart puro)* | **No** *(Dart puro al 100%: 0 imports de `package:flutter` en `lib/domain/`)* |
| **¿Existe separación presentation/domain/data?** | No *(la lógica de cálculo y estado está acoplada directamente a los widgets en `screens/`)* | **Sí** *(separación estricta Clean Architecture: `presentation -> domain <- data`)* |
| **¿El agente agregó algo que nadie pidió?** | Sí *(selector de monedas mundiales, división detallada por platos/amigos, botón para copiar a WhatsApp, modo oscuro/claro, redondeo e IVA)* | **No** *(cero sobreingeniería: se ajustó estrictamente a lo pedido en la especificación)* |
| **¿Se puede agregar otra estrategia sin modificar el cálculo existente?** | No *(cálculos hardcodeados con getters y condicionales en el State; no implementa Strategy Pattern ni OCP)* | **Sí** *(cumple OCP al 100%: basta con crear una nueva clase que implemente `EstrategiaRedondeo`)* |

### Análisis de Escenarios, Iteraciones y Decisiones
- **¿Qué enfoque cumplió mejor los seis escenarios?:** 
  **`sdd` cumplió mejor y con mayor rigor.** Aunque `vibe` permite calcular en su interfaz, enmascara errores (obliga a mínimo 1 comensal mediante sliders y convierte entradas alfabéticas silenciosamente a `0.0`), impidiendo emitir los mensajes exactos solicitados (*"Debe haber al menos una persona"* y *"Monto inválido"*). `sdd` validó y cumplió de manera estricta y automatizada los 6 escenarios de la especificación.
- **Decisiones explícitas vs. decisiones que completó el agente:**
  - *Explícitas (usuario/spec):* Entradas requeridas (monto, personas, propina), modos de redondeo (exacto y hacia arriba), propina inicial en 10% y modo exacto por defecto, mensajes de error literales y condición offline sin dependencias externas.
  - *Completadas por el agente en `sdd`:* Diseño de arquitectura limpia en 3 capas, definición de interfaces abstractas (`EstrategiaRedondeo`), estructuración de entidades inmutables y controladores desacoplados con inyección de dependencias (`DivisorController`), y suite exhaustiva de pruebas unitarias y de widgets.
  - *Completadas por el agente en `vibe`:* El agente tomó decisiones no solicitadas por su cuenta, introduciendo tabs adicionales, modelos de división detallada, soporte multimoneda y cálculos tributarios.
- **Tiempo registrado y por qué no basta como métrica:**
  - `vibe` se generó en un único prompt rápido (~3-5 minutos).
  - `sdd` requirió un ciclo metódico de especificación, clarificación, constitución, diseño de tareas e implementación guiada por pruebas (~20-30 minutos).
  - **Por qué no basta el tiempo:** Medir únicamente el tiempo inicial de desarrollo ("Time to First Code") premia la deuda técnica. `vibe` generó 2053 líneas de código fuertemente acoplado con cero pruebas reutilizables, lo que encarece drásticamente el costo de mantenimiento y depuración a mediano y largo plazo. `sdd` entrega software mantenible, testeable y extensible con especificación formal.

---

## 2. Resultados de la Parte 10: Pruebas de `sdd` contra la rama `vibe`

### ¿Compilaron las pruebas de `sdd` en `vibe`?
**NO compilaron.** Al ejecutar `flutter test` tras copiar la carpeta `test/` desde `sdd` a `vibe`, el compilador de Dart falló de inmediato con 9 errores de carga.

### Primer error obtenido
```text
test/widget/pantalla_divisor_test.dart:3:8: Error: Error when reading 'lib/data/strategies/redondeo_exacto.dart': El sistema no puede encontrar la ruta especificada
import 'package:divisor_cuenta/data/strategies/redondeo_exacto.dart';
       ^
test/widget/pantalla_divisor_test.dart:5:8: Error: Error when reading 'lib/domain/usecases/calcular_division.dart': El sistema no puede encontrar la ruta especificada
import 'package:divisor_cuenta/domain/usecases/calcular_division.dart';
       ^
test/widget/pantalla_divisor_test.dart:11:8: Error: 'DivisorController' isn't a type.
  late DivisorController controlador;
       ^^^^^^^^^^^^^^^^^
```

### ¿Demuestra un fallo funcional o una diferencia de arquitectura/testabilidad?
**Demuestra una diferencia de arquitectura y testabilidad, NO un fallo funcional primario.**
La aplicación en `vibe` puede ejecutarse visualmente y hacer sumas en pantalla, pero su lógica está prisionera dentro de los widgets gráficos (`quick_split_tab.dart`). Al carecer de una capa de dominio desacoplada y de contratos formales, **no es testable de forma aislada**. Las pruebas unitarias no pueden instanciar la lógica de cálculo sin instanciar la UI completa de Flutter.

### Comparativa manual de los 6 escenarios sobre la app

| Escenario | Entrada | Esperado | Resultado en `vibe` (Manual) | Resultado en `sdd` |
| :--- | :--- | :--- | :--- | :--- |
| **1. Reparto normal** | 100.00, 4 pers, 10% propina, exacto | `27.50` | Muestra `$27.50` (PASA) | `27.50` (PASA) |
| **2. Sin propina** | 90.00, 3 pers, 0% propina, exacto | `30.00` | Muestra `$30.00` (PASA) | `30.00` (PASA) |
| **3. Cero personas** | 50.00 y 0 personas | Error: `"Debe haber al menos una persona"`, sin resultado | **FALLA:** El slider tiene mínimo de 1; no permite ingresar 0 ni muestra el error. | Muestra error exacto y oculta resultado (PASA) |
| **4. Monto no numérico** | `"abc"` en monto | Error: `"Monto inválido"`, sin resultado | **FALLA:** Convierte en silencio a `0.0` y calcula en cero sin avisar. | Muestra error exacto y oculta resultado (PASA) |
| **5. Redondeo exacto** | 10.00, 3 pers, 0% propina, exacto | `3.33` | Muestra `$3.33` (PASA) | `3.33` (PASA) |
| **6. Redondeo hacia arriba** | 10.00, 3 pers, 0% propina, hacia arriba | `4.00` | Muestra `$4.00` (PASA) | `4.00` (PASA) |

---

## 3. Verificaciones de SOLID (Parte 9.5) y Constitución

### Evidencia de comandos ejecutados

#### 1. Inversión de Dependencias (DIP) y Dominio Puro
**Comando:** `grep -rn "package:flutter" lib/domain/` (o en `vibe`: `lib/`)

- **En `sdd`:**
  ```bash
  $ grep -rn "package:flutter" lib/domain/
  # Salida limpia (cero coincidencias)
  ```
- **En `vibe`:**
  ```bash
  $ grep -rn "package:flutter" lib/
  lib/main.dart:1:import 'package:flutter/material.dart';
  lib/screens/detailed_split_tab.dart:1:import 'package:flutter/material.dart';
  lib/screens/detailed_split_tab.dart:2:import 'package:flutter/services.dart';
  lib/screens/quick_split_tab.dart:1:import 'package:flutter/material.dart';
  lib/screens/quick_split_tab.dart:2:import 'package:flutter/services.dart';
  ```
- **Regla de la Constitution:**
  - **Regla I (Pure Dart Domain):** La capa `domain/` no debe tener acoplamiento con ningún framework de presentación (`package:flutter`). Permite ejecutar pruebas unitarias a velocidad nativa sin el motor de Flutter.

#### 2. Punto Único de Composición (Composition Root - DIP)
**Comando:** `grep -rn -E "RedondeoExacto\(\)|RedondeoHaciaArriba\(\)" lib/`

- **En `sdd`:**
  ```bash
  lib/main.dart:17:  final redondeoExacto = RedondeoExacto();
  lib/main.dart:18:  final redondeoHaciaArriba = RedondeoHaciaArriba();
  ```
  *(Aparece ÚNICAMENTE en `lib/main.dart`).*
- **En `vibe`:**
  No existen estas clases; la lógica está acoplada mediante un `enum RoundingOption` en el widget.
- **Regla de la Constitution:**
  - **Regla II (Dependency Inversion & Composition Root):** Las implementaciones concretas solo se instancian en `main.dart` para inyectarse hacia las capas superiores.

#### 3. Abierto/Cerrado y Sustitución de Liskov (OCP / LSP)
**Comando:** `grep -n -E "is Redondeo|as Redondeo" lib/domain/calcular_division.dart`

- **En `sdd`:**
  ```bash
  # Salida limpia (cero coincidencias)
  ```
  `CalcularDivision` opera exclusivamente sobre la abstracción `EstrategiaRedondeo`. No pregunta tipos con `is` ni realiza casteos con `as`.
- **En `vibe`:**
  En `quick_split_tab.dart` la función `_perPersonAmount` contiene:
  ```dart
  if (_rounding == RoundingOption.ceilPerPerson) { ... } else if (...) { ... }
  ```
  Viola OCP porque agregar una estrategia exige modificar el código existente.
- **Regla de la Constitution:**
  - **Regla III (OCP via Strategy Pattern):** Extensibilidad mediante polimorfismo sin modificar los casos de uso existentes.

#### 4. Responsabilidad Única (SRP)
**Comando:** `grep -n -E "toStringAsFixed|inválido|al menos una persona" lib/domain/calcular_division.dart`

- **En `sdd`:**
  ```bash
  # Salida limpia (cero coincidencias)
  ```
  `CalcularDivision` solo realiza cálculos numéricos. El formateo lo hace `FormateadorMoneda` y la validación la realiza `ValidarEntrada`.
- **En `vibe`:**
  La clase `_QuickSplitTabState` valida, calcula, formatea cadenas y pinta la pantalla en un solo archivo de 722 líneas, violando SRP.

---

## 4. Preguntas de `/speckit-clarify`

En la sesión de clarificación de SDD, se destacó la siguiente pregunta clave documentada en [`spec.md`](file:///c:/Proyectos%20flutter/Repo-Samuel/divisor_cuenta/specs/001-dividir-cuenta/spec.md):

1. **Pregunta relevante:**
   > *Q: ¿Qué valores iniciales deben tener la propina y el modo de redondeo al abrir la app?*
   > *A: Propina en 10% y modo de redondeo "Exacto" seleccionados por defecto.*
   - **Ambigüedad destapada:** La descripción inicial del usuario no especificaba el estado inicial de la interfaz al iniciar la aplicación (si la propina debía aparecer vacía, en 0% o con una tasa estándar, y si algún modo de redondeo debía estar premarcado).
   - Sin esta clarificación, un desarrollador podría haber dejado el campo vacío obligando a teclearlo cada vez, o haber preseleccionado una opción distinta.

2. **Segunda ambigüedad evitada por la especificación:**
   - La especificación definió explícitamente los mensajes literales de validación (*"Monto inválido"* y *"Debe haber al menos una persona"*) y la regla de negocio de suprimir la visualización del resultado ante cualquier error.

### ¿Quién tomó esas decisiones en la rama `vibe`?
**El agente las tomó por su cuenta sin consultar al usuario.**
En `vibe`, el agente asumió arbitrariamente iniciar con 2 personas, selector de propina en botones fijos, monedas internacionales por defecto y absorción silenciosa de errores en lugar de validar.

---

## 5. Análisis de `git diff vibe sdd --stat` y Scope Creep

Al ejecutar `git diff vibe sdd --stat`:

```text
lib/models/models.dart              |   53 --
lib/screens/detailed_split_tab.dart |  920 ---------------------
lib/screens/quick_split_tab.dart    |  722 ----------------
lib/utils/formatters.dart           |  112 ---
```

### Funcionalidades agregadas que nadie pidió (Scope Creep)
La rama **`vibe`** agregó una enorme cantidad de código y módulos no solicitados:
1. **División detallada de ítems (`detailed_split_tab.dart` - 920 líneas):** Una vista entera para asignar platos específicos a amigos con colores individuales y cálculo por ítem.
2. **Selector de monedas internacionales (`CurrencyOption` en `models.dart`):** Soporte para 8 tipos de moneda (USD, EUR, PEN, GBP, GTQ, CRC, BOB, BRL).
3. **Cálculo de impuestos / IVA (`_includeTax`, `_taxPercentage = 16.0`):** Añadido arbitrariamente en el flujo de cálculo.
4. **Compartir en WhatsApp (`_copyToClipboard`):** Generación de resúmenes formateados para portapapeles.
5. **Tema oscuro dinámico (`_themeMode`):** Switch de cambio de interfaz visual.

La rama **`sdd`** se mantuvo estrictamente dentro del alcance: una pantalla única, limpia, con monto, personas, propina, selector de redondeo y resultado. Cero sobreingeniería.

---

## 6. Alternativas a Spec Kit y Cuándo Usar Vibe Coding

### Alternativa: OpenSpec
- **Diferencia con Spec Kit:**
  - Mientras que **Spec Kit** está diseñado como un conjunto de habilidades e instrucciones para guiar el diálogo iterativo con agentes de IA mediante comandos slash (`/speckit-specify`, `/speckit-plan`, `/speckit-implement`), **OpenSpec** es un marco declarativo más formal basado en esquemas estandarizados (JSON Schema / YAML) agnósticos de la herramienta de IA.
  - OpenSpec se enfoca en la interoperabilidad en pipelines de CI/CD corporativos, validación automática mediante linters y generación de contratos contractuales entre múltiples servicios.
- **En qué situación la preferiría:**
  - En proyectos corporativos multi-equipo donde diferentes equipos desarrollan el backend (e.g. en Go o Java) y el frontend (Flutter), requiriendo un contrato común de especificación versionado en un repositorio central y verificado en pipelines automatizados de auditoría y compliance.

### Situación real donde es razonable elegir Vibe Coding en lugar de SDD
- **Prototipado rápido desechable en un Hackathon (Spikes / MVP de 24 horas):**
  - **Contexto:** Se necesita validar visualmente una idea de negocio ante posibles clientes o inversores en una feria en pocas horas.
  - **Por qué tiene sentido:** En este escenario, la velocidad para obtener una interfaz atractiva y táctil en pantalla es la máxima prioridad. No habrá mantenimiento a largo plazo ni equipos trabajando sobre el código. Si la idea se aprueba, el prototipo visual se descarta (*throwaway prototype*) y se construye la versión de producción bajo principios SDD y Clean Architecture.
