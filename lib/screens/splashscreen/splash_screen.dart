import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart';
import 'package:sws_app/components/constants.dart';
import 'package:sws_app/components/custom_header.dart';
import 'package:sws_app/components/custom_slider.dart';
import 'package:sws_app/screens/bluetooth/request_permission_screen.dart';

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  Size size;

  @override
  Widget build(BuildContext context) {
    size = MediaQuery.of(context).size;

    return Scaffold(
      body: Column(
        children: [
          CustomHeader(size: size),
          Divider(
            height: 2,
            thickness: 2,
            color: cPrimaryColor,
          ),
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [Colors.lightBlue.shade200, Colors.purple.shade400],
                  begin: Alignment.bottomLeft,
                  end: Alignment.topRight,
                ),
              ),
              child: CustomSlider(size: size),
            ),
          ),
          Divider(
            height: 2,
            thickness: 2,
            color: cPrimaryColor,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 30),
            child: InkWell(
              onTap: () => Navigator.push(
                context,
                PageTransition(
                  type: PageTransitionType.fade,
                  child: RequestPermissionScreen(),
                ),
              ),
              child: Container(
                height: 50,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: appGreenColor),
                child: Align(
                  child: Text(
                    "Start",
                    style: TextStyle(
                      color: Colors.white,
                      fontFamily: 'OpenSans',
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
