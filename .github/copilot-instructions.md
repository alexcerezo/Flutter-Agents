# GitHub Copilot - Instrucciones de Accesibilidad para Flutter

Esta aplicación Flutter de reserva de eventos debe cumplir con WCAG 2.1 Nivel AA y ser compatible con TalkBack (Android) y VoiceOver (iOS).

Todo elemento interactivo debe tener un widget Semantics con label, hint y las propiedades apropiadas (button: true, image: true, header: true, etc.).

Usa el patrón Semantics con ExcludeSemantics en el child para evitar redundancia: el widget externo proporciona la descripción accesible y ExcludeSemantics previene que los widgets internos se lean por separado.

Para contenido dinámico que cambia frecuentemente (contadores, precios), usa liveRegion: true en Semantics, pero considera implementar debouncing para evitar anuncios excesivos.

Todos los headers de página (AppBar titles, secciones) deben usar Semantics con header: true.

Las imágenes deben tener Semantics con image: true y un label descriptivo que identifique el contenido visual.

Los botones deben incluir enabled en Semantics para reflejar su estado actual y permitir que los lectores de pantalla lo anuncien.

En tests de widgets que verifican accesibilidad, siempre usa await tester.pumpAndSettle() después de pumpWidget() para asegurar que las animaciones y operaciones asíncronas completen antes de las aserciones.

Usamos Material Design 3 con ColorScheme.fromSeed para garantizar contraste de color adecuado, pero verifica manualmente cualquier combinación de colores personalizada.

El área mínima de toque para elementos interactivos es 48x48 dp según Material Design; Flutter lo maneja automáticamente para widgets estándar.

Para revisiones especializadas de accesibilidad, delega al agente @SemantiDash cuando trabajes en widgets de UI o cambios que afecten la experiencia del usuario.

Los strings de UI (textos visibles para el usuario) deben estar en español; el código (nombres de variables, funciones, comentarios) debe estar en inglés siguiendo las convenciones estándar de Dart/Flutter.

Usa const constructors siempre que sea posible para mejorar el rendimiento.

Preferimos ValueNotifier con ValueListenableBuilder para estado local y ChangeNotifier con ListenableBuilder para estado global.

Los tests de accesibilidad están en test/accessibility_test.dart y deben actualizarse cuando se agregan o modifican widgets interactivos.
