# Instrucciones de GitHub Copilot para Accesibilidad en Flutter

Este documento proporciona directrices detalladas para garantizar que toda la aplicación Flutter cumpla con los estándares de accesibilidad **WCAG 2.1 Nivel AA** durante el desarrollo.

## 🎯 Principios Fundamentales

### 1. Accesibilidad desde el Diseño (Accessibility by Design)
- **SIEMPRE** considera la accesibilidad desde el inicio, no como una mejora posterior
- Todo elemento interactivo **DEBE** tener etiquetas semánticas apropiadas
- Todo contenido visual **DEBE** tener alternativas textuales

### 2. Cumplimiento de Estándares
Esta aplicación cumple con:
- **WCAG 2.1 Nivel AA**: Pautas de Accesibilidad al Contenido Web
- **Flutter Accessibility Guidelines**: Directrices oficiales de Flutter
- **TalkBack** (Android) y **VoiceOver** (iOS): Compatibilidad completa con lectores de pantalla

## 📋 Directrices de Implementación

### Uso de Widgets Semánticos

#### ✅ DO: Envolver Elementos Interactivos con Semantics

```dart
// Botón con semántica completa
// Nota: FilledButton requiere Material 3 (Flutter 3.7+)
// Alternativa: ElevatedButton para versiones anteriores
Semantics(
  button: true,
  label: 'Confirmar Reserva',  // Identifica el elemento
  hint: 'Confirma la reserva de las entradas seleccionadas',  // Explica la acción
  enabled: canBook,  // Estado del botón
  child: FilledButton(  // O ElevatedButton para Flutter < 3.7
    onPressed: canBook ? _handleBooking : null,
    child: const Text('Confirmar Reserva'),
  ),
)

// Tarjeta interactiva
Semantics(
  button: true,
  label: 'Evento: ${event.title}',
  value: 'Fecha: ${formattedDate}, Ubicación: ${event.location}, Precio: €${event.price}',
  hint: 'Toca para ver detalles y reservar entradas',
  child: ExcludeSemantics(
    child: Card(...),
  ),
)
```

#### ❌ DON'T: Dejar Elementos sin Etiquetas Semánticas

```dart
// ❌ INCORRECTO: Sin semántica
GestureDetector(
  onTap: () => _navigate(),
  child: Card(...),
)

// ✅ CORRECTO: Con semántica
Semantics(
  button: true,
  label: 'Descripción clara del elemento',
  hint: 'Acción que ocurrirá al activar',
  child: ExcludeSemantics(
    child: GestureDetector(
      onTap: () => _navigate(),
      child: Card(...),
    ),
  ),
)
```

### Jerarquía y Estructura

#### Headers y Títulos

```dart
// AppBar con header semántico
AppBar(
  title: Semantics(
    header: true,
    label: 'Título de la Página',
    child: const ExcludeSemantics(
      child: Text('Título de la Página'),
    ),
  ),
)

// Encabezados en contenido
Semantics(
  header: true,
  label: event.title,
  child: ExcludeSemantics(
    child: Text(
      event.title,
      style: Theme.of(context).textTheme.headlineLarge,
    ),
  ),
)
```

### Imágenes Accesibles

```dart
// Imagen con descripción semántica
Semantics(
  image: true,
  label: 'Imagen del evento ${event.title}',
  child: ExcludeSemantics(
    child: Image.network(
      event.imageUrl,
      fit: BoxFit.cover,
    ),
  ),
)

// Imagen decorativa (sin contenido informativo)
ExcludeSemantics(
  child: Image.asset('assets/decoration.png'),
)
```

### Regiones Dinámicas (Live Regions)

Para contenido que cambia dinámicamente y debe anunciarse:

```dart
// Contador que anuncia cambios
// ⚠️ Consideración de rendimiento: Las live regions anuncian cada cambio.
// Para actualizaciones frecuentes, considera debouncing o throttling.
ValueListenableBuilder<int>(
  valueListenable: ticketCount,
  builder: (context, count, _) {
    return Semantics(
      label: '$count entradas seleccionadas',
      liveRegion: true,  // Anuncia cambios automáticamente
      child: ExcludeSemantics(
        child: Text(
          '$count',
          style: Theme.of(context).textTheme.headlineMedium,
        ),
      ),
    );
  },
)

// Precio total que se actualiza
// Nota: Solo usa liveRegion si el usuario necesita conocer cambios inmediatos
Semantics(
  label: '€${total.toStringAsFixed(2)}',
  liveRegion: true,
  child: ExcludeSemantics(
    child: Text('€${total.toStringAsFixed(2)}'),
  ),
)
```

