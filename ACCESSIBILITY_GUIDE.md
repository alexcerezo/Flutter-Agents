# Guía de Accesibilidad Flutter - Semanti-Dash

## Introducción

Esta guía documenta las mejores prácticas de accesibilidad para aplicaciones Flutter, basadas en WCAG 2.1 y las directrices de Google y Apple para tecnologías de asistencia.

## 1. Principios Fundamentales de Accesibilidad

### 1.1 Semántica Correcta

**WCAG 1.1.1 - Alternativas de Texto**

Cada elemento interactivo o informativo debe tener información semántica adecuada:

```dart
// ❌ MAL - Ícono sin etiqueta
IconButton(
  icon: Icon(Icons.settings),
  onPressed: () => openSettings(),
)

// ✅ BIEN - Ícono con etiqueta semántica explícita
Semantics(
  label: 'Configuración',
  hint: 'Abrir el menú de configuración',
  button: true,
  child: IconButton(
    icon: Icon(Icons.settings),
    onPressed: () => openSettings(),
  ),
)

// ✅ MEJOR - Usar el tooltip que también proporciona semántica
IconButton(
  icon: Icon(Icons.settings),
  onPressed: () => openSettings(),
  tooltip: 'Configuración',
)
```

### 1.2 Contraste de Color

**WCAG 1.4.3 - Contraste Mínimo (Nivel AA)**

- Texto normal: relación de contraste mínima de 4.5:1
- Texto grande (18pt+): relación de contraste mínima de 3:1

```dart
// ❌ MAL - Contraste insuficiente
Text(
  'Texto difícil de leer',
  style: TextStyle(
    color: Color(0xFF757575), // Gris sobre blanco = 2.8:1
  ),
)

// ✅ BIEN - Contraste suficiente
Text(
  'Texto fácil de leer',
  style: TextStyle(
    color: Color(0xFF212121), // Negro sobre blanco = 16.1:1
  ),
)
```

**Herramientas para verificar contraste:**
- WebAIM Contrast Checker: https://webaim.org/resources/contrastchecker/
- Chrome DevTools: Audits > Accessibility

### 1.3 Tamaño de Área de Pulsación

**WCAG 2.5.5 - Tamaño del Objetivo (Nivel AAA)**

Área mínima recomendada: 48x48 píxeles

```dart
// ❌ MAL - Área muy pequeña
GestureDetector(
  onTap: () => doSomething(),
  child: Container(
    width: 20,
    height: 20,
    color: Colors.blue,
  ),
)

// ✅ BIEN - Área de pulsación adecuada
Material(
  child: InkWell(
    onTap: () => doSomething(),
    child: Container(
      width: 48,
      height: 48,
      alignment: Alignment.center,
      child: Icon(Icons.add, size: 24),
    ),
  ),
)
```

### 1.4 Escalado de Texto

**WCAG 1.4.4 - Redimensionamiento del Texto**

El diseño debe soportar el escalado de texto del sistema (hasta 200%):

```dart
// ✅ BIEN - Respetar las preferencias de accesibilidad del sistema
MaterialApp(
  builder: (context, child) {
    return MediaQuery(
      // No forzar textScaleFactor, usar el del sistema
      data: MediaQuery.of(context),
      child: child!,
    );
  },
  // ...
)

// ❌ MAL - Forzar el tamaño del texto
Text(
  'Texto fijo',
  textScaleFactor: 1.0, // No hacer esto
)
```

## 2. Widgets de Accesibilidad en Flutter

### 2.1 Widget Semantics

El widget `Semantics` es la herramienta principal para añadir información de accesibilidad:

```dart
Semantics(
  // Etiqueta descriptiva del elemento
  label: 'Botón de enviar',
  
  // Información adicional sobre qué hace el elemento
  hint: 'Envía el formulario de contacto',
  
  // Tipo de elemento
  button: true,
  
  // Estado del elemento
  enabled: isEnabled,
  
  // Valor actual (para controles con valores)
  value: currentValue.toString(),
  
  // Ocultar del árbol semántico
  excludeSemantics: false,
  
  child: YourWidget(),
)
```

### 2.2 ExcludeSemantics

