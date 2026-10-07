import '../../domain/strategies/estrategia_redondeo.dart';

/// Implementación concreta de la estrategia de redondeo exacto a dos decimales.
///
/// Principios aplicados:
/// - LSP (Liskov Substitution): Puede sustituir cualquier otra [EstrategiaRedondeo].
/// - SRP: Responsable únicamente de truncar/redondear a dos posiciones decimales estándar.
class RedondeoExacto implements EstrategiaRedondeo {
  /// Redondea un valor numérico a dos cifras decimales.
  ///
  /// - Qué hace: Multiplica por 100, redondea al entero más cercano y divide entre 100.
  /// - Por qué existe: Representar la precisión monetaria estándar requerida para el pago exacto.
  /// - Qué recibe: [monto] el número [double] a redondear.
  /// - Qué devuelve: El [double] redondeado a 2 decimales.
  /// - Errores: No produce errores.
  @override
  double redondear(double monto) {
    return (monto * 100).round() / 100;
  }
}

