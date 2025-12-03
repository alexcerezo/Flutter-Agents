# Event Booking Application - Architecture Documentation

## Overview
This is a Flutter event booking application built with Clean Architecture principles, focusing on performance, maintainability, and testability.

## Architecture Layers

### 1. Domain Layer (`lib/event.dart`, `lib/booking.dart`)
**Immutable domain models** with const constructors:
- `Event`: Represents an event with all details (title, date, location, capacity, etc.)
- `Booking`: Represents a ticket booking

**Key Features:**
- All fields are `final` for immutability
- `copyWith` method for creating updated copies
- Computed properties (`availableTickets`, `isSoldOut`)
- No dependencies on Flutter framework

### 2. State Management Layer (`lib/events_notifier.dart`)
**EventsNotifier** manages application state using `ChangeNotifier`:
- Loads and manages mock event data
- Handles booking logic with validation
- Notifies listeners of state changes
- Separation of business logic from UI

**Performance Strategy:**
- Single source of truth for event data
- Efficient state updates using `notifyListeners()`
- O(n) search for event by ID (acceptable for small datasets)

### 3. Presentation Layer

#### Home Page (`lib/events_home_page.dart`)
**Meetup-style sectioned layout** with horizontal and vertical scrolling:
- `EventsHomePage`: Main container widget with Meetup-inspired AppBar
- `_MeetupStyleLayout`: Sectioned layout with "Top picks" and "Upcoming events"
- `_SectionHeader`: Section headers with icons (header: true for accessibility)
- `_HorizontalEventList`: Horizontal scrolling carousel for featured events
- `_VerticalEventList`: Vertical list for upcoming events
- `_MeetupEventCard`: Individual event card component matching Meetup design

