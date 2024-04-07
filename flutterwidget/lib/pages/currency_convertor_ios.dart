import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'dart:async';
import 'dart:convert';

class CurrenyCunvertorCupertinoPage extends StatefulWidget {
  const CurrenyCunvertorCupertinoPage({Key? key});

  @override
  State<CurrenyCunvertorCupertinoPage> createState() =>
      _CurrenyCunvertorCupertinoPageState();
}

class _CurrenyCunvertorCupertinoPageState
    extends State<CurrenyCunvertorCupertinoPage> {
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
        currentTime =
            DateFormat('yyyy/MM/dd HH:mm:ss').format(DateTime.now());
      });
    });
  }

  Future<void> fetchExchangeRates() async {
    setState(() {
      isLoading = true;
    });
    final response = await http.get(Uri.parse(
        'https://open.er-api.com/v6/latest/USD'));
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
    return CupertinoPageScaffold(
      backgroundColor: CupertinoColors.white,
      navigationBar: CupertinoNavigationBar(
        backgroundColor: CupertinoColors.activeGreen,
        middle: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
           const SizedBox(height: 1),
            const Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Icon(
                  CupertinoIcons.money_dollar,
                  color: CupertinoColors.white,
                  size: 14,
                ),
                Text(
                  "Currency Converter",
                  style: TextStyle(
                    color: CupertinoColors.white,
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
              style: const TextStyle(
                color: CupertinoColors.white,
                fontSize: 14,
              ),
            )
          ],
        ),
      ),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(
                  CupertinoIcons.money_dollar,
                  color: CupertinoColors.activeGreen,
                  size: 45,
                ),
               const SizedBox(width: 5),
                Text(
                  result.toStringAsFixed(4),
                  style: const TextStyle(
                    fontSize: 45,
                    fontWeight: FontWeight.bold,
                    color: CupertinoColors.activeGreen,
                  ),
                ),
              ],
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              margin:const EdgeInsets.symmetric(vertical: 10),
              child: CupertinoTextField(
                style: const TextStyle(
                  color: CupertinoColors.black,
                  fontSize: 15,
                ),
                controller: _textEditingController,
                placeholder: 'Enter currency in NPR',
                placeholderStyle:const TextStyle(color: CupertinoColors.lightBackgroundGray),
                prefix: const Padding(
                  padding:  EdgeInsets.all(8.0),
                  child: Text(
                    'रु.',
                    style: TextStyle(color: CupertinoColors.activeGreen, fontSize: 24),
                  ),
                ),
                keyboardType:const TextInputType.numberWithOptions(
                  decimal: true,
                  signed: true,
                ),
                decoration: BoxDecoration(
                  color: CupertinoColors.white,
                  border: Border.all(color: CupertinoColors.lightBackgroundGray),
                  borderRadius: BorderRadius.circular(5),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: CupertinoButton(
                onPressed: () {
                  setState(() {
                    double amount =
                        double.parse(_textEditingController.text);
                    result = amount / exchangeRates['NPR']!;
                  });
                },
                color: CupertinoColors.activeGreen,
                child: const Text("Convert",),
                
              ),
            ),
          ],
        ),
        
      ),
      
    );
  }
}
