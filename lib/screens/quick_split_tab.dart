import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../utils/formatters.dart';

enum RoundingOption { none, ceilPerPerson, ceilTotal }

class QuickSplitTab extends StatefulWidget {
  final String currencySymbol;

  const QuickSplitTab({
    super.key,
    required this.currencySymbol,
  });

  @override
  State<QuickSplitTab> createState() => _QuickSplitTabState();
}

class _QuickSplitTabState extends State<QuickSplitTab> {
  final TextEditingController _amountController = TextEditingController();
  
  int _peopleCount = 2;
  double _tipPercentage = 10.0;
  bool _customTipSelected = false;
  
  bool _includeTax = false;
  double _taxPercentage = 16.0;
  
  RoundingOption _rounding = RoundingOption.none;

  final List<double> _tipPresets = [0.0, 5.0, 10.0, 15.0, 18.0, 20.0];

  @override
  void dispose() {
    _amountController.dispose();
    super.dispose();
  }

  double get _billAmount {
    final text = _amountController.text.replaceAll(',', '.').trim();
    return double.tryParse(text) ?? 0.0;
  }

  double get _tipAmount => _billAmount * (_tipPercentage / 100);
  
  double get _taxAmount => _includeTax ? _billAmount * (_taxPercentage / 100) : 0.0;
  
  double get _rawTotal => _billAmount + _tipAmount + _taxAmount;

  double get _totalAmount {
    if (_rounding == RoundingOption.ceilTotal) {
      return _rawTotal.ceilToDouble();
    }
    return _rawTotal;
  }

  double get _perPersonAmount {
    if (_peopleCount <= 0) return 0.0;
    
    if (_rounding == RoundingOption.ceilPerPerson) {
      final exactPerPerson = _rawTotal / _peopleCount;
      return exactPerPerson.ceilToDouble();
    } else if (_rounding == RoundingOption.ceilTotal) {
      return _totalAmount / _peopleCount;
    } else {
      return _rawTotal / _peopleCount;
    }
  }

  double get _effectiveTotal {
    if (_rounding == RoundingOption.ceilPerPerson) {
      return _perPersonAmount * _peopleCount;
    }
    return _totalAmount;
  }