### Botones e Interacciones

```dart
// Botón de incremento/decremento con estado
Semantics(
  button: true,
  label: 'Aumentar número de entradas',
  enabled: count < maxTickets,
  child: IconButton(
    onPressed: count < maxTickets ? () => increment() : null,
    icon: const Icon(Icons.add),
  ),
)

Semantics(
  button: true,
  label: 'Disminuir número de entradas',
  enabled: count > 0,
  child: IconButton(
    onPressed: count > 0 ? () => decrement() : null,
    icon: const Icon(Icons.remove),
  ),
)
```

### Diálogos y Mensajes

```dart
// Diálogo con semántica de ruta
Semantics(
  namesRoute: true,
  label: 'Reserva Confirmada',
  child: AlertDialog(
    title: const Text('¡Reserva Confirmada!'),
    content: Text('Has reservado $tickets entrada(s) para ${event.title}'),
    actions: [
      Semantics(
        button: true,
        label: 'Aceptar',
        hint: 'Cierra el diálogo y regresa a la lista de eventos',
        child: TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Aceptar'),
        ),
      ),
    ],
  ),
)
```

### Información Compleja

Para información que combina múltiples elementos visuales:

```dart
// Barra de disponibilidad con descripción completa
Semantics(
  label: 'Disponibilidad: ${event.availableTickets} de ${event.maxCapacity} '
         'entradas disponibles, ${availabilityPercentage} por ciento',
  child: ExcludeSemantics(
    child: Column(
      children: [
        Text('Disponibilidad: ${event.availableTickets}/${event.maxCapacity}'),
        LinearProgressIndicator(value: availability),
      ],
    ),
  ),
)
```

## 🎨 Consideraciones Visuales

### Contraste de Color

**WCAG AA requiere:**
- Texto normal: ratio de contraste mínimo 4.5:1
- Texto grande (≥18pt o ≥14pt bold): ratio mínimo 3:1
- Elementos de UI y gráficos: ratio mínimo 3:1

```dart
// ✅ Material Design 3 proporciona buenos contrastes por defecto
MaterialApp(
  theme: ThemeData(
    colorScheme: ColorScheme.fromSeed(
      seedColor: Colors.blue,
      brightness: Brightness.light,
    ),
  ),
  darkTheme: ThemeData(
    colorScheme: ColorScheme.fromSeed(
      seedColor: Colors.blue,
      brightness: Brightness.dark,
    ),
  ),
)

// ⚠️ Verifica contrastes personalizados con herramientas:
// - Chrome DevTools (Lighthouse)
// - Accessibility Scanner (Android)
// - Color Contrast Analyzer
```

### Área Mínima de Toque

- **Mínimo requerido**: 48x48 dp (Material Design)
- Flutter maneja esto automáticamente para widgets estándar
- Para gestos personalizados, asegura el área mínima:

```dart
// ✅ Widget estándar (área automática)
IconButton(
  icon: Icon(Icons.add),
  onPressed: () {},
)

// ✅ GestureDetector personalizado (área explícita)
SizedBox(
  width: 48,
  height: 48,
  child: GestureDetector(
    onTap: () {},
    child: Center(child: Icon(Icons.custom)),
  ),
)
```

## 🧪 Testing de Accesibilidad

### Tests Semánticos Obligatorios

Cada PR **DEBE** incluir tests de accesibilidad para nuevos widgets:

