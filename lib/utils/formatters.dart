import '../models/models.dart';

class Formatters {
  static String formatCurrency(double amount, String symbol) {
    if (amount.isNaN || amount.isInfinite) return '$symbol 0.00';
    
    // Format to 2 decimal places
    final isNegative = amount < 0;
    final absAmount = amount.abs();
    final parts = absAmount.toStringAsFixed(2).split('.');
    
    // Add thousand commas
    final integerPart = parts[0].replaceAllMapped(
      RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
      (Match m) => '${m[1]},',
    );
    final decimalPart = parts[1];
    
    final sign = isNegative ? '-' : '';
    return '$sign$symbol$integerPart.$decimalPart';
  }

  static String generateQuickSplitShareText({
    required double billAmount,
    required double tipPercentage,
    required double tipAmount,
    required double taxAmount,
    required int peopleCount,
    required double totalAmount,
    required double perPersonAmount,
    required String currencySymbol,
    required bool isRounded,
  }) {
    final buffer = StringBuffer();
    buffer.writeln('🧾 *CUENTA COMPARTIDA* 🧾');
    buffer.writeln('-----------------------------------');
    buffer.writeln('💵 Subtotal: ${formatCurrency(billAmount, currencySymbol)}');
    if (tipAmount > 0) {
      buffer.writeln('🤝 Propina (${tipPercentage.toStringAsFixed(0)}%): ${formatCurrency(tipAmount, currencySymbol)}');
    }
    if (taxAmount > 0) {
      buffer.writeln('🏛️ Impuestos: ${formatCurrency(taxAmount, currencySymbol)}');
    }
    buffer.writeln('💰 Total General: ${formatCurrency(totalAmount, currencySymbol)}');
    buffer.writeln('👥 Personas: $peopleCount');
    buffer.writeln('-----------------------------------');
    buffer.writeln('👉 *CADA UNO PAGA:* ${formatCurrency(perPersonAmount, currencySymbol)} ${isRounded ? "(redondeado)" : ""}');
    buffer.writeln('-----------------------------------');
    buffer.writeln('✨ _Calculado con Divisor de Cuentas_');
    return buffer.toString();
  }

  static String generateDetailedSplitShareText({
    required List<Person> people,
    required List<BillItem> items,
    required double tipPercentage,
    required String currencySymbol,
  }) {
    final buffer = StringBuffer();
    buffer.writeln('🧾 *DESGLOSE DE LA CUENTA POR PERSONA* 🧾');
    buffer.writeln('-----------------------------------');

    double grandSubtotal = 0;
    for (final item in items) {
      grandSubtotal += item.totalPrice;
    }
    final grandTip = grandSubtotal * (tipPercentage / 100);
    final grandTotal = grandSubtotal + grandTip;

    for (final person in people) {
      // Find items consumed by person
      final personItems = items.where((it) => it.assignedPersonIds.contains(person.id)).toList();
      double personSubtotal = 0;

      for (final item in personItems) {
        final share = item.totalPrice / (item.assignedPersonIds.isNotEmpty ? item.assignedPersonIds.length : 1);
        personSubtotal += share;
      }

      final personTip = grandSubtotal > 0 ? (personSubtotal / grandSubtotal) * grandTip : 0.0;
      final personTotal = personSubtotal + personTip;

      buffer.writeln('👤 *${person.name.toUpperCase()}*');
      if (personItems.isEmpty) {
        buffer.writeln('   (Sin consumos registrados)');
      } else {
        for (final item in personItems) {
          final share = item.totalPrice / item.assignedPersonIds.length;
          final splitNote = item.assignedPersonIds.length > 1 ? ' (entre ${item.assignedPersonIds.length})' : '';
          buffer.writeln('   • ${item.name}$splitNote: ${formatCurrency(share, currencySymbol)}');
        }
      }
      buffer.writeln('   Subtotal: ${formatCurrency(personSubtotal, currencySymbol)}');
      if (tipPercentage > 0) {
        buffer.writeln('   Propina: ${formatCurrency(personTip, currencySymbol)}');
      }
      buffer.writeln('   👉 *TOTAL A PAGAR: ${formatCurrency(personTotal, currencySymbol)}*');
      buffer.writeln('');
    }

    buffer.writeln('-----------------------------------');
    buffer.writeln('💰 Subtotal grupo: ${formatCurrency(grandSubtotal, currencySymbol)}');
    if (grandTip > 0) {
      buffer.writeln('🤝 Propina (${tipPercentage.toStringAsFixed(0)}%): ${formatCurrency(grandTip, currencySymbol)}');
    }
    buffer.writeln('💵 Gran Total: ${formatCurrency(grandTotal, currencySymbol)}');
    buffer.writeln('-----------------------------------');
    buffer.writeln('✨ _Calculado con Divisor de Cuentas_');
    return buffer.toString();
  }
}

