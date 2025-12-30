import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class BmiScreen extends StatefulWidget {
  const BmiScreen({super.key});

  @override
  State<BmiScreen> createState() => _BmiScreenState();
}

class _BmiScreenState extends State<BmiScreen> {
  final _weightController = TextEditingController();
  final _heightController = TextEditingController();
  double? _bmi;
  String _message = "";

  void _calculate() {
    final weight = double.tryParse(_weightController.text);
    final height = double.tryParse(_heightController.text);

    if (weight != null && height != null && height > 0) {
      // Height in cm to meters
      final heightInMeters = height / 100;
      setState(() {
        _bmi = weight / (heightInMeters * heightInMeters);
        if (_bmi! < 18.5) {
          _message = "Underweight";
        } else if (_bmi! < 25) {
          _message = "Normal";
        } else if (_bmi! < 30) {
          _message = "Overweight";
        } else {
          _message = "Obese";
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(title: Text("BMI Calculator", style: GoogleFonts.outfit(fontWeight: FontWeight.bold))),
      body: Padding(
        padding: const EdgeInsets.all(25),
        child: Column(
          children: [
            _buildInputField(_weightController, "Weight (kg)", Icons.monitor_weight_outlined),
            const SizedBox(height: 20),
            _buildInputField(_heightController, "Height (cm)", Icons.height_rounded),
            const SizedBox(height: 40),
            SizedBox(
              width: double.infinity,
              height: 60,
              child: ElevatedButton(
                onPressed: _calculate,
                style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF2355C4), foregroundColor: Colors.white),
                child: const Text("Calculate BMI"),
              ),
            ),
            if (_bmi != null) ...[
              const SizedBox(height: 50),
              Container(
                padding: const EdgeInsets.all(30),
                decoration: BoxDecoration(
                  color: const Color(0xFF2355C4).withValues(alpha: 0.05), 
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Column(
                  children: [
                    Text("Your BMI", style: TextStyle(color: Colors.grey.shade600)),
                    Text(_bmi!.toStringAsFixed(1), style: GoogleFonts.outfit(fontSize: 48, fontWeight: FontWeight.bold, color: const Color(0xFF2355C4))),
                    Text(_message, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w600)),
                  ],
                ),
              ),
            ]
          ],
        ),
      ),
    );
  }

  Widget _buildInputField(TextEditingController controller, String label, IconData icon) {
    return TextField(
      controller: controller,
      keyboardType: TextInputType.number,
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(icon, color: const Color(0xFF2355C4)),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(15)),
      ),
    );
  }
}
