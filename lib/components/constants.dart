import 'package:flutter/material.dart';

// Colors
const appAccentColor = Color(0xFF003480); //0076A8
const appDarkAccentColor = Color(0xFF00204F);
const appLightAccentColor = Color(0xFF81D2E5);

const appGreenColor = Color(0xFF06A75A);
const appRedColor = Color(0xFFA80011);
const appVioletColor = Color(0xFF8182D0);
const appAmberColor = Color(0xFFFFBD82);

const lPrimaryColor = Colors.lightBlue;
const lSecondaryColor = Color(0xFF003480);
const lBackgroundColor = Color(0xFFF9F8FD);
const lAccentColor = Colors.white;
const lTextColor = Colors.white;

const dPrimaryColor = Colors.black;
const dSecondaryColor = Color(0xFF3C4046);
const dBackgroundColor = Color(0xFF191A1C);
const dAccentColor = Color(0xFF3C4046);
const dTextColor = Colors.white;

Color cPrimaryColor = lPrimaryColor;
Color cSecondaryColor = lSecondaryColor;
Color cBackgroundColor = lBackgroundColor;
Color cAccentColor = lTextColor;
Color cTextColor = lTextColor;

void setaAppThemeColor(bool onDarkMode) {
  if (onDarkMode) {
    cPrimaryColor = dPrimaryColor;
    cSecondaryColor = dSecondaryColor;
    cBackgroundColor = dBackgroundColor;
    cAccentColor = dAccentColor;
    cTextColor = dTextColor;
  } else {
    cPrimaryColor = lPrimaryColor;
    cSecondaryColor = lSecondaryColor;
    cBackgroundColor = lBackgroundColor;
    cAccentColor = lAccentColor;
    cTextColor = lTextColor;
  }
}

// Paddings
const double cDefaultPadding = 20.0;
