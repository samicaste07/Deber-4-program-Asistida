import '../../domain/entities/cuenta.dart';
import '../../domain/entities/resultado.dart';
import '../../domain/strategies/estrategia_redondeo.dart';
import '../../domain/usecases/calcular_division.dart';
import '../../domain/usecases/validar_entrada.dart';

/// Controlador de presentación que coordina la validación, la selección de estrategia
/// y la ejecución del cálculo para la pantalla de división de cuenta.
///
/// Principios aplicados:
/// - SRP: Conectar la entrada de la vista con los casos de uso y la estrategia adecuada.
/// - DIP: Recibe sus dependencias a través del constructor.
class DivisorController {
  final CalcularDivision calcularDivision;
  final ValidarEntrada validarEntrada;
  final EstrategiaRedondeo redondeoExacto;
  final EstrategiaRedondeo redondeoHaciaArriba;

  DivisorController({
    required this.calcularDivision,
    required this.validarEntrada,
    required this.redondeoExacto,
    required this.redondeoHaciaArriba,
  });

  /// Almacena el resultado del cálculo más reciente, o `null` si hubo un error.
  Resultado? resultado;

  /// Mensaje de error para el campo de monto, o `null` si es válido.
  String? errorMonto;

  /// Mensaje de error para el campo de personas, o `null` si es válido.
  String? errorPersonas;

  /// Mensaje de error para el campo de propina, o `null` si es válido.
  String? errorPropina;

  /// Ejecuta el proceso de validación y cálculo a partir de las cadenas ingresadas por el usuario.
  ///
  /// - Qué hace:
  ///   1. Valida los campos de monto, comensales y porcentaje de propina.
  ///   2. Si existen errores de validación, asigna los mensajes correspondientes y anula [resultado].
  ///   3. Si las entradas son válidas, selecciona la estrategia de redondeo, construye la entidad [Cuenta]
  ///      y ejecuta el caso de uso [CalcularDivision].
  /// - Por qué existe: Desacoplar la lógica de flujo de la interfaz visual de Flutter.
  /// - Qué recibe:
  ///   - [textoMonto]: Texto ingresado para el monto total.
  ///   - [textoPersonas]: Texto ingresado para el número de personas.
  ///   - [textoPropina]: Texto ingresado para la propina en porcentaje.
  ///   - [usarRedondeoHaciaArriba]: `true` para redondeo hacia arriba, `false` para redondeo exacto.
  /// - Qué devuelve: `void` (actualiza el estado interno de la instancia).
  void calcular({
    required String textoMonto,
    required String textoPersonas,
    required String textoPropina,
    required bool usarRedondeoHaciaArriba,
  }) {
    errorMonto = validarEntrada.validarMonto(textoMonto);
    errorPersonas = validarEntrada.validarPersonas(textoPersonas);
    errorPropina = validarEntrada.validarPropina(textoPropina);

    if (errorMonto != null || errorPersonas != null || errorPropina != null) {
      resultado = null;
      return;
    }

    final double monto = double.parse(textoMonto.trim().replaceAll(',', '.'));
    final int personas = int.parse(textoPersonas.trim());
    final String propinaLimpia = textoPropina.trim().replaceAll(',', '.');
    final double propina = propinaLimpia.isEmpty ? 0.0 : double.parse(propinaLimpia);

    final EstrategiaRedondeo estrategia =
        usarRedondeoHaciaArriba ? redondeoHaciaArriba : redondeoExacto;

    final cuenta = Cuenta(
      montoBase: monto,
      numeroPersonas: personas,
      porcentajePropina: propina,
      estrategiaRedondeo: estrategia,
    );

    resultado = calcularDivision.ejecutar(cuenta);
  }

  /// Limpia los estados de error y resultados almacenados.
  void reiniciar() {
    resultado = null;
    errorMonto = null;
    errorPersonas = null;
    errorPropina = null;
  }
}

