import '../entities/cuenta.dart';
import '../entities/resultado.dart';

/// Caso de uso que ejecuta la lógica pura de división de una cuenta de restaurante.
///
/// Principios aplicados:
/// - SRP (Single Responsibility): Solo realiza operaciones matemáticas de división y cálculo de propina.
///   No valida cadenas de texto ni formatea para la pantalla.
/// - DIP (Dependency Inversion): Aplica la [EstrategiaRedondeo] a través de su interfaz abstracta.
/// - Dart puro: Sin dependencias de UI ni librerías externas de framework.
class CalcularDivision {
  /// Ejecuta el cálculo de la división a partir de los datos provistos en [cuenta].
  ///
  /// - Qué hace:
  ///   1. Multiplica el monto base por la tasa de propina para hallar el total de propina.
  ///   2. Suma el monto base y la propina para hallar el total a pagar.
  ///   3. Divide el total a pagar entre el número de comensales.
  ///   4. Aplica la estrategia de redondeo configurada a la cuota individual.
  /// - Por qué existe: Centralizar la regla de negocio de división sin acoplarse a la UI.
  /// - Qué recibe: [cuenta] una instancia válida e inmutable de [Cuenta].
  /// - Qué devuelve: Una instancia de [Resultado] con los totales y la cuota individual.
  /// - Errores: Supone que [cuenta.numeroPersonas] es mayor a 0 (validado previamente por la capa correspondiente).
  Resultado ejecutar(Cuenta cuenta) {
    final double totalPropina = cuenta.montoBase * (cuenta.porcentajePropina / 100.0);
    final double totalPagar = cuenta.montoBase + totalPropina;
    final double cuotaBruta = totalPagar / cuenta.numeroPersonas;
    final double montoPorPersona = cuenta.estrategiaRedondeo.redondear(cuotaBruta);

    return Resultado(
      montoPorPersona: montoPorPersona,
      totalPropina: totalPropina,
      totalPagar: totalPagar,
    );
  }
}

