import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:firebase_database/firebase_database.dart';

class TestsAvailableScreen extends StatefulWidget {
  const TestsAvailableScreen({super.key});

  @override
  State<TestsAvailableScreen> createState() => _TestsAvailableScreenState();
}

class _TestsAvailableScreenState extends State<TestsAvailableScreen> {
  final List<Map<dynamic, dynamic>> _tests = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchTests();
  }

  Future<void> _fetchTests() async {
    final ref = FirebaseDatabase.instance.ref("tests");
    try {
      final snapshot = await ref.get();
      if (snapshot.exists) {
        final data = snapshot.value as Map<dynamic, dynamic>;
        setState(() {
          _tests.addAll(data.values.map((e) => e as Map<dynamic, dynamic>).toList());
          _isLoading = false;
        });
      } else {
        // Fallback for demo if DB is empty
        setState(() {
          _tests.addAll([
            {'test_name': 'Complete Blood Count (CBC)', 'test_price': 'Rs. 1,500', 'test_availability': 'Available', 'test_requirments': '12h Fasting'},
            {'test_name': 'Blood Sugar Random', 'test_price': 'Rs. 500', 'test_availability': 'Available', 'test_requirments': 'None'},
            {'test_name': 'Liver Function Test (LFT)', 'test_price': 'Rs. 2,500', 'test_availability': 'Available', 'test_requirments': '8h Fasting'},
            {'test_name': 'Kidney Function Test (KFT)', 'test_price': 'Rs. 2,000', 'test_availability': 'Available', 'test_requirments': 'None'},
          ]);
          _isLoading = false;
        });
      }
    } catch (e) {
      debugPrint("Error fetching tests: $e");
      setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FE),
      appBar: AppBar(
        title: Text("Tests Available", style: GoogleFonts.outfit(fontWeight: FontWeight.bold)),
        backgroundColor: Colors.white,
        elevation: 0,
        foregroundColor: Colors.black,
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : ListView.builder(
              padding: const EdgeInsets.all(20),
              itemCount: _tests.length,
              itemBuilder: (context, index) {
                final test = _tests[index];
                return Container(
                  margin: const EdgeInsets.only(bottom: 15),
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.03), blurRadius: 10)],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: Text(
                              test['test_name'] ?? 'Unknown Test',
                              style: GoogleFonts.outfit(fontSize: 18, fontWeight: FontWeight.bold, color: const Color(0xFF2355C4)),
                            ),
                          ),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                            decoration: BoxDecoration(
                              color: Colors.green.withValues(alpha: 0.1),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Text(
                              test['test_availability'] ?? 'Available',
                              style: const TextStyle(color: Colors.green, fontWeight: FontWeight.bold, fontSize: 12),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 15),
                      const Divider(height: 1),
                      const SizedBox(height: 15),
                      _buildInfoRow(Icons.payments_outlined, "Price", test['test_price'] ?? 'N/A'),
                      const SizedBox(height: 10),
                      _buildInfoRow(Icons.assignment_outlined, "Requirements", test['test_requirments'] ?? 'None'),
                    ],
                  ),
                );
              },
            ),
    );
  }

  Widget _buildInfoRow(IconData icon, String label, String value) {
    return Row(
      children: [
        Icon(icon, size: 18, color: Colors.grey),
        const SizedBox(width: 10),
        Text("$label: ", style: const TextStyle(color: Colors.grey, fontWeight: FontWeight.w500)),
        Text(value, style: const TextStyle(fontWeight: FontWeight.bold)),
      ],
    );
  }
}
