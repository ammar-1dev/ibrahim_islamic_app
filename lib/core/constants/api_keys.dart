import 'package:flutter_dotenv/flutter_dotenv.dart';

class AppApiKeys {
  static String get geminiApiKey => dotenv.env['GEMINI_API_KEY'] ?? '';

  static String get openAiApiKey => dotenv.env['OPENAI_API_KEY'] ?? '';

  static String get openRouterApiKey => dotenv.env['OPENROUTER_API_KEY'] ?? '';
}