**Design Features (Meetup-style):**
- Light gray background (#FAFAFA) for page
- White cards with subtle shadows (elevation: 1)
- Red/pink accent color (#F65858) for primary actions and highlights
- Sectioned content with clear visual hierarchy
- Horizontal scrolling for featured content (like Meetup's "Top picks")
- Date badges overlaid on event images
- Attendee count display instead of just availability
- Rounded corners and modern card design

**Performance Optimizations:**
- `ListenableBuilder` for efficient rebuilds
- `const` constructors wherever possible
- `ListView.builder` for lazy loading in both horizontal and vertical lists
- Minimal widget rebuilds with strategic use of ExcludeSemantics

#### Event Detail Page (`lib/event_detail_page.dart`)
**Detailed event view with booking functionality:**
- `EventDetailPage`: Main container (StatefulWidget for local state)
- `_EventDetailAppBar`: Collapsible app bar with image
- `_EventDetailContent`: Event information and booking form
- `_TicketCounter`: Ticket quantity selector with ValueNotifier
- `_TotalPrice`: Dynamic price calculator

**State Management Strategy:**
- `ValueNotifier<int>` for ticket count (minimizes rebuilds)
- Only counter and price widgets rebuild on count change
- `ListenableBuilder` for event data updates
- Local state managed with StatefulWidget

**Booking Flow:**
1. User selects number of tickets using +/- buttons
2. Total price updates automatically
3. User confirms booking
4. Validation checks available tickets
5. Success/error dialog shown
6. State updated and user returned to home

## Performance Considerations

### Const Constructors
Used extensively throughout the codebase:
- All widget constructors use `const` where possible
- Reduces memory allocation and GC pressure
- Enables compile-time constant evaluation

### Minimal Rebuilds
Strategic use of Flutter's reactive primitives:
- `ChangeNotifier` for global state
- `ValueNotifier` for local state (ticket counter)
- `ValueListenableBuilder` for granular updates
- `ListenableBuilder` for efficient list updates

### Pure Build Methods
All `build()` methods:
- Have no side effects
- Always return the same output for the same input
- Don't perform async operations
- Don't modify state

## Testing Strategy

### Unit Tests (@Test-Agent)
Should cover:
- `Event` model validation and edge cases
- `Booking` model creation
- `EventsNotifier` business logic:
  - Event loading
  - Booking validation (capacity, negative numbers)
  - State updates
  - Edge cases (sold out, invalid event ID)

### Widget Tests (@Test-Agent)
Should cover:
- `EventsHomePage`:
  - Responsive grid behavior
  - Event card rendering
  - Navigation to detail page
- `EventDetailPage`:
  - Event information display
  - Ticket counter increment/decrement
  - Price calculation
  - Booking button state
  - Dialog display

### Integration Tests (@Test-Agent)
Should cover:
- Complete booking flow:
  1. App launch
  2. Event selection
  3. Ticket quantity selection
  4. Booking confirmation
  5. State verification
  6. Navigation back to home

## Accessibility Considerations (@Access-Agent)

### Semantic Labels Needed
- Event cards: Meaningful descriptions for screen readers
- Event images: Alt text describing event
- Booking buttons: Clear action labels
- Ticket counter: Announce count changes
- Dialogs: Proper focus management

### Focus Management
- Proper tab order through booking form
- Focus return after dialogs
- Keyboard navigation support

### Color Contrast
- All text meets WCAG AA standards
- Error states clearly visible
- Sold out badge has sufficient contrast

## DevOps Considerations (@DevOps-Agent)

### Build Process
- Standard Flutter web build: `flutter build web`
- Mobile builds: `flutter build apk/ios`
- No special build configuration required

### CI/CD Pipeline
Recommended stages:
1. **Lint**: `flutter analyze`
2. **Format Check**: `flutter format --set-exit-if-changed .`
3. **Unit Tests**: `flutter test`
4. **Widget Tests**: `flutter test`
5. **Build**: `flutter build web`
6. **Deploy**: Deploy to hosting (e.g., Firebase Hosting)

### Dependencies
- `flutter`: Framework
- `intl`: ^0.18.0 (date formatting)
- `cupertino_icons`: ^1.0.2 (iOS icons)

## Design System (Meetup-inspired)

### Color Palette
- **Primary Accent**: #F65858 (Meetup red/pink) - Used for buttons, icons, highlights
- **Background**: #FAFAFA (Light gray) - Main page background
- **Card Background**: #FFFFFF (White) - Card surfaces
- **Text Primary**: #212121 (Dark gray) - Main text and titles
- **Text Secondary**: #757575 (Medium gray) - Secondary text, captions
- **Border/Divider**: #E0E0E0 (Light gray) - Borders and subtle dividers
- **Error Container**: #FFF5F5 with #FFE0E0 border - Error states and availability info

### Typography Hierarchy
- **Page Title**: 22px, Bold, #212121
- **Card Title**: 16px, Bold, #212121
- **Section Header**: 22px, Bold, #212121
- **Date Badge**: 20px (number), 10px (day), Bold
- **Body Text**: 16px, Regular, #424242
- **Caption**: 12-14px, Regular, #757575

### Spacing & Layout
- **Card Padding**: 16px
- **Section Spacing**: 32px between sections
- **Card Margins**: 16px horizontal, 16px between cards
- **Card Border Radius**: 8px
- **Element Spacing**: 8-12px between related elements

### Component Styling
- **Cards**: White background, 1px elevation, 8px border radius
- **Date Badges**: White with shadow, positioned on top-left of images
- **Icons**: 22-28px, Meetup red color for primary actions
- **Buttons**: Filled with primary color, 16px vertical padding
- **Images**: AspectRatio 16:9 (horizontal) or 4:3 (vertical)

## Code Style

### Effective Dart Compliance
- Prefer single quotes for strings
- Use trailing commas for formatting
- Avoid using `!` (bang operator) unnecessarily
- Explicit types for public APIs
- Private members prefixed with `_`
- Comprehensive DartDoc comments for public APIs

### Naming Conventions
- Classes: `PascalCase`
- Methods/Variables: `camelCase`
- Constants: `lowerCamelCase`
- Private: prefix with `_`

## Mock Data
Six sample events included in Spanish:
1. Flutter Conference 2024 (Madrid)
2. Dart Workshop: Advanced Techniques (Barcelona)
3. Mobile Development Summit (Valencia)
4. UI/UX Design for Flutter (Sevilla)
5. Flutter for Web Masterclass (Bilbao)
6. State Management Deep Dive (Zaragoza)

All events have:
- Realistic dates (15-60 days in future)
- Spanish locations
- Varied capacity (100-800)
- Different booking percentages
- Placeholder images from picsum.photos

## Future Enhancements
Potential improvements (out of current scope):
- Real backend integration
- User authentication
- Payment processing
- Email confirmations
- Search and filter functionality
- Favorite events
- Calendar integration
- Push notifications
- Offline support
