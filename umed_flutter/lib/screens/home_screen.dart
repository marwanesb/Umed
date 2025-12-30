import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'chatbot_screen.dart';
import 'book_appointment_screen.dart';
import 'booked_appointments_screen.dart';
import 'profile_screen.dart';
import 'bmi_screen.dart';
import 'report_analysis_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: _selectedIndex == 0, // Only allow pop if we are on the first tab
      onPopInvokedWithResult: (didPop, result) {
        if (didPop) return;
        
        // If we are not on the first tab, switch to it instead of popping
        if (_selectedIndex != 0) {
          setState(() {
            _selectedIndex = 0;
          });
        }
      },
      child: Scaffold(
        backgroundColor: const Color(0xFFF8F9FE),
        bottomNavigationBar: _buildBottomNav(),
        body: _buildBody(),
      ),
    );
  }

  Widget _buildBottomNav() {
    return Container(
      decoration: BoxDecoration(
        boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.1), blurRadius: 20)],
      ),
      child: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: (index) => setState(() => _selectedIndex = index),
        selectedItemColor: const Color(0xFF2355C4),
        unselectedItemColor: Colors.grey,
        showSelectedLabels: true,
        showUnselectedLabels: false,
        type: BottomNavigationBarType.fixed,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.grid_view_rounded), label: "Home"),
          BottomNavigationBarItem(icon: Icon(Icons.chat_bubble_rounded), label: "AI Chat"),
          BottomNavigationBarItem(icon: Icon(Icons.calendar_month_rounded), label: "Appts"),
          BottomNavigationBarItem(icon: Icon(Icons.person_rounded), label: "Profile"),
        ],
      ),
    );
  }

  Widget _buildBody() {
    if (_selectedIndex == 1) return const ChatbotScreen();
    if (_selectedIndex == 2) return const BookedAppointmentsScreen();
    if (_selectedIndex == 3) return const ProfileScreen();
    
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildHeader(),
          const SizedBox(height: 20),
          _buildBanner(),
          const SizedBox(height: 30),
          _buildSpecialistServices(),
          const SizedBox(height: 30),
          _buildPopularArticles(),
          const SizedBox(height: 100),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      padding: const EdgeInsets.fromLTRB(25, 60, 25, 20),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(bottomLeft: Radius.circular(30), bottomRight: Radius.circular(30)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              CircleAvatar(
                radius: 25,
                backgroundImage: const AssetImage('assets/images/profile.jpg'),
                backgroundColor: Colors.blue.shade50,
              ),
              const SizedBox(width: 15),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("Hi, Mahad", style: GoogleFonts.outfit(fontSize: 20, fontWeight: FontWeight.bold)),
                  Text("May you always be healthy", style: TextStyle(color: Colors.grey.shade600, fontSize: 13)),
                ],
              ),
            ],
          ),
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(color: Colors.grey.shade100, borderRadius: BorderRadius.circular(15)),
            child: const Icon(Icons.notifications_none_rounded, color: Color(0xFF2355C4)),
          ),
        ],
      ),
    );
  }

  Widget _buildBanner() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 25),
      height: 160,
      width: double.infinity,
      decoration: BoxDecoration(
        gradient: const LinearGradient(colors: [Color(0xFF2355C4), Color(0xFF4A80F0)]),
        borderRadius: BorderRadius.circular(25),
        boxShadow: [BoxShadow(color: const Color(0xFF2355C4).withValues(alpha: 0.3), blurRadius: 15, offset: const Offset(0, 8))],
      ),
      child: Stack(
        children: [
          Padding(
            padding: const EdgeInsets.all(25),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text("Free Consultation", style: TextStyle(color: Colors.white, fontSize: 22, fontWeight: FontWeight.bold)),
                const SizedBox(height: 5),
                const Text("Get expert advice instantly", style: TextStyle(color: Colors.white70, fontSize: 14)),
                const SizedBox(height: 15),
                ElevatedButton(
                  onPressed: () {},
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white,
                    foregroundColor: const Color(0xFF2355C4),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                  ),
                  child: const Text("Ask AI Now"),
                ),
              ],
            ),
          ),
          Positioned(
            right: -20,
            bottom: -20,
            child: Icon(Icons.health_and_safety_rounded, size: 150, color: Colors.white.withValues(alpha: 0.1)),
          ),
        ],
      ),
    );
  }

  Widget _buildSpecialistServices() {
    final services = [
      {'name': 'Book Appointment', 'icon': 'assets/images/ic_book_appointment.png', 'color': Colors.blue},
      {'name': 'My Bookings', 'icon': 'assets/images/ic_booked_appointments.png', 'color': Colors.purple},
      {'name': 'BMI Calc', 'icon': 'assets/images/ic_bmi_calculator.png', 'color': Colors.green},
      {'name': 'AI Chat', 'icon': 'assets/images/ic_ai_health.jpg', 'color': Colors.orange},
      {'name': 'Report Scanner', 'icon': 'assets/images/ic_report.png', 'color': Colors.red},
    ];

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 25),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("Specialist Services", style: GoogleFonts.outfit(fontSize: 18, fontWeight: FontWeight.bold)),
          const SizedBox(height: 20),
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: services.length,
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 15,
              mainAxisSpacing: 15,
              childAspectRatio: 1.3,
            ),
            itemBuilder: (context, index) {
              final service = services[index];
              return InkWell(
                onTap: () => _onServiceTap(index),
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.04), blurRadius: 10, offset: const Offset(0, 4))],
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: (service['color'] as Color).withValues(alpha: 0.1),
                          shape: BoxShape.circle,
                        ),
                        child: Image.asset(service['icon'] as String, height: 30, width: 30),
                      ),
                      const SizedBox(height: 12),
                      Text(service['name'] as String, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
                    ],
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  void _onServiceTap(int index) {
    if (index == 0) Navigator.push(context, MaterialPageRoute(builder: (context) => const BookAppointmentScreen()));
    if (index == 1) Navigator.push(context, MaterialPageRoute(builder: (context) => const BookedAppointmentsScreen()));
    if (index == 2) Navigator.push(context, MaterialPageRoute(builder: (context) => const BmiScreen()));
    if (index == 3) setState(() => _selectedIndex = 1);
    if (index == 4) Navigator.push(context, MaterialPageRoute(builder: (context) => const ReportAnalysisScreen()));
  }

  Widget _buildPopularArticles() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 25),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text("Popular Articles", style: GoogleFonts.outfit(fontSize: 18, fontWeight: FontWeight.bold)),
              TextButton(onPressed: () {}, child: const Text("See All")),
            ],
          ),
          ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: 2,
            itemBuilder: (context, index) {
              return Container(
                margin: const EdgeInsets.only(bottom: 15),
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.03), blurRadius: 10)],
                ),
                child: Row(
                  children: [
                    Container(
                      height: 70,
                      width: 70,
                      decoration: BoxDecoration(color: Colors.blue.shade50, borderRadius: BorderRadius.circular(15)),
                      child: const Icon(Icons.article_rounded, color: Color(0xFF2355C4)),
                    ),
                    const SizedBox(width: 15),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text("10 Tips for Heart Health", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
                          const SizedBox(height: 5),
                          Text("Read the latest research...", style: TextStyle(color: Colors.grey.shade600, fontSize: 12)),
                        ],
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
