part of 'pages.dart';

class WelcomingPageView extends StatefulWidget {
  const WelcomingPageView({super.key});

  @override
  State<WelcomingPageView> createState() => _WelcomingPageViewState();
}

class _WelcomingPageViewState extends State<WelcomingPageView> {
  int _currentNavIndex = 1;
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<EventViewModel>().loadEvents();
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFE3F2FD),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Header Section
                    Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Hello, Suryanto',
                            style: TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                              color: Colors.black,
                            ),
                          ),
                          const SizedBox(height: 8),
                          RichText(
                            text: const TextSpan(
                              children: [
                                TextSpan(
                                  text: 'There will be ',
                                  style: TextStyle(
                                    fontSize: 16,
                                    color: Color(0xFF2196F3),
                                  ),
                                ),
                                TextSpan(
                                  text: '70+ Events',
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                    color: Color(0xFF2196F3),
                                  ),
                                ),
                                TextSpan(
                                  text: '\naround this year',
                                  style: TextStyle(
                                    fontSize: 16,
                                    color: Color(0xFF2196F3),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),

                    // Search Bar
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: TextField(
                        controller: _searchController,
                        decoration: InputDecoration(
                          hintText: 'Search your events ...',
                          hintStyle: TextStyle(color: Colors.grey[400]),
                          prefixIcon: const Icon(
                            Icons.search,
                            color: Colors.grey,
                          ),
                          filled: true,
                          fillColor: Colors.white,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: BorderSide.none,
                          ),
                          contentPadding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 12,
                          ),
                        ),
                      ),
                    ),

                    const SizedBox(height: 24),

                    // Category Buttons
                    SizedBox(
                      height: 100,
                      child: ListView(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        scrollDirection: Axis.horizontal,
                        children: [
                          _CategoryButton(
                            icon: Icons.account_balance,
                            label: 'Pengmas',
                            onTap: () {},
                          ),
                          _CategoryButton(
                            icon: Icons.work_outline,
                            label: 'Career Center',
                            onTap: () {},
                          ),
                          _CategoryButton(
                            icon: Icons.language,
                            label: 'International',
                            onTap: () {},
                          ),
                          _CategoryButton(
                            icon: Icons.psychology,
                            label: 'Lainnya',
                            onTap: () {},
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 24),

                    // Upcoming Events Section (Reusable Widget)
                    Consumer<EventViewModel>(
                      builder: (context, viewModel, child) {
                        return UpcomingEventsSection(
                          events: viewModel.events,
                          isLoading: viewModel.isLoading,
                          errorMessage: viewModel.errorMessage,
                          onEventTap: (event) {
                            // Navigate to event detail page
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) =>
                                    EventDetailView(event: event),
                              ),
                            );
                          },
                        );
                      },
                    ),

                    const SizedBox(height: 24),

                    // Mandatory Events Section
                    const Padding(
                      padding: EdgeInsets.symmetric(horizontal: 16),
                      child: Text(
                        'Mandatory Event',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                      ),
                    ),

                    const SizedBox(height: 16),

                    // Mandatory Events List (using same widget pattern)
                    Consumer<EventViewModel>(
                      builder: (context, viewModel, child) {
                        final mandatoryEvents = viewModel.events
                            .where((event) => event.mandatory)
                            .toList();

                        return UpcomingEventsSection(
                          events: mandatoryEvents,
                          isLoading: viewModel.isLoading,
                          errorMessage: viewModel.errorMessage,
                          onEventTap: (event) {
                            // Navigate to event detail page
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) =>
                                    EventDetailView(event: event),
                              ),
                            );
                          },
                        );
                      },
                    ),

                    const SizedBox(height: 100), // Space for bottom nav
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
      // Bottom Navigation Bar (Reusable Widget)
      bottomNavigationBar: CustomBottomNavBar(
        currentIndex: _currentNavIndex,
        onTap: (index) {
          setState(() {
            _currentNavIndex = index;
          });

          // Handle navigation based on index
          switch (index) {
            case 0:
              // Navigate to My Ticket page
              print('Navigate to My Ticket');
              break;
            case 1:
              // Stay on Explore page
              print('Stay on Explore');
              break;
            case 2:
              // Navigate to Profile page
              print('Navigate to Profile');
              break;
          }
        },
      ),
    );
  }
}

class _CategoryButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;

  const _CategoryButton({
    Key? key,
    required this.icon,
    required this.label,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 100,
        margin: const EdgeInsets.only(right: 12),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 4,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 32, color: Colors.black87),
            const SizedBox(height: 8),
            Text(
              label,
              style: const TextStyle(fontSize: 12, color: Colors.black87),
              textAlign: TextAlign.center,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }
}
