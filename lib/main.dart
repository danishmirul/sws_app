import 'package:flutter/material.dart';
import 'package:flutter_bluetooth_serial/flutter_bluetooth_serial.dart';
import 'package:sws_app/components/constants.dart';
import 'package:sws_app/router.dart';
import 'package:sws_app/screens/bluetooth/device_list_screen.dart';
import 'package:sws_app/screens/splashscreen/splash_screen.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'SWS Navi',
      theme: ThemeData(
          visualDensity: VisualDensity.adaptivePlatformDensity,
          fontFamily: 'OpenSans',
          scaffoldBackgroundColor: cBackgroundColor,
          textTheme: Theme.of(context).textTheme.apply(bodyColor: cTextColor)),
      debugShowCheckedModeBanner: false,
      onGenerateRoute: generateRoute,
      home: SplashScreen(),

      // home: FutureBuilder(
      //   future: FlutterBluetoothSerial.instance.requestEnable(),
      //   builder: (context, future) {
      //     if (future.connectionState == ConnectionState.waiting) {
      //       return Scaffold(
      //         body: Container(
      //           height: double.infinity,
      //           decoration: BoxDecoration(
      //             gradient: LinearGradient(
      //               colors: [Colors.lightBlue, Colors.purple],
      //               begin: Alignment.bottomLeft,
      //               end: Alignment.topRight,
      //             ),
      //           ),
      //           child: Center(
      //             child: Icon(
      //               Icons.bluetooth_disabled,
      //               size: 200.0,
      //               color: Colors.white70,
      //             ),
      //           ),
      //         ),
      //       );
      //     } else {
      //       return DeviceListScreen();
      //       // return FirebaseAuthService().handleAuth();
      //       // Application();
      //     }
      //   },
      // ),
    );
  }
}
