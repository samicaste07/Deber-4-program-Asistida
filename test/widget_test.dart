import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:divisor_cuenta/main.dart';

void main() {
  testWidgets('Bill splitter smoke test and quick split verification', (WidgetTester tester) async {
    await tester.pumpWidget(const BillSplitterApp());
    await tester.pumpAndSettle();

    // Verify title and main elements
    expect(find.text('Divisor de Cuenta'), findsOneWidget);
    expect(find.text('TOTAL POR PERSONA'), findsOneWidget);
    expect(find.text('División Rápida'), findsOneWidget);
    expect(find.text('Por Consumo'), findsOneWidget);

    // Enter bill amount
    final amountField = find.byType(TextField).first;
    await tester.enterText(amountField, '100');
    await tester.pumpAndSettle();

    // Verify that calculations updated:
    // With 100 base, 10% tip, 2 people:
    // Total = 110, Per person = 55
    expect(find.text('\$55.00'), findsOneWidget);

    // Switch to Detailed Tab
    await tester.tap(find.text('Por Consumo'));
    await tester.pumpAndSettle();

    // Verify detailed split screen elements
    expect(find.text('TOTAL DE LA CUENTA'), findsOneWidget);
    expect(find.textContaining('Amigos'), findsOneWidget);
    expect(find.text('Samuel'), findsAtLeastNWidgets(1));
  });
}