Usar para eliminar información semántica redundante:

```dart
// Ejemplo: Un botón con ícono y texto
ElevatedButton.icon(
  icon: ExcludeSemantics(
    // El ícono es decorativo, el texto ya describe el botón
    child: Icon(Icons.save),
  ),
  label: Text('Guardar'),
  onPressed: () => save(),
)
```

### 2.3 MergeSemantics

Combinar múltiples nodos semánticos en uno solo:

```dart
MergeSemantics(
  child: Row(
    children: [
      Icon(Icons.star),
      Text('4.5'),
      Text('(123 reseñas)'),
    ],
  ),
)
// El lector de pantalla dirá: "4.5 estrellas, 123 reseñas"
```

## 3. Orden de Enfoque y Navegación

### 3.1 Orden de Enfoque Lógico

**WCAG 2.4.3 - Orden del Foco**

El orden de navegación debe seguir el flujo visual:

```dart
// ✅ BIEN - Orden lógico de lectura
Column(
  children: [
    Semantics(
      sortKey: OrdinalSortKey(1.0),
      child: TextField(
        decoration: InputDecoration(labelText: 'Nombre'),
      ),
    ),
    Semantics(
      sortKey: OrdinalSortKey(2.0),
      child: TextField(
        decoration: InputDecoration(labelText: 'Email'),
      ),
    ),
    Semantics(
      sortKey: OrdinalSortKey(3.0),
      child: ElevatedButton(
        onPressed: () => submit(),
        child: Text('Enviar'),
      ),
    ),
  ],
)
```

### 3.2 FocusNode para Control Explícito

```dart
class MyForm extends StatefulWidget {
  @override
  _MyFormState createState() => _MyFormState();
}

class _MyFormState extends State<MyForm> {
  final FocusNode _emailFocus = FocusNode();
  final FocusNode _passwordFocus = FocusNode();

  @override
  void dispose() {
    _emailFocus.dispose();
    _passwordFocus.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        TextField(
          decoration: InputDecoration(labelText: 'Email'),
          onSubmitted: (_) {
            // Al presionar enter, pasar al siguiente campo
            FocusScope.of(context).requestFocus(_passwordFocus);
          },
        ),
        TextField(
          focusNode: _passwordFocus,
          decoration: InputDecoration(labelText: 'Contraseña'),
          obscureText: true,
        ),
      ],
    );
  }
}
```

## 4. Casos de Uso Específicos

### 4.1 Listas Largas

```dart
ListView.builder(
  itemCount: items.length,
  itemBuilder: (context, index) {
    return Semantics(
      label: 'Elemento ${index + 1} de ${items.length}',
      customSemanticsActions: {
        CustomSemanticsAction(label: 'Eliminar'): () {
          deleteItem(items[index]);
        },
      },
      child: ListTile(
        title: Text(items[index].title),
        subtitle: Text(items[index].subtitle),
        onTap: () => openItem(items[index]),
      ),
    );
  },
)
```

### 4.2 Imágenes

**WCAG 1.1.1 - Alternativas de Texto**

```dart
// Imagen informativa
Semantics(
  label: 'Gato naranja durmiendo en un sofá gris',
  child: Image.network('https://example.com/cat.jpg'),
)

// Imagen decorativa
ExcludeSemantics(
  child: Image.asset('assets/decorative_pattern.png'),
)
```

### 4.3 Formularios

```dart
Column(
  children: [
    // Label asociado semánticamente con el campo
    Semantics(
      label: 'Nombre completo',
      hint: 'Introduce tu nombre y apellidos',
      textField: true,
      child: TextField(
        decoration: InputDecoration(
          labelText: 'Nombre',
          hintText: 'Juan Pérez',
        ),
      ),
    ),
    // Mensaje de error accesible
    if (hasError)
      Semantics(
        liveRegion: true, // Anunciar cambios inmediatamente
        child: Text(
          'Error: El nombre es requerido',
          style: TextStyle(color: Colors.red),
        ),
      ),
  ],
)
```

### 4.4 Modales y Diálogos

