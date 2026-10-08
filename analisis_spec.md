
1. Análisis de la Especificación (`specs/001-dividir-cuenta/spec.md`)

A continuación se analizan todos los enunciados atómicos independientes contenidos en la especificación de la funcionalidad:

| # | Enunciado de la spec | Tipo (QUÉ/CÓMO/MIXTO) | ¿Viaja a React? | Justificación |
| 1 | Al abrir la app por primera vez, el porcentaje de propina inicia en 10% por defecto. | QUÉ | Intacto | Estado inicial de la interfaz de usuario, independiente del framework. |

| 2 | Al abrir la app por primera vez, el modo de redondeo 'Exacto' debe estar preseleccionado por defecto. | QUÉ | Intacto | Configuración predeterminada de negocio y UI para el usuario. |

| 3 | El usuario ingresa el monto total de la cuenta, el número de personas y el porcentaje de propina. | QUÉ | Intacto | Comportamiento del sistema y flujo de interacción de entrada de datos. |

| 4 | Al presionar la acción "Calcular", el usuario visualiza cuánto paga cada persona con precisión de dos decimales. | QUÉ | Intacto | Regla funcional de salida observable por el usuario. |

| 5 | El usuario recibe retroalimentación clara e inmediata si ingresa datos erróneos o incompletos. | QUÉ | Intacto | Requisito de experiencia de usuario y manejo defensivo de errores. |

| 6 | Ante entradas erróneas o incompletas, el sistema no produce excepciones no controladas ni muestra cálculos incorrectos. | QUÉ | Intacto | Criterio de robustez funcional independiente de la tecnología. |

| 7 | El usuario puede seleccionar el modo de redondeo hacia arriba al entero más cercano para evitar centavos sueltos. | QUÉ | Intacto | Regla de negocio funcional alternativa para pagos en efectivo. |

| 8 | Si el usuario deja el monto vacío, el sistema presenta el mensaje "Monto inválido". | QUÉ | Intacto | Caso borde funcional de validación de entrada vacía. |

| 9 | Si el usuario ingresa números negativos o cero en el monto, el sistema presenta el mensaje "Monto inválido". | QUÉ | Intacto | Regla de negocio: los cobros monetarios deben ser estrictamente positivos. |

| 10 | FR-001: El sistema DEBE proveer campos para ingresar monto total, personas y propina en una única pantalla. | QUÉ | Intacto | Requisito funcional de disposición y alcance de la interfaz. |

| 11 | FR-002: El sistema DEBE proveer un selector para elegir entre dos modos de redondeo: exacto y hacia arriba. | QUÉ | Intacto | Requisito funcional de componente de selección visual. |

| 12 | FR-004: El sistema DEBE mostrar el monto individual con dos decimales cuando las entradas son válidas. | QUÉ | Intacto | Formato de presentación del resultado al usuario. |

| 13 | FR-006: El sistema DEBE validar que el número de personas sea un entero mayor o igual a 1 y mostrar "Debe haber al menos una persona" si no lo es. | QUÉ | Intacto | Requisito funcional de validación de comensales. |

| 14 | FR-007: La aplicación DEBE funcionar 100% fuera de línea sin requerir conexión a internet, servicios web ni base de datos. | QUÉ | Intacto | Requisito no funcional de disponibilidad y autonomía local. |

| 15 | Los valores de porcentaje de propina son números no negativos (0% o mayores). | QUÉ | Intacto | Suposición y precondición de negocio. |

| 16 | No se requiere persistencia histórica de cálculos anteriores entre sesiones de la app. | QUÉ | Intacto | Suposición de alcance (aplicación sin estado persistente). |

Total de enunciados analizados: 16
Enunciados clasificados como QUÉ: 16 (100 %)
Enunciados clasificados como CÓMO: 0 (0 %)
Enunciados clasificados como MIXTO: 0 (0 %)

Explicación de los porcentajes QUÉ/CÓMO/MIXTO:
El 100 % de los enunciados (16 de 16) son de tipo QUÉ porque describen exclusivamente el comportamiento observable del sistema, los datos de entrada, las salidas y los mensajes de error desde el punto de vista del usuario (requisitos de caja negra). No existen enunciados de tipo CÓMO (0 %) ni MIXTO (0 %) debido a que la especificación no menciona librerías, nombres de clases, widgets, hooks ni detalles técnicos de implementación.

El 30 % se presenta como un umbral pedagógico de este deber para medir la adaptación entre tecnologías, no como una regla universal.


2. Análisis de la Constitución (`.specify/memory/constitution.md`)

| Regla / Enunciado de la Constitution | Clasificación | ¿Viaja a React? | Justificación de la decisión |
| I. SRP (Single Responsibility Principle): Una clase o módulo tiene una única razón de cambio. La lógica de cálculo NO valida entradas ni formatea cadenas visuales. | Idéntica | Intacto | Principio de diseño universal. En React, separar los cálculos matemáticos de los componentes de presentación y de los validadores es exactamente igual de mandatorio. |

| I. OCP (Open/Closed Principle): Abierto a extensión, cerrado a modificación. Agregar una nueva regla de redondeo no obliga a editar clases preexistentes. | Idéntica | Intacto | Principio universal. En TypeScript/React se implementa mediante el patrón Strategy o interfaces polimórficas sin tocar código existente. |

| I. LSP (Liskov Substitution Principle): Cualquier implementación de una interfaz DEBE sustituir a otra sin comprobaciones de tipo concreto. | Idéntica | Intacto | Principio universal de sustitución. Aplica idénticamente a interfaces y tipos abstractos en TypeScript sin usar `instanceof`. |

| I. ISP (Interface Segregation Principle): Interfaces pequeñas y específicas; ningún cliente depende de métodos que no utiliza. | Idéntica | Intacto | Principio universal de segregación. En TypeScript las interfaces modulares evitan acoplamiento innecesario. |

| I. DIP (Dependency Inversion Principle): La capa presentation depende exclusivamente de abstracciones de domain. | Adaptada en redacción | Adaptado | La regla de inversión viaja intacta, pero se redacta para el ecosistema React.|

| II. Capas Arquitectónicas: Organización estricta en lib/presentation/, lib/domain/ y lib/data/. | Adaptada en redacción | Adaptado | La arquitectura en tres capas se conserva, pero en React la carpeta raíz de código fuente estándar es src/, organizándose en src/presentation/, src/domain/ y src/data/. |

| II. Regla de Dependencia: Flujo unidireccional presentation -> domain <- data. | Idéntica | Intacto | La arquitectura limpia y la dirección de dependencias hacia el núcleo del dominio son agnósticas de la tecnología. |

| II. Aislamiento de Dominio: lib/domain/ es Dart puro y NO importa package:flutter. | Adaptada en redacción | Adaptado | Caso representativo: el dominio se preserva, pero se adapta: src/domain/ es TypeScript/JavaScript puro y NO importa react, react-dom ni librerías de UI. |

| III. Seguridad: Prohibición de almacenar secretos, credenciales o API keys dentro del repositorio. | Idéntica | Intacto | Regla de seguridad universal aplicable a cualquier lenguaje, repositorio Git o arquitectura de software. |

| V. Regla de la Materia (Explicabilidad Estudiantil): Toda función debe poder ser explicada por el estudiante | Idéntica | Intacto | Regla pedagógica y académica del curso; independiente de las tecnologías o frameworks utilizados. |

 Resumen de la Constitución ante una migración a React

Reglas Idénticas: 7 de 10 (70 %)
Reglas Adaptadas en redacción: 2 de 10 (20 %)
Reglas Reemplazadas: 0 de 14 (0.0 %)

