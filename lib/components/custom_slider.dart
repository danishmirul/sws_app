import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:sws_app/components/constants.dart';
import 'package:sws_app/components/custom_text.dart';
import 'package:sws_app/components/fade_animation.dart';

class CustomSlider extends StatelessWidget {
  const CustomSlider({Key key, @required this.size}) : super(key: key);
  final Size size;

  final List<String> images = const [
    'assets/images/wheelchair-01.png',
    'assets/images/financial-analytics.png',
    'assets/images/cloud.png'
  ];

  final List<String> titles = const [
    'Care and Independent',
    'Monitor Wheelchair',
    'Save Information'
  ];

  final List<String> subtitles = const [
    "Moving around by your own",
    "View the information of the wheelchair",
    "Save the information through cloud"
  ];

  @override
  Widget build(BuildContext context) {
    return CarouselSlider.builder(
      itemCount: images.length,
      options: CarouselOptions(
        height: 300,
        viewportFraction: 1.0,
        aspectRatio: 1.0,
        autoPlay: true,
        enlargeCenterPage: false,
      ),
      itemBuilder: (context, index, realIndex) {
        return Container(
          width: size.width,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              FadeAnimation(
                1.3,
                CustomText(
                  text: titles[index],
                  size: 24.0,
                  weight: FontWeight.w900,
                  color: cTextColor,
                ),
              ),
              FadeAnimation(
                1.5,
                CustomText(
                  text: subtitles[index],
                  size: 18.0,
                  weight: FontWeight.w600,
                  color: cTextColor,
                ),
              ),
              FadeAnimation(
                1.0,
                Container(
                  height: 200,
                  width: size.width,
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      image: AssetImage(images[index]),
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
