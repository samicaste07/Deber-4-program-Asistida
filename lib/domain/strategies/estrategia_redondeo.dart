/// Interfaz abstracta que define la estrategia de redondeo para los cálculos.
///
/// Principios aplicados:
/// - OCP (Open/Closed): Permite incorporar nuevas políticas de redondeo sin modificar el caso de uso existente.
/// - ISP (Interface Segregation): Expone únicamente el método estrictamente necesario.
abstract interface class EstrategiaRedondeo {
  /// Aplica una política de redondeo sobre un monto calculado.
  ///
  /// - Qué hace: Transforma un valor numérico continuo a un valor ajustado según la regla.
  /// - Por qué existe: Desacoplar la política matemática del algoritmo de división.
  /// - Qué recibe: [monto] el valor numérico bruto antes del redondeo.
  /// - Qué devuelve: El valor numérico [double] redondeado.
  /// - Errores: No produce excepciones en condiciones normales de valores finitos.
  double redondear(double monto);
}

