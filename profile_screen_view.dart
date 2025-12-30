part of 'pages.dart';

class ProfileScreenView extends StatefulWidget {
  const ProfileScreenView({super.key});

  @override
  State<ProfileScreenView> createState() => _ProfileScreenViewState();
}

class _ProfileScreenViewState extends State<ProfileScreenView> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<EventViewModel>(context, listen: false).loadEvents();
    });
  }

  @override
  Widget build(BuildContext context) {
    final authVM = Provider.of<AuthViewModel>(context);
    final eventVM = Provider.of<EventViewModel>(context);
    final user = authVM.currentUser;

    if (user == null) {
      return const Scaffold(
        body: Center(child: Text("Silakan login terlebih dahulu.")),
      );
    }

    final myEvents = eventVM.events.where((event) {
      return event.participantsList.contains(user.id);
    }).toList();

    return Scaffold(
      appBar: AppBar(
        title: const Text("Profil Saya"),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.logout, color: Colors.red),
            tooltip: 'Logout',
            onPressed: () async {
              await authVM.logout();
            },
          )
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(height: 24),
            CircleAvatar(
              radius: 50,
              backgroundColor: Colors.blueAccent,
              child: Text(
                user.fullName.isNotEmpty ? user.fullName[0].toUpperCase() : "U",
                style: const TextStyle(
                  fontSize: 40, 
                  color: Colors.white, 
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const SizedBox(height: 16),
            Text(
              user.fullName,
              style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            Text(
              user.email,
              style: const TextStyle(color: Colors.grey, fontSize: 14),
            ),
            const SizedBox(height: 8),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: Colors.blue[50],
                borderRadius: BorderRadius.circular(20),
              ),
              child: Text(
                user.organizationTitle.isNotEmpty ? user.organizationTitle : "Member",
                style: const TextStyle(color: Colors.blue, fontWeight: FontWeight.w600),
              ),
            ),
            const SizedBox(height: 24),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  _buildStatItem("Credit Points", user.creditPoints.toString()),
                  Container(height: 40, width: 1, color: Colors.grey[300]),
                  _buildStatItem("Event Diikuti", myEvents.length.toString()),
                ],
              ),
            ),
            const SizedBox(height: 32),
            const Divider(thickness: 4, color: Color(0xFFF5F5F5)),
            const SizedBox(height: 16),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  "Riwayat Event",
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                ),
              ),
            ),
            const SizedBox(height: 16),
            myEvents.isEmpty
                ? const Padding(
                    padding: EdgeInsets.only(top: 40),
                    child: Center(
                      child: Column(
                        children: [
                          Icon(Icons.event_busy, size: 60, color: Colors.grey),
                          SizedBox(height: 16),
                          Text("Belum ada event yang diikuti", style: TextStyle(color: Colors.grey)),
                        ],
                      ),
                    ),
                  )
                : ListView.separated(
                    physics: const NeverScrollableScrollPhysics(),
                    shrinkWrap: true,
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    itemCount: myEvents.length,
                    separatorBuilder: (context, index) => const SizedBox(height: 16),
                    itemBuilder: (context, index) {
                      final event = myEvents[index];
                      return Center(
                        child: SizedBox(
                          child: EventCard(
                            event: event,
                            onTap: () {},
                          ),
                        ),
                      );
                    },
                  ),
            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }

  Widget _buildStatItem(String label, String value) {
    return Column(
      children: [
        Text(
          value,
          style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: const TextStyle(color: Colors.grey, fontSize: 12),
        ),
      ],
    );
  }
}