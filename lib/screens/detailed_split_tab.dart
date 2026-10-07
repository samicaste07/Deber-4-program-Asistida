import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../models/models.dart';
import '../utils/formatters.dart';

class DetailedSplitTab extends StatefulWidget {
  final String currencySymbol;

  const DetailedSplitTab({
    super.key,
    required this.currencySymbol,
  });

  @override
  State<DetailedSplitTab> createState() => _DetailedSplitTabState();
}

class _DetailedSplitTabState extends State<DetailedSplitTab> {
  final List<Person> _people = [
    Person(id: '1', name: 'Samuel', colorValue: 0xFF0D9488),
    Person(id: '2', name: 'Carlos', colorValue: 0xFF2563EB),
    Person(id: '3', name: 'María', colorValue: 0xFFDB2777),
  ];

  final List<BillItem> _items = [
    BillItem(
      id: 'item_1',
      name: 'Pizza Familiar',
      price: 24.0,
      quantity: 1,
      assignedPersonIds: ['1', '2', '3'],
    ),
    BillItem(
      id: 'item_2',
      name: 'Bebidas & Cervezas',
      price: 12.0,
      quantity: 1,
      assignedPersonIds: ['1', '2'],
    ),
    BillItem(
      id: 'item_3',
      name: 'Postre Brownie',
      price: 6.5,
      quantity: 1,
      assignedPersonIds: ['3'],
    ),
  ];

  double _tipPercentage = 10.0;

  final List<int> _colorPalette = [
    0xFF0D9488, // Teal
    0xFF2563EB, // Blue
    0xFFDB2777, // Pink
    0xFF7C3AED, // Violet
    0xFFEA580C, // Orange
    0xFF16A34A, // Green
    0xFFCA8A04, // Yellow
    0xFF0891B2, // Cyan
    0xFFE11D48, // Rose
  ];

  double get _subtotal {
    double sum = 0;
    for (final it in _items) {
      sum += it.totalPrice;
    }
    return sum;
  }

  double get _tipAmount => _subtotal * (_tipPercentage / 100);
  double get _grandTotal => _subtotal + _tipAmount;

