import 'package:flutter/material.dart';

class MyHeaderDrawer extends StatelessWidget {
  const MyHeaderDrawer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.blueAccent[100],
      width: double.infinity,
      height: 200,
      padding: EdgeInsets.only(top: 20.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            margin: EdgeInsets.only(bottom: 10),
            height: 70,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              image: DecorationImage(image: AssetImage('assets/img/logo.jpg')),
            ),
          ),
          Text(
            './PolloRicoAlCarbonPR',
            style: TextStyle(color: Colors.black),
          )
        ],
      ),
    );
  }
}
