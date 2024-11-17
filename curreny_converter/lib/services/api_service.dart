import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiService {
  static const String _baseUrl =
      'https://v6.exchangerate-api.com/v6/fed2b2d9121c8685a12c5b1d/latest/';

  Future<Map<String, double>> fetchExchangeRates(String baseCurrency) async {
    final url = Uri.parse('$_baseUrl$baseCurrency');

    final response = await http.get(url);

    if (response.statusCode == 200) {
      final Map<String, dynamic> rates =
          json.decode(response.body)['conversion_rates'];

      return rates.map((key, value) => MapEntry(key, value.toDouble()));
    } else {
      throw Exception('Failed to load exchange rates');
    }
  }
}
