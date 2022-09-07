import 'package:caja/screens/delivery.dart';
import 'package:flutter/material.dart';
import 'package:caja/widgets/home.dart';
import 'package:caja/screens/assign.dart';
import 'package:caja/screens/poducts_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Proyecto Caja',
      debugShowCheckedModeBanner: false,
      // home: Home(),
      initialRoute: "/",
      routes: {
        "/": (BuildContext context) => Home(),
        "/assign": (BuildContext context) => Assign(),
        "/products_screen": (BuildContext context) => ProductScreen(),
        "/delivery": (BuildContext context) => Delivery()
      },
    );
  }
}
