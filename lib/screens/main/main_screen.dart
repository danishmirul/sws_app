import 'dart:async';
import 'dart:convert';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:flutter_bluetooth_serial/flutter_bluetooth_serial.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:sws_app/components/constants.dart';
import 'package:sws_app/components/custom_clipper.dart';
import 'package:sws_app/components/custom_text.dart';
import 'package:sws_app/models/direction.dart';
import 'package:sws_app/models/message.dart';
import 'package:sws_app/models/wheelchair.dart';
import 'package:sws_app/screens/main/console.dart';
import 'package:sws_app/screens/main/dashboard.dart';
import 'package:sws_app/screens/navigation/accelerometer.dart';
import 'package:sws_app/screens/navigation/dpad.dart';
import 'package:sws_app/screens/navigation/semi_auto.dart';
import 'package:sws_app/screens/navigation/swipe.dart';
import 'package:sws_app/screens/navigation/voice.dart';
import 'package:sws_app/screens/support/support.dart';
import 'package:sws_app/services/firestore_service.dart';

class MainScreen extends StatefulWidget {
  final BluetoothDevice server;
  final Wheelchair wheelchair;

  const MainScreen({this.server, this.wheelchair});

  @override
  _MainScreen createState() => new _MainScreen();
}

class _MainScreen extends State<MainScreen> {
  Timer timer;
  Wheelchair _wheelchair;
  static final clientID = 0;
  BluetoothConnection connection;

  List<Message> messages = [];
  // String _messageBuffer = '';

  final TextEditingController textEditingController =
      new TextEditingController();
  final ScrollController listScrollController = new ScrollController();

  bool isConnecting = true;
  bool get isConnected => connection != null && connection.isConnected;

  bool isDisconnecting = false;
  bool firstRead = true;

  String view = 'dashboard';

  String speed = '60';
  bool move = false;
  bool collided = false;
  bool reversing = false;
  bool readyNavigate = false;
  bool readBattery = false;
  bool readCollision = false;
  bool readDistance = false;
  List<int> receivedBytes = [];
  String receivedMsg = '';
  // double _value = 90.0;
  int hundredMiliSeconds = 0;

  List<Direction> directions;
  Direction _direction;

  getDirection(String param) =>
      directions.firstWhere((element) => element.label == param);

  void moveForward() {
    if (!collided) {
      _sendMessage('!f$speed');
    }
  }

  void moveBackward() {
    _sendMessage('!b$speed');
  }

  void moveRight() {
    if (!collided) {
      _sendMessage('!r$speed');
    }
  }

  void moveLeft() {
    if (!collided) {
      _sendMessage('!l$speed');
    }
  }

  void stop() {
    _sendMessage('!f00');
  }

  void resetWheelchair() {
    stop();
  }

  void readSensors() {
    if (hundredMiliSeconds == 1 || hundredMiliSeconds % 300000 == 0) {
      _sendMessage('@b'); // Read battery every 5 minutes
      readBattery = true;
    }

    if (readyNavigate) {
      // Read when navigation UI is open
      if (hundredMiliSeconds % 2 == 0) {
        // Alternate reading
        _sendMessage('@c');
        readCollision = true;
      } else {
        _sendMessage('@d');
        readDistance = true;
      }
    }
  }

  void updateDirection(String param) {
    if (param != _direction.label) {
      if (param != 'Stop') {
        if (collided && param == 'Reverse') {
          setState(() {
            _direction = getDirection(param);
          });
          _direction.callback();
          setState(() {
            collided = false;
            move = true;
          });
        } else if (!collided) {
          setState(() {
            _direction = getDirection(param);
          });
          _direction.callback();
          setState(() {
            move = true;
          });
        }
      } else {
        setState(() {
          _direction = getDirection(param);
        });
        _direction.callback();
        setState(() {
          move = false;
        });
      }
    }
  }

