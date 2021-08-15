import 'dart:async';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sws_app/components/constants.dart';
import 'package:control_button/control_button.dart';
import 'package:sws_app/components/custom_text.dart';
import 'package:sws_app/components/loading.dart';
import 'package:sws_app/controllers/location_controller.dart';
import 'package:sws_app/controllers/navigation_controller.dart';
import 'package:sws_app/models/coordinate.dart';
import 'package:sws_app/models/direction.dart';
import 'package:sws_app/models/location.dart';
import 'package:sws_app/models/navigation.dart';
import 'package:sws_app/models/wheelchair.dart';
import 'package:sws_app/services/firestore_service.dart';

class _Item {
  String plate;
  Offset center;
  List<Offset> offsets;

  _Item({this.plate, this.center, this.offsets});
}

class SemiAuto extends StatefulWidget {
  SemiAuto(
      {@required this.direction,
      @required this.updateDirection,
      @required this.wheelchair,
      @required this.collided,
      @required this.setSpeed,
      key})
      : super(key: key);
  final Direction direction;
  final Function updateDirection;
  final Wheelchair wheelchair;
  final bool collided;
  final Function setSpeed;

  @override
  _SemiAutoState createState() => _SemiAutoState();
}

class _SemiAutoState extends State<SemiAuto> {
  Timer timer;
  Navigation _navigation;
  _Item item = new _Item();
  bool init = false;
  bool isLoading = false;
  bool isRunning = false;
  NavigationController navigationController =
      NavigationController(firestoreService: FirestoreService());
  LocationController locationController =
      LocationController(firestoreService: FirestoreService());
  int ms = 0;
  String origin, dest;

  @override
  void initState() {
    super.initState();
    print("TEST");
    widget.updateDirection('Stop');
    widget.setSpeed('60', auto: true);
    init = true;
    ms = 0;
    timer = Timer.periodic(Duration(milliseconds: 100), (Timer t) {
      if (_navigation.instruction.isNotEmpty && isRunning && !widget.collided) {
        ms++;

        switch (dest) {
          case 'CR3':
            if (ms < 40)
              widget.updateDirection('Forward');
            else {
              widget.updateDirection('Stop');
              resetRequest();
            }
            break;
          case 'X':
            if (ms < 17)
              widget.updateDirection('Forward');
            else if (ms < 23)
              widget.updateDirection('Right');
            else if (ms < 40)
              widget.updateDirection('Forward');
            else if (ms < 47)
              widget.updateDirection('Left');
            else if (ms < 66)
              widget.updateDirection('Forward');
            else {
              widget.updateDirection('Stop');
              resetRequest();
            }
            break;
          case 'R':
            break;
          default:
        }
      } else
        widget.updateDirection('Stop');
      // if (_navigation.execute) {
      //   widget.updateDirection(_navigation.msg);
      // }
    });
  }

  @override
  void dispose() {
    widget.updateDirection('Stop');
    timer?.cancel();

    Navigation temp = Navigation.copy(_navigation);
    temp.instruction = '';
    temp.request = false;
    navigationController.updateNavigation(temp);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: cDefaultPadding),
        child: isLoading
            ? Loading()
            : SingleChildScrollView(
                scrollDirection: Axis.vertical,
                child: FutureBuilder(
                  future: navigationController
                      .fetchNavigation(widget.wheelchair.uid),
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      if (snapshot.data != null) {
                        return StreamBuilder(
                          stream: navigationController
                              .navigationStream(snapshot.data.uid),
                          builder: (context, snapshot) {
                            if (snapshot.hasData) {
                              _navigation = snapshot.data;
                              extractInstruction();

                              return Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  SizedBox(height: size.height * 0.35),
                                  Align(
                                    alignment: Alignment.center,
                                    child: Column(
                                      children: [
                                        Text(
                                          _navigation.request
                                              ? "Instruction"
                                              : "Request is disabled, turn on the request",
                                          style: TextStyle(
                                              fontSize: 36.0,
                                              color: cPrimaryColor),
                                          textAlign: TextAlign.center,
                                        ),
                                        Text(
                                          _navigation.request
                                              ? _navigation.instruction.isEmpty
                                                  ? 'Waiting for instruction...'
                                                  : _navigation.instruction
                                              : '',
                                          style: TextStyle(
                                              fontSize: 30.0,
                                              color: cSecondaryColor),
                                        ),
                                        _navigation.instruction.isNotEmpty
                                            ? Container(
                                                child: Column(
                                                  children: [
                                                    Text(
                                                      'MSG: ${_navigation.msg}',
                                                      style: TextStyle(
                                                          fontSize: 36.0,
                                                          color:
                                                              cSecondaryColor),
                                                    ),
                                                    Text(
                                                      widget.direction.label,
                                                      style: TextStyle(
                                                          fontSize: 36.0,
                                                          color: widget
                                                              .direction.color),
                                                    ),
                                                    Container(
                                                      height: size.width * 0.7,
                                                      width: size.width * 0.7,
                                                      decoration: BoxDecoration(
                                                        image: DecorationImage(
                                                          image: AssetImage(
                                                              widget.direction
                                                                  .asset),
                                                          colorFilter:
                                                              ColorFilter.mode(
                                                                  widget
                                                                      .direction
                                                                      .color,
                                                                  BlendMode
                                                                      .modulate),
                                                        ),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              )
                                            : Container(),
                                        SizedBox(height: 50),
                                        TextButton(
                                          onPressed: () async {
                                            if (_navigation.request)
                                              await resetRequest();
                                            else
                                              await enableRequest();
                                          },
                                          child: Container(
                                            height: 50,
                                            width: 50,
                                            child: Icon(
                                              Icons.power_settings_new,
                                              size: 40,
                                              color: _navigation.request
                                                  ? Colors.red
                                                  : cSecondaryColor,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              );
                            }
                            return Loading();
                          },
                        );
                      }
                      if (init) {
                        createNavigation();
                        init = false;
                      }
                    }
                    return Loading();
                  },
                ),
              ),
      ),
    );
  }

  Future createNavigation() async {
    Navigation temp = Navigation(
        wheelchairID: widget.wheelchair.uid, request: false, execute: false);
    bool status = await navigationController.createNavigation(temp);
    if (status)
      setState(() {});
    else
      return Text(
        'Initializing new navigation request failed.',
        style: TextStyle(fontSize: 36.0, color: Colors.red),
      );
  }

  Future enableRequest() async {
    Navigation temp = Navigation.copy(_navigation);
    temp.instruction = '';
    temp.request = true;

    setState(() => isLoading = true);
    await navigationController.updateNavigation(temp);
    setState(() => isLoading = false);
  }

  Future resetRequest() async {
    Navigation temp = Navigation.copy(_navigation);
    temp.instruction = '';
    temp.console = '';
    temp.execute = false;
    temp.request = false;

    setState(() => isLoading = true);
    widget.updateDirection('Stop');
    await navigationController.updateNavigation(temp);
    setState(() {
      isLoading = false;
      isRunning = false;
      ms = 0;
    });
  }

  void extractInstruction() {
    if (_navigation.instruction.isNotEmpty && !isRunning) {
      String instruction = _navigation.instruction;
      if (instruction.contains('-')) {
        List<String> place = instruction.split('-');
        setState(() {
          origin = place[0];
          dest = place[1];
          isRunning = true;
        });
      }
    }
  }
}
