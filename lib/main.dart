import 'package:flutter/material.dart';
import 'models/models.dart';
import 'screens/quick_split_tab.dart';
import 'screens/detailed_split_tab.dart';

void main() {
  runApp(const BillSplitterApp());
}

class BillSplitterApp extends StatefulWidget {
  const BillSplitterApp({super.key});

  @override
  State<BillSplitterApp> createState() => _BillSplitterAppState();
}

class _BillSplitterAppState extends State<BillSplitterApp> {
  ThemeMode _themeMode = ThemeMode.system;
  CurrencyOption _selectedCurrency = CurrencyOption.commonCurrencies[0];

  void _toggleTheme() {
    setState(() {
      _themeMode = _themeMode == ThemeMode.dark ? ThemeMode.light : ThemeMode.dark;
    });
  }

  void _selectCurrency(CurrencyOption currency) {
    setState(() {
      _selectedCurrency = currency;
    });
  }

  @override
  Widget build(BuildContext context) {
    const primarySeed = Color(0xFF0D9488); // Teal Moderno

    return MaterialApp(
      title: 'Divisor de Cuentas',
      debugShowCheckedModeBanner: false,
      themeMode: _themeMode,
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: primarySeed,
          brightness: Brightness.light,
        ),
        appBarTheme: const AppBarTheme(
          centerTitle: false,
          elevation: 0,
        ),
        cardTheme: const CardThemeData(
          elevation: 0,
          margin: EdgeInsets.zero,
        ),
      ),
      darkTheme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: primarySeed,
          brightness: Brightness.dark,
        ),
        appBarTheme: const AppBarTheme(
          centerTitle: false,
          elevation: 0,
        ),
        cardTheme: const CardThemeData(
          elevation: 0,
          margin: EdgeInsets.zero,
        ),
      ),
      home: HomeScreen(
        selectedCurrency: _selectedCurrency,
        onCurrencyChanged: _selectCurrency,
        onToggleTheme: _toggleTheme,
        currentThemeMode: _themeMode,
      ),
    );
  }
}

class HomeScreen extends StatefulWidget {
  final CurrencyOption selectedCurrency;
  final ValueChanged<CurrencyOption> onCurrencyChanged;
  final VoidCallback onToggleTheme;
  final ThemeMode currentThemeMode;

  const HomeScreen({
    super.key,
    required this.selectedCurrency,
    required this.onCurrencyChanged,
    required this.onToggleTheme,
    required this.currentThemeMode,
  });

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  void _showCurrencyDialog() {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Row(
          children: [
            Icon(Icons.currency_exchange_rounded),
            SizedBox(width: 8),
            Text('Seleccionar Moneda'),
          ],
        ),
        content: SizedBox(
          width: double.maxFinite,
          child: ListView.separated(
            shrinkWrap: true,
            itemCount: CurrencyOption.commonCurrencies.length,
            separatorBuilder: (ctx, i) => const Divider(height: 1),
            itemBuilder: (ctx, index) {
              final currency = CurrencyOption.commonCurrencies[index];
              final isSelected = currency.symbol == widget.selectedCurrency.symbol &&
                  currency.code == widget.selectedCurrency.code;
              return ListTile(
                leading: CircleAvatar(
                  backgroundColor: isSelected
                      ? Theme.of(context).colorScheme.primary
                      : Theme.of(context).colorScheme.surfaceContainerHighest,
                  foregroundColor: isSelected
                      ? Theme.of(context).colorScheme.onPrimary
                      : Theme.of(context).colorScheme.onSurfaceVariant,
                  child: Text(
                    currency.symbol,
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
                title: Text(currency.name),
                subtitle: Text(currency.code),
                trailing: isSelected ? const Icon(Icons.check_rounded, color: Colors.teal) : null,
                onTap: () {
                  widget.onCurrencyChanged(currency);
                  Navigator.pop(ctx);
                },
              );
            },
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Cerrar'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        title: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: const EdgeInsets.all(7),
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.primaryContainer,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(
                Icons.pie_chart_rounded,
                color: Theme.of(context).colorScheme.onPrimaryContainer,
                size: 20,
              ),
            ),
            const SizedBox(width: 8),
            const Flexible(
              child: Text(
                'Divisor de Cuenta',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
        actions: [
          // Moneda
          ActionChip(
            visualDensity: VisualDensity.compact,
            padding: const EdgeInsets.symmetric(horizontal: 4),
            avatar: const Icon(Icons.monetization_on_outlined, size: 16),
            label: Text(
              widget.selectedCurrency.symbol,
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            onPressed: _showCurrencyDialog,
          ),
          const SizedBox(width: 2),
          // Tema claro/oscuro
          IconButton(
            visualDensity: VisualDensity.compact,
            tooltip: isDark ? 'Modo claro' : 'Modo oscuro',
            icon: Icon(isDark ? Icons.light_mode_rounded : Icons.dark_mode_rounded),
            onPressed: widget.onToggleTheme,
          ),
          const SizedBox(width: 4),
        ],
        bottom: TabBar(
          controller: _tabController,
          indicatorSize: TabBarIndicatorSize.tab,
          tabs: const [
            Tab(
              icon: Icon(Icons.calculate_rounded),
              text: 'División Rápida',
            ),
            Tab(
              icon: Icon(Icons.receipt_long_rounded),
              text: 'Por Consumo',
            ),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          QuickSplitTab(currencySymbol: widget.selectedCurrency.symbol),
          DetailedSplitTab(currencySymbol: widget.selectedCurrency.symbol),
        ],
      ),
    );
  }
}
