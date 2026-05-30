import 'package:flutter_dotenv/flutter_dotenv.dart';

/// Gemini API key loaded from assets/creds/.env
/// Usage: import '../utils/constants.dart'; then use [apiKey]
final String apiKey = dotenv.env['API_KEY'] ?? '';
