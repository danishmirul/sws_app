import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bluetooth_serial/flutter_bluetooth_serial.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:sws_app/components/connection.dart';
import 'package:sws_app/components/device.dart';
import 'package:sws_app/models/wheelchair.dart';
import 'package:sws_app/screens/main/main_screen.dart';
import 'package:sws_app/services/firestore_service.dart';

class DeviceListScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text('Connection'),
      ),
      body: SelectBondedDevicePage(
        callBack: (device) async {
          BluetoothDevice _device = device;

          Wheelchair _wheelchair = await FirestoreService().getWheelchairDevice(
              name: _device.name, address: _device.address);

          if (_wheelchair != null) {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) {
                  return MainScreen(
                    server: _device,
                    wheelchair: _wheelchair,
                  );
                },
              ),
            );
          } else {
            Fluttertoast.showToast(
                msg:
                    "Device selected does not registered or not accessible in the system.",
                toastLength: Toast.LENGTH_SHORT,
                gravity: ToastGravity.CENTER,
                timeInSecForIosWeb: 1,
                backgroundColor: Colors.red,
                textColor: Colors.white,
                fontSize: 16.0);
          }
        },
      ),
    ));
  }
}
