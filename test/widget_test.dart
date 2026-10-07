import 'package:flutter_test/flutter_test.dart';
import 'package:divisor_cuenta/main.dart';

void main() {
  testWidgets('Smoke test de inicio de la aplicación', (WidgetTester tester) async {
    // Construye la aplicación y dispara un cuadro.
    await tester.pumpWidget(const MyApp());

    // Verifica que la pantalla principal cargue con sus elementos esenciales.
    expect(find.text('Divisor de Cuenta'), findsOneWidget);
    expect(find.text('Calcular'), findsOneWidget);
  });
}
