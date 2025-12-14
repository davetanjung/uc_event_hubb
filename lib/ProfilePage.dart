import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FD), // Background abu-abu muda
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // --- 1. HEADER SECTION ---
            Container(
              width: double.infinity,
              padding: const EdgeInsets.only(top: 60, bottom: 30, left: 24, right: 24),
              decoration: const BoxDecoration(
                color: Color(0xFF94D8FF), // Warna biru muda sesuai desain
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(30),
                  bottomRight: Radius.circular(30),
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Profile Image with Camera Icon
                      Stack(
                        children: [
                          Container(
                            width: 80,
                            height: 80,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(20), // Rounded Square
                              image: const DecorationImage(
                                image: NetworkImage("https://images.unsplash.com/photo-1599566150163-29194dcaad36?fit=crop&w=200&h=200"),
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                          Positioned(
                            top: -4,
                            right: -4,
                            child: Container(
                              padding: const EdgeInsets.all(6),
                              decoration: const BoxDecoration(
                                color: Color(0xFF5AB2FF), // Warna biru icon kamera
                                shape: BoxShape.circle,
                              ),
                              child: const Icon(Icons.camera_alt, color: Colors.white, size: 14),
                            ),
                          )
                        ],
                      ),
                      const SizedBox(width: 16),
                      // Name & Role
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.only(top: 8.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "Suryanto",
                                style: GoogleFonts.poppins(
                                  fontSize: 20,
                                  fontWeight: FontWeight.w700,
                                  color: Colors.black,
                                ),
                              ),
                              Text(
                                "President SU Informatics",
                                style: GoogleFonts.poppins(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w400,
                                  fontStyle: FontStyle.italic,
                                  color: Colors.black87,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),
                  
                  // Stats Row (Credit Points & Events Created)
                  Row(
                    children: [
                      _buildStatItem("Credit Points", "250"),
                      const SizedBox(width: 40), // Jarak antar stat
                      _buildStatItem("Events Created", "250"),
                    ],
                  )
                ],
              ),
            ),

            const SizedBox(height: 24),

            // --- 2. MY EVENT SECTION ---
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24.0),
              child: Text(
                "My Event",
                style: GoogleFonts.poppins(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
            ),
            const SizedBox(height: 16),
            
            // Horizontal List View My Event
            SizedBox(
              height: 230, // Tinggi card + text
              child: ListView(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                scrollDirection: Axis.horizontal,
                children: [
                  _buildEventCard(
                    title: "Open recruitment Night Jam UC 2024",
                    image: "https://images.unsplash.com/photo-1516280440614-6697288d5d38?fit=crop&w=400&h=250",
                    dateMonth: "Aug",
                    dateDay: "26",
                    tag: "Mandatory",
                    price: "Free",
                  ),
                  const SizedBox(width: 16),
                  _buildEventCard(
                    title: "Open recruitment Student Union...",
                    image: "https://images.unsplash.com/photo-1516280440614-6697288d5d38?fit=crop&w=400&h=250",
                    dateMonth: "Sep",
                    dateDay: "12",
                    tag: "Optional",
                    price: "Free",
                  ),
                ],
              ),
            ),

            const SizedBox(height: 10),

            // --- 3. BOOKMARK SECTION ---
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24.0),
              child: Text(
                "Bookmark",
                style: GoogleFonts.poppins(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
            ),
            const SizedBox(height: 16),

             // Horizontal List View Bookmark (Same cards for demo)
            SizedBox(
              height: 230,
              child: ListView(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                scrollDirection: Axis.horizontal,
                children: [
                  _buildEventCard(
                    title: "Open recruitment Night Jam UC 2024",
                    image: "https://images.unsplash.com/photo-1516280440614-6697288d5d38?fit=crop&w=400&h=250",
                    dateMonth: "Aug",
                    dateDay: "26",
                    tag: "Mandatory",
                    price: "Free",
                  ),
                  const SizedBox(width: 16),
                  _buildEventCard(
                    title: "Open recruitment Student Union...",
                    image: "https://images.unsplash.com/photo-1516280440614-6697288d5d38?fit=crop&w=400&h=250",
                    dateMonth: "Sep",
                    dateDay: "12",
                    tag: "Optional",
                    price: "Free",
                  ),
                ],
              ),
            ),

            const SizedBox(height: 20),

            // --- 4. ADD EVENT BUTTON ---
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24.0),
              child: SizedBox(
                width: double.infinity,
                height: 55,
                child: ElevatedButton(
                  onPressed: () {},
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF5BCBF5), // Cyan Blue
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    elevation: 0,
                  ),
                  child: Text(
                    "Add Event",
                    style: GoogleFonts.poppins(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ),
            
            const SizedBox(height: 40), // Bottom spacing
          ],
        ),
      ),
      
      // --- 5. BOTTOM NAVBAR (Static UI) ---
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Colors.white,
        selectedItemColor: const Color(0xFF5BCBF5), // Blue active
        unselectedItemColor: Colors.grey[400],
        currentIndex: 2, // Profile selected
        type: BottomNavigationBarType.fixed,
        showSelectedLabels: true,
        showUnselectedLabels: true,
        selectedLabelStyle: GoogleFonts.poppins(fontSize: 12, fontWeight: FontWeight.w500),
        unselectedLabelStyle: GoogleFonts.poppins(fontSize: 12),
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.confirmation_number_outlined),
            label: 'My Ticket',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.explore_outlined),
            label: 'Explore',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Profile',
          ),
        ],
      ),
    );
  }

  // Helper Widget: Stat Item (Credit Points, etc)
  Widget _buildStatItem(String label, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: GoogleFonts.poppins(
            fontSize: 12,
            color: Colors.black54,
            fontWeight: FontWeight.w500,
          ),
        ),
        Text(
          value,
          style: GoogleFonts.poppins(
            fontSize: 22, // Besar
            fontWeight: FontWeight.bold,
            color: Colors.black,
            height: 1.2,
          ),
        ),
      ],
    );
  }

  // Helper Widget: Event Card
  Widget _buildEventCard({
    required String title,
    required String image,
    required String dateMonth,
    required String dateDay,
    required String tag,
    required String price,
  }) {
    return Container(
      width: 260,
      decoration: BoxDecoration(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Image & Date Badge
          Stack(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(16),
                child: Image.network(
                  image,
                  height: 140,
                  width: 260,
                  fit: BoxFit.cover,
                ),
              ),
              Positioned(
                top: 12,
                left: 12,
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Column(
                    children: [
                      Text(
                        dateMonth,
                        style: GoogleFonts.poppins(
                          fontSize: 10,
                          fontWeight: FontWeight.w500,
                          color: Colors.black54,
                          height: 1.0,
                        ),
                      ),
                      Text(
                        dateDay,
                        style: GoogleFonts.poppins(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                          height: 1.0,
                        ),
                      ),
                    ],
                  ),
                ),
              )
            ],
          ),
          const SizedBox(height: 8),
          
          // Title
          Text(
            title,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: GoogleFonts.poppins(
              fontSize: 14,
              fontWeight: FontWeight.w500, // Medium bold
              color: Colors.black87,
            ),
          ),
          
          const SizedBox(height: 4),

          // Tags Row
          Row(
            children: [
              Text(
                tag,
                style: GoogleFonts.poppins(
                  fontSize: 13,
                  fontWeight: FontWeight.bold, // Bold untuk Mandatory/Optional
                  color: Colors.black,
                ),
              ),
              const SizedBox(width: 8),
              Text(
                price,
                style: GoogleFonts.poppins(
                  fontSize: 13,
                  fontWeight: FontWeight.w400, // Regular untuk Free
                  color: Colors.grey[600],
                ),
              ),
            ],
          )
        ],
      ),
    );
  }
}