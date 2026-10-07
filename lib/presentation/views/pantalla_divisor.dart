import 'package:flutter/material.dart';

import '../../domain/entities/resultado.dart';
import '../controllers/divisor_controller.dart';
import '../utils/formateador_moneda.dart';

/// Pantalla visual única de la aplicación para dividir la cuenta de restaurante.
///
/// Principios aplicados:
/// - SRP: Responsable exclusivamente de la interfaz de usuario, captura de eventos y renderizado de estado visual.
/// - Inyección de dependencias: Recibe [controlador] en su constructor.
/// - Gestión de estado: Utiliza [setState] para actualizar la interfaz ante cambios del controlador.
class PantallaDivisor extends StatefulWidget {
  final DivisorController controlador;

  const PantallaDivisor({
    super.key,
    required this.controlador,
  });

  @override
  State<PantallaDivisor> createState() => _PantallaDivisorState();
}

class _PantallaDivisorState extends State<PantallaDivisor> {
  late final TextEditingController _controladorMonto;
  late final TextEditingController _controladorPersonas;
  late final TextEditingController _controladorPropina;

  /// Controla el modo de redondeo seleccionado: `false` para Exacto, `true` para Hacia arriba.
  /// Por especificación, inicia en `false` (Exacto por defecto).
  bool _usarRedondeoHaciaArriba = false;

  @override
  void initState() {
    super.initState();
    _controladorMonto = TextEditingController();
    _controladorPersonas = TextEditingController();
    // Valor inicial por defecto de propina según especificación: 10%
    _controladorPropina = TextEditingController(text: '10');
  }

  @override
  void dispose() {
    _controladorMonto.dispose();
    _controladorPersonas.dispose();
    _controladorPropina.dispose();
    super.dispose();
  }

  /// Dispara el cálculo invocando al controlador y actualiza la vista con [setState].
  void _ejecutarCalculo() {
    setState(() {
      widget.controlador.calcular(
        textoMonto: _controladorMonto.text,
        textoPersonas: _controladorPersonas.text,
        textoPropina: _controladorPropina.text,
        usarRedondeoHaciaArriba: _usarRedondeoHaciaArriba,
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    final Resultado? resultado = widget.controlador.resultado;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Divisor de Cuenta'),
        centerTitle: true,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Campo para monto total
              TextField(
                key: const Key('campoMonto'),
                controller: _controladorMonto,
                keyboardType: const TextInputType.numberWithOptions(decimal: true),
                decoration: InputDecoration(
                  labelText: 'Monto total',
                  hintText: 'Ej. 100.00',
                  prefixIcon: const Icon(Icons.attach_money),
                  errorText: widget.controlador.errorMonto,
                  border: const OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 16.0),

              // Campo para número de personas
              TextField(
                key: const Key('campoPersonas'),
                controller: _controladorPersonas,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  labelText: 'Número de personas',
                  hintText: 'Ej. 4',
                  prefixIcon: const Icon(Icons.people_alt_outlined),
                  errorText: widget.controlador.errorPersonas,
                  border: const OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 16.0),

              // Campo para porcentaje de propina
              TextField(
                key: const Key('campoPropina'),
                controller: _controladorPropina,
                keyboardType: const TextInputType.numberWithOptions(decimal: true),
                decoration: InputDecoration(
                  labelText: 'Porcentaje de propina (%)',
                  hintText: 'Ej. 10',
                  prefixIcon: const Icon(Icons.percent),
                  errorText: widget.controlador.errorPropina,
                  border: const OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 20.0),

              // Selector de modo de redondeo
              const Text(
                'Modo de redondeo:',
                style: TextStyle(fontWeight: FontWeight.w600),
              ),
              const SizedBox(height: 8.0),
              SegmentedButton<bool>(
                key: const Key('selectorRedondeo'),
                segments: const [
                  ButtonSegment<bool>(
                    value: false,
                    label: Text('Exacto'),
                    icon: Icon(Icons.tune),
                  ),
                  ButtonSegment<bool>(
                    value: true,
                    label: Text('Hacia arriba'),
                    icon: Icon(Icons.arrow_upward),
                  ),
                ],
                selected: {_usarRedondeoHaciaArriba},
                onSelectionChanged: (nuevaSeleccion) {
                  setState(() {
                    _usarRedondeoHaciaArriba = nuevaSeleccion.first;
                  });
                },
              ),
              const SizedBox(height: 24.0),

              // Botón de cálculo
              FilledButton.icon(
                key: const Key('botonCalcular'),
                onPressed: _ejecutarCalculo,
                icon: const Icon(Icons.calculate),
                label: const Text(
                  'Calcular',
                  style: TextStyle(fontSize: 16.0),
                ),
                style: FilledButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 14.0),
                ),
              ),
              const SizedBox(height: 24.0),

              // Visualización de resultados (únicamente si no hay errores y existe resultado)
              if (resultado != null) ...[
                Card(
                  key: const Key('tarjetaResultado'),
                  elevation: 2.0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12.0),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Column(
                      children: [
                        Text(
                          'Monto por persona',
                          style: Theme.of(context).textTheme.titleMedium,
                        ),
                        const SizedBox(height: 8.0),
                        Text(
                          FormateadorMoneda.formatear(resultado.montoPorPersona),
                          key: const Key('textoMontoPorPersona'),
                          style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                                fontWeight: FontWeight.bold,
                                color: Theme.of(context).colorScheme.primary,
                              ),
                        ),
                        const Divider(height: 24.0),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text('Total de propina:'),
                            Text(
                              FormateadorMoneda.formatear(resultado.totalPropina),
                              key: const Key('textoTotalPropina'),
                              style: const TextStyle(fontWeight: FontWeight.w600),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8.0),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text('Total a pagar:'),
                            Text(
                              FormateadorMoneda.formatear(resultado.totalPagar),
                              key: const Key('textoTotalPagar'),
                              style: const TextStyle(fontWeight: FontWeight.w600),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}

