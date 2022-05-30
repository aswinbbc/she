import 'package:she/pages/home_page.dart';
import 'package:she/pages/login.dart';
import 'package:she/pages/message_page.dart';
import 'package:flutter/material.dart';
import 'package:she/utils/constant.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        fontFamily: 'Poppins',
      ),
      home: FutureBuilder(
        future: Constants.UserId,
        builder: (context, snapshot) {
          if (snapshot.data != "0") {
            return HomePage();
          } else {
            return const SimpleLoginScreen();
          }
        },
      ),
    );
  }
}
