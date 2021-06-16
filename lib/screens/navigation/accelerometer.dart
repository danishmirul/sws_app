import 'dart:async';

import 'package:flutter/material.dart';
import 'package:sensors/sensors.dart';
import 'package:sws_app/components/constants.dart';
import 'package:sws_app/models/direction.dart';

class Accelerometer extends StatefulWidget {
  Accelerometer(
      {@required this.direction, @required this.updateDirection, Key key})
      : super(key: key);
  final Direction direction;
  final Function updateDirection;

  @override
  _AccelerometerState createState() => _AccelerometerState();
}

class _AccelerometerState extends State<Accelerometer> {
  // event returned from accelerometer stream
  AccelerometerEvent event;

  // hold a refernce to these, so that they can be disposed
  Timer timer;
  StreamSubscription accel;

  // color of the circle
  Color color = Colors.greenAccent;

  // positions and count
  double top = 125;
  double left;
  int _marginError = 10;
  int count = 0;

  // variables for screen size
  double width;
  double height;

  setColor(AccelerometerEvent event) {
    // Calculate Left
    double x = ((event.x * 12) + ((width - 100) / 2));
    // Calculate Top
    double y = event.y * 12 + 125;

    // find the difference from the target position
    var xDiff = x.abs() - ((width - 100) / 2);
    var yDiff = y.abs() - 125;

    // check if the circle is centered, currently allowing a buffer of 3 to make centering easier
    if (xDiff.abs() < _marginError && yDiff.abs() < _marginError) {
      // set the color and increment count
      setState(() {
        color = Colors.greenAccent;
        count += 1;
      });
    } else {
      // set the color and restart count
      setState(() {
        color = Colors.red;
        count = 0;
      });
    }
  }

  setPosition(AccelerometerEvent event) {
    if (event == null) {
      return;
    }

    double _left = ((-event.x * 12) + ((width - 100) / 2));
    double _top = event.y * 12 + 125;

    // When x = 0 it should be centered horizontally
    // The left positin should equal (width - 100) / 2
    // The greatest absolute value of x is 10, multipling it by 12 allows the left position to move a total of 120 in either direction.

    // When y = 0 it should have a top position matching the target, which we set at 125

    if (event.y < -0.5 && event.x > -2.0 && event.x < 2.0) {
      widget.updateDirection('Forward');
    } else if (event.y > 0.5 && event.x > -2.0 && event.x < 2.0) {
      widget.updateDirection('Backward');
    } else if (event.x < -0.5 && event.y > -0.5) {
      widget.updateDirection('Right');
    } else if (event.x > 0.5 && event.y > -0.5) {
      widget.updateDirection('Left');
    }

    setState(() {
      top = _top;
      left = _left;
    });
  }

  startTimer() {
    // if the accelerometer subscription hasn't been created, go ahead and create it
    if (accel == null) {
      accel = accelerometerEvents.listen((AccelerometerEvent eve) {
        setState(() {
          event = eve;
        });
      });
    } else {
      // it has already ben created so just resume it
      accel.resume();
    }

    // Accelerometer events come faster than we need them so a timer is used to only proccess them every 200 milliseconds
    if (timer == null || !timer.isActive) {
      timer = Timer.periodic(Duration(milliseconds: 200), (_) {
        // if count has increased greater than 3 call pause timer to handle success
        if (count > 3) {
          pauseTimer();
        } else {
          // proccess the current event
          setColor(event);
          setPosition(event);
        }
      });
    }
  }

  pauseTimer() {
    // stop the timer and pause the accelerometer stream
    timer.cancel();
    accel.pause();

    // set the success color and reset the count
    setState(() {
      count = 0;
      color = Colors.green;
      widget.updateDirection('Stop');
    });
  }

  @override
  void initState() {
    super.initState();
    widget.updateDirection('Stop');
  }

  @override
  void dispose() {
    timer?.cancel();
    accel?.cancel();
    widget.updateDirection('Stop');
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    height = size.height;
    width = size.width;

    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: cDefaultPadding),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Spacer(),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Text(
                    'x: ${(event != null ? event.x ?? 0 : 0).toStringAsFixed(3)}'),
                Text(
                    'y: ${(event != null ? event?.y ?? 0 : 0).toStringAsFixed(3)}'),
                Padding(
                  padding:
                      EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                  child: RaisedButton(
                    onPressed: startTimer,
                    child: Text('Begin'),
                    color: Theme.of(context).primaryColor,
                    textColor: Colors.white,
                  ),
                ),
              ],
            ),
            Align(
              alignment: Alignment.center,
              child: Column(
                children: [
                  Text(
                    'Direction',
                    style: TextStyle(fontSize: 24.0),
                  ),
                  Container(
                    child: ColorFiltered(
                      child: Image.asset(widget.direction.asset),
                      colorFilter: ColorFilter.mode(
                          widget.direction.color, BlendMode.modulate),
                    ),
                  ),
                  Text(
                    widget.direction != null ? widget.direction.label : '',
                    style: TextStyle(
                        fontSize: 24.0, color: widget.direction.color),
                  ),
                ],
              ),
            ),
            Stack(
              children: [
                // This empty container is given a width and height to set the size of the stack
                Container(
                  height: height / 2,
                  width: width,
                ),

                // Create the outer target circle wrapped in a Position
                Positioned(
                  // positioned 50 from the top of the stack
                  // and centered horizontally, left = (ScreenWidth - Container width) / 2
                  top: 50,
                  left: (width - 250) / 2,
                  child: Container(
                    height: 250,
                    width: 250,
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.red, width: 2.0),
                      borderRadius: BorderRadius.circular(125),
                    ),
                  ),
                ),
                // This is the colored circle that will be moved by the accelerometer
                // the top and left are variables that will be set
                Positioned(
                  top: top,
                  left: left ?? (width - 100) / 2,
                  // the container has a color and is wrappeed in a ClipOval to make it round
                  child: ClipOval(
                    child: Container(
                      width: 100,
                      height: 100,
                      color: color,
                    ),
                  ),
                ),
                // inner target circle wrapped in a Position
                Positioned(
                  top: 125,
                  left: (width - 100) / 2,
                  child: Container(
                    height: 100,
                    width: 100,
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.green, width: 2.0),
                      borderRadius: BorderRadius.circular(50),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
