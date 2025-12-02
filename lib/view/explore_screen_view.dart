import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:uc_event_hubb/viewmodel/event_viewmodel.dart';

class EventScreen extends StatelessWidget {
  const EventScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => EventViewModel()..loadEvents(),
      child: Scaffold(
        appBar: AppBar(title: const Text("Events")),
        body: Consumer<EventViewModel>(
          builder: (context, vm, child) {
            if (vm.isLoading) {
              return const Center(child: CircularProgressIndicator());
            }

            if (vm.errorMessage != null) {
              return Center(child: Text("Error: ${vm.errorMessage}"));
            }

            if (vm.events.isEmpty) {
              return const Center(child: Text("No events available"));
            }

            return ListView.builder(
              itemCount: vm.events.length,
              itemBuilder: (context, index) {
                final event = vm.events[index];

                return Card(
                  margin: const EdgeInsets.all(12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // IMAGE
                      ClipRRect(
                        borderRadius: const BorderRadius.vertical(
                          top: Radius.circular(12),
                        ),
                        child: event.image.isNotEmpty
                            ? Image.network(
                                event.image,
                                height: 180,
                                width: double.infinity,
                                fit: BoxFit.cover,
                              )
                            : Container(
                                height: 180,
                                color: Colors.grey.shade300,
                                alignment: Alignment.center,
                                child: const Icon(Icons.image, size: 50),
                              ),
                      ),

                      // TEXT
                      Padding(
                        padding: const EdgeInsets.all(12),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              event.title,
                              style: const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text("${event.location} • ${event.date}"),
                          ],
                        ),
                      ),
                    ],
                  ),
                );
              },
            );
          },
        ),
      ),
    );
  }
}
