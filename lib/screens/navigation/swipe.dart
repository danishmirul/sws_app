import 'package:flutter/material.dart';
import 'package:swipedetector/swipedetector.dart';
import 'package:sws_app/components/constants.dart';
import 'package:sws_app/models/direction.dart';

class Swipe extends StatefulWidget {
  Swipe({@required this.direction, @required this.updateDirection, Key key})
      : super(key: key);
  final Direction direction;
  final Function updateDirection;

  @override
  _SwipeState createState() => _SwipeState();
}

class _SwipeState extends State<Swipe> {
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
            Spacer(),
            Container(
              height: size.height * 0.5,
              width: size.width,
              child: SwipeDetector(
                child: Card(
                  child: Padding(
                    padding: EdgeInsets.all(cDefaultPadding),
                    child: Container(
                      decoration: BoxDecoration(color: widget.direction.color),
                      padding: EdgeInsets.all(cDefaultPadding),
                      child: Center(
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: <Widget>[
                            Image.asset(widget.direction.asset),
                            Text(
                              'Swipe Here!',
                              style: TextStyle(
                                fontSize: 40.0,
                              ),
                            ),
                            Text(
                              widget.direction.label,
                              style: TextStyle(
                                fontSize: 30.0,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
                onSwipeUp: () => widget.updateDirection('Forward'),
                onSwipeDown: () => widget.updateDirection('Stop'),
                onSwipeLeft: () => widget.updateDirection('Left'),
                onSwipeRight: () => widget.updateDirection('Right'),
                swipeConfiguration: SwipeConfiguration(
                    verticalSwipeMinVelocity: 100.0,
                    verticalSwipeMinDisplacement: 50.0,
                    verticalSwipeMaxWidthThreshold: 100.0,
                    horizontalSwipeMaxHeightThreshold: 50.0,
                    horizontalSwipeMinDisplacement: 50.0,
                    horizontalSwipeMinVelocity: 200.0),
              ),
            ),
            Spacer(),
          ],
        ),
      ),
    );
  }
}
