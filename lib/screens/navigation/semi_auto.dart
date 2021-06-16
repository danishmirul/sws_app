import 'dart:async';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sws_app/components/constants.dart';
import 'package:control_button/control_button.dart';
import 'package:sws_app/components/loading.dart';
import 'package:sws_app/controllers/navigation_controller.dart';
import 'package:sws_app/models/direction.dart';
import 'package:sws_app/models/navigation.dart';
import 'package:sws_app/models/wheelchair.dart';
import 'package:sws_app/services/firestore_service.dart';

class SemiAuto extends StatefulWidget {
  SemiAuto(
      {@required this.direction,
      @required this.updateDirection,
      @required this.wheelchair,
      key})
      : super(key: key);
  final Direction direction;
  final Function updateDirection;
  final Wheelchair wheelchair;

  @override
  _SemiAutoState createState() => _SemiAutoState();
}

class _SemiAutoState extends State<SemiAuto> {
  Timer timer;
  Navigation _navigation;
  bool init = false;
  bool isLoading = false;
  bool isRunning = false;
  NavigationController navigationController =
      NavigationController(firestoreService: FirestoreService());

  @override
  void initState() {
    super.initState();
    widget.updateDirection('Stop');
    init = true;
    timer = Timer.periodic(Duration(seconds: 1), (Timer t) => runInstruction());
  }

  @override
  void dispose() {
    widget.updateDirection('Stop');
    timer?.cancel();
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
            : FutureBuilder(
                future:
                    navigationController.fetchNavigation(widget.wheelchair.uid),
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    if (snapshot.data['status']) {
                      return StreamBuilder(
                        stream: navigationController
                            .navigationStream(snapshot.data['data'].uid),
                        builder: (context, snapshot) {
                          if (snapshot.hasData) {
                            _navigation = snapshot.data;

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
                                      _navigation.request
                                          ? Text(
                                              _navigation.instruction.isEmpty
                                                  ? 'Waiting for instruction...'
                                                  : _navigation.instruction,
                                              style: TextStyle(
                                                  fontSize: 30.0,
                                                  color: cSecondaryColor),
                                            )
                                          : Container(),
                                      _navigation.instruction.isNotEmpty
                                          ? Text(
                                              widget.direction.label,
                                              style: TextStyle(
                                                  fontSize: 36.0,
                                                  color:
                                                      widget.direction.color),
                                            )
                                          : Container(),
                                      _navigation.instruction.isNotEmpty
                                          ? Container(
                                              height: size.width * 0.2,
                                              width: size.width * 0.2,
                                              decoration: BoxDecoration(
                                                image: DecorationImage(
                                                  image: AssetImage(
                                                      widget.direction.asset),
                                                  colorFilter: ColorFilter.mode(
                                                      widget.direction.color,
                                                      BlendMode.modulate),
                                                ),
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
                                          height: size.width * 0.2,
                                          width: size.width * 0.2,
                                          child: Icon(
                                            Icons.power_settings_new,
                                            size: size.width * 0.2,
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
    );
  }

  Future createNavigation() async {
    Navigation temp = Navigation(
        wheelchairID: widget.wheelchair.uid, instruction: '', request: false);
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
    temp.request = false;

    setState(() => isLoading = true);
    widget.updateDirection('Stop');
    await navigationController.updateNavigation(temp);
    setState(() {
      isLoading = false;
      isRunning = false;
    });
  }

  void runInstruction() {
    if (_navigation.instruction.isNotEmpty && !isRunning) {
      String instruction = _navigation.instruction;
      print('instruction: $instruction');
      if (instruction.contains('-')) {
        List<String> place = instruction.split('-');
        print('origin: ${place[0]}');
        print('destination: ${place[1]}');
        setState(() => isRunning = true);
        widget.updateDirection('Forward');
      }
    }
  }
}
