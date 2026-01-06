part of 'pages.dart';

class MyTicketScreen extends StatefulWidget {
  const MyTicketScreen({super.key});

  @override
  State<MyTicketScreen> createState() => _MyTicketScreenState();
}

class _MyTicketScreenState extends State<MyTicketScreen> {
  Future<List<Map<String, dynamic>>>? _futureTickets;

  Future<List<Map<String, dynamic>>> _fetchUserTickets() async {
    final auth = Provider.of<AuthViewModel>(context, listen: false);
    final uid = auth.userId;
    if (uid.isEmpty) return [];

    final snap = await FirebaseDatabase.instance.ref('userTickets/$uid').get();
    if (!snap.exists || snap.value == null) return [];

    final raw = snap.value;
    final List<Map<String, dynamic>> result = [];

    if (raw is Map) {
      raw.forEach((key, value) {
        if (value is Map) {
          final map = <String, dynamic>{};
          value.forEach((k, v) => map[k.toString()] = v);
          map['id'] = key.toString();
          result.add(map);
        }
      });
    }

    return result;
  }

  void _loadTickets() {
    setState(() {
      _futureTickets = _fetchUserTickets();
    });
  }

  @override
  void initState() {
    super.initState();
    _loadTickets();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        // This screen is part of MainNavigationScreen, so we don't want to pop
        // Instead, just return false to prevent navigation
        return false;
      },
      child: Scaffold(
        appBar: AppBar(
          title: const Text('My Tickets'),
          backgroundColor: const Color(0xFF2196F3),
          foregroundColor: Colors.white,
          elevation: 0,
          automaticallyImplyLeading: false, // Remove back button from AppBar
        ),
        body: FutureBuilder<List<Map<String, dynamic>>>(
          future: _futureTickets,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }
            if (snapshot.hasError) {
              return Center(child: Text('Error: ${snapshot.error}'));
            }

            final tickets = snapshot.data ?? [];
            if (tickets.isEmpty) {
              return const Center(child: Text('You have not purchased any tickets yet.'));
            }

            return ListView.separated(
              padding: const EdgeInsets.all(16),
              itemCount: tickets.length,
              separatorBuilder: (_, __) => const SizedBox(height: 16),
              itemBuilder: (context, index) {
                final t = tickets[index];
                final status = (t['status'] ?? 'Upcoming').toString();
                final statusColor = status.toLowerCase() == 'upcoming' ? Colors.orange : Colors.grey;
                return _buildTicketCard(
                  context,
                  id: t['id']?.toString() ?? '',
                  eventId: t['eventId']?.toString() ?? '',
                  eventName: t['eventName']?.toString() ?? '',
                  date: t['date']?.toString() ?? '',
                  time: t['time']?.toString() ?? '',
                  location: t['location']?.toString() ?? '',
                  ticketType: t['ticketType']?.toString() ?? '',
                  status: status,
                  statusColor: statusColor,
                );
              },
            );
          },
        ),
      ),
    );
  }

  Widget _buildTicketCard(
    BuildContext context, {
    required String id,
    required String eventId,
    required String eventName,
    required String date,
    required String time,
    required String location,
    required String ticketType,
    required String status,
    required Color statusColor,
  }) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(
                    eventName,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: statusColor.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    status,
                    style: TextStyle(
                      color: statusColor,
                      fontWeight: FontWeight.w600,
                      fontSize: 12,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                const Icon(Icons.calendar_today, size: 16, color: Colors.grey),
                const SizedBox(width: 8),
                Text(date, style: const TextStyle(color: Colors.grey)),
                const SizedBox(width: 16),
                const Icon(Icons.access_time, size: 16, color: Colors.grey),
                const SizedBox(width: 8),
                Text(time, style: const TextStyle(color: Colors.grey)),
              ],
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                const Icon(Icons.location_on, size: 16, color: Colors.grey),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    location,
                    style: const TextStyle(color: Colors.grey),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Ticket Type: $ticketType',
                  style: const TextStyle(
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF2196F3),
                  ),
                ),
                if (status == 'Upcoming')
                  ElevatedButton(
                    onPressed: () async {
                      // Navigate to ticket detail and refresh on return if deleted
                      final result = await Navigator.push<bool?>(
                        context,
                        MaterialPageRoute(
                          builder: (context) => TicketDetailView(ticketId: id, ticketData: {
                            'eventId': eventId,
                            'eventName': eventName,
                            'date': date,
                            'time': time,
                            'location': location,
                            'ticketType': ticketType,
                            'status': status,
                          }),
                        ),
                      );

                      if (result == true) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Ticket cancelled')),
                        );
                        _loadTickets();
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF2196F3),
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: const Text('View Ticket'),
                  ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}