```dart
testWidgets('Event card has proper semantic labels', (tester) async {
  await tester.pumpWidget(MaterialApp(home: EventCard(event: testEvent)));
  await tester.pumpAndSettle();  // Espera a que completen animaciones y operaciones async
  
  // Verificar que el widget tenga semántica de botón
  final semanticsFinder = find.byWidgetPredicate(
    (widget) =>
        widget is Semantics &&
        widget.properties.button == true &&
        widget.properties.label != null &&
        widget.properties.label!.contains('Evento:'),
  );
  
  expect(semanticsFinder, findsOneWidget);
});

testWidgets('Live regions announce changes', (tester) async {
  await tester.pumpWidget(MaterialApp(home: TicketCounter()));
  await tester.pumpAndSettle();  // Importante para tests semánticos
  
  final liveRegionFinder = find.byWidgetPredicate(
    (widget) =>
        widget is Semantics &&
        widget.properties.liveRegion == true,
  );
  
  expect(liveRegionFinder, findsWidgets);
});

testWidgets('Images have descriptive labels', (tester) async {
  await tester.pumpWidget(MaterialApp(home: EventDetailPage(event: testEvent)));
  await tester.pumpAndSettle();  // Espera a que carguen todos los elementos
  
  final imageFinder = find.byWidgetPredicate(
    (widget) =>
        widget is Semantics &&
        widget.properties.image == true &&
        widget.properties.label != null,
  );
  
  expect(imageFinder, findsWidgets);
});
```

### Verificación Manual

Antes de finalizar un PR, verifica con:

1. **TalkBack** (Android):
   ```
   Configuración > Accesibilidad > TalkBack > Activar
   ```

2. **VoiceOver** (iOS):
   ```
   Ajustes > Accesibilidad > VoiceOver > Activar
   ```

3. **Flutter DevTools**: 
   - Widget Inspector > Accessibility > Ver árbol semántico

## 🔄 Flujo de Trabajo con Agentes

### @SemantiDash - Jefe de Etiquetas y Estructura Inclusiva

Para revisiones especializadas de accesibilidad, delega a **@SemantiDash**:

```markdown
@SemantiDash por favor revisa la accesibilidad de:
- Widget: EventCard en lib/events_home_page.dart
- Verifica: Etiquetas semánticas, live regions, y compatibilidad con lectores de pantalla
```

### Checklist de Accesibilidad Pre-Merge

Antes de solicitar merge, verifica:

- [ ] Todos los elementos interactivos tienen `Semantics` con `button: true`
- [ ] Todos los elementos tienen `label` descriptivo
- [ ] Elementos complejos tienen `hint` explicativo
- [ ] Imágenes tienen `Semantics` con `image: true` y `label`
- [ ] Headers usan `header: true`
- [ ] Contenido dinámico usa `liveRegion: true`
- [ ] Se usa `ExcludeSemantics` para evitar redundancia
- [ ] Tests de accesibilidad incluidos
- [ ] Verificación manual con TalkBack/VoiceOver
- [ ] Contraste de color validado (si hay cambios visuales)

## 📚 Recursos Adicionales

### Documentación Oficial
- [Flutter Accessibility](https://docs.flutter.dev/development/accessibility-and-localization/accessibility)
- [WCAG 2.1 Guidelines](https://www.w3.org/WAI/WCAG21/quickref/)
- [Material Design Accessibility](https://material.io/design/usability/accessibility.html)

### Herramientas de Verificación
- **Accessibility Scanner** (Android): [Play Store](https://play.google.com/store/apps/details?id=com.google.android.apps.accessibility.auditor)
- **Color Contrast Analyzer**: [Paciello Group](https://www.tpgi.com/color-contrast-checker/)
- **Lighthouse** (Chrome DevTools): Auditoría automática de accesibilidad

### Archivos del Proyecto
- `ACCESSIBILITY_REPORT.md`: Informe detallado de mejoras implementadas
- `test/accessibility_test.dart`: Suite completa de tests de accesibilidad
- `.github/agents/SemantiDash.md`: Directivas del agente de accesibilidad

## ⚡ Principios Clave - Resumen Rápido

1. **Semántica sobre Redundancia**: Usa `Semantics` + `ExcludeSemantics`
2. **Etiquetado Completo**: `label` (qué es) + `value` (estado) + `hint` (acción)
3. **Anuncios Dinámicos**: `liveRegion: true` para cambios automáticos
4. **Jerarquía Clara**: `header`, `button`, `image` para identificar tipos
5. **Testing Obligatorio**: Test semánticos para cada widget nuevo
6. **Verificación Manual**: TalkBack/VoiceOver antes de merge

---

**Recuerda**: La accesibilidad no es opcional. Es un requisito fundamental para que todos los usuarios puedan utilizar la aplicación de manera efectiva e independiente.

