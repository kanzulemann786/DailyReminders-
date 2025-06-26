import 'package:http/http.dart' as http;
import 'dart:convert';
import '../models/quote_model.dart';

class QuoteService {
  static const String _baseUrl = 'https://zenquotes.io/api/random';

  Future<Quote> fetchQuote() async {
    final response = await http.get(Uri.parse(_baseUrl));
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return Quote.fromJson(data[0]);
    } else {
      throw Exception('Failed to load quote');
    }
  }
}
