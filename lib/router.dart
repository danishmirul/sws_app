import 'package:flutter/material.dart';
import 'package:sws_app/components/routes.dart';
import 'package:sws_app/main.dart';
import 'package:sws_app/screens/main/main_screen.dart';

Route<dynamic> generateRoute(RouteSettings settings) {
  switch (settings.name) {
    case homeRoute:
      // return MaterialPageRoute(builder: (context) => HomeScreen());
      return MaterialPageRoute(builder: (context) => MyApp());
    case homeRoute:
      return MaterialPageRoute(builder: (context) => MyApp());
    // case 'login':
    //   return MaterialPageRoute(builder: (context) => LoginView());
    default:
      return MaterialPageRoute(builder: (context) => MainScreen());
  }
}
