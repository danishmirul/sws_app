import 'package:flutter/material.dart';
import 'package:sws_app/components/custom_text.dart';

class CustomHeader extends StatelessWidget {
  const CustomHeader({@required this.size, Key key}) : super(key: key);
  final Size size;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: size.height * 0.10,
      width: size.width,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CustomText(
            text: 'Smart Wheelchair System',
            color: Colors.lightBlue.shade900,
            size: 24.0,
            weight: FontWeight.bold,
          ),
        ],
      ),
    );
  }
}
