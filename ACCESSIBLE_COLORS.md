# Paleta de Colores Accesibles (WCAG AA)

Este documento define una paleta de colores que cumple con los estándares de contraste WCAG AA (4.5:1 para texto normal, 3:1 para texto grande).

## Texto sobre Fondo Blanco (#FFFFFF)

### ✅ Colores Aprobados para Texto Normal (≥4.5:1)

```dart
// Negros y grises oscuros
Color(0xFF000000)  // Negro - Contraste: 21:1
Color(0xFF212121)  // Gris muy oscuro - Contraste: 16.1:1
Color(0xFF424242)  // Gris oscuro - Contraste: 12.6:1
Color(0xFF616161)  // Gris medio-oscuro - Contraste: 7.2:1
Color(0xFF757575)  // Gris medio - Contraste: 4.9:1 ✅ (mínimo)

// Azules
Color(0xFF0D47A1)  // Azul oscuro - Contraste: 10.7:1
Color(0xFF1565C0)  // Azul - Contraste: 7.4:1
Color(0xFF1976D2)  // Azul medio - Contraste: 5.7:1
Color(0xFF1E88E5)  // Azul claro - Contraste: 4.5:1 ✅ (mínimo)

// Verdes
Color(0xFF1B5E20)  // Verde oscuro - Contraste: 9.8:1
Color(0xFF2E7D32)  // Verde - Contraste: 6.4:1
Color(0xFF388E3C)  // Verde medio - Contraste: 5.1:1

// Rojos (para errores)
Color(0xFF8B0000)  // Rojo oscuro - Contraste: 9.2:1
Color(0xFFB71C1C)  // Rojo - Contraste: 6.3:1
Color(0xFFC62828)  // Rojo medio - Contraste: 5.1:1

// Naranjas (para advertencias)
Color(0xFFE65100)  // Naranja oscuro - Contraste: 4.8:1
Color(0xFFEF6C00)  // Naranja - Contraste: 4.5:1 ✅ (mínimo)
```

### ❌ Colores NO Aprobados para Texto Normal (<4.5:1)

```dart
// Estos colores NO cumplen WCAG AA para texto normal
Color(0xFF9E9E9E)  // Gris claro - Contraste: 2.8:1 ❌
Color(0xFF42A5F5)  // Azul claro - Contraste: 3.1:1 ❌
Color(0xFFFFEB3B)  // Amarillo - Contraste: 1.9:1 ❌
Color(0xFFFF5722)  // Naranja brillante - Contraste: 3.4:1 ❌
```

## Texto sobre Fondo Oscuro (#212121)

### ✅ Colores Aprobados para Texto Normal (≥4.5:1)

```dart
// Blancos y grises claros
Color(0xFFFFFFFF)  // Blanco - Contraste: 16.1:1
Color(0xFFF5F5F5)  // Gris muy claro - Contraste: 15.3:1
Color(0xFFEEEEEE)  // Gris claro - Contraste: 14.1:1
Color(0xFFE0E0E0)  // Gris - Contraste: 12.6:1
Color(0xFFBDBDBD)  // Gris medio - Contraste: 9.7:1

// Colores brillantes
Color(0xFF64B5F6)  // Azul claro - Contraste: 6.8:1
Color(0xFF81C784)  // Verde claro - Contraste: 7.9:1
Color(0xFFFFB74D)  // Naranja claro - Contraste: 8.2:1
```

## Paleta Material Design 3 (Accesible)

```dart
// Paleta de color primario accesible
class AccessibleColors {
  // Colores principales
  static const Color primaryDark = Color(0xFF0D47A1);    // Azul oscuro
  static const Color primary = Color(0xFF1976D2);         // Azul
  static const Color primaryLight = Color(0xFF63A4FF);    // Azul claro
  
  // Colores secundarios
  static const Color secondaryDark = Color(0xFF1B5E20);  // Verde oscuro
  static const Color secondary = Color(0xFF388E3C);       // Verde
  static const Color secondaryLight = Color(0xFF6ABF69);  // Verde claro
  
  // Estados
  static const Color error = Color(0xFFB71C1C);          // Rojo oscuro
  static const Color warning = Color(0xFFE65100);         // Naranja oscuro
  static const Color success = Color(0xFF2E7D32);         // Verde oscuro
  static const Color info = Color(0xFF1565C0);            // Azul oscuro
  
  // Textos sobre fondo claro
  static const Color textPrimary = Color(0xFF212121);    // Casi negro
  static const Color textSecondary = Color(0xFF757575);  // Gris
  static const Color textDisabled = Color(0xFF9E9E9E);   // Gris claro
  
  // Textos sobre fondo oscuro
  static const Color textOnDark = Color(0xFFFFFFFF);     // Blanco
  static const Color textOnDarkSecondary = Color(0xFFBDBDBD); // Gris claro
  
  // Fondos
  static const Color background = Color(0xFFFFFFFF);      // Blanco
  static const Color surface = Color(0xFFF5F5F5);         // Gris muy claro
  static const Color backgroundDark = Color(0xFF212121);  // Casi negro
  static const Color surfaceDark = Color(0xFF424242);     // Gris oscuro
}
```

## Uso en Flutter Theme

