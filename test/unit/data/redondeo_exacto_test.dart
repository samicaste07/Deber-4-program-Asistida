import 'package:flutter_test/flutter_test.dart';
import 'package:divisor_cuenta/data/strategies/redondeo_exacto.dart';

void main() {
  group('RedondeoExacto Tests', () {
    late RedondeoExacto estrategia;

    setUp(() {
      estrategia = RedondeoExacto();
    });

    test('redondea a dos decimales exactos valores fraccionarios', () {
      expect(estrategia.redondear(27.50), equals(27.50));
      expect(estrategia.redondear(30.00), equals(30.00));
      // 10 / 3 = 3.3333333333333335 -> 3.33
      expect(estrategia.redondear(10.0 / 3.0), equals(3.33));
    });

    test('redondea correctamente hacia arriba y hacia abajo según el tercer decimal', () {
      expect(estrategia.redondear(2.556), equals(2.56));
      expect(estrategia.redondear(2.554), equals(2.55));
      expect(estrategia.redondear(2.555), equals(2.56));
    });
  });
}

