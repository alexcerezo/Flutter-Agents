# Ejemplos de Código Accesible en Flutter

Este documento contiene ejemplos completos de componentes Flutter con accesibilidad optimizada.

## 1. Aplicación Principal (main.dart)

```dart
import 'package:flutter/material.dart';

void main() {
  runApp(const AccessibleFlutterApp());
}

class AccessibleFlutterApp extends StatelessWidget {
  const AccessibleFlutterApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'App Accesible',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        // Contraste de color optimizado para WCAG AA
        primarySwatch: Colors.blue,
        brightness: Brightness.light,
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.blue,
          brightness: Brightness.light,
        ),
        // Tamaño de fuente base que escala con las preferencias del sistema
        textTheme: const TextTheme(
          headlineLarge: TextStyle(
            fontSize: 32.0,
            fontWeight: FontWeight.bold,
            color: Colors.black87,
          ),
          headlineMedium: TextStyle(
            fontSize: 24.0,
            fontWeight: FontWeight.w600,
            color: Colors.black87,
          ),
          bodyLarge: TextStyle(
            fontSize: 16.0,
            color: Colors.black87,
          ),
          bodyMedium: TextStyle(
            fontSize: 14.0,
            color: Colors.black87,
          ),
        ),
        // Asegurar áreas de pulsación mínimas
        materialTapTargetSize: MaterialTapTargetSize.padded,
      ),
      home: const HomeScreen(),
    );
  }
}

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('App Accesible'),
        actions: [
          // Botón de configuración con semántica explícita
          Semantics(
            label: 'Configuración',
            hint: 'Abrir el menú de configuración de la aplicación',
            button: true,
            child: IconButton(
              icon: const Icon(Icons.settings),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const SettingsScreen(),
                  ),
                );
              },
            ),
          ),
        ],
      ),
      body: const AccessibleHomeContent(),
      floatingActionButton: Semantics(
        label: 'Agregar nuevo elemento',
        hint: 'Toca para crear un nuevo elemento',
        button: true,
        child: FloatingActionButton(
          onPressed: () {
            // Acción de agregar
          },
          child: const Icon(Icons.add),
        ),
      ),
    );
  }
}

class AccessibleHomeContent extends StatelessWidget {
  const AccessibleHomeContent({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Encabezado con semántica de header
          Semantics(
            header: true,
            child: Text(
              'Bienvenido',
              style: Theme.of(context).textTheme.headlineLarge,
            ),
          ),
          const SizedBox(height: 16),
          
          // Texto descriptivo
          const Text(
            'Esta aplicación demuestra las mejores prácticas de accesibilidad en Flutter.',
            style: TextStyle(fontSize: 16),
          ),
          const SizedBox(height: 24),
          
          // Lista de funcionalidades accesibles
          const AccessibleFeatureList(),
          
          const SizedBox(height: 24),
          
          // Formulario accesible de ejemplo
          const AccessibleFormExample(),
        ],
      ),
    );
  }
}

class AccessibleFeatureList extends StatelessWidget {
  const AccessibleFeatureList({super.key});

  @override
  Widget build(BuildContext context) {
    final features = [
      {
        'icon': Icons.check_circle,
        'title': 'Semántica Correcta',
        'description': 'Todos los elementos tienen etiquetas descriptivas',
      },
      {
        'icon': Icons.contrast,
        'title': 'Contraste Óptimo',
        'description': 'Cumple con WCAG AA (4.5:1 para texto normal)',
      },
      {
        'icon': Icons.touch_app,
        'title': 'Áreas de Pulsación',
        'description': 'Mínimo 48x48 píxeles para todos los botones',
      },
      {
        'icon': Icons.navigation,
        'title': 'Navegación Lógica',
        'description': 'Orden de enfoque coherente y predecible',
      },
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Semantics(
          header: true,
          child: Text(
            'Características de Accesibilidad',
            style: Theme.of(context).textTheme.headlineMedium,
          ),
        ),
        const SizedBox(height: 16),
        ...features.map((feature) {
          return Padding(
            padding: const EdgeInsets.only(bottom: 16.0),
            child: AccessibleFeatureCard(
              icon: feature['icon'] as IconData,
              title: feature['title'] as String,
              description: feature['description'] as String,
            ),
          );
        }).toList(),
      ],
    );
  }
}

class AccessibleFeatureCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String description;

  const AccessibleFeatureCard({
    super.key,
    required this.icon,
    required this.title,
    required this.description,
  });

  @override
  Widget build(BuildContext context) {
    return MergeSemantics(
      child: Card(
        elevation: 2,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            children: [
              // Ícono decorativo (excluido de semántica)
              ExcludeSemantics(
                child: Icon(
                  icon,
                  size: 40,
                  color: Theme.of(context).primaryColor,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      description,
                      style: const TextStyle(fontSize: 14),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class AccessibleFormExample extends StatefulWidget {
  const AccessibleFormExample({super.key});

  @override
  State<AccessibleFormExample> createState() => _AccessibleFormExampleState();
}

class _AccessibleFormExampleState extends State<AccessibleFormExample> {
  final _formKey = GlobalKey<FormState>();
  final _nameFocusNode = FocusNode();
  final _emailFocusNode = FocusNode();
  
  String? _nameError;
  String? _emailError;

  @override
  void dispose() {
    _nameFocusNode.dispose();
    _emailFocusNode.dispose();
    super.dispose();
  }

  void _submitForm() {
    setState(() {
      _nameError = null;
      _emailError = null;
    });

    if (_formKey.currentState!.validate()) {
      // Mostrar confirmación accesible
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Formulario enviado correctamente'),
          duration: Duration(seconds: 3),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Semantics(
            header: true,
            child: Text(
              'Formulario de Contacto',
              style: Theme.of(context).textTheme.headlineMedium,
            ),
          ),
          const SizedBox(height: 16),
          
          // Campo de nombre con semántica completa
          Semantics(
            label: 'Nombre completo',
            hint: 'Introduce tu nombre y apellidos',
            textField: true,
            child: TextFormField(
              focusNode: _nameFocusNode,
              decoration: const InputDecoration(
                labelText: 'Nombre',
                hintText: 'Juan Pérez',
                border: OutlineInputBorder(),
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  setState(() {
                    _nameError = 'El nombre es requerido';
                  });
                  return _nameError;
                }
                return null;
              },
              onFieldSubmitted: (_) {
                // Mover el enfoque al siguiente campo
                FocusScope.of(context).requestFocus(_emailFocusNode);
              },
            ),
          ),
          
          // Mensaje de error con live region
          if (_nameError != null)
            Padding(
              padding: const EdgeInsets.only(top: 8.0),
              child: Semantics(
                liveRegion: true,
                child: Text(
                  _nameError!,
                  style: const TextStyle(
                    color: Colors.red,
                    fontSize: 12,
                  ),
                ),
              ),
            ),
          
          const SizedBox(height: 16),
          
          // Campo de email
          Semantics(
            label: 'Correo electrónico',
            hint: 'Introduce tu dirección de email',
            textField: true,
            child: TextFormField(
              focusNode: _emailFocusNode,
              decoration: const InputDecoration(
                labelText: 'Email',
                hintText: 'ejemplo@correo.com',
                border: OutlineInputBorder(),
              ),
              keyboardType: TextInputType.emailAddress,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  setState(() {
                    _emailError = 'El email es requerido';
                  });
                  return _emailError;
                }
                if (!value.contains('@')) {
                  setState(() {
                    _emailError = 'Introduce un email válido';
                  });
                  return _emailError;
                }
                return null;
              },
            ),
          ),
          
          if (_emailError != null)
            Padding(
              padding: const EdgeInsets.only(top: 8.0),
              child: Semantics(
                liveRegion: true,
                child: Text(
                  _emailError!,
                  style: const TextStyle(
                    color: Colors.red,
                    fontSize: 12,
                  ),
                ),
              ),
            ),
          
          const SizedBox(height: 24),
          
          // Botón de envío con área de pulsación adecuada
          SizedBox(
            width: double.infinity,
            height: 48,
            child: ElevatedButton(
              onPressed: _submitForm,
              child: const Text(
                'Enviar',
                style: TextStyle(fontSize: 16),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Configuración'),
        leading: Semantics(
          label: 'Volver',
          hint: 'Regresar a la pantalla anterior',
          button: true,
          child: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () => Navigator.pop(context),
          ),
        ),
      ),
      body: ListView(
        children: [
          Semantics(
            label: 'Notificaciones',
            hint: 'Activar o desactivar notificaciones',
            toggled: true,
            child: SwitchListTile(
              title: const Text('Notificaciones'),
              subtitle: const Text('Recibir alertas de la aplicación'),
              value: true,
              onChanged: (bool value) {
                // Cambiar configuración
              },
            ),
          ),
          Semantics(
            label: 'Modo oscuro',
            hint: 'Cambiar entre tema claro y oscuro',
            toggled: false,
            child: SwitchListTile(
              title: const Text('Modo Oscuro'),
              subtitle: const Text('Usar tema oscuro en la aplicación'),
              value: false,
              onChanged: (bool value) {
                // Cambiar tema
              },
            ),
          ),
        ],
      ),
    );
  }
}
```

