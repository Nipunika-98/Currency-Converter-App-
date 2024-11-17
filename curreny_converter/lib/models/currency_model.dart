class CurrencyModel {
  final String code;
  final double rate;

  CurrencyModel({required this.code, required this.rate});

  factory CurrencyModel.fromJson(String code, double rate) {
    return CurrencyModel(code: code, rate: rate);
  }
}