  void _addPerson() {
    final controller = TextEditingController();
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Agregar Amigo'),
        content: TextField(
          controller: controller,
          autofocus: true,
          decoration: const InputDecoration(
            labelText: 'Nombre',
            hintText: 'Ej. Laura, Andrés...',
          ),
          textCapitalization: TextCapitalization.words,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Cancelar'),
          ),
          FilledButton(
            onPressed: () {
              final name = controller.text.trim();
              if (name.isNotEmpty) {
                final newColor = _colorPalette[_people.length % _colorPalette.length];
                setState(() {
                  _people.add(
                    Person(
                      id: DateTime.now().millisecondsSinceEpoch.toString(),
                      name: name,
                      colorValue: newColor,
                    ),
                  );
                });
                Navigator.pop(ctx);
              }
            },
            child: const Text('Agregar'),
          ),
        ],
      ),
    );
  }

  void _deletePerson(Person person) {
    if (_people.length <= 1) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Debe haber al menos 1 persona.')),
      );
      return;
    }

    setState(() {
      _people.removeWhere((p) => p.id == person.id);
      // Remove person from assigned items
      for (final item in _items) {
        item.assignedPersonIds.remove(person.id);
      }
    });
  }

  void _showAddItemDialog({BillItem? editItem}) {
    if (_people.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Agrega al menos una persona primero.')),
      );
      return;
    }

    final nameController = TextEditingController(text: editItem?.name ?? '');
    final priceController = TextEditingController(
      text: editItem != null ? editItem.price.toString() : '',
    );
    final quantityController = TextEditingController(
      text: editItem != null ? editItem.quantity.toString() : '1',
    );

    final selectedPersonIds = <String>{
      if (editItem != null) ...editItem.assignedPersonIds else ..._people.map((p) => p.id),
    };

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (ctx) {
        return StatefulBuilder(
          builder: (ctx, setSheetState) {
            final bottomInsets = MediaQuery.of(ctx).viewInsets.bottom;
            return Padding(
              padding: EdgeInsets.only(
                left: 20,
                right: 20,
                top: 20,
                bottom: bottomInsets + 20,
              ),
              child: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Text(
                      editItem == null ? 'Nuevo Consumo' : 'Editar Consumo',
                      style: Theme.of(ctx).textTheme.titleLarge?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                    ),
                    const SizedBox(height: 16),
                    TextField(
                      controller: nameController,
                      textCapitalization: TextCapitalization.sentences,
                      decoration: InputDecoration(
                        labelText: 'Nombre del plato o consumo',
                        hintText: 'Ej. Hamburguesa doble, Bebidas, etc.',
                        prefixIcon: const Icon(Icons.fastfood_rounded),
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                      ),
                    ),
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        Expanded(
                          flex: 2,
                          child: TextField(
                            controller: priceController,
                            keyboardType: const TextInputType.numberWithOptions(decimal: true),
                            decoration: InputDecoration(
                              labelText: 'Precio unitario (${widget.currencySymbol})',
                              hintText: '0.00',
                              prefixIcon: const Icon(Icons.attach_money_rounded),
                              border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                            ),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          flex: 1,
                          child: TextField(
                            controller: quantityController,
                            keyboardType: TextInputType.number,
                            decoration: InputDecoration(
                              labelText: 'Cant.',
                              border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          '¿Quiénes consumieron?',
                          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
                        ),
                        TextButton(
                          onPressed: () {
                            setSheetState(() {
                              if (selectedPersonIds.length == _people.length) {
                                selectedPersonIds.clear();
                              } else {
                                selectedPersonIds.addAll(_people.map((p) => p.id));
                              }
                            });
                          },
                          child: Text(
                            selectedPersonIds.length == _people.length
                                ? 'Deseleccionar todos'
                                : 'Todos',
                          ),
                        ),
                      ],
                    ),
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: _people.map((p) {
                        final isSelected = selectedPersonIds.contains(p.id);
                        return FilterChip(
                          selected: isSelected,
                          avatar: CircleAvatar(
                            backgroundColor: Color(p.colorValue),
                            child: Text(
                              p.name.isNotEmpty ? p.name[0].toUpperCase() : '?',
                              style: const TextStyle(color: Colors.white, fontSize: 11),
                            ),
                          ),
                          label: Text(p.name),
                          onSelected: (val) {
                            setSheetState(() {
                              if (val) {
                                selectedPersonIds.add(p.id);
                              } else {
                                selectedPersonIds.remove(p.id);
                              }
                            });
                          },
                        );
                      }).toList(),
                    ),
                    const SizedBox(height: 20),
                    FilledButton(
                      onPressed: () {
                        final name = nameController.text.trim();
                        final price = double.tryParse(priceController.text.replaceAll(',', '.')) ?? 0.0;
                        final quantity = int.tryParse(quantityController.text) ?? 1;

                        if (name.isEmpty) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('Ingresa un nombre para el consumo')),
                          );
                          return;
                        }

                        if (price <= 0) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('Ingresa un precio válido')),
                          );
                          return;
                        }

                        if (selectedPersonIds.isEmpty) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('Selecciona al menos una persona')),
                          );
                          return;
                        }

                        setState(() {
                          if (editItem != null) {
                            final idx = _items.indexWhere((it) => it.id == editItem.id);
                            if (idx != -1) {
                              _items[idx] = BillItem(
                                id: editItem.id,
                                name: name,
                                price: price,
                                quantity: quantity,
                                assignedPersonIds: selectedPersonIds.toList(),
                              );
                            }
                          } else {
                            _items.add(
                              BillItem(
                                id: DateTime.now().millisecondsSinceEpoch.toString(),
                                name: name,
                                price: price,
                                quantity: quantity,
                                assignedPersonIds: selectedPersonIds.toList(),
                              ),
                            );
                          }
                        });
                        Navigator.pop(ctx);
                      },
                      style: FilledButton.styleFrom(
                        backgroundColor: Colors.teal.shade700,
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      ),
                      child: Text(
                        editItem == null ? 'Guardar Consumo' : 'Actualizar Consumo',
                        style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }

  void _copyDetailedToClipboard() {
    if (_items.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Agrega consumos primero.')),
      );
      return;
    }

    final shareText = Formatters.generateDetailedSplitShareText(
      people: _people,
      items: _items,
      tipPercentage: _tipPercentage,
      currencySymbol: widget.currencySymbol,
    );

    Clipboard.setData(ClipboardData(text: shareText));
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Row(
          children: [
            Icon(Icons.check_circle, color: Colors.white),
            SizedBox(width: 8),
            Expanded(child: Text('¡Desglose copiado para WhatsApp!')),
          ],
        ),
        backgroundColor: Colors.teal.shade700,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      ),
    );
  }

  void _clearAllItems() {
    setState(() {
      _items.clear();
    });
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Lista de consumos vaciada')),
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
          // TOTAL RESUMEN HEADER
          _buildTotalCard(theme, isDark),
          const SizedBox(height: 16),

          // AMIGOS SECTION
          _buildPeopleSection(theme),
          const SizedBox(height: 16),

          // ITEMS / CONSUMOS SECTION
          _buildItemsSection(theme),
          const SizedBox(height: 16),

          // TIP SELECTOR
          _buildTipSection(theme),
          const SizedBox(height: 16),

          // PER-PERSON BREAKDOWN CARDS
          _buildBreakdownSection(theme),
          const SizedBox(height: 24),

          // ACTIONS
          Row(
            children: [
              Expanded(
                child: FilledButton.icon(
                  onPressed: _copyDetailedToClipboard,
                  style: FilledButton.styleFrom(
                    backgroundColor: Colors.teal.shade700,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                  ),
                  icon: const Icon(Icons.share_rounded),
                  label: const Text(
                    'Copiar desglose completo',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
              ),
              const SizedBox(width: 10),
              IconButton.filledTonal(
                onPressed: _items.isNotEmpty ? _clearAllItems : null,
                icon: const Icon(Icons.delete_sweep_rounded),
                tooltip: 'Vaciar consumos',
                style: IconButton.styleFrom(
                  padding: const EdgeInsets.all(14),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),
        ],
      ),
    );
  }

  Widget _buildTotalCard(ThemeData theme, bool isDark) {
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
                'TOTAL DE LA CUENTA',
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
                child: Text(
                  '${_items.length} ${_items.length == 1 ? "ítem" : "ítems"}',
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 12,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          FittedBox(
            fit: BoxFit.scaleDown,
            child: Text(
              Formatters.formatCurrency(_grandTotal, widget.currencySymbol),
              style: const TextStyle(
                color: Colors.white,
                fontSize: 38,
                fontWeight: FontWeight.w900,
              ),
            ),
          ),
          const SizedBox(height: 14),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Expanded(
                child: Column(
                  children: [
                    const FittedBox(
                      fit: BoxFit.scaleDown,
                      child: Text('Subtotal platos', style: TextStyle(color: Colors.white70, fontSize: 11)),
                    ),
                    const SizedBox(height: 2),
                    FittedBox(
                      fit: BoxFit.scaleDown,
                      child: Text(
                        Formatters.formatCurrency(_subtotal, widget.currencySymbol),
                        style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 14),
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: Column(
                  children: [
                    FittedBox(
                      fit: BoxFit.scaleDown,
                      child: Text('Propina (${_tipPercentage.toStringAsFixed(0)}%)',
                          style: const TextStyle(color: Colors.white70, fontSize: 11)),
                    ),
                    const SizedBox(height: 2),
                    FittedBox(
                      fit: BoxFit.scaleDown,
                      child: Text(
                        Formatters.formatCurrency(_tipAmount, widget.currencySymbol),
                        style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 14),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildPeopleSection(ThemeData theme) {
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
                    Icon(Icons.people_rounded, color: theme.colorScheme.primary, size: 20),
                    const SizedBox(width: 8),
                    Text(
                      'Amigos (${_people.length})',
                      style: theme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                TextButton.icon(
                  onPressed: _addPerson,
                  icon: const Icon(Icons.person_add_alt_1_rounded, size: 18),
                  label: const Text('Añadir'),
                ),
              ],
            ),
            const SizedBox(height: 10),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: _people.map((p) {
                return Chip(
                  avatar: CircleAvatar(
                    backgroundColor: Color(p.colorValue),
                    child: Text(
                      p.name.isNotEmpty ? p.name[0].toUpperCase() : '?',
                      style: const TextStyle(color: Colors.white, fontSize: 11, fontWeight: FontWeight.bold),
                    ),
                  ),
                  label: Text(p.name, style: const TextStyle(fontWeight: FontWeight.w600)),
                  deleteIcon: const Icon(Icons.close_rounded, size: 16),
                  onDeleted: _people.length > 1 ? () => _deletePerson(p) : null,
                );
              }).toList(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildItemsSection(ThemeData theme) {
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
                    Icon(Icons.restaurant_menu_rounded, color: theme.colorScheme.primary, size: 20),
                    const SizedBox(width: 8),
                    Text(
                      'Platos y Consumos',
                      style: theme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                FilledButton.tonalIcon(
                  onPressed: () => _showAddItemDialog(),
                  icon: const Icon(Icons.add_rounded, size: 18),
                  label: const Text('Agregar'),
                  style: FilledButton.styleFrom(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            if (_items.isEmpty)
              Center(
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 20),
                  child: Column(
                    children: [
                      Icon(Icons.menu_book_rounded, size: 40, color: theme.colorScheme.outline),
                      const SizedBox(height: 8),
                      Text(
                        'Aún no hay consumos agregados',
                        style: TextStyle(color: theme.colorScheme.outline),
                      ),
                    ],
                  ),
                ),
              )
            else
              ListView.separated(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: _items.length,
                separatorBuilder: (ctx, i) => const Divider(height: 1),
                itemBuilder: (ctx, index) {
                  final item = _items[index];
                  final assignedNames = _people
                      .where((p) => item.assignedPersonIds.contains(p.id))
                      .map((p) => p.name)
                      .join(', ');

                  return ListTile(
                    contentPadding: EdgeInsets.zero,
                    title: Text(
                      item.name,
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                    subtitle: Text(
                      'Compartido con: ${assignedNames.isEmpty ? "Nadie" : assignedNames}',
                      style: TextStyle(fontSize: 12, color: theme.colorScheme.outline),
                    ),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          Formatters.formatCurrency(item.totalPrice, widget.currencySymbol),
                          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
                        ),
                        IconButton(
                          visualDensity: VisualDensity.compact,
                          padding: EdgeInsets.zero,
                          constraints: const BoxConstraints(),
                          icon: const Icon(Icons.edit_outlined, size: 18),
                          onPressed: () => _showAddItemDialog(editItem: item),
                        ),
                        const SizedBox(width: 4),
                        IconButton(
                          visualDensity: VisualDensity.compact,
                          padding: EdgeInsets.zero,
                          constraints: const BoxConstraints(),
                          icon: const Icon(Icons.delete_outline, size: 18, color: Colors.redAccent),
                          onPressed: () {
                            setState(() {
                              _items.removeAt(index);
                            });
                          },
                        ),
                      ],
                    ),
                  );
                },
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildTipSection(ThemeData theme) {
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
                    Icon(Icons.volunteer_activism_rounded, color: theme.colorScheme.primary, size: 20),
                    const SizedBox(width: 8),
                    Text(
                      'Propina grupal',
                      style: theme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                Text(
                  '${_tipPercentage.toInt()}%  (${Formatters.formatCurrency(_tipAmount, widget.currencySymbol)})',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: theme.colorScheme.primary,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),
            Wrap(
              spacing: 8,
              children: [0.0, 5.0, 10.0, 15.0, 20.0].map((pct) {
                final isSelected = _tipPercentage == pct;
                return ChoiceChip(
                  label: Text('${pct.toInt()}%'),
                  selected: isSelected,
                  onSelected: (val) {
                    if (val) setState(() => _tipPercentage = pct);
                  },
                );
              }).toList(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBreakdownSection(ThemeData theme) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(Icons.payments_rounded, color: theme.colorScheme.primary, size: 20),
            const SizedBox(width: 8),
            Text(
              'Desglose por Amigo',
              style: theme.textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        ..._people.map((person) {
          final personItems = _items.where((it) => it.assignedPersonIds.contains(person.id)).toList();
          double personSubtotal = 0;
          for (final it in personItems) {
            personSubtotal += it.totalPrice / (it.assignedPersonIds.isNotEmpty ? it.assignedPersonIds.length : 1);
          }
          final personTip = _subtotal > 0 ? (personSubtotal / _subtotal) * _tipAmount : 0.0;
          final personTotal = personSubtotal + personTip;

          return Card(
            elevation: 1,
            margin: const EdgeInsets.only(bottom: 12),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
            child: ExpansionTile(
              leading: CircleAvatar(
                backgroundColor: Color(person.colorValue),
                child: Text(
                  person.name.isNotEmpty ? person.name[0].toUpperCase() : '?',
                  style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                ),
              ),
              title: Text(
                person.name,
                style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
              ),
              subtitle: Text(
                'Debe pagar: ${Formatters.formatCurrency(personTotal, widget.currencySymbol)}',
                style: TextStyle(
                  fontWeight: FontWeight.w700,
                  color: theme.colorScheme.primary,
                ),
              ),
              childrenPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              children: [
                if (personItems.isEmpty)
                  const Padding(
                    padding: EdgeInsets.symmetric(vertical: 8),
                    child: Text('Sin consumos asignados', style: TextStyle(fontStyle: FontStyle.italic)),
                  )
                else
                  ...personItems.map((item) {
                    final splitShare = item.totalPrice / item.assignedPersonIds.length;
                    return Padding(
                      padding: const EdgeInsets.symmetric(vertical: 4),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: Text(
                              '• ${item.name} ${item.assignedPersonIds.length > 1 ? "(1/${item.assignedPersonIds.length})" : ""}',
                              style: const TextStyle(fontSize: 13),
                            ),
                          ),
                          Text(
                            Formatters.formatCurrency(splitShare, widget.currencySymbol),
                            style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w500),
                          ),
                        ],
                      ),
                    );
                  }),
                const Divider(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text('Subtotal consumo:', style: TextStyle(fontSize: 12, color: Colors.grey)),
                    Text(
                      Formatters.formatCurrency(personSubtotal, widget.currencySymbol),
                      style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
                if (_tipPercentage > 0) ...[
                  const SizedBox(height: 2),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('Propina (${_tipPercentage.toStringAsFixed(0)}%):',
                          style: const TextStyle(fontSize: 12, color: Colors.grey)),
                      Text(
                        Formatters.formatCurrency(personTip, widget.currencySymbol),
                        style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                ],
                const SizedBox(height: 6),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text('TOTAL:', style: TextStyle(fontWeight: FontWeight.bold)),
                    Text(
                      Formatters.formatCurrency(personTotal, widget.currencySymbol),
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 15,
                        color: theme.colorScheme.primary,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
              ],
            ),
          );
        }),
      ],
    );
  }
}