## 2. Widget de Botón Accesible Reutilizable

```dart
import 'package:flutter/material.dart';

/// Botón personalizado con accesibilidad integrada
/// 
/// Este widget garantiza:
/// - Área de pulsación mínima de 48x48 píxeles
/// - Etiqueta semántica clara
/// - Hint contextual opcional
/// - Soporte para estado deshabilitado
class AccessibleButton extends StatelessWidget {
  final String label;
  final String? hint;
  final VoidCallback? onPressed;
  final IconData? icon;
  final bool isPrimary;

  const AccessibleButton({
    super.key,
    required this.label,
    this.hint,
    required this.onPressed,
    this.icon,
    this.isPrimary = true,
  });

  @override
  Widget build(BuildContext context) {
    final isEnabled = onPressed != null;

    return Semantics(
      label: label,
      hint: hint,
      button: true,
      enabled: isEnabled,
      child: SizedBox(
        height: 48, // Altura mínima para accesibilidad
        child: icon != null
            ? ElevatedButton.icon(
                onPressed: onPressed,
                icon: ExcludeSemantics(
                  // El ícono es decorativo, la etiqueta ya describe el botón
                  child: Icon(icon),
                ),
                label: Text(label),
                style: _buttonStyle(context),
              )
            : ElevatedButton(
                onPressed: onPressed,
                style: _buttonStyle(context),
                child: Text(label),
              ),
      ),
    );
  }

  ButtonStyle _buttonStyle(BuildContext context) {
    return ElevatedButton.styleFrom(
      minimumSize: const Size(88, 48), // Tamaño mínimo accesible
      textStyle: const TextStyle(fontSize: 16),
    );
  }
}
```