  void setSpeed(String param) {
    setState(() {
      speed = param;
    });
  }

  void _onDataReceived(Uint8List data) {
    print('_onDataReceived: $data');
    bool completeMsg = false;

    print('receivedBytes BEFORE: $receivedBytes');
    receivedBytes.addAll(data);
    print('receivedBytes AFTER: $receivedBytes');

    if (readBattery) completeMsg = receivedBytes.length == 2;
    if (readCollision) completeMsg = receivedBytes.length == 4;
    if (readDistance) completeMsg = receivedBytes.length == 3;

    if (completeMsg) {
      print(
          'RAW ${readBattery ? "BATTERY" : readCollision ? "COLLISION" : "DISTANCE"} DATA: $receivedBytes');

      String dataString =
          String.fromCharCodes(receivedBytes); // Dec -> char // Hex -> value
      print(
          'CONVERTED ${readBattery ? "BATTERY" : readCollision ? "COLLISION" : "DISTANCE"} DATA: $dataString');

      Message msg;
      if (readBattery) {
        // Battery Signal
        switch (dataString) {
          case '#0':
            msg = Message(
                wheelchairId: _wheelchair.uid,
                whom: 1,
                label: 'Battery',
                text: 'LOW');
            setState(() {
              _wheelchair.battery = 'LOW';
              _wheelchair.status = 'U';
            });
            FirestoreService().updateBatteryWheelchair(_wheelchair.uid, 'LOW');
            break;
          case '#1':
            msg = Message(
                wheelchairId: _wheelchair.uid,
                whom: 1,
                label: 'Battery',
                text: 'HIGH');
            setState(() {
              _wheelchair.battery = 'HIGH';
              _wheelchair.status = 'A';
            });
            FirestoreService().updateBatteryWheelchair(_wheelchair.uid, 'HIGH');
            break;
        }
      } else if (readCollision) {
        // Touch Sensor Signal

        // extract out #
        String _dataString = dataString.substring(1);
        // determine left / right sensor == 1
        // 0+0, 1+0, 0+1, 1+1
        List<String> sensors = _dataString.split('+');

        if (sensors[0] == '1' && sensors[1] == '1') {
          collided = true;
          msg = Message(
              wheelchairId: _wheelchair.uid,
              whom: 1,
              label: 'Touch',
              text: 'Collision Detected');
          updateDirection('Stop');
        } else if (sensors[0] == '0' && sensors[1] == '1') {
          collided = true;
          msg = Message(
              wheelchairId: _wheelchair.uid,
              whom: 1,
              label: 'Touch',
              text: 'Collision Detected right Side');
          updateDirection('Stop');
        } else if (sensors[0] == '1' && sensors[1] == '0') {
          collided = true;
          msg = Message(
              wheelchairId: _wheelchair.uid,
              whom: 1,
              label: 'Touch',
              text: 'Collision Detected left Side');
          updateDirection('Stop');
        } else {
          collided = false;
          msg = Message(
              wheelchairId: _wheelchair.uid,
              whom: 1,
              label: 'Touch',
              text: 'No Collision Detected');
        }
      } else if (readDistance) {
        // Distance Sensor Signal



        // extract out #
        String _dataString = dataString.substring(1);

        if(double.tryParse(_dataString) < 13 && !reversing){
          collided = true;
          updateDirection('Stop');
        }
        msg = Message(
            wheelchairId: _wheelchair.uid,
            whom: 1,
            label: 'Distance',
            text: '$_dataString cm');
      }
      print('MESSAGE: ${msg.toString()}');

      setState(() {
        messages.add(msg);
      });
      FirestoreService().addMessageLog(msg);

      receivedBytes.clear();
      readBattery = readCollision = readDistance = false;
    }
  }

