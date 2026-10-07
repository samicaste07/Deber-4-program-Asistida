import 'package:flutter_test/flutter_test.dart';
import 'package:divisor_cuenta/data/strategies/redondeo_exacto.dart';
import 'package:divisor_cuenta/data/strategies/redondeo_hacia_arriba.dart';
import 'package:divisor_cuenta/domain/usecases/calcular_division.dart';
import 'package:divisor_cuenta/domain/usecases/validar_entrada.dart';
import 'package:divisor_cuenta/presentation/controllers/divisor_controller.dart';

void main() {
  late DivisorController controller;

  setUp(() {
    controller = DivisorController(
      calcularDivision: CalcularDivision(),
      validarEntrada: ValidarEntrada(),
      redondeoExacto: RedondeoExacto(),
      redondeoHaciaArriba: RedondeoHaciaArriba(),
    );
  });

  group('DivisorController', () {
    test('calcula correctamente en modo exacto', () {
      controller.calcular(
        textoMonto: '100.00',
        textoPersonas: '4',
        textoPropina: '10',
        usarRedondeoHaciaArriba: false,
      );

      expect(controller.errorMonto, isNull);
      expect(controller.errorPersonas, isNull);
      expect(controller.errorPropina, isNull);
      expect(controller.resultado, isNotNull);
      expect(controller.resultado!.montoPorPersona, 27.50);
      expect(controller.resultado!.totalPropina, 10.00);
      expect(controller.resultado!.totalPagar, 110.00);
    });

    test('calcula correctamente en modo hacia arriba', () {
      controller.calcular(
        textoMonto: '10.00',
        textoPersonas: '3',
        textoPropina: '0',
        usarRedondeoHaciaArriba: true,
      );

      expect(controller.errorMonto, isNull);
      expect(controller.errorPersonas, isNull);
      expect(controller.errorPropina, isNull);
      expect(controller.resultado, isNotNull);
      expect(controller.resultado!.montoPorPersona, 4.00);
    });

    test('establece errorMonto y anula resultado si el monto es inválido', () {
      controller.calcular(
        textoMonto: 'abc',
        textoPersonas: '2',
        textoPropina: '10',
        usarRedondeoHaciaArriba: false,
      );

      expect(controller.errorMonto, equals('Monto inválido'));
      expect(controller.resultado, isNull);
    });

    test('establece errorPersonas y anula resultado si personas es menor a 1', () {
      controller.calcular(
        textoMonto: '50.00',
        textoPersonas: '0',
        textoPropina: '10',
        usarRedondeoHaciaArriba: false,
      );

      expect(controller.errorPersonas, equals('Debe haber al menos una persona'));
      expect(controller.resultado, isNull);
    });

    test('establece errorPropina y anula resultado si la propina es negativa', () {
      controller.calcular(
        textoMonto: '50.00',
        textoPersonas: '2',
        textoPropina: '-5',
        usarRedondeoHaciaArriba: false,
      );

      expect(controller.errorPropina, equals('Propina inválida'));
      expect(controller.resultado, isNull);
    });

    test('interpreta propina vacía como 0% sin arrojar error', () {
      controller.calcular(
        textoMonto: '90.00',
        textoPersonas: '3',
        textoPropina: '',
        usarRedondeoHaciaArriba: false,
      );

      expect(controller.errorMonto, isNull);
      expect(controller.errorPersonas, isNull);
      expect(controller.errorPropina, isNull);
      expect(controller.resultado, isNotNull);
      expect(controller.resultado!.montoPorPersona, 30.00);
    });

    test('reiniciar limpia errores y resultado', () {
      controller.calcular(
        textoMonto: 'abc',
        textoPersonas: '0',
        textoPropina: '-1',
        usarRedondeoHaciaArriba: false,
      );

      controller.reiniciar();

      expect(controller.errorMonto, isNull);
      expect(controller.errorPersonas, isNull);
      expect(controller.errorPropina, isNull);
      expect(controller.resultado, isNull);
    });
  });
}

