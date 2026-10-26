import 'package:flutter_test/flutter_test.dart';
import 'package:divisor_cuenta/data/strategies/redondeo_exacto.dart';
import 'package:divisor_cuenta/data/strategies/redondeo_hacia_arriba.dart';
import 'package:divisor_cuenta/domain/entities/cuenta.dart';
import 'package:divisor_cuenta/domain/entities/resultado.dart';
import 'package:divisor_cuenta/domain/strategies/estrategia_redondeo.dart';
import 'package:divisor_cuenta/domain/usecases/calcular_division.dart';
import 'package:divisor_cuenta/domain/usecases/validar_entrada.dart';

import 'casos_de_prueba.dart';

void main() {
  final validador = ValidarEntrada();
  final calcular = CalcularDivision();
  final redondeoExacto = RedondeoExacto();
  final redondeoArriba = RedondeoHaciaArriba();

  group('Pruebas parametrizadas de división desde casos_de_prueba.dart', () {
    for (final caso in casos) {
      test(caso.nombre, () {
        // Valida la entrada con ValidarEntrada
        final String? error = validador.validar(
          monto: caso.monto,
          personas: caso.personas,
          propina: caso.propina,
        );

        if (caso.errorEsperado != null) {
          // Si el caso tiene errorEsperado, verifica que devuelve exactamente ese mensaje
          expect(error, equals(caso.errorEsperado));

          // Verifica que NO se calcula nada
          Resultado? resultado;
          expect(resultado, isNull);
        } else {
          // Si el caso tiene esperado, no debe haber error de validación
          expect(error, isNull);

          // EstrategiaRedondeo que corresponde al campo modo ('arriba' o 'exacto')
          final EstrategiaRedondeo estrategia =
              caso.modo == 'arriba' ? redondeoArriba : redondeoExacto;

          final cuenta = Cuenta(
            montoBase: caso.monto,
            numeroPersonas: caso.personas,
            porcentajePropina: caso.propina,
            estrategiaRedondeo: estrategia,
          );

          // Ejecuta CalcularDivision y compara el resultado con closeTo(esperado, 0.001)
          final resultado = calcular.ejecutar(cuenta);
          expect(resultado.montoPorPersona, closeTo(caso.esperado!, 0.001));
        }
      });
    }
  });

  group('Demostración del Principio de Sustitución de Liskov (LSP)', () {
    test(
      'El mismo CalcularDivision recibe RedondeoExacto y luego RedondeoHaciaArriba sin ningún if ni cast y funciona con los dos',
      () {
        final calcularLsp = CalcularDivision();

        // 1. RedondeoExacto como subtipo de EstrategiaRedondeo
        final EstrategiaRedondeo estrategiaExacta = RedondeoExacto();
        final cuentaExacta = Cuenta(
          montoBase: 10.0,
          numeroPersonas: 3,
          porcentajePropina: 0.0,
          estrategiaRedondeo: estrategiaExacta,
        );

        final resultadoExacto = calcularLsp.ejecutar(cuentaExacta);
        expect(resultadoExacto.montoPorPersona, closeTo(3.33, 0.001));

        // 2. RedondeoHaciaArriba como subtipo de EstrategiaRedondeo
        final EstrategiaRedondeo estrategiaArriba = RedondeoHaciaArriba();
        final cuentaArriba = Cuenta(
          montoBase: 10.0,
          numeroPersonas: 3,
          porcentajePropina: 0.0,
          estrategiaRedondeo: estrategiaArriba,
        );

        // La misma instancia de CalcularDivision procesa ambas estrategias polimórficamente sin if ni cast
        final resultadoArriba = calcularLsp.ejecutar(cuentaArriba);
        expect(resultadoArriba.montoPorPersona, closeTo(4.00, 0.001));
      },
    );
  });

  group('Regla: La propina no puede superar el 100%', () {
    test(
      'Con monto 100, 4 personas y propina 150, la validación devuelve exactamente "La propina no puede superar el 100%"',
      () {
        final error = validador.validar(
          monto: 100,
          personas: 4,
          propina: 150,
        );

        expect(error, equals('La propina no puede superar el 100%'));
      },
    );

    test(
      'Con monto 100, 4 personas y propina 100, la validación NO devuelve error (el límite exacto sí se permite)',
      () {
        final error = validador.validar(
          monto: 100,
          personas: 4,
          propina: 100,
        );

        expect(error, isNull);
      },
    );
  });
}

