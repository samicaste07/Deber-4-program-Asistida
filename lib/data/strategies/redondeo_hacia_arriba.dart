import '../../domain/strategies/estrategia_redondeo.dart';

/// Implementación concreta de la estrategia de redondeo hacia arriba al entero más cercano.
///
/// Principios aplicados:
/// - LSP: Sustituye a [EstrategiaRedondeo] sin alterar el contrato esperado por el cliente.
/// - SRP: Única responsabilidad de aplicar la función techo (ceiling) al monto por persona.
class RedondeoHaciaArriba implements EstrategiaRedondeo {
  /// Redondea un valor numérico hacia arriba al entero inmediatamente superior.
  ///
  /// - Qué hace: Aplica la función matemática [ceilToDouble] sobre el monto.
  /// - Por qué existe: Simplificar los pagos en efectivo evitando el uso de monedas o centavos.
  /// - Qué recibe: [monto] el número [double] a redondear.
  /// - Qué devuelve: El [double] correspondiente al entero superior.
  /// - Errores: No produce errores.
  @override
  double redondear(double monto) {
    return monto.ceilToDouble();
  }
}

