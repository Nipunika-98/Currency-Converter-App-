import 'package:country_currency_pickers/country_pickers.dart';
import 'package:curreny_converter/models/currency_model.dart';
import 'package:curreny_converter/view_model/currency_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<CurrencyProvider>(context);

    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 43, 41, 41),
      appBar: AppBar(
        title: const Text('Advanced Exchanger', style: TextStyle(color: Colors.white)),
        backgroundColor: const Color.fromARGB(255, 40, 39, 39),
        centerTitle: true,
        // leading: IconButton(
        //   icon: const Icon(Icons.arrow_back, color: Colors.white),
        //   onPressed: () => Navigator.pop(context),
        // ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('INSERT AMOUNT:',
                      style: TextStyle(color: Colors.white70, fontSize: 14)),
                  const SizedBox(height: 8),
                  Container(
                      decoration: BoxDecoration(
                          color: Colors.grey[800], borderRadius: BorderRadius.circular(12)),
                      child: Row(
                        children: [
                          Expanded(
                            child: TextField(
                              keyboardType: TextInputType.number,
                              style: const TextStyle(color: Colors.white),
                              decoration: InputDecoration(
                                hintText: 'Enter amount',
                                hintStyle: const TextStyle(color: Colors.white70),
                                border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(22.0),
                                    borderSide: BorderSide.none),
                                contentPadding:
                                    const EdgeInsets.symmetric(vertical: 16, horizontal: 12),
                                filled: true,
                                fillColor: Colors.grey[800],
                              ),
                              onChanged: (value) =>
                                  provider.updateAmount(double.tryParse(value) ?? 0),
                            ),
                          ),
                          const SizedBox(width: 10),
                          SizedBox(
                            width: 32,
                            height: 32,
                            child: ClipOval(
                              child: CountryPickerUtils.getDefaultFlagImage(
                                CountryPickerUtils.getCountryByCurrencyCode(provider.baseCurrency),
                              ),
                            ),
                          ),
                          const SizedBox(width: 10),
                          DropdownButtonHideUnderline(
                            child: DropdownButton<String>(
                                value: provider.baseCurrency,
                                onChanged: (String? newValue) {
                                  if (newValue != null) {
                                    provider.updateBaseCurrency(newValue);
                                  }
                                },
                                items: provider.exchangeRates.keys
                                    .map<DropdownMenuItem<String>>((String value) {
                                  return DropdownMenuItem<String>(
                                    value: value,
                                    child: Text(value, style: const TextStyle(color: Colors.white)),
                                  );
                                }).toList(),
                                dropdownColor: Colors.grey[800],
                                style: const TextStyle(color: Colors.white, fontSize: 18)),
                          ),
                          const SizedBox(width: 10),
                        ],
                      )),
                  const SizedBox(height: 16),
                  const Text('CONVERT TO:', style: TextStyle(color: Colors.white70, fontSize: 14)),
                  const SizedBox(height: 8),
                ],
              ),
            ),
            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: provider.preferredCurrencies.length,
              itemBuilder: (context, index) {
                final currencyCode = provider.preferredCurrencies[index];
                final convertedAmount = provider.convert(currencyCode);
                final country = CountryPickerUtils.getCountryByCurrencyCode(currencyCode);

                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 5.0, horizontal: 16.0),
                  child: Container(
                    decoration: BoxDecoration(
                        color: Colors.grey[800], borderRadius: BorderRadius.circular(12)),
                    padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 16),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(convertedAmount.toStringAsFixed(2),
                            style: const TextStyle(color: Colors.white, fontSize: 18)),
                        const SizedBox(width: 10),
                        Row(
                          children: [
                            ClipOval(
                              child: SizedBox(
                                width: 30,
                                height: 30,
                                child: CountryPickerUtils.getDefaultFlagImage(country),
                              ),
                            ),
                            const SizedBox(width: 10),
                            SizedBox(
                              width: 50,
                              child: Text(currencyCode,
                                  style: const TextStyle(color: Colors.white, fontSize: 18)),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color.fromARGB(47, 76, 175, 79),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(22),
                  ),
                  padding: const EdgeInsets.symmetric(vertical: 12.0, horizontal: 24.0),
                ),
                onPressed: () async {
                  final selected = await showDialog<List<String>>(
                    context: context,
                    builder: (context) =>
                        CurrencySelectionDialog(provider.currencies, provider.preferredCurrencies),
                  );
                  if (selected != null) {
                    provider.updatePreferredCurrencies(selected);
                  }
                },
                child: const Text(style: TextStyle(color: Colors.green), "+ ADD CONVERTER"),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class CurrencySelectionDialog extends StatefulWidget {
  final List<CurrencyModel> currencies;
  final List<String> selectedCurrencies;

  const CurrencySelectionDialog(this.currencies, this.selectedCurrencies, {super.key});

  @override
  _CurrencySelectionDialogState createState() => _CurrencySelectionDialogState();
}

class _CurrencySelectionDialogState extends State<CurrencySelectionDialog> {
  late List<String> _selectedCurrencies;

  @override
  void initState() {
    super.initState();
    _selectedCurrencies = List.from(widget.selectedCurrencies);
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text(
        'Select Target Currencies',
      ),
      content: SizedBox(
        width: double.maxFinite,
        child: ListView(
          children: widget.currencies.map((currency) {
            return CheckboxListTile(
              title: Text(
                currency.code,
              ),
              value: _selectedCurrencies.contains(currency.code),
              onChanged: (bool? selected) {
                setState(() {
                  if (selected == true) {
                    _selectedCurrencies.add(currency.code);
                  } else {
                    _selectedCurrencies.remove(currency.code);
                  }
                });
              },
            );
          }).toList(),
        ),
      ),
      actions: [
        TextButton(
            onPressed: () => Navigator.pop(context, _selectedCurrencies), child: const Text("Save"))
      ],
    );
  }
}
