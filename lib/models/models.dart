class CurrencyOption {
  final String symbol;
  final String name;
  final String code;

  const CurrencyOption({
    required this.symbol,
    required this.name,
    required this.code,
  });

  static const List<CurrencyOption> commonCurrencies = [
    CurrencyOption(symbol: '\$', code: 'USD/MXN/COP/CLP', name: 'Peso / Dólar (\$)'),
    CurrencyOption(symbol: '€', code: 'EUR', name: 'Euro (€)'),
    CurrencyOption(symbol: 'S/', code: 'PEN', name: 'Sol Peruano (S/)'),
    CurrencyOption(symbol: '£', code: 'GBP', name: 'Libra Esterlina (£)'),
    CurrencyOption(symbol: 'Q', code: 'GTQ', name: 'Quetzal (Q)'),
    CurrencyOption(symbol: '₡', code: 'CRC', name: 'Colón (₡)'),
    CurrencyOption(symbol: 'Bs', code: 'BOB/VES', name: 'Bolívar / Boliviano (Bs)'),
    CurrencyOption(symbol: 'R\$', code: 'BRL', name: 'Real Brasileño (R\$)'),
  ];
}

class Person {
  final String id;
  final String name;
  final int colorValue;

  Person({
    required this.id,
    required this.name,
    required this.colorValue,
  });
}

class BillItem {
  final String id;
  final String name;
  final double price;
  final int quantity;
  final List<String> assignedPersonIds;

  BillItem({
    required this.id,
    required this.name,
    required this.price,
    this.quantity = 1,
    required this.assignedPersonIds,
  });

  double get totalPrice => price * quantity;
}

