import 'dart:io';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:google_mlkit_text_recognition/google_mlkit_text_recognition.dart';
import 'package:lottie/lottie.dart';
import 'package:flutter/foundation.dart';
import '../services/chatbot_service.dart';

class ReportAnalysisScreen extends StatefulWidget {
  const ReportAnalysisScreen({super.key});

  @override
  State<ReportAnalysisScreen> createState() => _ReportAnalysisScreenState();
}

class _ReportAnalysisScreenState extends State<ReportAnalysisScreen> {
  File? _image;
  bool _isProcessing = false;
  String _analysisResult = "";
  final _picker = ImagePicker();
  final _chatbotService = ChatbotService();

  Future<void> _pickImage(ImageSource source) async {
    final pickedFile = await _picker.pickImage(source: source);
    if (pickedFile != null) {
      if (kIsWeb) {
        setState(() {
          _analysisResult = "Analysis Simulation: \n\n"
              "Based on the simulated scan, your Hemoglobin levels are 13.5 g/dL (Normal) and Blood Sugar is 95 mg/dL (Normal). "
              "All parameters appear stable. Keep maintaining a balanced diet and regular exercise. \n\n"
              "(Note: Real OCR scanning is available on Android/iOS devices).";
        });
        return;
      }
      setState(() {
        _image = File(pickedFile.path);
        _analysisResult = "";
      });
      _processImage();
    }
  }

  Future<void> _processImage() async {
    if (_image == null) return;

    setState(() => _isProcessing = true);

    try {
      final inputImage = InputImage.fromFile(_image!);
      final textRecognizer = TextRecognizer(script: TextRecognitionScript.latin);
      final RecognizedText recognizedText = await textRecognizer.processImage(inputImage);
      
      String extractedText = recognizedText.text;
      textRecognizer.close();

      if (extractedText.trim().isEmpty) {
        setState(() {
          _analysisResult = "No text found in the image. Please try a clearer photo of your report.";
          _isProcessing = false;
        });
        return;
      }

      // Send to AI for analysis
      final prompt = "You are a professional medical assistant. I have scanned a medical lab report. "
          "Please analyze the following text from the report. Identify key metrics like Hemoglobin, "
          "Glucose, Cholesterol, etc., and explain if they are within normal ranges. "
          "Provide actionable health advice based on these results. \n\n"
          "Report Text:\n$extractedText";

      final aiResponse = await _chatbotService.getAiResponse(prompt);

      setState(() {
        _analysisResult = aiResponse;
        _isProcessing = false;
      });
    } catch (e) {
      setState(() {
        _analysisResult = "Error processing report: $e";
        _isProcessing = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FE),
      appBar: AppBar(
        title: Text("AI Report Scanner", style: GoogleFonts.outfit(fontWeight: FontWeight.bold)),
        backgroundColor: Colors.white,
        elevation: 0,
        foregroundColor: Colors.black,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(25),
        child: Column(
          children: [
            _buildImageContainer(),
            const SizedBox(height: 30),
            if (!_isProcessing && _image == null) _buildEmptyState(),
            if (kIsWeb && _image == null) ...[
              const SizedBox(height: 20),
              ElevatedButton.icon(
                onPressed: () => _pickImage(ImageSource.gallery),
                icon: const Icon(Icons.bolt_rounded),
                label: const Text("Simulate AI Analysis (Web Mode)"),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.orange,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                ),
              ),
            ],
            if (_isProcessing) _buildProcessingState(),
            if (!_isProcessing && _analysisResult.isNotEmpty) _buildResultCard(),
          ],
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: _image == null ? _buildActionButtons() : null,
    );
  }

  Widget _buildImageContainer() {
    return Container(
      width: double.infinity,
      height: 250,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(25),
        boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.05), blurRadius: 15)],
      ),
      child: _image != null
          ? ClipRRect(
              borderRadius: BorderRadius.circular(25),
              child: kIsWeb ? Image.network(_image!.path, fit: BoxFit.cover) : Image.file(_image!, fit: BoxFit.cover),
            )
          : Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.description_outlined, size: 60, color: Colors.grey.shade300),
                  const SizedBox(height: 10),
                  const Text("No report selected", style: TextStyle(color: Colors.grey)),
                ],
              ),
            ),
    );
  }

  Widget _buildEmptyState() {
    return Column(
      children: [
        const SizedBox(height: 20),
        Text(
          "Scan your lab reports for instant AI analysis and health recommendations.",
          textAlign: TextAlign.center,
          style: GoogleFonts.outfit(fontSize: 16, color: Colors.grey.shade600),
        ),
      ],
    );
  }

  Widget _buildProcessingState() {
    return Column(
      children: [
        const SizedBox(height: 20),
        Lottie.asset('assets/lottie/loading.json', height: 120),
        const SizedBox(height: 10),
        Text("Our AI is analyzing your report...", style: GoogleFonts.outfit(fontWeight: FontWeight.bold, fontSize: 16)),
        const Text("This usually takes a few seconds", style: TextStyle(color: Colors.grey)),
      ],
    );
  }

  Widget _buildResultCard() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(25),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(25),
        boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.05), blurRadius: 15)],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.analytics_outlined, color: Color(0xFF2355C4)),
              const SizedBox(width: 10),
              Text("Analysis Results", style: GoogleFonts.outfit(fontSize: 18, fontWeight: FontWeight.bold)),
            ],
          ),
          const Divider(height: 30),
          Text(
            _analysisResult,
            style: const TextStyle(fontSize: 15, height: 1.6, color: Colors.black87),
          ),
          const SizedBox(height: 30),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () => setState(() {
                _image = null;
                _analysisResult = "";
              }),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF2355C4),
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                padding: const EdgeInsets.symmetric(vertical: 15),
              ),
              child: const Text("Scan Another Report"),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActionButtons() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        _buildFab("Camera", Icons.camera_alt_rounded, () => _pickImage(ImageSource.camera)),
        const SizedBox(width: 20),
        _buildFab("Gallery", Icons.photo_library_rounded, () => _pickImage(ImageSource.gallery)),
      ],
    );
  }

  Widget _buildFab(String label, IconData icon, VoidCallback onPressed) {
    return ElevatedButton.icon(
      onPressed: onPressed,
      icon: Icon(icon, size: 20),
      label: Text(label),
      style: ElevatedButton.styleFrom(
        backgroundColor: const Color(0xFF2355C4),
        foregroundColor: Colors.white,
        padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 15),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
        elevation: 10,
      ),
    );
  }
}
