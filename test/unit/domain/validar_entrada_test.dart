import 'package:flutter_test/flutter_test.dart';
import 'package:divisor_cuenta/domain/usecases/validar_entrada.dart';

void main() {
  group('ValidarEntrada UseCase Tests', () {
    late ValidarEntrada validador;

    setUp(() {
      validador = ValidarEntrada();
    });

    test('Escenario 4: el monto dice "abc" -> mensaje "Monto inválido"', () {
      expect(validador.validarMonto('abc'), equals('Monto inválido'));
      expect(validador.validarMonto(''), equals('Monto inválido'));
      expect(validador.validarMonto(null), equals('Monto inválido'));
      expect(validador.validarMonto('-10'), equals('Monto inválido'));
      expect(validador.validarMonto('0'), equals('Monto inválido'));
    });

    test('Monto numérico válido devuelve null', () {
      expect(validador.validarMonto('100.00'), isNull);
      expect(validador.validarMonto('90'), isNull);
      expect(validador.validarMonto('10.5'), isNull);
      expect(validador.validarMonto(' 50.00 '), isNull);
    });

    test('Escenario 3: 0 personas o negativo -> mensaje "Debe haber al menos una persona"', () {
      expect(validador.validarPersonas('0'), equals('Debe haber al menos una persona'));
      expect(validador.validarPersonas('-3'), equals('Debe haber al menos una persona'));
      expect(validador.validarPersonas(''), equals('Debe haber al menos una persona'));
      expect(validador.validarPersonas(null), equals('Debe haber al menos una persona'));
      expect(validador.validarPersonas('dos'), equals('Debe haber al menos una persona'));
    });

    test('Número de personas válido devuelve null', () {
      expect(validador.validarPersonas('1'), isNull);
      expect(validador.validarPersonas('3'), isNull);
      expect(validador.validarPersonas('4'), isNull);
      expect(validador.validarPersonas(' 10 '), isNull);
    });

    test('Validar propina acepta números positivos o vacíos como 0 y rechaza negativos', () {
      expect(validador.validarPropina('10'), isNull);
      expect(validador.validarPropina('0'), isNull);
      expect(validador.validarPropina(''), isNull);
      expect(validador.validarPropina('-5'), equals('Propina inválida'));
      expect(validador.validarPropina('diez'), equals('Propina inválida'));
    });
  });
}

