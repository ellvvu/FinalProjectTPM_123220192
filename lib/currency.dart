import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:intl/intl.dart';

class CurrencyConverterScreen extends StatefulWidget {
  const CurrencyConverterScreen({super.key});

  @override
  State<CurrencyConverterScreen> createState() => _CurrencyConverterScreenState();
}

class _CurrencyConverterScreenState extends State<CurrencyConverterScreen> {
  final TextEditingController _amountController = TextEditingController();
  String _fromCurrency = 'USD';
  String _toCurrency = 'IDR';
  double _convertedAmount = 0;
  bool _isLoading = false;
  Map<String, double> _exchangeRates = {};
  final List<String> _popularCurrencies = [
    'USD',
    'IDR',
    'EUR',
    'JPY',
    'GBP',
    'SGD'
  ];

  @override
  void initState() {
    super.initState();
    _fetchExchangeRates();
  }

  Future<void> _fetchExchangeRates() async {
    setState(() => _isLoading = true);
    try {
      final response = await http.get(Uri.parse(
          'https://api.exchangerate-api.com/v4/latest/USD')); // API gratis
      
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        setState(() {
          _exchangeRates = Map<String, double>.from(data['rates']);
        });
      } else {
        throw Exception('Failed to load exchange rates');
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $e')),
      );
    } finally {
      setState(() => _isLoading = false);
    }
  }

  void _convertCurrency() {
    if (_amountController.text.isEmpty) return;
    
    final amount = double.tryParse(_amountController.text) ?? 0;
    if (_exchangeRates.isEmpty) return;

    final fromRate = _exchangeRates[_fromCurrency] ?? 1;
    final toRate = _exchangeRates[_toCurrency] ?? 1;

    setState(() {
      _convertedAmount = amount * (toRate / fromRate);
    });
  }

  String _formatCurrency(double amount, String currencyCode) {
    final formatter = NumberFormat.currency(
      locale: _getLocale(currencyCode),
      symbol: _getSymbol(currencyCode),
      decimalDigits: _getDecimalDigits(currencyCode),
    );
    return formatter.format(amount);
  }

  String _getLocale(String currencyCode) {
    switch (currencyCode) {
      case 'IDR':
        return 'id_ID';
      case 'EUR':
        return 'fr_FR';
      default:
        return 'en_US';
    }
  }

  String _getSymbol(String currencyCode) {
    switch (currencyCode) {
      case 'IDR':
        return 'Rp';
      default:
        return currencyCode;
    }
  }

  int _getDecimalDigits(String currencyCode) {
    return currencyCode == 'IDR' ? 0 : 2;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Currency Converter'),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Card(
              elevation: 4,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    TextField(
                      controller: _amountController,
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(
                        labelText: 'Amount',
                        border: OutlineInputBorder(),
                        prefixIcon: Icon(Icons.money),
                      ),
                      onChanged: (_) => _convertCurrency(),
                    ),
                    const SizedBox(height: 16),
                    Row(
                      children: [
                        Expanded(
                          child: _buildCurrencyDropdown(
                            value: _fromCurrency,
                            onChanged: (value) {
                              setState(() => _fromCurrency = value!);
                              _convertCurrency();
                            },
                            label: 'From',
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: _buildCurrencyDropdown(
                            value: _toCurrency,
                            onChanged: (value) {
                              setState(() => _toCurrency = value!);
                              _convertCurrency();
                            },
                            label: 'To',
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 24),
            if (_isLoading)
              const CircularProgressIndicator()
            else if (_exchangeRates.isNotEmpty)
              Column(
                children: [
                  Text(
                    '${_amountController.text.isEmpty ? '0' : _amountController.text} $_fromCurrency =',
                    style: TextStyle(fontSize: 18),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    _formatCurrency(_convertedAmount, _toCurrency),
                    style: const TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      color: Colors.blue,
                    ),
                  ),
                  const SizedBox(height: 16),
                  if (_toCurrency == 'IDR')
                    Text(
                      '≈ ${(_convertedAmount / 1000).toStringAsFixed(0)} ribu',
                      style: TextStyle(color: Colors.grey[600]),
                    ),
                ],
              ),
            const Spacer(),
            _buildPopularCurrencies(),
          ],
        ),
      ),
    );
  }

  Widget _buildCurrencyDropdown({
    required String value,
    required ValueChanged<String?> onChanged,
    required String label,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: TextStyle(color: Colors.grey[600])),
        const SizedBox(height: 4),
        DropdownButtonFormField<String>(
          value: value,
          items: _exchangeRates.keys.map((currency) {
            return DropdownMenuItem(
              value: currency,
              child: Row(
                children: [
                  Text(currency),
                  const SizedBox(width: 8),
                  Text(_getCurrencyName(currency)),
                ],
              ),
            );
          }).toList(),
          onChanged: onChanged,
          decoration: InputDecoration(
            border: OutlineInputBorder(),
            contentPadding: EdgeInsets.symmetric(horizontal: 12),
          ),
        ),
      ],
    );
  }

  Widget _buildPopularCurrencies() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Popular Currencies:', style: TextStyle(fontWeight: FontWeight.bold)),
        const SizedBox(height: 8),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: _popularCurrencies.map((currency) {
            return ActionChip(
              label: Text(currency),
              onPressed: () {
                setState(() => _toCurrency = currency);
                _convertCurrency();
              },
              backgroundColor: _toCurrency == currency 
                  ? Colors.blue.withOpacity(0.2) 
                  : Colors.grey[200],
            );
          }).toList(),
        ),
      ],
    );
  }

  String _getCurrencyName(String code) {
    const names = {
      'USD': 'US Dollar',
      'IDR': 'Indonesian Rupiah',
      'EUR': 'Euro',
      'JPY': 'Japanese Yen',
      'GBP': 'British Pound',
      'SGD': 'Singapore Dollar',
    };
    return names[code] ?? code;
  }
}