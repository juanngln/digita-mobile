import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/quote.dart';

class ApiService {
  static const String _baseUrl = 'https://zenquotes.io/api/random';

  Future<Quote> fetchRandomQuote() async {
    final response = await http.get(Uri.parse(_baseUrl));

    if (response.statusCode == 200) {
      // The API returns a list with a single quote object
      final List<dynamic> jsonResponse = json.decode(response.body);
      return Quote.fromJson(jsonResponse[0]);
    } else {
      throw Exception('Failed to load quote');
    }
  }
}