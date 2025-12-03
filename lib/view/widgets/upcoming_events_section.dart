import 'package:flutter/material.dart';
import 'package:uc_event_hubb/model/event.dart';
import 'package:uc_event_hubb/view/widgets/event_card_widget.dart';

class UpcomingEventsSection extends StatelessWidget {
  final List<Event> events;
  final bool isLoading;
  final String? errorMessage;
  final Function(Event)? onEventTap;

  const UpcomingEventsSection({
    super.key,
    required this.events,
    this.isLoading = false,
    this.errorMessage,
    this.onEventTap,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 16),
          child: Text(
            'Upcoming Events',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
          ),
        ),
        const SizedBox(height: 16),
        _buildContent(),
      ],
    );
  }

  Widget _buildContent() {
    if (isLoading) {
      return const SizedBox(
        height: 200,
        child: Center(
          child: CircularProgressIndicator(),
        ),
      );
    }

    if (errorMessage != null) {
      return SizedBox(
        height: 200,
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.error_outline, size: 48, color: Colors.red),
              const SizedBox(height: 8),
              Text(
                'Error: $errorMessage',
                style: const TextStyle(color: Colors.red),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      );
    }

    if (events.isEmpty) {
      return const SizedBox(
        height: 200,
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.event_busy, size: 48, color: Colors.grey),
              SizedBox(height: 8),
              Text(
                'No upcoming events',
                style: TextStyle(color: Colors.grey),
              ),
            ],
          ),
        ),
      );
    }

    return SizedBox(
      height: 220,
      child: ListView.builder(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        scrollDirection: Axis.horizontal,
        itemCount: events.length,
        itemBuilder: (context, index) {
          return EventCard(
            event: events[index],
            onTap: onEventTap != null ? () => onEventTap!(events[index]) : null,
          );
        },
      ),
    );
  }
}