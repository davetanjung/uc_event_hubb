part of 'pages.dart';

class MyTicketScreen extends StatelessWidget {
  const MyTicketScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('My Tickets'),
        backgroundColor: const Color(0xFF2196F3),
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          _buildTicketCard(
            context,
            eventName: 'Tech Conference 2024',
            date: 'Dec 25, 2024',
            time: '09:00 AM',
            location: 'Jakarta Convention Center',
            ticketType: 'VIP',
            status: 'Upcoming',
            statusColor: Colors.orange,
          ),
          const SizedBox(height: 16),
          _buildTicketCard(
            context,
            eventName: 'Music Festival',
            date: 'Dec 30, 2024',
            time: '06:00 PM',
            location: 'Gelora Bung Karno Stadium',
            ticketType: 'General',
            status: 'Upcoming',
            statusColor: Colors.orange,
          ),
          const SizedBox(height: 16),
          _buildTicketCard(
            context,
            eventName: 'Art Exhibition',
            date: 'Dec 10, 2024',
            time: '10:00 AM',
            location: 'National Gallery',
            ticketType: 'Regular',
            status: 'Completed',
            statusColor: Colors.grey,
          ),
        ],
      ),
    );
  }

  Widget _buildTicketCard(
    BuildContext context, {
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
                    onPressed: () {
                      // Show ticket details
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('View Ticket Details')),
                      );
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