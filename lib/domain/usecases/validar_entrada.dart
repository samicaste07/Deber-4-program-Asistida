/// Caso de uso responsable de la validación sintáctica y de reglas de negocio para los campos de entrada.
///
/// Principios aplicados:
/// - SRP: Única responsabilidad de validar entradas del usuario.
/// - Dart puro: Sin dependencias de widgets ni librerías de Flutter.
class ValidarEntrada {
  /// Valida la cadena ingresada como monto total de la cuenta.
  ///
  /// - Qué hace: Comprueba que el texto no sea nulo, sea convertible a número finito no NaN y sea estrictamente mayor que cero.
  /// - Por qué existe: Asegurar que el cálculo monetario opere sobre cantidades positivas reales.
  /// - Qué recibe: [texto] la cadena opcional ingresada por el usuario.
  /// - Qué devuelve: "Monto inválido" si no cumple las condiciones; `null` si es válido.
  /// - Errores: No arroja excepciones; encapsula el error en un mensaje claro.
  String? validarMonto(String? texto) {
    if (texto == null) return 'Monto inválido';
    final limpio = texto.trim().replaceAll(',', '.');
    if (limpio.isEmpty) return 'Monto inválido';

    final valor = double.tryParse(limpio);
    if (valor == null || valor.isNaN || valor.isInfinite || valor <= 0) {
      return 'Monto inválido';
    }
    return null;
  }

  /// Valida la cantidad de personas ingresada.
  ///
  /// - Qué hace: Comprueba que el texto represente un número entero mayor o igual a 1.
  /// - Por qué existe: Evitar divisiones entre cero y asegurar que haya comensales válidos.
  /// - Qué recibe: [texto] la cadena opcional con la cantidad de personas.
  /// - Qué devuelve: "Debe haber al menos una persona" si es nulo, inválido o menor a 1; `null` si es válido.
  /// - Errores: No arroja excepciones.
  String? validarPersonas(String? texto) {
    if (texto == null) return 'Debe haber al menos una persona';
    final limpio = texto.trim();
    if (limpio.isEmpty) return 'Debe haber al menos una persona';

    final cantidad = int.tryParse(limpio);
    if (cantidad == null || cantidad < 1) {
      return 'Debe haber al menos una persona';
    }
    return null;
  }

  /// Valida el porcentaje de propina ingresado.
  ///
  /// - Qué hace: Comprueba que el porcentaje sea convertible a número finito no negativo. Una cadena vacía se interpreta como 0% válido.
  /// - Por qué existe: Prevenir tasas de propina negativas, infinitas o alfabéticas.
  /// - Qué recibe: [texto] la cadena opcional con la propina.
  /// - Qué devuelve: "Propina inválida" si es erróneo; `null` si es válido o vacío.
  /// - Errores: No arroja excepciones.
  String? validarPropina(String? texto) {
    if (texto == null) return null;
    final limpio = texto.trim().replaceAll(',', '.');
    if (limpio.isEmpty) return null;

    final valor = double.tryParse(limpio);
    if (valor == null || valor.isNaN || valor.isInfinite || valor < 0) {
      return 'Propina inválida';
    }
    return null;
  }

  /// Valida conjuntamente las entradas requeridas para el cálculo de la división.
  ///
  /// - Qué hace: Comprueba secuencialmente el monto, la cantidad de personas y la tasa de propina.
  /// - Por qué existe: Permitir una validación unificada y reutilizable.
  /// - Qué recibe: [monto], [personas] y [propina] que pueden ser valores numéricos o cadenas de texto.
  /// - Qué devuelve: El primer mensaje de error encontrado, o `null` si todas las entradas son válidas.
  String? validar({
    required dynamic monto,
    required dynamic personas,
    dynamic propina,
  }) {
    final String? textoMonto = monto == null
        ? null
        : (monto is double && monto.isNaN ? 'NaN' : monto.toString());
    final errorMonto = validarMonto(textoMonto);
    if (errorMonto != null) return errorMonto;

    final String? textoPersonas = personas?.toString();
    final errorPersonas = validarPersonas(textoPersonas);
    if (errorPersonas != null) return errorPersonas;

    final String? textoPropina = propina?.toString();
    final errorPropina = validarPropina(textoPropina);
    if (errorPropina != null) return errorPropina;

    return null;
  }
}
