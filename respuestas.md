# Respuestas del Taller

1. TABLA DE METRICAS Y CONFIGURACION


Datos de mi entorno:
- Agente: Antigravity / Gemini CLI
- Modelo: Gemini 2.5 Pro (con razonamiento alto / extended thinking)
- Archivo de instrucciones: GEMINI.md
- Caso de Git que me toco (Parte 1.5): Caso A (cree las dos ramas, vibe y sdd, saliendo desde el commit base inicial 5b0849f).

Tabla de metricas:

Metrica                                      | Rama vibe                | Rama sdd
---------------------------------------------|--------------------------|-------------------------
Iteraciones (pedir correcciones)             | 1 (corregir overflow)    | 0 (salio de una con las tareas; 1 si cuento el analyze)
Casos de aceptacion cumplidos (0 a 6)        | 6 / 6 (probando a mano)  | 6 / 6 (comprobados con tests automaticos)
Pruebas automatizadas que pasan              | 1 / 1                    | 38 / 38
Archivos en lib/                             | 5                        | 10
Lineas de codigo en lib/                     | 2053                     | ~565
domain/ depende de Flutter?                  | No aplica (no existe)    | No (100% Dart puro, 0 imports de flutter)
Existe separacion presentation/domain/data?  | No                       | Si (Clean Architecture estricta)
El agente agrego cosas no pedidas?           | Si (un monton)           | No (se apego a la spec)
Se puede agregar otra estrategia sin tocarlo?| No (esta con if y enums) | Si (con Strategy Pattern / OCP)

Que enfoque cumplio mejor los 6 escenarios?
Para mi cumplio mucho mejor sdd. Aunque en vibe la pantalla se ve bonita y calcula sumas, a la hora de meter casos raros o errores falla porque los esconde (te bloquea el slider para que nunca pongas 0 personas y si escribes texto lo convierte a 0.0 sin avisar). En cambio sdd valida exactamente las cadenas de error pedidas ("Debe haber al menos una persona" y "Monto invalido") y no muestra calculos basura.

Cuantas iteraciones necesito cada uno?
En vibe tuve que pedirle 1 iteracion extra para arreglar desbordamientos en la UI. En sdd la implementacion salio en 0 iteraciones de correccion de codigo, todo paso los tests a la primera siguiendo la lista de tareas (solo hubo 1 paso previo que fue corregir los hallazgos del speckit-analyze antes de codificar).

Decisiones explicitas vs decisiones que completo el agente:
- Explicitas: los campos que pedia el usuario (monto, personas, propina), los dos modos de redondeo, que arrancara con 10% y modo exacto, los mensajes literales de error y que fuera offline sin paquetes raros.
- Completadas por el agente: en sdd el agente diseno las 3 capas, la interfaz EstrategiaRedondeo, el controlador y los tests. En vibe el agente se puso creativo por su cuenta y metio soporte para monedas de otros paises, division por platos individuales, switch de tema oscuro y hasta un boton para mandar por WhatsApp.

Sobre el tiempo:
Vibe fue mucho mas rapido al principio (salio en unos 3 minutos con un solo prompt), mientras que sdd tomo como 20 o 25 minutos haciendo la especificacion, el plan, las tareas y las pruebas. Pero el tiempo inicial no sirve para decidir cual es mejor: vibe dejo un archivo gigante de mas de 700 lineas sin pruebas donde cualquier cambio futuro va a costar horas de depurar, mientras que sdd dejo un proyecto ordenado, con pruebas que corren en 2 segundos y facil de mantener.


======================================================================
2. PARTE 10: LLEVAR LAS PRUEBAS DE SDD A VIBE
======================================================================

Hice checkout a vibe y me traje la carpeta test/ de sdd:
  git checkout vibe
  git checkout sdd -- test/
  flutter test

Compilaron?
No, no compilaron para nada. Salieron 9 errores de carga.

Primer error que salio:
test/widget/pantalla_divisor_test.dart:3:8: Error: Error when reading 'lib/data/strategies/redondeo_exacto.dart': El sistema no puede encontrar la ruta especificada
import 'package:divisor_cuenta/data/strategies/redondeo_exacto.dart';
       ^
test/widget/pantalla_divisor_test.dart:5:8: Error: Error when reading 'lib/domain/usecases/calcular_division.dart': El sistema no puede encontrar la ruta especificada
import 'package:divisor_cuenta/domain/usecases/calcular_division.dart';
       ^
test/widget/pantalla_divisor_test.dart:11:8: Error: 'DivisorController' isn't a type.
  late DivisorController controlador;
       ^^^^^^^^^^^^^^^^^

Que demuestra este error?
Demuestra una diferencia de arquitectura y testabilidad, no que la app no funcione. La app vibe corre si le das flutter run, pero como metieron toda la logica adentro de los widgets y no crearon clases ni capas de dominio, no hay forma de probar el calculo por separado. Las pruebas buscan archivos y clases que en vibe directamente no existen.

Comparacion manual de los 6 escenarios en la app:
- Escenario 1 (100.00, 4 personas, 10% propina, exacto -> 27.50): Pasa en las dos.
- Escenario 2 (90.00, 3 personas, 0% propina, exacto -> 30.00): Pasa en las dos.
- Escenario 3 (50.00, 0 personas -> error "Debe haber al menos una persona"): En sdd pasa perfecto. En vibe falla porque el slider no te deja bajar de 1 y nunca muestra ese mensaje de error.
- Escenario 4 ("abc" en monto -> error "Monto invalido"): En sdd pasa perfecto. En vibe falla porque usa tryParse y si falla pone 0.0 en silencio, no muestra el error.
- Escenario 5 (10.00, 3 personas, 0% propina, exacto -> 3.33): Pasa en las dos.
- Escenario 6 (10.00, 3 personas, 0% propina, hacia arriba -> 4.00): Pasa en las dos activando el redondeo por persona.


