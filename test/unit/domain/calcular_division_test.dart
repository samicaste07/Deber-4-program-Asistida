import 'package:flutter_test/flutter_test.dart';
import 'package:divisor_cuenta/domain/entities/cuenta.dart';
import 'package:divisor_cuenta/domain/usecases/calcular_division.dart';
import 'package:divisor_cuenta/data/strategies/redondeo_exacto.dart';
import 'package:divisor_cuenta/data/strategies/redondeo_hacia_arriba.dart';

void main() {
  group('CalcularDivision UseCase Tests', () {
    late CalcularDivision casoDeUso;
    late RedondeoExacto redondeoExacto;
    late RedondeoHaciaArriba redondeoHaciaArriba;

    setUp(() {
      casoDeUso = CalcularDivision();
      redondeoExacto = RedondeoExacto();
      redondeoHaciaArriba = RedondeoHaciaArriba();
    });

    test('Escenario 1: 100.00, 4 personas, 10% de propina, modo exacto -> 27.50 por persona', () {
      final cuenta = Cuenta(
        montoBase: 100.00,
        numeroPersonas: 4,
        porcentajePropina: 10.0,
        estrategiaRedondeo: redondeoExacto,
      );

      final resultado = casoDeUso.ejecutar(cuenta);

      expect(resultado.totalPropina, equals(10.00));
      expect(resultado.totalPagar, equals(110.00));
      expect(resultado.montoPorPersona, equals(27.50));
    });

    test('Escenario 2: 90.00, 3 personas, 0% de propina, modo exacto -> 30.00 por persona', () {
      final cuenta = Cuenta(
        montoBase: 90.00,
        numeroPersonas: 3,
        porcentajePropina: 0.0,
        estrategiaRedondeo: redondeoExacto,
      );

      final resultado = casoDeUso.ejecutar(cuenta);

      expect(resultado.totalPropina, equals(0.00));
      expect(resultado.totalPagar, equals(90.00));
      expect(resultado.montoPorPersona, equals(30.00));
    });

    test('Escenario 5: 10.00, 3 personas, 0%, modo exacto -> 3.33 por persona', () {
      final cuenta = Cuenta(
        montoBase: 10.00,
        numeroPersonas: 3,
        porcentajePropina: 0.0,
        estrategiaRedondeo: redondeoExacto,
      );

      final resultado = casoDeUso.ejecutar(cuenta);

      expect(resultado.totalPropina, equals(0.00));
      expect(resultado.totalPagar, equals(10.00));
      expect(resultado.montoPorPersona, equals(3.33));
    });

    test('Escenario 6: 10.00, 3 personas, 0%, modo hacia arriba -> 4.00 por persona', () {
      final cuenta = Cuenta(
        montoBase: 10.00,
        numeroPersonas: 3,
        porcentajePropina: 0.0,
        estrategiaRedondeo: redondeoHaciaArriba,
      );

      final resultado = casoDeUso.ejecutar(cuenta);

      expect(resultado.totalPropina, equals(0.00));
      expect(resultado.totalPagar, equals(10.00));
      expect(resultado.montoPorPersona, equals(4.00));
    });
  });
}
