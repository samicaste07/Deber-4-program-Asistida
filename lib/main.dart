import 'package:flutter/material.dart';

import 'data/strategies/redondeo_exacto.dart';
import 'data/strategies/redondeo_hacia_arriba.dart';
import 'domain/usecases/calcular_division.dart';
import 'domain/usecases/validar_entrada.dart';
import 'presentation/controllers/divisor_controller.dart';
import 'presentation/views/pantalla_divisor.dart';

/// Punto de entrada principal y raíz de composición de la aplicación.
///
/// Principios aplicados:
/// - Composición Root: Único lugar donde se instancian las implementaciones concretas
///   de las capas de datos y dominio para inyectarlas hacia la capa de presentación.
/// - Inversión de dependencias (DIP): Los módulos de alto nivel no crean sus dependencias.
void main() {
  final redondeoExacto = RedondeoExacto();
  final redondeoHaciaArriba = RedondeoHaciaArriba();
  final validarEntrada = ValidarEntrada();
  final calcularDivision = CalcularDivision();

  final controlador = DivisorController(
    calcularDivision: calcularDivision,
    validarEntrada: validarEntrada,
    redondeoExacto: redondeoExacto,
    redondeoHaciaArriba: redondeoHaciaArriba,
  );

  runApp(AppDivisor(controlador: controlador));
}

/// Widget raíz de la aplicación Flutter.
class AppDivisor extends StatelessWidget {
  final DivisorController? controlador;

  const AppDivisor({super.key, this.controlador});

  @override
  Widget build(BuildContext context) {
    final ctrl =
        controlador ??
        DivisorController(
          calcularDivision: CalcularDivision(),
          validarEntrada: ValidarEntrada(),
          redondeoExacto: RedondeoExacto(),
          redondeoHaciaArriba: RedondeoHaciaArriba(),
        );

    return MaterialApp(
      title: 'Divisor de Cuenta',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.teal),
        useMaterial3: true,
      ),
      home: PantallaDivisor(controlador: ctrl),
    );
  }
}

/// Alias para mantener compatibilidad con referencias estándar.
typedef MyApp = AppDivisor;
