import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:divisor_cuenta/data/strategies/redondeo_exacto.dart';
import 'package:divisor_cuenta/data/strategies/redondeo_hacia_arriba.dart';
import 'package:divisor_cuenta/domain/usecases/calcular_division.dart';
import 'package:divisor_cuenta/domain/usecases/validar_entrada.dart';
import 'package:divisor_cuenta/presentation/controllers/divisor_controller.dart';
import 'package:divisor_cuenta/presentation/views/pantalla_divisor.dart';

void main() {
  late DivisorController controlador;

  setUp(() {
    controlador = DivisorController(
      calcularDivision: CalcularDivision(),
      validarEntrada: ValidarEntrada(),
      redondeoExacto: RedondeoExacto(),
      redondeoHaciaArriba: RedondeoHaciaArriba(),
    );
  });

  Widget crearAppPrueba() {
    return MaterialApp(
      home: PantallaDivisor(controlador: controlador),
    );
  }

  group('PantallaDivisor - Escenarios de Aceptación', () {
    testWidgets('Estado inicial: propina en 10% y modo exacto por defecto', (tester) async {
      await tester.pumpWidget(crearAppPrueba());

      final campoPropinaFinder = find.byKey(const Key('campoPropina'));
      expect(campoPropinaFinder, findsOneWidget);

      final TextField campoPropina = tester.widget<TextField>(campoPropinaFinder);
      expect(campoPropina.controller?.text, equals('10'));

      expect(find.byKey(const Key('tarjetaResultado')), findsNothing);
      expect(find.text('Debe haber al menos una persona'), findsNothing);
      expect(find.text('Monto inválido'), findsNothing);
    });

    testWidgets(
      'Escenario 1: Monto 100.00, 4 personas, 10% propina, modo exacto -> muestra 27.50',
      (tester) async {
        await tester.pumpWidget(crearAppPrueba());

        await tester.enterText(find.byKey(const Key('campoMonto')), '100.00');
        await tester.enterText(find.byKey(const Key('campoPersonas')), '4');
        await tester.enterText(find.byKey(const Key('campoPropina')), '10');

        await tester.tap(find.byKey(const Key('botonCalcular')));
        await tester.pumpAndSettle();

        expect(find.byKey(const Key('tarjetaResultado')), findsOneWidget);
        expect(find.text('27.50'), findsOneWidget);
        expect(find.text('10.00'), findsOneWidget); // Total propina
        expect(find.text('110.00'), findsOneWidget); // Total a pagar
      },
    );

    testWidgets(
      'Escenario 2: Monto 90.00, 3 personas, 0% propina, modo exacto -> muestra 30.00',
      (tester) async {
        await tester.pumpWidget(crearAppPrueba());

        await tester.enterText(find.byKey(const Key('campoMonto')), '90.00');
        await tester.enterText(find.byKey(const Key('campoPersonas')), '3');
        await tester.enterText(find.byKey(const Key('campoPropina')), '0');

        await tester.tap(find.byKey(const Key('botonCalcular')));
        await tester.pumpAndSettle();

        expect(find.byKey(const Key('tarjetaResultado')), findsOneWidget);
        expect(find.text('30.00'), findsOneWidget);
      },
    );

    testWidgets(
      'Escenario 3: Monto 50.00 y 0 personas -> muestra error "Debe haber al menos una persona" y NO muestra resultado',
      (tester) async {
        await tester.pumpWidget(crearAppPrueba());

        await tester.enterText(find.byKey(const Key('campoMonto')), '50.00');
        await tester.enterText(find.byKey(const Key('campoPersonas')), '0');

        await tester.tap(find.byKey(const Key('botonCalcular')));
        await tester.pumpAndSettle();

        expect(find.text('Debe haber al menos una persona'), findsOneWidget);
        expect(find.byKey(const Key('tarjetaResultado')), findsNothing);
      },
    );

    testWidgets(
      'Escenario 4: Monto "abc" -> muestra error "Monto inválido" y NO muestra resultado',
      (tester) async {
        await tester.pumpWidget(crearAppPrueba());

        await tester.enterText(find.byKey(const Key('campoMonto')), 'abc');
        await tester.enterText(find.byKey(const Key('campoPersonas')), '2');

        await tester.tap(find.byKey(const Key('botonCalcular')));
        await tester.pumpAndSettle();

        expect(find.text('Monto inválido'), findsOneWidget);
        expect(find.byKey(const Key('tarjetaResultado')), findsNothing);
      },
    );

    testWidgets(
      'Escenario 5: Monto 10.00, 3 personas, 0% propina, modo exacto -> muestra 3.33',
      (tester) async {
        await tester.pumpWidget(crearAppPrueba());

        await tester.enterText(find.byKey(const Key('campoMonto')), '10.00');
        await tester.enterText(find.byKey(const Key('campoPersonas')), '3');
        await tester.enterText(find.byKey(const Key('campoPropina')), '0');

        await tester.tap(find.byKey(const Key('botonCalcular')));
        await tester.pumpAndSettle();

        expect(find.byKey(const Key('tarjetaResultado')), findsOneWidget);
        expect(find.text('3.33'), findsOneWidget);
      },
    );

    testWidgets(
      'Escenario 6: Monto 10.00, 3 personas, 0% propina, modo hacia arriba -> muestra 4.00',
      (tester) async {
        await tester.pumpWidget(crearAppPrueba());

        await tester.enterText(find.byKey(const Key('campoMonto')), '10.00');
        await tester.enterText(find.byKey(const Key('campoPersonas')), '3');
        await tester.enterText(find.byKey(const Key('campoPropina')), '0');

        // Seleccionar modo de redondeo 'Hacia arriba'
        await tester.tap(find.text('Hacia arriba'));
        await tester.pumpAndSettle();

        await tester.tap(find.byKey(const Key('botonCalcular')));
        await tester.pumpAndSettle();

        expect(find.byKey(const Key('tarjetaResultado')), findsOneWidget);
        expect(find.text('4.00'), findsOneWidget);
      },
    );
  });
}

