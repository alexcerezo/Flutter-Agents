import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import 'event.dart';
import 'event_detail_page.dart';
import 'events_notifier.dart';

/// Home page displaying events in Meetup-style layout.
/// 
/// This widget uses a sectioned layout with horizontal scrolling cards
/// matching Meetup's visual design and UX patterns.
/// Follows Flutter best practices:
/// - Uses const constructors where possible for performance
/// - Separates UI from business logic
/// - Implements Meetup-style design with sections and horizontal scrolling
/// 
/// @Access-Agent: This page needs semantic labels and screen reader support
/// for the event cards and navigation actions.
class EventsHomePage extends StatelessWidget {
  const EventsHomePage({
    required this.eventsNotifier,
    super.key,
  });

  final EventsNotifier eventsNotifier;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFAFAFA),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: Semantics(
          header: true,
          label: 'Eventos',
          child: const ExcludeSemantics(
            child: Text(
              'Eventos',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: Color(0xFF212121),
              ),
            ),
          ),
        ),
      ),
      body: ListenableBuilder(
        listenable: eventsNotifier,
        builder: (context, _) {
          final events = eventsNotifier.events;

          if (events.isEmpty) {
            return Semantics(
              label: 'Cargando eventos',
              child: const Center(
                child: CircularProgressIndicator(),
              ),
            );
          }

          return _MeetupStyleLayout(
            events: events,
            onEventTap: (event) {
              Navigator.push(
                context,
                MaterialPageRoute<void>(
                  builder: (context) => EventDetailPage(
                    event: event,
                    eventsNotifier: eventsNotifier,
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}

/// Meetup-style layout with sections and horizontal scrolling
class _MeetupStyleLayout extends StatelessWidget {
  const _MeetupStyleLayout({
    required this.events,
    required this.onEventTap,
  });

  final List<Event> events;
  final void Function(Event) onEventTap;

  @override
  Widget build(BuildContext context) {
    // Split events into featured and upcoming
    final featuredEvents = events.take(3).toList();
    final upcomingEvents = events.skip(3).toList();

    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Featured section
          _SectionHeader(
            title: 'Top picks for you',
            icon: Icons.star_rounded,
          ),
          const SizedBox(height: 12),
          _HorizontalEventList(
            events: featuredEvents,
            onEventTap: onEventTap,
          ),
          const SizedBox(height: 32),
          
          // Upcoming section
          _SectionHeader(
            title: 'Upcoming events',
            icon: Icons.event,
          ),
          const SizedBox(height: 12),
          _VerticalEventList(
            events: upcomingEvents,
            onEventTap: onEventTap,
          ),
          const SizedBox(height: 24),
        ],
      ),
    );
  }
}

/// Section header widget matching Meetup style
class _SectionHeader extends StatelessWidget {
  const _SectionHeader({
    required this.title,
    required this.icon,
  });

  final String title;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Semantics(
        header: true,
        label: title,
        child: ExcludeSemantics(
          child: Row(
            children: [
              Icon(
                icon,
                size: 24,
                color: const Color(0xFFF65858),
              ),
              const SizedBox(width: 8),
              Text(
                title,
                style: const TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF212121),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// Horizontal scrolling list of events (Meetup-style carousel)
class _HorizontalEventList extends StatelessWidget {
  const _HorizontalEventList({
    required this.events,
    required this.onEventTap,
  });

  final List<Event> events;
  final void Function(Event) onEventTap;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 320,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        itemCount: events.length,
        itemBuilder: (context, index) {
          return Padding(
            padding: EdgeInsets.only(
              right: index < events.length - 1 ? 16 : 0,
            ),
            child: SizedBox(
              width: 280,
              child: _MeetupEventCard(
                event: events[index],
                onTap: () => onEventTap(events[index]),
              ),
            ),
          );
        },
      ),
    );
  }
}

/// Vertical list of events
class _VerticalEventList extends StatelessWidget {
  const _VerticalEventList({
    required this.events,
    required this.onEventTap,
  });

  final List<Event> events;
  final void Function(Event) onEventTap;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        children: events
            .map(
              (event) => Padding(
                padding: const EdgeInsets.only(bottom: 16),
                child: _MeetupEventCard(
                  event: event,
                  onTap: () => onEventTap(event),
                  isHorizontal: true,
                ),
              ),
            )
            .toList(),
      ),
    );
  }
}

/// Meetup-style event card with image, date badge, and attendee info
/// 
/// @Access-Agent: This card needs semantic labels for images and interactive
/// elements to support screen readers.
class _MeetupEventCard extends StatelessWidget {
  const _MeetupEventCard({
    required this.event,
    required this.onTap,
    this.isHorizontal = false,
  });

  final Event event;
  final VoidCallback onTap;
  final bool isHorizontal;

  @override
  Widget build(BuildContext context) {
    final dateFormat = DateFormat('dd MMM', 'es_ES');
    final dayFormat = DateFormat('EEE', 'es_ES');

    final availabilityText = event.isSoldOut 
      ? 'Agotado' 
      : '${event.bookedTickets} asistentes';
    
    final semanticValue = 'Fecha: ${dateFormat.format(event.date)}. '
        'Ubicación: ${event.location}. '
        'Precio: €${event.price.toStringAsFixed(2)}. '
        '$availabilityText.';

    return Semantics(
      button: true,
      label: 'Evento: ${event.title}',
      value: semanticValue,
      hint: 'Toca para ver detalles y reservar entradas',
      child: Card(
        clipBehavior: Clip.antiAlias,
        elevation: 1,
        shadowColor: Colors.black26,
        child: InkWell(
          onTap: onTap,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              // Event image with date badge
              Stack(
                children: [
                  AspectRatio(
                    aspectRatio: isHorizontal ? 16 / 9 : 4 / 3,
                    child: Container(
                      color: const Color(0xFFE0E0E0),
                      child: Semantics(
                        image: true,
                        label: 'Imagen del evento ${event.title}',
                        child: ExcludeSemantics(
                          child: Image.network(
                            event.imageUrl,
                            fit: BoxFit.cover,
                            errorBuilder: (context, error, stackTrace) {
                              return const Center(
                                child: Icon(
                                  Icons.event,
                                  size: 48,
                                  color: Color(0xFF757575),
                                ),
                              );
                            },
                          ),
                        ),
                      ),
                    ),
                  ),
                  // Date badge (Meetup-style)
                  Positioned(
                    top: 12,
                    left: 12,
                    child: ExcludeSemantics(
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 6,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(4),
                          boxShadow: const [
                            BoxShadow(
                              color: Colors.black26,
                              blurRadius: 4,
                              offset: Offset(0, 2),
                            ),
                          ],
                        ),
                        child: Column(
                          children: [
                            Text(
                              dayFormat.format(event.date).toUpperCase(),
                              style: const TextStyle(
                                fontSize: 10,
                                fontWeight: FontWeight.w600,
                                color: Color(0xFF757575),
                                letterSpacing: 0.5,
                              ),
                            ),
                            Text(
                              DateFormat('d').format(event.date),
                              style: const TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color: Color(0xFF212121),
                                height: 1.0,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              // Event details
              Padding(
                padding: const EdgeInsets.all(16),
                child: ExcludeSemantics(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Date and time
                      Text(
                        dateFormat.format(event.date).toUpperCase(),
                        style: const TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                          color: Color(0xFFF65858),
                          letterSpacing: 0.5,
                        ),
                      ),
                      const SizedBox(height: 8),
                      // Title
                      Text(
                        event.title,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF212121),
                          height: 1.3,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 12),
                      // Location
                      Row(
                        children: [
                          const Icon(
                            Icons.location_on_outlined,
                            size: 16,
                            color: Color(0xFF757575),
                          ),
                          const SizedBox(width: 4),
                          Expanded(
                            child: Text(
                              event.location,
                              style: const TextStyle(
                                fontSize: 14,
                                color: Color(0xFF757575),
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      // Attendees and price
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              const Icon(
                                Icons.people_outline,
                                size: 16,
                                color: Color(0xFF757575),
                              ),
                              const SizedBox(width: 4),
                              Text(
                                '${event.bookedTickets} asistentes',
                                style: const TextStyle(
                                  fontSize: 13,
                                  color: Color(0xFF757575),
                                ),
                              ),
                            ],
                          ),
                          Text(
                            event.price == 0 
                                ? 'Gratis' 
                                : '€${event.price.toStringAsFixed(2)}',
                            style: const TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF212121),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
