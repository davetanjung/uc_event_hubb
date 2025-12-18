part of 'pages.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final TextEditingController _searchController = TextEditingController();
  String _selectedCategory = '';

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Access AuthViewModel to get user data
    final authVM = Provider.of<AuthViewModel>(context);
    
    return ChangeNotifierProvider(
      create: (_) => EventViewModel()
        ..loadEvents()
        ..fetchMandatoryEvents(),
      child: Scaffold(
        backgroundColor: const Color(0xFFE8F4F8),
        body: SafeArea(
          child: Consumer<EventViewModel>(
            builder: (context, vm, child) {
              return SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Header - Now using actual user data
                      Text(
                        "Hello, ${authVM.userName}",
                        style: const TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                      ),
                      const SizedBox(height: 8),
                      const Text(
                        "There will be 70+ Events\naround this year",
                        style: TextStyle(
                          fontSize: 18,
                          color: Color(0xFF4DB8E8),
                          height: 1.3,
                        ),
                      ),
                      const SizedBox(height: 24),

                      // Search Bar
                      TextField(
                        controller: _searchController,
                        decoration: InputDecoration(
                          hintText: "Search your events ...",
                          hintStyle: TextStyle(color: Colors.grey.shade400),
                          prefixIcon: const Icon(Icons.search, color: Colors.grey),
                          filled: true,
                          fillColor: Colors.white,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(30),
                            borderSide: BorderSide.none,
                          ),
                          contentPadding: const EdgeInsets.symmetric(
                            horizontal: 20,
                            vertical: 16,
                          ),
                        ),
                        onChanged: (value) {
                          setState(() {});
                        },
                      ),
                      const SizedBox(height: 24),

                      // Category Filters
                      SizedBox(
                        height: 90,
                        child: ListView(
                          scrollDirection: Axis.horizontal,
                          children: [
                            _buildCategoryCard(
                              icon: Icons.account_balance,
                              label: "Pengmas",
                              category: "Pengmas",
                            ),
                            _buildCategoryCard(
                              icon: Icons.work,
                              label: "Career Center",
                              category: "Career Center",
                            ),
                            _buildCategoryCard(
                              icon: Icons.public,
                              label: "International",
                              category: "International",
                            ),
                            _buildCategoryCard(
                              icon: Icons.favorite,
                              label: "Lainnya",
                              category: "Lainnya",
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 24),

                      // Upcoming Events Section
                      const Text(
                        "Upcoming Events",
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                      ),
                      const SizedBox(height: 16),

                      if (vm.isLoading)
                        const Center(child: CircularProgressIndicator())
                      else if (vm.errorMessage != null)
                        Center(child: Text("Error: ${vm.errorMessage}"))
                      else if (_getFilteredEvents(vm.events).isEmpty)
                        const Center(child: Text("No upcoming events"))
                      else
                        SizedBox(
                          height: 220,
                          child: ListView.builder(
                            scrollDirection: Axis.horizontal,
                            itemCount: _getFilteredEvents(vm.events).length,
                            itemBuilder: (context, index) {
                              final event = _getFilteredEvents(vm.events)[index];
                              return _buildEventCard(event);
                            },
                          ),
                        ),
                      const SizedBox(height: 24),

                      // Mandatory Events Section
                      const Text(
                        "Mandatory Event",
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                      ),
                      const SizedBox(height: 16),

                      if (vm.isLoading)
                        const Center(child: CircularProgressIndicator())
                      else if (vm.mandatoryEvents.isEmpty)
                        const Center(child: Text("No mandatory events"))
                      else
                        ListView.builder(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemCount: vm.mandatoryEvents.length,
                          itemBuilder: (context, index) {
                            final event = vm.mandatoryEvents[index];
                            return _buildEventCard(event, isMandatory: true);
                          },
                        ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }

  Widget _buildCategoryCard({
    required IconData icon,
    required String label,
    required String category,
  }) {
    final isSelected = _selectedCategory == category;
    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedCategory = isSelected ? '' : category;
        });
      },
      child: Container(
        width: 100,
        margin: const EdgeInsets.only(right: 12),
        decoration: BoxDecoration(
          color: isSelected ? const Color(0xFF4DB8E8) : Colors.white,
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
            Icon(
              icon,
              size: 32,
              color: isSelected ? Colors.white : Colors.black87,
            ),
            const SizedBox(height: 8),
            Text(
              label,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 12,
                color: isSelected ? Colors.white : Colors.black87,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEventCard(Event event, {bool isMandatory = false}) {
    final startDate = DateTime.tryParse(event.startDate);
    final month = startDate != null
        ? ['', 'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'][startDate.month]
        : 'Aug';
    final day = startDate?.day.toString() ?? '26';

    return Container(
      width: isMandatory ? double.infinity : 200,
      margin: EdgeInsets.only(
        right: isMandatory ? 0 : 12,
        bottom: isMandatory ? 12 : 0,
      ),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Image with Date Badge
          Stack(
            children: [
              ClipRRect(
                borderRadius: const BorderRadius.vertical(
                  top: Radius.circular(12),
                ),
                child: event.image.isNotEmpty
                    ? Image.network(
                        event.image,
                        height: 120,
                        width: double.infinity,
                        fit: BoxFit.cover,
                      )
                    : Container(
                        height: 120,
                        color: Colors.grey.shade300,
                        alignment: Alignment.center,
                        child: const Icon(Icons.image, size: 40),
                      ),
              ),
              Positioned(
                top: 8,
                left: 8,
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 8,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Column(
                    children: [
                      Text(
                        month,
                        style: const TextStyle(
                          fontSize: 10,
                          fontWeight: FontWeight.w600,
                          color: Colors.black54,
                        ),
                      ),
                      Text(
                        day,
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),

          // Event Details
          Padding(
            padding: const EdgeInsets.all(12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  event.title,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: Colors.black87,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: event.mandatory
                            ? Colors.black
                            : Colors.grey.shade200,
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Text(
                        event.mandatory ? "Mandatory" : "Optional",
                        style: TextStyle(
                          fontSize: 10,
                          fontWeight: FontWeight.w600,
                          color: event.mandatory
                              ? Colors.white
                              : Colors.black54,
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.grey.shade200,
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Text(
                        event.price == 0 ? "Free" : "Rp ${event.price}",
                        style: const TextStyle(
                          fontSize: 10,
                          fontWeight: FontWeight.w600,
                          color: Colors.black54,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  List<Event> _getFilteredEvents(List<Event> events) {
    var filtered = events;

    // Filter by search
    if (_searchController.text.isNotEmpty) {
      filtered = filtered.where((event) {
        return event.title
            .toLowerCase()
            .contains(_searchController.text.toLowerCase());
      }).toList();
    }

    // Filter by category
    if (_selectedCategory.isNotEmpty) {
      filtered = filtered.where((event) {
        return event.category == _selectedCategory;
      }).toList();
    }

    return filtered;
  }
}