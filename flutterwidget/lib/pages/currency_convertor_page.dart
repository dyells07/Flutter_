import 'dart:async';
import 'dart:convert';
import 'package:currency_code_to_currency_symbol/currency_code_to_currency_symbol.dart';
import 'package:currency_picker/currency_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';

class CurrencyConverterMaterialPage extends StatefulWidget {
  const CurrencyConverterMaterialPage({Key? key}) : super(key: key);

  @override
  State<CurrencyConverterMaterialPage> createState() =>
      _CurrencyConverterMaterialPageState();
}

TextEditingController _controller = TextEditingController();

class _CurrencyConverterMaterialPageState
    extends State<CurrencyConverterMaterialPage> {
  double result = 0;
  final TextEditingController _textEditingController = TextEditingController();
  late Map<String, double> exchangeRates;
  bool isLoading = false;
  late Timer _timer;
  String currentTime = DateFormat('yyyy/MM/dd HH:mm:ss').format(DateTime.now());
  String selectedCurrency = 'USD';
  CurrencyCode selectedCur = CurrencyCode.USD;
  String currencyIcon = '';

  Map<String, String> currencyNames = {
    'USD': 'United States Dollar (USD)',
    'EUR': 'Euro (EUR)',
    'GBP': 'British Pound (GBP)',
    'INR': 'Indian Rupee (INR)',
    'NPR': 'Nepalese Rupee(NPR)',
    'AED': 'United Arab Emirates Dirham (AED)',
    'AFN': 'Afghan Afghani (AFN)',
    'ALL': 'Albanian Lek (ALL)',
    'AMD': 'Armenian Dram (AMD)',
    'ANG': 'Netherlands Antillean Guilder (ANG)',
    'AOA': 'Angolan Kwanza (AOA)',
    'ARS': 'Argentine Peso (ARS)',
    'AUD': 'Australian Dollar (AUD)',
    'AWG': 'Aruban Florin (AWG)',
    'AZN': 'Azerbaijani Manat (AZN)',
    'BAM': 'Bosnia-Herzegovina Convertible Mark (BAM)',
    'BBD': 'Barbadian Dollar (BBD)',
    'BDT': 'Bangladeshi Taka (BDT)',
    'BGN': 'Bulgarian Lev (BGN)',
    'BHD': 'Bahraini Dinar (BHD)',
    'BIF': 'Burundian Franc (BIF)',
    'BMD': 'Bermudian Dollar (BMD)',
    'BND': 'Brunei Dollar (BND)',
    'BOB': 'Bolivian Boliviano (BOB)',
    'BRL': 'Brazilian Real (BRL)',
    'BSD': 'Bahamian Dollar (BSD)',
    'BTN': 'Bhutanese Ngultrum (BTN)',
    'BWP': 'Botswana Pula (BWP)',
    'BYN': 'Belarusian Ruble (BYN)',
    'BZD': 'Belize Dollar (BZD)',
    'CAD': 'Canadian Dollar (CAD)',
    'CDF': 'Congolese Franc (CDF)',
    'CHF': 'Swiss Franc (CHF)',
    'CLP': 'Chilean Peso (CLP)',
    'CNY': 'Chinese Yuan (CNY)',
    'COP': 'Colombian Peso (COP)',
    'CRC': 'Costa Rican Colón (CRC)',
    'CUP': 'Cuban Peso (CUP)',
    'CVE': 'Cape Verdean Escudo (CVE)',
    'CZK': 'Czech Koruna (CZK)',
    'DJF': 'Djiboutian Franc (DJF)',
    'DKK': 'Danish Krone (DKK)',
    'DOP': 'Dominican Peso (DOP)',
    'DZD': 'Algerian Dinar (DZD)',
    'EGP': 'Egyptian Pound (EGP)',
    'ERN': 'Eritrean Nakfa (ERN)',
    'ETB': 'Ethiopian Birr (ETB)',
    'FJD': 'Fijian Dollar (FJD)',
    'FKP': 'Falkland Islands Pound (FKP)',
    'FOK': 'Faroese Króna (FOK)',
    'GEL': 'Georgian Lari (GEL)',
    'GGP': 'Guernsey Pound (GGP)',
    'GHS': 'Ghanaian Cedi (GHS)',
    'GIP': 'Gibraltar Pound (GIP)',
    'GMD': 'Gambian Dalasi (GMD)',
    'GNF': 'Guinean Franc (GNF)',
    'GTQ': 'Guatemalan Quetzal (GTQ)',
    'GYD': 'Guyanaese Dollar (GYD)',
    'HKD': 'Hong Kong Dollar (HKD)',
    'HNL': 'Honduran Lempira (HNL)',
    'HRK': 'Croatian Kuna (HRK)',
    'HTG': 'Haitian Gourde (HTG)',
    'HUF': 'Hungarian Forint (HUF)',
    'IDR': 'Indonesian Rupiah (IDR)',
    'ILS': 'Israeli New Shekel (ILS)',
    'IMP': 'Manx Pound (IMP)',
    'IQD': 'Iraqi Dinar (IQD)',
    'IRR': 'Iranian Rial (IRR)',
    'ISK': 'Icelandic Króna (ISK)',
    'JEP': 'Jersey Pound (JEP)',
    'JMD': 'Jamaican Dollar (JMD)',
    'JOD': 'Jordanian Dinar (JOD)',
    'JPY': 'Japanese Yen (JPY)',
    'KES': 'Kenyan Shilling (KES)',
    'KGS': 'Kyrgyzstani Som (KGS)',
    'KHR': 'Cambodian Riel (KHR)',
    'KID': 'Kiribati Dollar (KID)',
    'KMF': 'Comorian Franc (KMF)',
    'KRW': 'South Korean Won (KRW)',
    'KWD': 'Kuwaiti Dinar (KWD)',
    'KYD': 'Cayman Islands Dollar (KYD)',
    'KZT': 'Kazakhstani Tenge (KZT)',
    'LAK': 'Laotian Kip (LAK)',
    'LBP': 'Lebanese Pound (LBP)',
    'LKR': 'Sri Lankan Rupee (LKR)',
    'LRD': 'Liberian Dollar (LRD)',
    'LSL': 'Lesotho Loti (LSL)',
    'LYD': 'Libyan Dinar (LYD)',
    'MAD': 'Moroccan Dirham (MAD)',
    'MDL': 'Moldovan Leu (MDL)',
    'MGA': 'Malagasy Ariary (MGA)',
    'MKD': 'Macedonian Denar (MKD)',
    'MMK': 'Myanmar Kyat (MMK)',
    'MNT': 'Mongolian Tugrik (MNT)',
    'MOP': 'Macanese Pataca (MOP)',
    'MRU': 'Mauritanian Ouguiya (MRU)',
    'MUR': 'Mauritian Rupee (MUR)',
    'MVR': 'Maldivian Rufiyaa (MVR)',
    'MWK': 'Malawian Kwacha (MWK)',
    'MXN': 'Mexican Peso (MXN)',
    'MYR': 'Malaysian Ringgit (MYR)',
    'MZN': 'Mozambican Metical (MZN)',
    'NAD': 'Namibian Dollar (NAD)',
    'NGN': 'Nigerian Naira (NGN)',
    'NIO': 'Nicaraguan Córdoba (NIO)',
    'NOK': 'Norwegian Krone (NOK)',
    'NZD': 'New Zealand Dollar (NZD)',
    'OMR': 'Omani Rial (OMR)',
    'PAB': 'Panamanian Balboa (PAB)',
    'PEN': 'Peruvian Nuevo Sol (PEN)',
    'PGK': 'Papua New Guinean Kina (PGK)',
    'PHP': 'Philippine Peso (PHP)',
    'PKR': 'Pakistani Rupee (PKR)',
    'PLN': 'Polish Zloty (PLN)',
    'PYG': 'Paraguayan Guarani (PYG)',
    'QAR': 'Qatari Rial (QAR)',
    'RON': 'Romanian Leu (RON)',
    'RSD': 'Serbian Dinar (RSD)',
    'RUB': 'Russian Ruble (RUB)',
    'RWF': 'Rwandan Franc (RWF)',
    'SAR': 'Saudi Riyal (SAR)',
    'SBD': 'Solomon Islands Dollar (SBD)',
    'SCR': 'Seychellois Rupee (SCR)',
    'SDG': 'Sudanese Pound (SDG)',
    'SEK': 'Swedish Krona (SEK)',
    'SGD': 'Singapore Dollar (SGD)',
    'SHP': 'Saint Helena Pound (SHP)',
    'SLE': 'Sierra Leonean Leone (SLE)',
    'SLL': 'Sierra Leonean Leone (SLL)',
    'SOS': 'Somali Shilling (SOS)',
    'SRD': 'Surinamese Dollar (SRD)',
    'SSP': 'South Sudanese Pound (SSP)',
    'STN': 'São Tomé and Príncipe Dobra (STN)',
    'SYP': 'Syrian Pound (SYP)',
    'SZL': 'Swazi Lilangeni (SZL)',
    'THB': 'Thai Baht (THB)',
    'TJS': 'Tajikistani Somoni (TJS)',
    'TMT': 'Turkmenistani Manat (TMT)',
    'TND': 'Tunisian Dinar (TND)',
    'TOP': 'Tongan Paanga (TOP)',
    'TRY': 'Turkish Lira (TRY)',
    'TTD': 'Trinidad and Tobago Dollar (TTD)',
    'TVD': 'Tuvaluan Dollar (TVD)',
    'TWD': 'New Taiwan Dollar (TWD)',
    'TZS': 'Tanzanian Shilling (TZS)',
    'UAH': 'Ukrainian Hryvnia (UAH)',
    'UGX': 'Ugandan Shilling (UGX)',
    'UYU': 'Uruguayan Peso (UYU)',
    'UZS': 'Uzbekistan Som (UZS)',
    'VES': 'Venezuelan Bolívar (VES)',
    'VND': 'Vietnamese Dong (VND)',
    'VUV': 'Vanuatu Vatu (VUV)',
    'WST': 'Samoan Tala (WST)',
    'XAF': 'Central African CFA Franc (XAF)',
    'XCD': 'East Caribbean Dollar (XCD)',
    'XDR': 'Special Drawing Rights (XDR)',
    'XOF': 'West African CFA Franc (XOF)',
    'XPF': 'CFP Franc (XPF)',
    'YER': 'Yemeni Rial (YER)',
    'ZAR': 'South African Rand (ZAR)',
    'ZMW': 'Zambian Kwacha (ZMW)',
    'ZWL': 'Zimbabwean Dollar (ZWL)',
  };

  @override
  void initState() {
    super.initState();
    fetchExchangeRates();
    _startTimer();
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  void _startTimer() {
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        currentTime =
            DateFormat('yyyy/MM/dd hh:mm:ss a').format(DateTime.now());
      });
    });
  }

  Future<void> fetchExchangeRates() async {
    setState(() {
      isLoading = true;
    });
    final response =
        await http.get(Uri.parse('https://open.er-api.com/v6/latest/NPR'));
    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      setState(() {
        exchangeRates =
            (data['rates'] as Map<String, dynamic>).map((key, value) {
          return MapEntry(key,
              (value is int) ? value.toDouble() : (value as num).toDouble());
        });
      });
    } else {
      print('Failed to fetch exchange rates.');
    }
    setState(() {
      isLoading = false;
    });
  }