======================================================================
3. VERIFICACIONES DE SOLID (PARTE 9.5)
======================================================================

Comando 1: grep -rn "package:flutter" lib/domain/
- En sdd: no sale nada (salida limpia). Cumple la Regla 1 de la Constitution (Dominio puro en Dart, sin Flutter).
- En vibe: no existe domain/, y si corres grep en lib/ sale que main.dart, quick_split_tab.dart y detailed_split_tab.dart importan flutter. La logica depende 100% del framework (viola DIP).

Comando 2: grep -rn -E "RedondeoExacto\(\)|RedondeoHaciaArriba\(\)" lib/
- En sdd:
  lib/main.dart:17:  final redondeoExacto = RedondeoExacto();
  lib/main.dart:18:  final redondeoHaciaArriba = RedondeoHaciaArriba();
  Sale UNICAMENTE en main.dart. Cumple la Regla 2 de la Constitution (Composition Root: solo main instancia clases concretas para inyectarlas).
- En vibe: no sale nada porque no existen esas clases, usan un enum con ifs adentro de la pantalla.

Comando 3: grep -n -E "is Redondeo|as Redondeo" lib/domain/calcular_division.dart
- En sdd: no sale nada. CalcularDivision recibe EstrategiaRedondeo y la usa directamente sin fijarse que tipo es ni hacer casts. Cumple OCP y LSP (Regla 3 de la Constitution).
- En vibe: adentro de quick_split_tab.dart tienen if (_rounding == RoundingOption.ceilPerPerson) else if ..., lo que rompe OCP porque para meter otro modo hay que modificar el codigo viejo.

Comando 4: grep -n -E "toStringAsFixed|invalido|al menos una persona" lib/domain/calcular_division.dart
- En sdd: no sale nada. CalcularDivision solo calcula numeros, no formatea texto ni valida strings. Cumple SRP.
- En vibe: en un solo archivo de 720 lineas hacen la validacion, los calculos, el formato con signos de pesos y los widgets.


======================================================================
4. PREGUNTAS DE SPECKIT-CLARIFY
======================================================================

La pregunta clave que salio en el speckit-clarify fue:
"Q: Que valores iniciales deben tener la propina y el modo de redondeo al abrir la app?
 A: Propina en 10% y modo de redondeo 'Exacto' seleccionados por defecto."

Que ambiguedad destapo?
Destapo que la descripcion original no decia como debia arrancar la pantalla cuando el usuario la abre por primera vez (si la propina debia estar en blanco, en 0 o con valor tipico, y que boton de redondeo debia estar marcado). Sin esa pregunta, cada programador o agente habria hecho lo que se le diera la gana.

Quien tomo esas decisiones en la rama vibe?
El agente las tomo completamente por su cuenta sin preguntarme nada. Decidio poner 2 personas por defecto, un slider, selector de monedas internacionales y asumir 0.0 si habia errores.


======================================================================
5. GIT DIFF VIBE SDD --STAT Y FUNCIONALIDADES NO PEDIDAS
======================================================================

Corri el comando:
  git diff vibe sdd --stat

Y se ve clarito que la rama vibe agrego un monton de cosas que nadie pidio:
- lib/screens/detailed_split_tab.dart: un archivo entero de 920 lineas para repartir la cuenta plato por plato asignando comida a amigos con colores.
- lib/models/models.dart: agrego una clase CurrencyOption con 8 monedas (dolares, euros, soles, libras, quetzales, colones, bolivares, reales).
- En quick_split_tab.dart metio calculo de impuestos/IVA (taxPercentage = 16.0).
- Metio un boton para copiar un texto formateado para mandar a WhatsApp.
- Metio cambio de modo oscuro y claro.

En cambio sdd solo tiene los archivos necesarios para resolver lo que se pidio: pantalla unica con monto, personas, propina, selector de redondeo y resultado/errores. Cero cosas inventadas.


======================================================================
6. OTRAS HERRAMIENTAS SDD Y CUANDO ELEGIR VIBE
======================================================================

Sobre las herramientas alternativas:
Elegi OpenSpec. La diferencia con Spec Kit es que Spec Kit esta pensado para guiar al desarrollador en la terminal con comandos interactivos (/speckit-specify, /speckit-plan, /speckit-tasks), mientras que OpenSpec es un formato mas estandarizado en YAML/JSON que se usa para definir contratos y especificaciones que puedan leer sistemas de CI/CD, linters automaticos o equipos grandes que usan distintos lenguajes (por ejemplo si unos hacen backend en Go y otros la app en Flutter).
La preferiria en un proyecto de empresa grande con varios equipos donde necesitas que la especificacion se valide automaticamente en el pipeline de GitHub o GitLab antes de fusionar ramas.

Situacion real y pequena donde si conviene vibe coding:
En una hackathon de un fin de semana o cuando necesitas hacer un prototipo desechable en 2 horas para mostrarle una idea visual a un cliente o inversionista.
Ahi no te importa la arquitectura ni las pruebas a largo plazo porque lo unico que necesitas es que se vea bien en pantalla rapido para validar si la idea gusta. Si gusta y se aprueba el proyecto, ese codigo se bota a la basura y se programa bien desde cero con SDD.
