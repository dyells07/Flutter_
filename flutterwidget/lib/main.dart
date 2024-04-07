import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/widgets.dart';
import 'package:flutterwidget/pages/splash_page.dart';
import '/pages/currency_convertor_page.dart';
import './pages/currency_convertor_ios.dart';

void main() {
  runApp(const MyApp());
}
//Types of Widgets
//1. StateWidgets
//2.StateFul
//3.Inherited


class MyApp extends StatelessWidget{
  const MyApp({super.key});
  @override
  Widget build(BuildContext context){
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: SplashPage(),

    );
  }
}


// class MyCupertinoApp extends StatelessWidget {
//   const MyCupertinoApp({Key? key});

//   @override
//   Widget build(BuildContext context) {
//     return const CupertinoApp(
//       home: CurrenyCunvertorCupertinoPage(),
//     );
//   }
// }
