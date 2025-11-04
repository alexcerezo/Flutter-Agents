# Checklist de Revisión de Accesibilidad

Este documento debe ser usado por **Semanti-Dash** al revisar Pull Requests y por desarrolladores antes de enviar código para revisión.

## ✅ Pre-requisitos

Antes de revisar la accesibilidad, verificar:

- [ ] El PR ha sido aprobado por **@Dash** (arquitectura y rendimiento)
- [ ] No hay comentarios críticos pendientes de **@Dash**
- [ ] El código compila sin errores
- [ ] Los tests funcionales pasan correctamente

## 📋 Checklist de Accesibilidad

### 1. Semántica y Etiquetado (WCAG 1.1.1, 4.1.2)

#### Elementos Interactivos
- [ ] Todos los botones tienen etiquetas semánticas claras
- [ ] Los iconos sin texto tienen `Semantics` con `label`
- [ ] Los `IconButton` tienen `tooltip` o `Semantics` explícito
- [ ] Los botones FAB tienen `Semantics` con descripción de acción
- [ ] Los elementos de lista tienen etiquetas descriptivas

#### Formularios
- [ ] Todos los campos de texto tienen labels asociados
- [ ] Los campos tienen hints contextuales útiles
- [ ] Los mensajes de error usan `Semantics` con `liveRegion: true`
- [ ] Los campos requeridos están claramente marcados
- [ ] Los validadores proporcionan mensajes claros

#### Imágenes y Multimedia
- [ ] Las imágenes informativas tienen texto alternativo
- [ ] Las imágenes decorativas usan `ExcludeSemantics`
- [ ] Los videos tienen subtítulos o transcripciones (si aplica)
- [ ] Los gráficos complejos tienen descripciones textuales

### 2. Contraste de Color (WCAG 1.4.3)

- [ ] Texto normal: contraste mínimo de 4.5:1
- [ ] Texto grande (18pt+): contraste mínimo de 3:1
- [ ] Los enlaces son distinguibles por algo más que solo el color
- [ ] Los estados de enfoque son claramente visibles
- [ ] Los iconos tienen contraste adecuado con el fondo

**Herramienta de verificación:** https://webaim.org/resources/contrastchecker/

### 3. Tamaño de Área de Pulsación (WCAG 2.5.5)

- [ ] Todos los elementos interactivos tienen al menos 48x48 píxeles
- [ ] Los botones pequeños tienen padding adecuado
- [ ] Los elementos en listas tienen altura mínima de 48 píxeles
- [ ] El spacing entre elementos interactivos es suficiente

### 4. Navegación y Enfoque (WCAG 2.4.3, 2.4.7)

#### Orden de Enfoque
- [ ] El orden de tabulación es lógico y coherente
- [ ] Los elementos se enfocan en orden visual (top-to-bottom, left-to-right)
- [ ] Se usa `OrdinalSortKey` si el orden natural no es adecuado
- [ ] Los diálogos y modales atrapan el enfoque apropiadamente

#### Gestión de Enfoque
- [ ] El enfoque se mueve correctamente entre campos de formulario
- [ ] Los `FocusNode` se disponen correctamente
- [ ] El enfoque vuelve al elemento apropiado al cerrar diálogos
- [ ] Los estados de enfoque son visualmente claros

### 5. Escalado de Texto (WCAG 1.4.4)

- [ ] El diseño soporta `textScaleFactor` hasta 2.0 sin romperse
- [ ] No se fuerza un `textScaleFactor` fijo
- [ ] Los tamaños de fuente se definen de forma relativa
- [ ] Los contenedores se ajustan al contenido escalado
- [ ] No hay texto truncado con escalado aumentado

### 6. Uso de Widgets Semánticos

#### Widgets Requeridos
- [ ] `Semantics` usado para elementos personalizados
- [ ] `ExcludeSemantics` para elementos decorativos
- [ ] `MergeSemantics` para agrupar información relacionada
- [ ] `header: true` para encabezados de sección

#### Propiedades Semánticas Correctas
- [ ] `button: true` para elementos clickeables
- [ ] `textField: true` para campos de entrada
- [ ] `toggled` para switches y checkboxes
- [ ] `enabled` refleja el estado real del elemento
- [ ] `liveRegion: true` para contenido dinámico importante

### 7. Diálogos y Modales (WCAG 2.4.3)

- [ ] Los diálogos usan `scopesRoute: true`
- [ ] El título del diálogo tiene `header: true`
- [ ] Los botones de acción tienen labels claros
- [ ] Se puede cerrar el diálogo con el botón de retroceso
- [ ] El enfoque vuelve al elemento que lo abrió

### 8. Estados y Feedback (WCAG 3.3.1, 3.3.3)

- [ ] Los estados de carga son anunciados
- [ ] Los cambios de estado importantes usan `liveRegion`
- [ ] Los errores tienen mensajes claros y descriptivos
- [ ] El éxito de acciones se confirma al usuario
- [ ] Los SnackBars tienen duración adecuada para ser leídos

