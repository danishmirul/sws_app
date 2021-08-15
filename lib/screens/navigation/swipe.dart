import 'package:flutter/material.dart';
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

  //Vertical drag details
  DragStartDetails startVerticalDragDetails;
  DragUpdateDetails updateVerticalDragDetails;

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
              child: GestureDetector(
                onVerticalDragStart: (dragDetails) {
                  startVerticalDragDetails = dragDetails;
                },
                onVerticalDragUpdate: (dragDetails) {
                  updateVerticalDragDetails = dragDetails;
                },
                onVerticalDragEnd: (endDetails) {
                  double dx = updateVerticalDragDetails.globalPosition.dx -
                      startVerticalDragDetails.globalPosition.dx;
                  double dy = updateVerticalDragDetails.globalPosition.dy -
                      startVerticalDragDetails.globalPosition.dy;
                  double velocity = endDetails.primaryVelocity;

                  // //Convert values to be positive
                  // print('SWIPE dx $dx');
                  // print('SWIPE dy $dy');
                  // print('SWIPE velocity $velocity');

                  // if (dx < 0) dx = -dx;
                  // if (dy < 0) dy = -dy;

                  if (velocity < 0) {
                    widget.updateDirection('Forward');
                  } else if (velocity > 0) {
                    widget.updateDirection('Stop');
                  } else {
                    if (dx > 0) {
                      widget.updateDirection('Right');
                    } else {
                      widget.updateDirection('Left');
                    }
                  }
                },
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
              ),
            ),
            Spacer(),
          ],
        ),
      ),
    );
  }
}
