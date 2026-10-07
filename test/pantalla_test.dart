import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:divisor_cuenta/main.dart';

void main() {
  testWidgets(
    '1. Escribo 100, 4 y 10, toco "Calcular" y aparece "27.50" en pantalla',
    (WidgetTester tester) async {
      await tester.pumpWidget(const MyApp());

      await tester.enterText(find.byKey(const Key('campoMonto')), '100');
      await tester.enterText(find.byKey(const Key('campoPersonas')), '4');
      await tester.enterText(find.byKey(const Key('campoPropina')), '10');

      await tester.tap(find.text('Calcular'));
      await tester.pumpAndSettle();

      expect(find.text('27.50'), findsOneWidget);
    },
  );

  testWidgets(
    '2. Escribo 50 y 0 personas, toco "Calcular" y aparece "Debe haber al menos una persona", y NO aparece ningún resultado',
    (WidgetTester tester) async {
      await tester.pumpWidget(const MyApp());

      await tester.enterText(find.byKey(const Key('campoMonto')), '50');
      await tester.enterText(find.byKey(const Key('campoPersonas')), '0');

      await tester.tap(find.text('Calcular'));
      await tester.pumpAndSettle();

      expect(find.text('Debe haber al menos una persona'), findsOneWidget);
      expect(find.byKey(const Key('tarjetaResultado')), findsNothing);
      expect(find.text('Monto por persona'), findsNothing);
    },
  );

  testWidgets(
    '3. Escribo "abc" en el monto, toco "Calcular" y aparece "Monto inválido"',
    (WidgetTester tester) async {
      await tester.pumpWidget(const MyApp());

      await tester.enterText(find.byKey(const Key('campoMonto')), 'abc');

      await tester.tap(find.text('Calcular'));
      await tester.pumpAndSettle();

      expect(find.text('Monto inválido'), findsOneWidget);
    },
  );
}

