import 'package:flutter/material.dart';
import 'package:sws_app/components/constants.dart';
import 'package:sws_app/components/custom_text.dart';

class DetailCard extends StatelessWidget {
  final String data;
  final String title;
  final Color color;
  const DetailCard({Key key, this.title, this.data, this.color})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0),
      child: Container(
        width: 200,
        padding: EdgeInsets.all(cDefaultPadding),
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(12.0),
          boxShadow: [
            BoxShadow(color: color, offset: Offset(0, 3), blurRadius: 24)
          ],
        ),
        child: Column(
          children: [
            Container(
              height: 25.0,
              width: 25.0,
              padding: EdgeInsets.all(8.0),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white,
              ),
              child: Container(
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.transparent,
                  border: Border.all(color: color, width: 2.0),
                ),
              ),
            ),
            SizedBox(height: cDefaultPadding * 0.5),
            CustomText(
              text: '$data',
              size: 18.0,
              color: Colors.white,
              weight: FontWeight.bold,
            ),
            CustomText(text: '$title', size: 12.0, color: Colors.white),
          ],
        ),
      ),
    );
  }
}