## 3. Card Accesible con Acción

```dart
import 'package:flutter/material.dart';

/// Card interactivo con semántica completa
class AccessibleActionCard extends StatelessWidget {
  final String title;
  final String? subtitle;
  final IconData? icon;
  final VoidCallback onTap;
  final String actionLabel;

  const AccessibleActionCard({
    super.key,
    required this.title,
    this.subtitle,
    this.icon,
    required this.onTap,
    required this.actionLabel,
  });

  @override
  Widget build(BuildContext context) {
    return Semantics(
      label: '$title${subtitle != null ? ', $subtitle' : ''}',
      hint: actionLabel,
      button: true,
      child: Card(
        child: InkWell(
          onTap: onTap,
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              children: [
                if (icon != null)
                  ExcludeSemantics(
                    child: Icon(
                      icon,
                      size: 40,
                      color: Theme.of(context).primaryColor,
                    ),
                  ),
                if (icon != null) const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      if (subtitle != null) ...[
                        const SizedBox(height: 4),
                        Text(
                          subtitle!,
                          style: const TextStyle(fontSize: 14),
                        ),
                      ],
                    ],
                  ),
                ),
                ExcludeSemantics(
                  child: Icon(
                    Icons.arrow_forward_ios,
                    size: 16,
                    color: Colors.grey,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
```

## 4. Test de Accesibilidad

```dart
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('Accessibility Tests', () {
    testWidgets('Button has proper semantic label', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Semantics(
              label: 'Guardar cambios',
              button: true,
              child: ElevatedButton(
                onPressed: () {},
                child: const Icon(Icons.save),
              ),
            ),
          ),
        ),
      );

      // Verificar que el botón tiene la etiqueta semántica correcta
      final semantics = tester.getSemantics(find.byType(ElevatedButton));
      expect(semantics.label, equals('Guardar cambios'));
      expect(semantics.hasAction(SemanticsAction.tap), isTrue);
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
                  alignment: Alignment.center,
                  child: const Icon(Icons.add),
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

    testWidgets('Text scaling does not break layout', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Center(
              child: Text(
                'Test text',
                style: const TextStyle(fontSize: 16),
              ),
            ),
          ),
        ),
      );

      // Verificar con escala normal
      await tester.pumpAndSettle();
      expect(find.text('Test text'), findsOneWidget);

      // Verificar con escala aumentada (2x)
      await tester.pumpWidget(
        MaterialApp(
          home: MediaQuery(
            data: const MediaQueryData(textScaleFactor: 2.0),
            child: Scaffold(
              body: Center(
                child: Text(
                  'Test text',
                  style: const TextStyle(fontSize: 16),
                ),
              ),
            ),
          ),
        ),
      );

      await tester.pumpAndSettle();
      expect(find.text('Test text'), findsOneWidget);
    });

    testWidgets('Form fields have proper labels', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Semantics(
              label: 'Nombre completo',
              hint: 'Introduce tu nombre y apellidos',
              textField: true,
              child: const TextField(
                decoration: InputDecoration(labelText: 'Nombre'),
              ),
            ),
          ),
        ),
      );

      final semantics = tester.getSemantics(find.byType(TextField));
      expect(semantics.label, equals('Nombre completo'));
      expect(semantics.hint, equals('Introduce tu nombre y apellidos'));
      expect(semantics.hasFlag(SemanticsFlag.isTextField), isTrue);
    });
  });
}
```

## Uso de los Ejemplos

Para usar estos ejemplos en tu aplicación:

1. Copia el código de `main.dart` a tu archivo principal
2. Usa los widgets `AccessibleButton` y `AccessibleActionCard` como componentes reutilizables
3. Ejecuta los tests de accesibilidad para validar la implementación
4. Ajusta los colores y estilos según tu diseño, manteniendo el contraste WCAG AA

## Verificación

Para verificar la accesibilidad:

```bash
# Analizar el código
flutter analyze

# Ejecutar tests
flutter test

# Ejecutar en dispositivo con TalkBack/VoiceOver activado
flutter run
```
