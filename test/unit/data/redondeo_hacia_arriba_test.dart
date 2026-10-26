import 'package:flutter_test/flutter_test.dart';
import 'package:divisor_cuenta/data/strategies/redondeo_hacia_arriba.dart';

void main() {
  group('RedondeoHaciaArriba Tests', () {
    late RedondeoHaciaArriba estrategia;

    setUp(() {
      estrategia = RedondeoHaciaArriba();
    });

    test('redondea hacia arriba al entero más cercano', () {
      // 10 / 3 = 3.3333... -> 4.00
      expect(estrategia.redondear(10.0 / 3.0), equals(4.00));
      expect(estrategia.redondear(3.01), equals(4.00));
      expect(estrategia.redondear(3.99), equals(4.00));
      expect(estrategia.redondear(3.00), equals(3.00));
    });

    test('valores enteros se mantienen intactos', () {
      expect(estrategia.redondear(15.0), equals(15.00));
      expect(estrategia.redondear(0.0), equals(0.00));
    });
  });
}

