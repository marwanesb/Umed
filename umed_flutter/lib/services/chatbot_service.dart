import 'dart:convert';
import 'package:http/http.dart' as http;
import '../constants/app_constants.dart';
import 'package:logger/logger.dart';

class ChatbotService {
  final _logger = Logger();

  Future<String> getAiResponse(String message) async {
    final url = Uri.parse("${AppConstants.openaiBaseUrl}/chat/completions");
    
    try {
      final response = await http.post(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer ${AppConstants.openaiApiKey.trim()}',
        },
        body: jsonEncode({
          'model': AppConstants.openaiModel,
          'messages': [
            {'role': 'user', 'content': message}
          ],
        }),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return data['choices'][0]['message']['content'];
      } else {
        _logger.e("API Error: ${response.statusCode} - ${response.body}");
        return "Sorry, I am having trouble connecting to the AI service. (Error ${response.statusCode})";
      }
    } catch (e) {
      _logger.e("Connection Error: $e");
      return "Something went wrong. Please check your internet connection.";
    }
  }
}
