import 'package:flutter/material.dart';
import 'package:sws_app/components/constants.dart';
import 'package:control_button/control_button.dart';
import 'package:sws_app/models/direction.dart';

class DPad extends StatefulWidget {
  DPad({@required this.direction, @required this.updateDirection, key})
      : super(key: key);
  final Direction direction;
  final Function updateDirection;

  @override
  _DPadState createState() => _DPadState();
}

class _DPadState extends State<DPad> {
  @override
  void initState() {
    super.initState();
    widget.updateDirection('Stop');
  }

  @override
  void dispose() {
    widget.updateDirection('Stop');
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: cDefaultPadding),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: size.height * 0.35),
            Align(
              alignment: Alignment.center,
              child: Column(
                children: [
                  Text(
                    widget.direction.label,
                    style: TextStyle(
                        fontSize: 36.0, color: widget.direction.color),
                  ),
                  Container(
                    height: size.width * 0.2,
                    width: size.width * 0.2,
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        image: AssetImage(widget.direction.asset),
                        colorFilter: ColorFilter.mode(
                            widget.direction.color, BlendMode.modulate),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Spacer(),
            Align(
              alignment: Alignment.center,
              child: ControlButton(
                sectionOffset: FixedAngles.Inclined45,
                externalDiameter: 300,
                internalDiameter: 120,
                dividerColor: Colors.blue,
                elevation: 2,
                externalColor: Colors.lightBlueAccent,
                internalColor: Colors.red[500],
                mainAction: () => widget.updateDirection('Stop'),
                sections: [
                  () => widget.updateDirection('Right'),
                  () => widget.updateDirection('Forward'),
                  () => widget.updateDirection('Left'),
                  () => widget.updateDirection('Backward')
                ],
              ),
            ),
            Spacer(),
          ],
        ),
      ),
    );
  }
}
