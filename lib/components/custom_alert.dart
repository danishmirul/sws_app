import 'package:flutter/material.dart';

class CustomAlert extends StatelessWidget {
  final String text;
  final String type;
  final double height;
  final double width;
  final bool show;
  final double fontSize;
  final Color fontColor;
  final FontWeight weight;

  CustomAlert({
    @required this.text,
    this.type,
    this.height,
    this.width,
    this.fontColor,
    this.fontSize,
    this.weight,
    this.show = false,
  });

  @override
  Widget build(BuildContext context) {
    Color _color = Colors.lightBlue;
    switch (type) {
      case 'primary':
        _color = Colors.lightBlue;
        break;
      case 'warning':
        _color = Colors.orange;
        break;
      case 'danger':
        _color = Colors.red;
        break;
      default:
        _color = Colors.lightBlue;
    }
    return show
        ? LayoutBuilder(
            builder: (BuildContext context, BoxConstraints constraints) {
              return Padding(
                padding: const EdgeInsets.all(0),
                child: Container(
                  height: height ?? 50,
                  width: constraints.maxWidth,
                  decoration: BoxDecoration(
                    color: _color,
                    borderRadius: BorderRadius.all(Radius.circular(8)),
                    boxShadow: [
                      BoxShadow(
                          color: Colors.grey[300],
                          offset: Offset(0, 3),
                          blurRadius: 16)
                    ],
                  ),
                  child: Container(
                    height: (height ?? 50) - 16.0,
                    width: constraints.maxWidth - 16.0,
                    decoration: BoxDecoration(
                      color: _color,
                      borderRadius: BorderRadius.all(Radius.circular(8)),
                      border: Border.all(color: _color),
                    ),
                    child: Center(
                      child: Text(
                        text,
                        style: TextStyle(
                            fontFamily: 'OpenSans',
                            fontSize: fontSize ?? 16,
                            color: fontColor ?? Colors.white,
                            fontWeight: weight ?? FontWeight.normal),
                      ),
                    ),
                  ),
                ),
              );
            },
          )
        : Container();
  }
}