```dart
ThemeData(
  brightness: Brightness.light,
  
  // Colores principales
  primaryColor: AccessibleColors.primary,
  colorScheme: ColorScheme.light(
    primary: AccessibleColors.primary,
    secondary: AccessibleColors.secondary,
    error: AccessibleColors.error,
    background: AccessibleColors.background,
    surface: AccessibleColors.surface,
  ),
  
  // Tipografía con colores accesibles
  textTheme: TextTheme(
    headlineLarge: TextStyle(
      fontSize: 32.0,
      fontWeight: FontWeight.bold,
      color: AccessibleColors.textPrimary,
    ),
    bodyLarge: TextStyle(
      fontSize: 16.0,
      color: AccessibleColors.textPrimary,
    ),
    bodyMedium: TextStyle(
      fontSize: 14.0,
      color: AccessibleColors.textSecondary,
    ),
  ),
  
  // Colores de iconos
  iconTheme: IconThemeData(
    color: AccessibleColors.textPrimary,
  ),
)
```

## Verificación de Contraste

### Herramientas Online

1. **WebAIM Contrast Checker**
   - URL: https://webaim.org/resources/contrastchecker/
   - Uso: Introduce el color de texto y fondo en formato hexadecimal

2. **Accessible Colors**
   - URL: https://accessible-colors.com/
   - Uso: Encuentra el color más cercano que cumpla con WCAG

3. **Coolors Contrast Checker**
   - URL: https://coolors.co/contrast-checker
   - Uso: Verifica contraste y genera paletas accesibles

### En Flutter DevTools

1. Abrir Flutter DevTools
2. Ir a "Inspector"
3. Seleccionar un widget con texto
4. Verificar el contraste en el panel de propiedades

### Comando para Análisis

```bash
# Analizar problemas de accesibilidad en el código
flutter analyze

# Ejecutar con warnings de accesibilidad
flutter run --verbose
```

## Ejemplos de Uso

### Texto Normal (Contraste 4.5:1)

```dart
// ✅ CORRECTO
Text(
  'Texto legible',
  style: TextStyle(
    fontSize: 16,
    color: AccessibleColors.textPrimary, // #212121 sobre blanco = 16.1:1
  ),
)

// ❌ INCORRECTO
Text(
  'Texto difícil de leer',
  style: TextStyle(
    fontSize: 16,
    color: Color(0xFF9E9E9E), // Solo 2.8:1
  ),
)
```

### Texto Grande (Contraste 3:1)

```dart
// ✅ CORRECTO - Texto grande puede tener menos contraste
Text(
  'Encabezado Grande',
  style: TextStyle(
    fontSize: 24, // 18pt o más
    fontWeight: FontWeight.bold,
    color: Color(0xFF1E88E5), // 4.5:1 - sobrepasa el mínimo de 3:1
  ),
)
```

### Botones con Contraste Adecuado

```dart
// ✅ CORRECTO
ElevatedButton(
  onPressed: () {},
  style: ElevatedButton.styleFrom(
    backgroundColor: AccessibleColors.primary, // #1976D2
    foregroundColor: Colors.white, // Contraste: 5.7:1
  ),
  child: Text('Acción'),
)

// ❌ INCORRECTO
ElevatedButton(
  onPressed: () {},
  style: ElevatedButton.styleFrom(
    backgroundColor: Color(0xFFFFEB3B), // Amarillo
    foregroundColor: Colors.white, // Contraste: 1.9:1 ❌
  ),
  child: Text('Acción'), // Texto ilegible
)
```

### Estados de Error Accesibles

```dart
// ✅ CORRECTO
TextField(
  decoration: InputDecoration(
    labelText: 'Email',
    errorText: hasError ? 'Email inválido' : null,
    errorStyle: TextStyle(
      color: AccessibleColors.error, // #B71C1C - 6.3:1
    ),
  ),
)
```

## Tabla de Referencia Rápida

| Color Hex | Nombre | Contraste sobre Blanco | Contraste sobre #212121 | Uso Recomendado |
|-----------|--------|------------------------|-------------------------|-----------------|
| #000000 | Negro | 21:1 ✅ | 1.3:1 ❌ | Texto sobre claro |
| #212121 | Gris muy oscuro | 16.1:1 ✅ | 1:1 ❌ | Texto principal sobre claro |
| #757575 | Gris medio | 4.9:1 ✅ | 3.3:1 ❌ | Texto secundario sobre claro |
| #1976D2 | Azul | 5.7:1 ✅ | 2.8:1 ❌ | Primario sobre claro |
| #B71C1C | Rojo oscuro | 6.3:1 ✅ | 2.6:1 ❌ | Errores sobre claro |
| #FFFFFF | Blanco | 1:1 ❌ | 16.1:1 ✅ | Texto sobre oscuro |
| #64B5F6 | Azul claro | 2.5:1 ❌ | 6.8:1 ✅ | Primario sobre oscuro |

## Referencias

- **WCAG 2.1 Guideline 1.4.3:** https://www.w3.org/WAI/WCAG21/Understanding/contrast-minimum.html
- **Material Design Color System:** https://material.io/design/color/the-color-system.html
- **WebAIM Contrast Checker:** https://webaim.org/resources/contrastchecker/

---

**Nota:** Siempre verifica el contraste con herramientas antes de usar colores en producción. Esta guía proporciona valores calculados, pero el contexto (antialiasing, tamaño de fuente, grosor) puede afectar la legibilidad percibida.
