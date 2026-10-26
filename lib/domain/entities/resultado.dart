/// Entidad inmutable que representa el resultado del cálculo de la división de una cuenta.
///
/// Principios aplicados:
/// - SRP: Modela únicamente los valores de salida resultantes del cálculo.
/// - Dart puro: Libre de dependencias de Flutter.
class Resultado {
  /// Monto final que debe pagar cada persona de forma individual tras aplicar el redondeo.
  final double montoPorPersona;

  /// Monto total acumulado correspondiente a la propina calculada.
  final double totalPropina;

  /// Monto total general a pagar (monto base más propina).
  final double totalPagar;

  /// Constructor de la entidad [Resultado].
  ///
  /// - Qué hace: Almacena los resultados inmutables de la operación.
  /// - Por qué existe: Proveer una estructura clara y tipada para la capa de presentación.
  /// - Qué recibe: [montoPorPersona], [totalPropina], [totalPagar].
  /// - Qué devuelve: Una nueva instancia de [Resultado].
  /// - Errores: No produce excepciones.
  const Resultado({
    required this.montoPorPersona,
    required this.totalPropina,
    required this.totalPagar,
  });

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Resultado &&
          runtimeType == other.runtimeType &&
          montoPorPersona == other.montoPorPersona &&
          totalPropina == other.totalPropina &&
          totalPagar == other.totalPagar;

  @override
  int get hashCode =>
      montoPorPersona.hashCode ^ totalPropina.hashCode ^ totalPagar.hashCode;
}

