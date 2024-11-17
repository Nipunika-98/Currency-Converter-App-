import 'package:curreny_converter/models/currency_model.dart';
import 'package:curreny_converter/services/api_service.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CurrencyProvider with ChangeNotifier {
  final ApiService _apiService = ApiService();
  List<CurrencyModel> _currencies = [];
  Map<String, dynamic> _exchangeRates = {};
  List<String> _preferredCurrencies = [];
  String _baseCurrency = 'USD';
  double _amount = 0;

  CurrencyProvider() {
    loadExchangeRates();
    loadPreferences();
  }

  Future<void> loadExchangeRates() async {
    try {
      _exchangeRates = await _apiService.fetchExchangeRates(_baseCurrency);
      _currencies =
          _exchangeRates.entries.map((e) => CurrencyModel.fromJson(e.key, e.value)).toList();
      notifyListeners();
    } catch (e) {
      print(e);
    }
  }

  Future<void> loadPreferences() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    _preferredCurrencies = prefs.getStringList('preferredCurrencies') ?? [];
    notifyListeners();
  }

  void updateAmount(double amount) {
    _amount = amount;
    notifyListeners();
  }

  void updateBaseCurrency(String country) {
    _baseCurrency = country;
    loadExchangeRates();
    notifyListeners();
  }

  void updatePreferredCurrencies(List<String> selectedCurrencies) async {
    _preferredCurrencies = selectedCurrencies;
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setStringList('preferredCurrencies', _preferredCurrencies);
    notifyListeners();
  }

  List<CurrencyModel> get currencies => _currencies;
  List<String> get preferredCurrencies => _preferredCurrencies;
  double getConversionRate(String targetCurrency) => _exchangeRates[targetCurrency] ?? 1.0;
  double convert(String targetCurrency) => _amount * getConversionRate(targetCurrency);
  String get baseCurrency => _baseCurrency;
  Map<String, dynamic> get exchangeRates => _exchangeRates;
}
