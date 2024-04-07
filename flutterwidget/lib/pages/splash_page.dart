import 'package:flutter/material.dart';
import 'package:flutterwidget/pages/currency_convertor_ios.dart';
import 'package:flutterwidget/pages/currency_convertor_page.dart';

class SplashPage extends StatefulWidget {
  const SplashPage({super.key});

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
@override
void initState(){
  Future.delayed(const Duration(seconds: 3),(){
    Navigator.
    push(context,MaterialPageRoute(builder: (_)=>const CurrencyConverterMaterialPage()));
    super.initState();

  });
}

  @override
Widget build(BuildContext context) {
  return Scaffold(
    backgroundColor: Colors.white,
    body: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Padding(
          padding: const EdgeInsets.all(10),
          child: Container(
            padding: const EdgeInsets.all(8),
            color: Colors.white,
            child: const Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.euro,
                  color: Colors.green,
                  size: 38,
                ),
                SizedBox(width: 10),
                Text(
                  "X-Change",
                  style: TextStyle(
                    color: Colors.green,
                    fontSize: 38,
                    fontWeight: FontWeight.bold,
                    fontFamily: 'NotoSans',
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    ),
    bottomNavigationBar:BottomAppBar(
      child:Center(child: Text( '© ${DateTime.now().year} NUSDR',style: const TextStyle(color: Colors.green,fontSize: 24,fontWeight: FontWeight.bold),)) )
  );
}


}