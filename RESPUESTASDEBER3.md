1. Rojo antes de verde. ¿Qué mensaje de error te mostró `flutter test` en la Parte 2? 

Mostró que la prueba falló con 
Expected: 'La propina no puede superar el 100%'
Actual: <null>
Which: not an <Instance of 'String'>

¿Por qué era importante ver esa prueba fallar antes de escribir el código?

Para coumplir con el TDD y ver que falla en rojo demuestra que la prueba si esta evaluando la nueva regla y se confirma que la falla pasa porque todavía no existe la funcionalidad.


2. Linter vs. IA. Nombra un aviso que te mostró `flutter analyze` y un code smell que te señaló la IA. 

Aviso de flutter analyze: 
info - Missing type annotation. Try adding a type annotation - lib\main.dart:68:1 - strict_top_level_inference

Code smell de la IA: Duplicación de código (Violación del principio DRY) en validar_entrada.dart (líneas 16 y 54).

¿Por qué el linter no encontró el code smell?

porque el linter solo revisa la sintaxis del código, las convenciones de estilo. En cambio un code smell es de un problema de diseño y de la arquitectura.


3. Tu refactorización. ¿Qué code smell elegiste, qué cambió en el código y cómo sabes que la app sigue haciendo exactamente lo mismo?

Elegí el code smell: lib/domain/usecases/validar_entrada.dart
Líneas: 16 y 54
Code Smell: Duplicación de código (Violación del principio DRY)

Qué cambió? 
Se extrajo lo que estaba dupllicado y se cambió por un método privado reutilizable _normalizarTextoDecimal()

Cómo sé que sigue haciendo lo mismo?
Porque igual al correr el flutter test siguen todas las pruebas en verde

4. Coverage. ¿Qué archivo de `lib/` tiene el porcentaje más bajo?

lib/domain/entities/resultado.dart, con un 11.11 %

¿Significa eso que ese archivo tiene errores? Explica.
No. El porcentaje de cobertura solo indica qué líneas se ejecutaron durante las pruebas automatizadas