  void _sendMessage(String text) async {
    text = text.trim();
    textEditingController.clear();

    if (text.length > 0) {
      try {
        print('_sendMessage: $text');
        connection.output.add(utf8.encode(text + "\r\n"));
        await connection.output.allSent;

        String newText = '';
        String newLabel = '';

        if (text.contains('!f00')) {
          reversing = false;
          newLabel = 'Movement direction';
          newText = 'Request: STOP;';
        } else if (text.contains('!f')) {
          reversing = false;
          newLabel = 'Movement direction';
          newText = 'Request: FORWARD; Speed: $speed;';
        } else if (text.contains('!b')) {
          reversing = true;
          newLabel = 'Movement direction';
          newText = 'Request: BACKWARD; Speed: $speed;';
        } else if (text.contains('!r')) {
          reversing = false;
          newLabel = 'Movement direction';
          newText = 'Request: RIGHT; Speed: $speed;';
        } else if (text.contains('!l')) {
          reversing = false;
          newLabel = 'Movement direction';
          newText = 'Request: LEFT; Speed: $speed;';
        } else if (text == '@d') {
          newLabel = 'Read sensor';
          newText = 'Request: DISTANCE';
        } else if (text == '@c') {
          newLabel = 'Read sensor';
          newText = 'Request: COLLISION';
        } else if (text == '@b') {
          newLabel = 'Read sensor';
          newText = 'Request: BATTERY';
        } else if (text == '@h') {
          newLabel = 'Set actuator';
          newText = 'Request: Horn';
        } else if (text == '@e1') {
          newLabel = 'Set actuator';
          newText = 'Request: LED ON';
        } else if (text == '@e0') {
          newLabel = 'Set actuator';
          newText = 'Request: LED OFF';
        }

        Message msg = Message(
          wheelchairId: _wheelchair.uid,
          whom: 0,
          label: newLabel,
          text: newText,
        );
        setState(() {
          messages.add(msg);
        });
        FirestoreService().addMessageLog(msg);

        if (view == 'console')
          Future.delayed(Duration(milliseconds: 333)).then((_) {
            listScrollController.animateTo(
                listScrollController.position.maxScrollExtent,
                duration: Duration(milliseconds: 333),
                curve: Curves.easeOut);
          });
      } catch (e) {
        // Ignore error, but notify state
        print('error ===>$e');
        setState(() {});
      }
    }
  }

  void setCurrentView({String param = ''}) {
    if (param.isEmpty) {
      if (view == 'dashboard') {
        Navigator.pop(context);
      } else {
        setState(() {
          view = 'dashboard';
        });
      }
      resetWheelchair();
    } else {
      setState(() {
        view = param;
      });
    }
  }

