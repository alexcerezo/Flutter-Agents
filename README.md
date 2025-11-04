# Flutter Test App - Accesibilidad Optimizada

Esta aplicación Flutter demuestra las mejores prácticas de accesibilidad siguiendo las pautas WCAG 2.1 y las directrices de accesibilidad de Flutter.

## Características de Accesibilidad Implementadas

### 1. Semántica Correcta
- Uso explícito del widget `Semantics` para todos los elementos interactivos
- Etiquetas descriptivas (`label`) para iconos y botones
- Hints contextuales para guiar a los usuarios

### 2. Contraste y Tipografía
- Contraste de color mínimo de 4.5:1 (WCAG AA)
- Soporte para escalado de texto del sistema
- Fuentes legibles y tamaños apropiados

### 3. Navegación y Enfoque
- Orden de enfoque lógico y coherente
- Áreas de pulsación mínimas de 48x48 píxeles
- Soporte completo para navegación por teclado

### 4. Tecnologías de Asistencia
- Compatible con TalkBack (Android)
- Compatible con VoiceOver (iOS)
- Acciones semánticas personalizadas donde sea necesario

## Estructura del Proyecto

```
lib/
  ├── main.dart                 # Punto de entrada con tema accesible
  ├── screens/
  │   └── home_screen.dart     # Pantalla principal con componentes accesibles
  └── widgets/
      └── accessible_button.dart # Botón personalizado con accesibilidad integrada
```

## Ejecutar la Aplicación

```bash
flutter pub get
flutter run
```

## Auditoría de Accesibilidad

Para verificar la accesibilidad:

```bash
flutter analyze
```

Usar el inspector de Flutter para revisar el árbol semántico:
- En el DevTools, navegar a "Flutter Inspector"
- Activar "Show Semantics"
