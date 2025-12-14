import 'dart:math'; // Import library untuk Random
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

// --- MODEL DATA ---
class Attendee {
  final String name;
  final String imageUrl;

  Attendee({required this.name, required this.imageUrl});
}

class EventModel {
  final String title;
  final String subtitle;
  final String time;
  final String location;
  final String building;
  final String status; // 'Going', 'Done'
  final List<Attendee> attendees;
  final Gradient cardGradient;

  EventModel({
    required this.title,
    required this.subtitle,
    required this.time,
    required this.location,
    required this.building,
    required this.status,
    required this.attendees,
    required this.cardGradient,
  });
}

// --- UI PAGE ---
class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  // Menggunakan Map untuk menyimpan event berdasarkan index tanggal (0 = Tgl 1, dst)
  Map<int, List<EventModel>> dailyEvents = {};
  int selectedDateIndex = 0; // Default pilih tanggal 1

  // Resource Dummy Data
  final List<String> _dummyImages = [
    "https://images.unsplash.com/photo-1535713875002-d1d0cf377fde?fit=crop&w=100&h=100",
    "https://images.unsplash.com/photo-1494790108377-be9c29b29330?fit=crop&w=100&h=100",
    "https://images.unsplash.com/photo-1599566150163-29194dcaad36?fit=crop&w=100&h=100",
    "https://images.unsplash.com/photo-1527980965255-d3b416303d12?fit=crop&w=100&h=100",
    "https://images.unsplash.com/photo-1507003211169-0a1dd7228f2d?fit=crop&w=100&h=100",
  ];

  final List<String> _names = ["Bapak Rudy", "Ibu Rosalinda", "Pak Ahmad", "Bu Siti", "Bu Priscill", "Kak Budi"];

  @override
  void initState() {
    super.initState();
    _generateDummyDataForDays1to10();
  }

  // Logic Generate Random Data
  void _generateDummyDataForDays1to10() {
    final random = Random();

    // Loop untuk mengisi data tanggal 1 (index 0) sampai 10 (index 9)
    for (int i = 0; i < 10; i++) {
      int eventCount = random.nextInt(3) + 2; // Generate 2 sampai 4 event per hari
      List<EventModel> events = [];

      for (int j = 0; j < eventCount; j++) {
        // Randomly pick style (RABES UC style or RABES LD style)
        bool isStyleUC = random.nextBool();

        events.add(EventModel(
          title: isStyleUC ? "RABES UC" : "RABES LD",
          subtitle: "101",
          time: "${8 + (j * 3)}:00", // Jam berurutan: 08:00, 11:00, dst
          location: isStyleUC ? "Lantai 7" : "Lantai 2 Nomor ${random.nextInt(20) + 1}",
          building: isStyleUC ? "Universitas Ciputra" : "Apartemen Denver Surabaya",
          status: j == 0 ? "Done" : "Going", // Event pertama Done, sisanya Going
          attendees: List.generate(random.nextInt(4) + 1, (index) {
            return Attendee(
              name: _names[random.nextInt(_names.length)],
              imageUrl: _dummyImages[random.nextInt(_dummyImages.length)],
            );
          }),
          cardGradient: isStyleUC
              ? const LinearGradient(
                  colors: [Color(0xFF4facfe), Color(0xFF00f2fe)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                )
              : const LinearGradient(
                  colors: [Color(0xFFFB3E96), Color(0xFFAB6AFB), Color(0xFF5DA7F8)],
                  begin: Alignment.centerLeft,
                  end: Alignment.centerRight,
                ),
        ));
      }
      dailyEvents[i] = events;
    }
  }

  @override
  Widget build(BuildContext context) {
    // Ambil event untuk tanggal yang dipilih, jika null (tgl > 10) return list kosong
    List<EventModel> currentEvents = dailyEvents[selectedDateIndex] ?? [];

    return Scaffold(
      body: CustomScrollView(
        slivers: [
          // 1. Sticky Header
          SliverAppBar(
            pinned: true,
            floating: false,
            expandedHeight: 300,
            backgroundColor: Colors.transparent,
            elevation: 0,
            flexibleSpace: FlexibleSpaceBar(
              background: ClipRRect(
                borderRadius: const BorderRadius.only(
                  bottomLeft: Radius.circular(30),
                  bottomRight: Radius.circular(30),
                ),
                child: Container(
                  decoration: const BoxDecoration(
                    gradient: LinearGradient(
                      colors: [Color(0xFF0B466F), Color(0xFF166D9F)],
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                    ),
                  ),
                  child: SafeArea(
                    bottom: false,
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(24, 0, 24, 0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 20.0),
                            child: Column(
                              children: [
                                SizedBox(
                                  width: double.infinity,
                                  child: RichText(
                                    textAlign: TextAlign.center,
                                    text: TextSpan(
                                      style: GoogleFonts.poppins(color: Colors.white, fontSize: 18),
                                      children: [
                                        const TextSpan(text: "Welcome Back, "),
                                        TextSpan(
                                          text: "Suryanto.",
                                          style: GoogleFonts.poppins(fontWeight: FontWeight.bold),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  "NIM: 0706012310004",
                                  textAlign: TextAlign.center,
                                  style: GoogleFonts.poppins(
                                    color: Colors.white70, fontSize: 14, fontWeight: FontWeight.w500
                                  ),
                                ),
                              ],
                            ),
                          ),
                          
                          // Membership Card
                          Container(
                            margin: const EdgeInsets.only(bottom: 30, top: 10),
                            padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 20),
                            decoration: BoxDecoration(
                              color: const Color(0xFFF9F9F9),
                              borderRadius: BorderRadius.circular(16),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.1),
                                  blurRadius: 10,
                                  offset: const Offset(0, 5),
                                )
                              ],
                            ),
                            child: IntrinsicHeight(
                              child: Row(
                                children: [
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text("Nama Akun", style: GoogleFonts.poppins(fontSize: 11, color: Colors.grey[600])),
                                        Text("Suryanto Hendrawan", style: GoogleFonts.poppins(fontSize: 13, fontWeight: FontWeight.bold, color: Colors.black87)),
                                      ],
                                    ),
                                  ),
                                  const VerticalDivider(thickness: 1, color: Colors.grey),
                                  Expanded(
                                    child: Padding(
                                      padding: const EdgeInsets.only(left: 12.0),
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Text("Member", style: GoogleFonts.poppins(fontSize: 11, color: Colors.grey[600])),
                                          Text("Bergabung sekarang", style: GoogleFonts.poppins(fontSize: 13, fontWeight: FontWeight.w500, color: Colors.black54)),
                                        ],
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),

          // 2. Sisa Konten
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 24.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Profile Row
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 24.0),
                    child: Row(
                      children: [
                        const CircleAvatar(
                          radius: 22,
                          backgroundImage: NetworkImage("https://images.unsplash.com/photo-1500648767791-00dcc994a43e?fit=crop&w=100&h=100"),
                        ),
                        const SizedBox(width: 12),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text("Suryanto,", style: GoogleFonts.poppins(fontWeight: FontWeight.bold, fontSize: 14)),
                            Text("IMT - Universitas Ciputra", style: GoogleFonts.poppins(fontWeight: FontWeight.w600, fontSize: 13, color: Colors.black87)),
                          ],
                        ),
                      ],
                    ),
                  ),
                  
                  const SizedBox(height: 20),

                  // Banner
                  Container(
                    margin: const EdgeInsets.symmetric(horizontal: 20),
                    height: 140,
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: const Color(0xFFE3F0FF),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Stack(
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(24.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text("Leadership 101", style: GoogleFonts.poppins(color: const Color(0xFF0F5A88), fontWeight: FontWeight.bold, fontSize: 14)),
                              const SizedBox(height: 4),
                              Text("1-2 Dec", style: GoogleFonts.poppins(color: const Color(0xFF0B466F), fontWeight: FontWeight.w800, fontSize: 36, height: 1.0)),
                            ],
                          ),
                        ),
                        Positioned(
                          right: 20,
                          bottom: 0,
                          child: Image.network(
                            "https://cdn-icons-png.flaticon.com/512/744/744922.png",
                            height: 120,
                          ),
                        )
                      ],
                    ),
                  ),

                  const SizedBox(height: 24),

                  // My Orders & Calendar
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 24.0),
                    child: Text("My Orders", style: GoogleFonts.poppins(fontWeight: FontWeight.bold, fontSize: 16)),
                  ),
                  const SizedBox(height: 12),
                  
                  SizedBox(
                    height: 80,
                    child: ListView.separated(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      scrollDirection: Axis.horizontal,
                      itemCount: 31,
                      separatorBuilder: (_, __) => const SizedBox(width: 12),
                      itemBuilder: (context, index) {
                        DateTime date = DateTime(2025, 12, index + 1);
                        bool isSelected = index == selectedDateIndex;
                        String dayName = DateFormat('E').format(date).toUpperCase();
                        String dayNum = "${index + 1}";

                        return GestureDetector(
                          onTap: () {
                            setState(() {
                              selectedDateIndex = index;
                            });
                          },
                          child: Container(
                            width: 60,
                            decoration: BoxDecoration(
                              color: isSelected ? Colors.transparent : Colors.transparent,
                              border: isSelected ? Border.all(color: const Color(0xFF166D9F), width: 1.5) : null,
                              borderRadius: BorderRadius.circular(16),
                            ),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  dayName,
                                  style: GoogleFonts.poppins(
                                    color: const Color(0xFF166D9F),
                                    fontWeight: FontWeight.w500,
                                    fontSize: 12,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  dayNum,
                                  style: GoogleFonts.poppins(
                                    color: const Color(0xFF166D9F),
                                    fontWeight: FontWeight.bold,
                                    fontSize: 18,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                  ),

                  const SizedBox(height: 20),

                  // Events List (Dynamic based on Selection)
                  currentEvents.isEmpty
                  ? Padding(
                      padding: const EdgeInsets.all(40.0),
                      child: Center(
                        child: Text(
                          "No events for this date.",
                          style: GoogleFonts.poppins(color: Colors.grey),
                        ),
                      ),
                    )
                  : ListView.builder(
                    padding: const EdgeInsets.only(bottom: 40),
                    physics: const NeverScrollableScrollPhysics(),
                    shrinkWrap: true,
                    itemCount: currentEvents.length,
                    itemBuilder: (context, index) {
                      return _buildEventItem(currentEvents[index]);
                    },
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEventItem(EventModel event) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 12.0),
      child: IntrinsicHeight(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Time Column
            Padding(
              padding: const EdgeInsets.only(top: 10.0),
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                decoration: BoxDecoration(
                  color: const Color(0xFFEAEAEA),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  event.time,
                  style: GoogleFonts.poppins(
                    color: const Color(0xFF0B466F),
                    fontWeight: FontWeight.w600,
                    fontSize: 13,
                  ),
                ),
              ),
            ),
            
            const SizedBox(width: 16),

            // Card Column
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: double.infinity,
                    height: 140,
                    decoration: BoxDecoration(
                      gradient: event.cardGradient,
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: [
                        BoxShadow(
                          color: event.cardGradient.colors.last.withOpacity(0.4),
                          blurRadius: 10,
                          offset: const Offset(0, 5),
                        )
                      ],
                    ),
                    child: Stack(
                      children: [
                        Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                event.title,
                                style: GoogleFonts.poppins(
                                  color: Colors.white,
                                  fontSize: 28,
                                  fontWeight: FontWeight.w900,
                                  height: 1.0,
                                  letterSpacing: 1.2
                                ),
                              ),
                              Text(
                                event.subtitle,
                                style: GoogleFonts.poppins(
                                  color: Colors.white.withOpacity(0.9),
                                  fontSize: 24,
                                  fontWeight: FontWeight.bold,
                                  fontStyle: FontStyle.italic,
                                ),
                              ),
                            ],
                          ),
                        ),
                        Positioned(
                          top: 12,
                          right: 12,
                          child: Container(
                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(
                                  event.status == "Done" ? Icons.check_circle : Icons.check_circle,
                                  color: Colors.green,
                                  size: 14,
                                ),
                                const SizedBox(width: 4),
                                Text(
                                  event.status,
                                  style: GoogleFonts.poppins(
                                    fontSize: 10,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.green,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                  
                  const SizedBox(height: 12),

                  Text(
                    event.location,
                    style: GoogleFonts.poppins(
                      fontWeight: FontWeight.w600,
                      fontSize: 14,
                      color: Colors.black87,
                    ),
                  ),
                  Row(
                    children: [
                      const Icon(Icons.location_pin, size: 14, color: Colors.grey),
                      const SizedBox(width: 4),
                      Text(
                        event.building,
                        style: GoogleFonts.poppins(
                          fontSize: 12,
                          color: Colors.grey[600],
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 12),

                  Row(
                    children: [
                      SizedBox(
                        width: (event.attendees.length > 3 ? 3 : event.attendees.length) * 28.0 + 10,
                        height: 40,
                        child: Stack(
                          children: List.generate(
                            event.attendees.length > 3 ? 3 : event.attendees.length,
                            (index) {
                              return Positioned(
                                left: index * 24.0,
                                child: Container(
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    border: Border.all(color: Colors.white, width: 2),
                                  ),
                                  child: CircleAvatar(
                                    radius: 16,
                                    backgroundImage: NetworkImage(event.attendees[index].imageUrl),
                                  ),
                                ),
                              );
                            },
                          ),
                        ),
                      ),
                      
                      Expanded(
                        child: RichText(
                          text: TextSpan(
                            style: GoogleFonts.poppins(
                              color: Colors.grey[600],
                              fontSize: 12,
                            ),
                            children: _buildAttendeeNames(event.attendees),
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  List<TextSpan> _buildAttendeeNames(List<Attendee> attendees) {
    List<TextSpan> spans = [];
    int count = attendees.length;
    int displayCount = count > 3 ? 3 : count;
    
    List<String> names = attendees.take(displayCount).map((e) => e.name).toList();
    String namesString = names.join(" & ");
    
    if (names.length > 1) {
       String last = names.removeLast();
       namesString = "${names.join(", ")} & $last";
    }

    spans.add(TextSpan(text: namesString));
    if (count > 3) {
      spans.add(const TextSpan(text: ", and more"));
    }
    return spans;
  }
}