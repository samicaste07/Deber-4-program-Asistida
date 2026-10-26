import '../strategies/estrategia_redondeo.dart';

/// Entidad inmutable que representa los datos de entrada para la división de una cuenta.
///
/// Principios aplicados:
/// - SRP: Modela únicamente el estado y atributos del consumo de un restaurante.
/// - Dart puro: Sin dependencias de UI ni de frameworks externos.
class Cuenta {
  /// Monto total base de la cuenta antes de aplicar propina.
  final double montoBase;

  /// Cantidad de comensales entre los que se reparte la cuenta (mínimo 1).
  final int numeroPersonas;

  /// Porcentaje de propina a aplicar (por ejemplo: 10 para 10%).
  final double porcentajePropina;

  /// Estrategia elegida para redondear la cuota individual.
  final EstrategiaRedondeo estrategiaRedondeo;

  /// Constructor de la entidad [Cuenta].
  ///
  /// - Qué hace: Inicializa los atributos inmutables de una cuenta.
  /// - Por qué existe: Encapsular los datos validados requeridos para el cálculo.
  /// - Qué recibe: [montoBase], [numeroPersonas], [porcentajePropina], [estrategiaRedondeo].
  /// - Qué devuelve: Una nueva instancia de [Cuenta].
  /// - Errores: No produce errores en su construcción básica; las reglas de negocio son validadas por los casos de uso.
  const Cuenta({
    required this.montoBase,
    required this.numeroPersonas,
    required this.porcentajePropina,
    required this.estrategiaRedondeo,
  });
}