String countryCodeToEmoji(String countryCode) {
  countryCode = countryCode.toUpperCase();
  
  int base = 0x1F1E6; 
  int offsetA = 'A'.codeUnitAt(0);
  int firstChar = countryCode.codeUnitAt(0) - offsetA + base;
  int secondChar = countryCode.codeUnitAt(1) - offsetA + base;
  
  return String.fromCharCode(firstChar) + String.fromCharCode(secondChar);
}



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(70),
        child: AppBar(
          backgroundColor: Colors.green,
          elevation: 0,
          centerTitle: true,
          title: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                "X-Change",
                style: TextStyle(
                  color: Colors.white70,
                  fontWeight: FontWeight.bold,
                  fontSize: 23,
                  fontFamily: 'Roboto',
                ),
              ),
              Text(
                currentTime,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                ),
              )
            ],
          ),
        ),
      ),
      body: Container(
        child: Center(
          child: isLoading
              ? const CircularProgressIndicator()
              : Container(
                  height: 500,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Text(
                            'रु.',
                            style: TextStyle(
                                color: Colors.green,
                                fontSize: 30,
                                fontWeight: FontWeight.bold),
                          ),
                          SizedBox(width: 5),
                          Text(
                            result.toStringAsFixed(4),
                            style: const TextStyle(
                              fontSize: 45,
                              fontWeight: FontWeight.bold,
                              color: Colors.green,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 10),
                      //START Here

                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: GestureDetector(
                          onTap: () {
                            showCurrencyPicker(
                              context: context,
                              showFlag: true,
                              showSearchField: true,
                              showCurrencyName: true,
                              showCurrencyCode: true,
                              favorite: ['eur'],
                              onSelect: (Currency currency) {
                                setState(() {
                                  selectedCurrency = currency.code;
                                  currencyIcon = currency.symbol;
                                  _controller.text = '${countryCodeToEmoji(currency.code)} ${currency.code} - ${currency.name}';

                                });
                              },
                            );
                          },
                          child: AbsorbPointer(
                            child: TextFormField(
                              controller: _controller,
                              readOnly: true,
                              decoration: const InputDecoration(
                                labelText: 'Selected Currency',
                                labelStyle: TextStyle(color: Colors.green),
                                suffixIcon: Icon(Icons.arrow_drop_down),
                                border: OutlineInputBorder(
                                  borderSide: BorderSide(
                                      color: Colors.green,
                                      style: BorderStyle.solid),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),

                      //END HERE
                      const SizedBox(height: 5),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 10),
                        child: TextField(
                          controller: _textEditingController,
                          decoration: InputDecoration(
                            hintText: 'Enter '+ selectedCurrency + ' to convert to NPR',
                            prefix: Container(
                              margin: EdgeInsets.only(
                                  right: 5), // Add margin if necessary
                              child: Row(
                                mainAxisSize: MainAxisSize
                                    .min, // Use only the needed space
                                children: [
                                  Text(currencyIcon,
                                      style: TextStyle(
                                        fontSize:
                                            18, // Adjust font size as needed
                                        // Ensure the TextStyle here can support emoji characters
                                      )),
                                  // Any other widgets or text you want to include
                                ],
                              ),
                            ),
                            filled: true,
                            fillColor: Colors.white,
                            focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(color: Colors.green),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderSide: BorderSide(color: Colors.lightGreen),
                            ),
                          ),
                          keyboardType:
                              TextInputType.numberWithOptions(decimal: true),
                        ),
                      ),

                      Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: TextButton(
                          onPressed: () {
                            final amount =
                                double.tryParse(_textEditingController.text) ??
                                    0;

                            setState(() {
                              result = amount /
                                  (exchangeRates[selectedCurrency] ?? 0.0);
                            });
                          },
                          style: TextButton.styleFrom(
                            backgroundColor: Colors.green,
                            foregroundColor: Colors.white,
                            minimumSize: const Size(300, 50),
                          ),
                          child: const Text("Convert"),
                        ),
                      ),
                      //         DropdownButton<CurrencyCode>(
                      //   value: selectedCur,
                      //   onChanged: (value) {
                      //     setState(() {
                      //       selectedCur = value!;
                      //     });
                      //   },
                      //   items: CurrencyCode.values.map((CurrencyCode code) {
                      //     return DropdownMenuItem<CurrencyCode>(
                      //       value: code,
                      //       child: Text(code.toString().split('.').last),
                      //     );
                      //   }).toList(),
                      // ),
                      // Text(
                      //   'Symbol: ${getCurrencySymbolENUM(selectedCur)}',
                      //   style: TextStyle(fontSize: 24),
                      // ),
                      // Center(
                      //   child: ElevatedButton(
                      //     onPressed: () {
                      //       showCurrencyPicker(
                      //         context: context,
                      //         showFlag: true,
                      //         showSearchField: true,
                      //         showCurrencyName: true,
                      //         showCurrencyCode: true,
                      //         favorite: ['eur'],
                      //         onSelect: (Currency currency) {
                      //           Text('Select currency: ${currency.name}');
                      //         },
                      //       );
                      //     },
                      //     child: const Text('Show currency picker'),
                      //   ),
                      // ),
                    ],
                  ),
                ),
        ),
      ),
      bottomNavigationBar: BottomAppBar(
        color: Colors.green,
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 10.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: const [
              Text(
                '© 2024 NUSDR',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
