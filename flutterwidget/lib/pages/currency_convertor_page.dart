import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'dart:async';

class CurrencyConvertorMaterialPage extends StatefulWidget {
  const CurrencyConvertorMaterialPage({Key? key}) : super(key: key);

  @override
  State<CurrencyConvertorMaterialPage> createState() =>
      _CurrencyConvertorMaterialPage();
}

class _CurrencyConvertorMaterialPage
    extends State<CurrencyConvertorMaterialPage> {
  double result = 0;
  final TextEditingController _textEditingController =
      TextEditingController();
  late Map<String, double> exchangeRates;
  bool isLoading = false;
  late Timer _timer;
  String currentTime = DateFormat('yyyy/MM/dd HH:mm:ss').format(DateTime.now());

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
    _timer = Timer.periodic(Duration(seconds: 1), (timer) {
      setState(() {
        currentTime = DateFormat('yyyy/MM/dd HH:mm:ss').format(DateTime.now()); // Update current time every second
      });
    });
  }

  Future<void> fetchExchangeRates() async {
    setState(() {
      isLoading = true;
    });
    final response = await http.get(Uri.parse(
        'https://open.er-api.com/v6/latest/USD')); // Fetch exchange rates against USD
    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      setState(() {
        exchangeRates = Map<String, double>.from(data['rates']);
        isLoading = false;
      });
    } else {
      throw Exception('Failed to load exchange rates');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white60,
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(70),
        child: AppBar(
          backgroundColor: Colors.green,
          elevation: 0,
          centerTitle: true,
          title:  Column(
            mainAxisAlignment: MainAxisAlignment.center,
        
            crossAxisAlignment: CrossAxisAlignment.center,
            
            children: [
               const SizedBox(height: 1),
                 const Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                   children: [
                         Icon(
                             Icons.monetization_on_outlined, // Icon to be appended
                             color: Colors.white54,
                             size:40
                       
                           ),
                           Text(
                         "Currency Converter",
                           style: TextStyle(
                           color: Colors.white70,
                           fontWeight: FontWeight.bold,
                           fontSize: 23,
                           fontFamily: 'Roboto',
                           ),
                      ),
        
                      ],
                 ),           
              const SizedBox(height: 0.2),
              Text(
                currentTime,
                style : const TextStyle(
                  color :Colors.white,
                  fontSize:20,
                )
              )
        
            ],
          ),
        ),
      ),
      body: Center(
        child: isLoading
            ? CircularProgressIndicator() // Show loading indicator while fetching exchange rates
            : Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(
                        Icons.attach_money,
                        color: Colors.green,
                        size: 45,
                      ),
                      const SizedBox(width: 5),
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
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    margin: const EdgeInsets.symmetric(vertical: 10),
                    child: TextField(
                      style: const TextStyle(
                        color: Colors.black,
                        fontSize: 15,
                      ),
                      controller: _textEditingController,
                      decoration: InputDecoration(
                        hintText:
                            'कृपया नेपाली रुपैयाँमा मुद्रा प्रविष्ट गर्नुहोस्',
                        hintStyle: const TextStyle(color: Colors.lightGreen),
                        prefixIcon: const Text(
                          '  रु.',
                          style: TextStyle(color: Colors.green, fontSize: 24),
                        ),
                        prefixIconColor: const Color.fromARGB(255, 63, 220, 5),
                        floatingLabelBehavior: FloatingLabelBehavior.auto,
                        filled: true,
                        fillColor: Colors.white,
                        focusedBorder: OutlineInputBorder(
                          borderSide: const BorderSide(
                            color: Colors.green,
                            width: 2,
                            style: BorderStyle.solid,
                            strokeAlign: BorderSide.strokeAlignCenter,
                          ),
                          borderRadius: BorderRadius.circular(5),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderSide: const BorderSide(
                            color: Colors.lightGreen,
                            width: 3,
                            style: BorderStyle.solid,
                            strokeAlign: BorderSide.strokeAlignCenter,
                          ),
                          borderRadius: BorderRadius.circular(5),
                        ),
                      ),
                      keyboardType: const TextInputType.numberWithOptions(
                        decimal: true,
                        signed: true,
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: TextButton(
                      onPressed: () {
                        setState(() {
                          double amount =
                              double.parse(_textEditingController.text);
                          // Convert the entered amount using the selected currency exchange rate
                          result = amount / exchangeRates['NPR']!; // Convert to NPR
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
                ],
              ),
      ),
      bottomNavigationBar: BottomAppBar(
        color: Colors.green,
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 10.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                '© ${DateTime.now().year} NUSDR',
                style: const TextStyle(
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
