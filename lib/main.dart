import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:intl/date_symbol_data_local.dart';

import 'events_home_page.dart';
import 'events_notifier.dart';

/// Main entry point of the Event Booking application.
///
/// This application follows Clean Architecture principles:
/// - Domain models (Event, Booking) are immutable
/// - Business logic is separated in EventsNotifier
/// - UI is decoupled from business logic
/// - State management uses ChangeNotifier for performance
///
/// Architecture decisions:
/// - ChangeNotifier for simplicity and performance
/// - Const constructors throughout for optimization
/// - Responsive design using MediaQuery and LayoutBuilder
/// - Pure build methods that don't perform side effects
Future<void> main() async {
  // Ensure bindings are initialized before calling async code
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize locale data for date formatting (used throughout the app)
  // We use Spanish (Spain) locale because the app formats dates as 'es_ES'.
  await initializeDateFormatting('es_ES');
  Intl.defaultLocale = 'es_ES';

  runApp(const EventBookingApp());
}

/// Root application widget
class EventBookingApp extends StatefulWidget {
  const EventBookingApp({super.key});

  @override
  State<EventBookingApp> createState() => _EventBookingAppState();
}

class _EventBookingAppState extends State<EventBookingApp> {
  late final EventsNotifier _eventsNotifier;

  @override
  void initState() {
    super.initState();
    _eventsNotifier = EventsNotifier();
  }

  @override
  void dispose() {
    _eventsNotifier.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Reserva de Eventos',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFFF65858), // Meetup red/pink accent
          brightness: Brightness.light,
        ),
        scaffoldBackgroundColor: const Color(0xFFFAFAFA), // Light gray background
        cardTheme: CardTheme(
          elevation: 1,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
          color: Colors.white,
        ),
        useMaterial3: true,
      ),
      home: EventsHomePage(eventsNotifier: _eventsNotifier),
    );
  }
}