### 9. Listas y Contenido Dinámico

- [ ] Los elementos de lista tienen índice contextual ("Elemento 1 de 10")
- [ ] Las acciones de swipe tienen alternativas semánticas
- [ ] Los pull-to-refresh tienen indicadores accesibles
- [ ] El contenido infinito tiene puntos de parada lógicos

### 10. Testing

#### Tests Automatizados
- [ ] Existen tests que verifican las etiquetas semánticas
- [ ] Los tests validan el tamaño mínimo de elementos interactivos
- [ ] Se prueban diferentes valores de `textScaleFactor`
- [ ] Los tests verifican el orden de enfoque

#### Testing Manual
- [ ] Probado con TalkBack (Android) o VoiceOver (iOS)
- [ ] La navegación con teclado funciona correctamente
- [ ] El contenido se lee en orden lógico
- [ ] Todas las funciones son accesibles sin mouse/touch

## 🚫 Errores Comunes a Evitar

### ❌ Anti-patrones de Accesibilidad

1. **Iconos sin etiqueta:**
   ```dart
   // MAL
   IconButton(
     icon: Icon(Icons.settings),
     onPressed: () {},
   )
   ```

2. **Forzar escala de texto:**
   ```dart
   // MAL
   Text(
     'Texto fijo',
     textScaleFactor: 1.0,
   )
   ```

3. **Áreas de pulsación pequeñas:**
   ```dart
   // MAL
   GestureDetector(
     onTap: () {},
     child: Icon(Icons.close, size: 16),
   )
   ```

4. **Contraste insuficiente:**
   ```dart
   // MAL
   Text(
     'Difícil de leer',
     style: TextStyle(color: Colors.grey[400]),
   )
   ```

5. **Elementos decorativos no excluidos:**
   ```dart
   // MAL - El ícono se leerá redundantemente
   ListTile(
     leading: Icon(Icons.star),
     title: Text('Favoritos'),
   )
   
   // BIEN
   ListTile(
     leading: ExcludeSemantics(child: Icon(Icons.star)),
     title: Text('Favoritos'),
   )
   ```

## 📝 Comentarios de Revisión

### Ejemplos de Comentarios Constructivos

#### Falta de Etiqueta Semántica
```
❌ **Accesibilidad:** Este IconButton no tiene etiqueta semántica.

**Referencia:** WCAG 1.1.1 (Alternativas de texto)

**Solución:**
```dart
Semantics(
  label: 'Abrir configuración',
  button: true,
  child: IconButton(
    icon: Icon(Icons.settings),
    onPressed: () => openSettings(),
  ),
)
```

#### Contraste Insuficiente
```
❌ **Accesibilidad:** El contraste de este texto es 3.2:1, por debajo del mínimo WCAG AA de 4.5:1.

**Referencia:** WCAG 1.4.3 (Contraste Mínimo)

**Solución:** Usar un color más oscuro, como `Colors.black87` en lugar de `Colors.grey`.
```

#### Área de Pulsación Pequeña
```
❌ **Accesibilidad:** Este botón tiene solo 32x32 píxeles, por debajo del mínimo recomendado de 48x48.

**Referencia:** WCAG 2.5.5 (Tamaño del Objetivo)

**Solución:**
```dart
Container(
  width: 48,
  height: 48,
  child: InkWell(
    onTap: () {},
    child: Center(child: Icon(Icons.add)),
  ),
)
```

### Escalación a @Dash

Si un cambio de accesibilidad tiene implicaciones arquitectónicas:

```
⚠️ **@Dash:** Este cambio de accesibilidad añade múltiples widgets Semantics que podrían impactar el rendimiento en listas largas. ¿Podrías revisar si el patrón de implementación es óptimo antes de aprobar?
```

## 🎯 Criterios de Aprobación

El PR solo puede ser aprobado por Semanti-Dash si:

1. ✅ Todos los elementos del checklist aplicables están verificados
2. ✅ No hay violaciones críticas de WCAG AA
3. ✅ Los tests de accesibilidad pasan
4. ✅ Se ha probado con tecnologías de asistencia (o se justifica por qué no)
5. ✅ La documentación de accesibilidad está actualizada (si aplica)

## 📚 Referencias

- WCAG 2.1: https://www.w3.org/WAI/WCAG21/quickref/
- Flutter Accessibility: https://docs.flutter.dev/development/accessibility-and-localization/accessibility
- Material Design Accessibility: https://material.io/design/usability/accessibility.html
- TalkBack: https://support.google.com/accessibility/android/answer/6283677
- VoiceOver: https://support.apple.com/guide/iphone/turn-on-and-practice-voiceover-iph3e2e415f

---

**Versión:** 1.0  
**Última actualización:** 2025-11-04  
**Mantenedor:** Semanti-Dash (Agente de Accesibilidad)
