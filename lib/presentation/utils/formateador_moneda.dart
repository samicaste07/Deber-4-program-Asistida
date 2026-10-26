/// Utilidad de presentación para formatear valores numéricos a texto con formato de moneda.
///
/// Responsabilidad única: Convertir valores numéricos [double] a cadenas de texto
/// con dos posiciones decimales fijas.
class FormateadorMoneda {
  /// Formatea un valor numérico a una cadena con exactamente dos decimales.
  ///
  /// - Qué hace: Convierte [monto] a formato "0.00".
  /// - Por qué existe: Garantizar una presentación visual uniforme en la interfaz de usuario.
  /// - Qué recibe: [monto] un número de punto flotante [double].
  /// - Qué devuelve: Un [String] con el número formateado a dos decimales.
  /// - Errores: Si [monto] es NaN o infinito, devuelve "0.00" de forma segura.
  static String formatear(double monto) {
    if (monto.isNaN || monto.isInfinite) {
      return '0.00';
    }
    return monto.toStringAsFixed(2);
  }
}