  void _resetAll() {
    setState(() {
      _amountController.clear();
      _peopleCount = 2;
      _tipPercentage = 10.0;
      _customTipSelected = false;
      _includeTax = false;
      _rounding = RoundingOption.none;
    });
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Valores reiniciados'),
        duration: Duration(seconds: 1),
      ),
    );
  }

  void _copyToClipboard() {
    if (_billAmount <= 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Ingresa primero el total de la cuenta.')),
      );
      return;
    }

    final shareText = Formatters.generateQuickSplitShareText(
      billAmount: _billAmount,
      tipPercentage: _tipPercentage,
      tipAmount: _tipAmount,
      taxAmount: _taxAmount,
      peopleCount: _peopleCount,
      totalAmount: _effectiveTotal,
      perPersonAmount: _perPersonAmount,
      currencySymbol: widget.currencySymbol,
      isRounded: _rounding != RoundingOption.none,
    );

    Clipboard.setData(ClipboardData(text: shareText));
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Row(
          children: [
            Icon(Icons.check_circle, color: Colors.white),
            SizedBox(width: 8),
            Expanded(child: Text('¡Resumen copiado para WhatsApp!')),
          ],
        ),
        backgroundColor: Colors.teal.shade700,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      physics: const BouncingScrollPhysics(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // MAIN RESULT HERO CARD
          _buildHeroResultCard(theme, isDark),
          const SizedBox(height: 16),

          // INPUT BILL AMOUNT
          _buildBillAmountCard(theme),
          const SizedBox(height: 16),

          // NUMBER OF PEOPLE
          _buildPeopleSelectorCard(theme),
          const SizedBox(height: 16),

          // TIP SELECTOR
          _buildTipSelectorCard(theme),
          const SizedBox(height: 16),

          // TAX & ROUNDING CARD
          _buildTaxAndRoundingCard(theme),
          const SizedBox(height: 24),

          // ACTION BUTTONS
          Row(
            children: [
              Expanded(
                flex: 2,
                child: FilledButton.icon(
                  onPressed: _copyToClipboard,
                  style: FilledButton.styleFrom(
                    backgroundColor: Colors.teal.shade700,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                  ),
                  icon: const Icon(Icons.share_rounded),
                  label: const Text(
                    'Copiar para WhatsApp',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
                  ),
                ),
              ),
              const SizedBox(width: 10),
              IconButton.filledTonal(
                onPressed: _resetAll,
                icon: const Icon(Icons.refresh_rounded),
                tooltip: 'Reiniciar valores',
                style: IconButton.styleFrom(
                  padding: const EdgeInsets.all(14),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),
        ],
      ),
    );
  }

  Widget _buildHeroResultCard(ThemeData theme, bool isDark) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: isDark
              ? [const Color(0xFF0F766E), const Color(0xFF115E59)]
              : [const Color(0xFF0D9488), const Color(0xFF047857)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: Colors.teal.withValues(alpha: 0.3),
            blurRadius: 15,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      padding: const EdgeInsets.all(20),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'TOTAL POR PERSONA',
                style: TextStyle(
                  color: Colors.white70,
                  fontSize: 12,
                  letterSpacing: 1.2,
                  fontWeight: FontWeight.w700,
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.2),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(Icons.people_alt_rounded, color: Colors.white, size: 14),
                    const SizedBox(width: 4),
                    Text(
                      '$_peopleCount ${_peopleCount == 1 ? "persona" : "personas"}',
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          FittedBox(
            fit: BoxFit.scaleDown,
            child: Text(
              Formatters.formatCurrency(_perPersonAmount, widget.currencySymbol),
              style: const TextStyle(
                color: Colors.white,
                fontSize: 42,
                fontWeight: FontWeight.w900,
                letterSpacing: -0.5,
              ),
            ),
          ),
          const SizedBox(height: 16),
          const Divider(color: Colors.white24, height: 1),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildMetricSubItem(
                label: 'Cuenta base',
                value: Formatters.formatCurrency(_billAmount, widget.currencySymbol),
              ),
              _buildMetricSubItem(
                label: 'Propina (${_tipPercentage.toStringAsFixed(0)}%)',
                value: Formatters.formatCurrency(_tipAmount, widget.currencySymbol),
              ),
              _buildMetricSubItem(
                label: 'Total general',
                value: Formatters.formatCurrency(_effectiveTotal, widget.currencySymbol),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildMetricSubItem({required String label, required String value}) {
    return Expanded(
      child: Column(
        children: [
          FittedBox(
            fit: BoxFit.scaleDown,
            child: Text(
              label,
              textAlign: TextAlign.center,
              style: const TextStyle(
                color: Colors.white70,
                fontSize: 11,
              ),
            ),
          ),
          const SizedBox(height: 2),
          FittedBox(
            fit: BoxFit.scaleDown,
            child: Text(
              value,
              textAlign: TextAlign.center,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 13,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBillAmountCard(ThemeData theme) {
    return Card(
      elevation: 0,
      color: theme.colorScheme.surfaceContainerHighest.withValues(alpha: 0.4),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.receipt_rounded, color: theme.colorScheme.primary, size: 20),
                const SizedBox(width: 8),
                Text(
                  'Total de la cuenta',
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            TextField(
              controller: _amountController,
              keyboardType: const TextInputType.numberWithOptions(decimal: true),
              style: const TextStyle(fontSize: 26, fontWeight: FontWeight.bold),
              decoration: InputDecoration(
                prefixIcon: Padding(
                  padding: const EdgeInsets.only(left: 14, right: 8),
                  child: Text(
                    widget.currencySymbol,
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: theme.colorScheme.primary,
                    ),
                  ),
                ),
                prefixIconConstraints: const BoxConstraints(minWidth: 0, minHeight: 0),
                hintText: '0.00',
                suffixIcon: _amountController.text.isNotEmpty
                    ? IconButton(
                        icon: const Icon(Icons.clear_rounded),
                        onPressed: () {
                          setState(() {
                            _amountController.clear();
                          });
                        },
                      )
                    : null,
                filled: true,
                fillColor: theme.colorScheme.surface,
                contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(16),
                  borderSide: BorderSide.none,
                ),
              ),
              onChanged: (_) => setState(() {}),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPeopleSelectorCard(ThemeData theme) {
    return Card(
      elevation: 0,
      color: theme.colorScheme.surfaceContainerHighest.withValues(alpha: 0.4),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Icon(Icons.group_rounded, color: theme.colorScheme.primary, size: 20),
                    const SizedBox(width: 8),
                    Text(
                      'Número de personas',
                      style: theme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                Text(
                  '$_peopleCount',
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: theme.colorScheme.primary,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 14),
            Row(
              children: [
                IconButton.filledTonal(
                  onPressed: _peopleCount > 1
                      ? () => setState(() => _peopleCount--)
                      : null,
                  icon: const Icon(Icons.remove_rounded),
                ),
                Expanded(
                  child: SliderTheme(
                    data: SliderTheme.of(context).copyWith(
                      activeTrackColor: Colors.teal,
                      thumbColor: Colors.teal.shade700,
                    ),
                    child: Slider(
                      value: _peopleCount.toDouble(),
                      min: 1,
                      max: 20,
                      divisions: 19,
                      label: '$_peopleCount',
                      onChanged: (val) {
                        setState(() {
                          _peopleCount = val.toInt();
                        });
                      },
                    ),
                  ),
                ),
                IconButton.filledTonal(
                  onPressed: _peopleCount < 50
                      ? () => setState(() => _peopleCount++)
                      : null,
                  icon: const Icon(Icons.add_rounded),
                ),
              ],
            ),
            const SizedBox(height: 6),
            // Quick count shortcuts
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: [2, 3, 4, 5, 6, 8, 10].map((count) {
                  final isSelected = _peopleCount == count;
                  return Padding(
                    padding: const EdgeInsets.only(right: 8),
                    child: ChoiceChip(
                      label: Text('$count'),
                      selected: isSelected,
                      onSelected: (selected) {
                        if (selected) setState(() => _peopleCount = count);
                      },
                    ),
                  );
                }).toList(),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTipSelectorCard(ThemeData theme) {
    return Card(
      elevation: 0,
      color: theme.colorScheme.surfaceContainerHighest.withValues(alpha: 0.4),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Icon(Icons.volunteer_activism_rounded,
                        color: theme.colorScheme.primary, size: 20),
                    const SizedBox(width: 8),
                    Text(
                      'Propina / Servicio',
                      style: theme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                Text(
                  '${_tipPercentage.toStringAsFixed(0)}%  (${Formatters.formatCurrency(_tipAmount, widget.currencySymbol)})',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: theme.colorScheme.primary,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                ..._tipPresets.map((pct) {
                  final isSelected = !_customTipSelected && _tipPercentage == pct;
                  return ChoiceChip(
                    label: Text('${pct.toInt()}%'),
                    selected: isSelected,
                    onSelected: (selected) {
                      if (selected) {
                        setState(() {
                          _customTipSelected = false;
                          _tipPercentage = pct;
                        });
                      }
                    },
                  );
                }),
                ChoiceChip(
                  label: const Text('Personalizado'),
                  selected: _customTipSelected,
                  onSelected: (selected) {
                    setState(() {
                      _customTipSelected = true;
                    });
                  },
                ),
              ],
            ),
            if (_customTipSelected) ...[
              const SizedBox(height: 10),
              Row(
                children: [
                  Expanded(
                    child: SliderTheme(
                      data: SliderTheme.of(context).copyWith(
                        activeTrackColor: Colors.teal,
                        thumbColor: Colors.teal.shade700,
                      ),
                      child: Slider(
                        value: _tipPercentage,
                        min: 0,
                        max: 40,
                        divisions: 40,
                        label: '${_tipPercentage.toInt()}%',
                        onChanged: (val) {
                          setState(() {
                            _tipPercentage = val;
                          });
                        },
                      ),
                    ),
                  ),
                  Text(
                    '${_tipPercentage.toInt()}%',
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildTaxAndRoundingCard(ThemeData theme) {
    return Card(
      elevation: 0,
      color: theme.colorScheme.surfaceContainerHighest.withValues(alpha: 0.4),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // TAX SWITCH
            Row(
              children: [
                Icon(Icons.account_balance_rounded,
                    color: theme.colorScheme.primary, size: 20),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    'Agregar Impuesto / IVA',
                    style: theme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                Switch(
                  value: _includeTax,
                  activeThumbColor: Colors.teal,
                  onChanged: (val) {
                    setState(() {
                      _includeTax = val;
                    });
                  },
                ),
              ],
            ),
            if (_includeTax) ...[
              const SizedBox(height: 10),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Porcentaje de impuesto:',
                    style: TextStyle(fontWeight: FontWeight.w500, fontSize: 13),
                  ),
                  const SizedBox(height: 6),
                  Wrap(
                    spacing: 6,
                    runSpacing: 6,
                    children: [8.0, 16.0, 19.0, 21.0].map((pct) {
                      final isSelected = _taxPercentage == pct;
                      return ChoiceChip(
                        label: Text('${pct.toInt()}%'),
                        selected: isSelected,
                        onSelected: (val) {
                          if (val) setState(() => _taxPercentage = pct);
                        },
                      );
                    }).toList(),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Text(
                'Impuesto calculado: ${Formatters.formatCurrency(_taxAmount, widget.currencySymbol)}',
                style: TextStyle(
                  fontSize: 12,
                  color: theme.colorScheme.outline,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const Divider(height: 24),
            ],

            const SizedBox(height: 8),
            // ROUNDING
            Row(
              children: [
                Icon(Icons.auto_awesome_rounded,
                    color: theme.colorScheme.primary, size: 20),
                const SizedBox(width: 8),
                Text(
                  'Opciones de Redondeo',
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Wrap(
              spacing: 8,
              children: [
                ChoiceChip(
                  label: const Text('Exacto (sin redondeo)'),
                  selected: _rounding == RoundingOption.none,
                  onSelected: (val) {
                    if (val) setState(() => _rounding = RoundingOption.none);
                  },
                ),
                ChoiceChip(
                  label: const Text('Redondear por persona'),
                  selected: _rounding == RoundingOption.ceilPerPerson,
                  onSelected: (val) {
                    if (val) setState(() => _rounding = RoundingOption.ceilPerPerson);
                  },
                ),
                ChoiceChip(
                  label: const Text('Redondear total'),
                  selected: _rounding == RoundingOption.ceilTotal,
                  onSelected: (val) {
                    if (val) setState(() => _rounding = RoundingOption.ceilTotal);
                  },
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