```dart
showDialog(
  context: context,
  builder: (context) {
    return Semantics(
      // Indicar que es un diálogo modal
      scopesRoute: true,
      explicitChildNodes: true,
      child: AlertDialog(
        title: Semantics(
          header: true,
          child: Text('Confirmar eliminación'),
        ),
        content: Text('¿Estás seguro de que deseas eliminar este elemento?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Cancelar'),
          ),
          TextButton(
            onPressed: () {
              deleteItem();
              Navigator.pop(context);
            },
            child: Text('Eliminar'),
          ),
        ],
      ),
    );
  },
);
```

## 5. Testing de Accesibilidad

### 5.1 Tests Automatizados

```dart
testWidgets('Button has proper semantic label', (WidgetTester tester) async {
  await tester.pumpWidget(
    MaterialApp(
      home: Scaffold(
        body: Semantics(
          label: 'Guardar cambios',
          button: true,
          child: ElevatedButton(
            onPressed: () {},
            child: Icon(Icons.save),
          ),
        ),
      ),
    ),
  );

  // Verificar que el botón tiene la etiqueta semántica correcta
  expect(
    tester.getSemantics(find.byType(ElevatedButton)),
    matchesSemantics(
      label: 'Guardar cambios',
      isButton: true,
    ),
  );
});

testWidgets('Minimum tap target size', (WidgetTester tester) async {
  await tester.pumpWidget(
    MaterialApp(
      home: Scaffold(
        body: Material(
          child: InkWell(
            onTap: () {},
            child: Container(
              width: 48,
              height: 48,
              child: Icon(Icons.add),
            ),
          ),
        ),
      ),
    ),
  );

  final Size size = tester.getSize(find.byType(InkWell));
  expect(size.width, greaterThanOrEqualTo(48.0));
  expect(size.height, greaterThanOrEqualTo(48.0));
});
```

### 5.2 Herramientas de Testing Manual

**En el Dispositivo/Emulador:**

1. **Android (TalkBack):**
   - Configuración > Accesibilidad > TalkBack
   - Navegar con gestos de deslizamiento
   - Verificar que las etiquetas sean claras y descriptivas

2. **iOS (VoiceOver):**
   - Ajustes > Accesibilidad > VoiceOver
   - Deslizar para navegar entre elementos
   - Verificar orden de lectura

**En DevTools:**
- Flutter Inspector > "Show Semantics"
- Visualizar el árbol semántico completo

## 6. Checklist de Accesibilidad

Antes de aprobar un PR, verificar:

- [ ] Todos los botones e íconos tienen etiquetas semánticas (`label`)
- [ ] Los elementos interactivos tienen al menos 48x48 píxeles
- [ ] El contraste de color cumple WCAG AA (4.5:1 para texto normal)
- [ ] El orden de enfoque es lógico y coherente
- [ ] Los formularios tienen labels y mensajes de error accesibles
- [ ] Las imágenes informativas tienen texto alternativo
- [ ] El diseño soporta escalado de texto (hasta 200%)
- [ ] No se fuerza `textScaleFactor`
- [ ] Los diálogos y modales están correctamente marcados semánticamente
- [ ] Se usan `ExcludeSemantics` para elementos decorativos redundantes
- [ ] Tests de widget verifican la información semántica

## 7. Recursos Adicionales

### Documentación Oficial
- Flutter Accessibility: https://docs.flutter.dev/development/accessibility-and-localization/accessibility
- WCAG 2.1: https://www.w3.org/WAI/WCAG21/quickref/
- Material Design Accessibility: https://material.io/design/usability/accessibility.html

### Herramientas
- Accessibility Scanner (Android): https://play.google.com/store/apps/details?id=com.google.android.apps.accessibility.auditor
- Contrast Checker: https://webaim.org/resources/contrastchecker/

### Testing
- TalkBack: Lector de pantalla de Android
- VoiceOver: Lector de pantalla de iOS
- Flutter DevTools: Inspector con vista semántica

## 8. Contacto y Soporte

Para dudas sobre accesibilidad en Flutter, consultar con **Semanti-Dash**, el experto en accesibilidad del equipo.

---

**Versión:** 1.0  
**Última actualización:** 2025-11-04  
**Mantenedor:** Semanti-Dash (Agente de Accesibilidad)