  _buildHeader(Size size) => ClipPath(
        clipper: MyCustomClipper(),
        child: Container(
          height: size.height * 0.35,
          width: double.infinity,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topRight,
              end: Alignment.bottomLeft,
              colors: [Colors.lightBlue, Colors.purple],
            ),
            image: DecorationImage(
              image: AssetImage('assets/images/neural.png'),
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: cDefaultPadding * 3),
              Expanded(
                child: Container(
                  width: double.infinity,
                  child: Stack(
                    children: [
                      Image.asset(
                        'assets/images/wheelchair-01.png',
                        width: size.width * 0.6,
                        fit: BoxFit.fitWidth,
                        alignment: Alignment.topLeft,
                      ),
                      Positioned(
                        top: cDefaultPadding,
                        right: cDefaultPadding * 2,
                        child: CustomText(
                          text: 'All you need is\na smart wheelchair.',
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      );

  @override
  void initState() {
    super.initState();

    BluetoothConnection.toAddress(widget.server.address).then((_connection) {
      print('Connected to the device');
      connection = _connection;
      setState(() {
        isConnecting = false;
        isDisconnecting = false;
      });

      connection.input.listen(_onDataReceived).onDone(() {
        if (isDisconnecting) {
          print('Disconnecting locally!');
        } else {
          print('Disconnected remotely!');
        }
        if (this.mounted) {
          setState(() {
            //
          });
        }
      });
    }).catchError((error) {
      print('Cannot connect, exception occured');
      print('error is here ===> $error');

      Fluttertoast.showToast(
          msg: "Error is $error",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.CENTER,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.red,
          textColor: Colors.white,
          fontSize: 16.0);
    });

    _wheelchair = widget.wheelchair;

    readBattery = false;
    readCollision = false;
    readDistance = false;
    timer = Timer.periodic(Duration(milliseconds: 100), (Timer t) {
      ++hundredMiliSeconds;
      if (isConnected && !readBattery && !readCollision && !readDistance) {
        readSensors();
      }
    });

    directions = [
      new Direction(
        label: 'Forward',
        asset: 'assets/icons/forward_arrow_64px.png',
        color: Colors.greenAccent,
        callback: () => moveForward(),
      ),
      new Direction(
        label: 'Stop',
        asset: 'assets/icons/unavailable_64px.png',
        color: Colors.red,
        callback: () => stop(),
      ),
      new Direction(
        label: 'Backward',
        asset: 'assets/icons/unavailable_64px.png',
        color: Colors.red,
        callback: () => moveBackward(),
      ),
      new Direction(
        label: 'Right',
        asset: 'assets/icons/right_2_64px.png',
        color: Colors.greenAccent,
        callback: () => moveRight(),
      ),
      new Direction(
        label: 'Left',
        asset: 'assets/icons/left_2_64px.png',
        color: Colors.greenAccent,
        callback: () => moveLeft(),
      )
    ];

    _direction = getDirection('Stop');
  }

  @override
  void dispose() {
    // Avoid memory leak (`setState` after dispose) and disconnect
    if (isConnected) {
      isDisconnecting = true;
      connection.dispose();
      connection = null;
    }
    timer?.cancel();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    if (isConnected && firstRead) {
      resetWheelchair();
      setState(() {
        firstRead = false;
      });
    }

    Widget _currentView;
    readyNavigate = false;

    switch (view) {
      case 'dpad':
        readyNavigate = true;
        _currentView = DPad(
          direction: _direction,
          updateDirection: updateDirection,
        );
        break;
      case 'voice':
        readyNavigate = true;
        _currentView = Voice(
          direction: _direction,
          updateDirection: updateDirection,
        );
        break;
      case 'accel':
        readyNavigate = true;
        _currentView = Accelerometer(
          direction: _direction,
          updateDirection: updateDirection,
        );
        break;
      case 'swipe':
        readyNavigate = true;
        _currentView = Swipe(
          direction: _direction,
          updateDirection: updateDirection,
        );
        break;
      case 'semiauto':
        readyNavigate = true;
        _currentView = SemiAuto(
          direction: _direction,
          updateDirection: updateDirection,
          wheelchair: widget.wheelchair,
        );
        break;
      case 'console':
        readyNavigate = true;
        _currentView = Console(
          size: size,
          messages: messages,
          sendMessage: _sendMessage,
          textEditingController: textEditingController,
          listScrollController: listScrollController,
        );
        break;
      case 'support':
        _currentView = Support(size: size);
        break;
      case 'dashboard':
      default:
        _currentView = Dashboard(
          wheelchair: _wheelchair,
          size: size,
          isConnecting: isConnecting,
          isConnected: isConnected,
          setView: setCurrentView,
          speed: speed,
          setSpeed: setSpeed,
        );
    }

    return Scaffold(
      body: Stack(
        children: [
          _buildHeader(size),
          _currentView,
          Align(
            alignment: Alignment.topLeft,
            child: Padding(
              padding: const EdgeInsets.symmetric(
                  vertical: cDefaultPadding * 2,
                  horizontal: cDefaultPadding * 0.5),
              child: IconButton(
                onPressed: () => setCurrentView(),
                icon: Icon(Icons.arrow_back_ios, color: Colors.white),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
