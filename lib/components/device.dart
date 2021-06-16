import 'package:flutter/material.dart';
import 'package:flutter_bluetooth_serial/flutter_bluetooth_serial.dart';

class BluetoothDeviceListEntry extends StatelessWidget {
  final Function onTap;
  final BluetoothDevice device;

  BluetoothDeviceListEntry({this.onTap, @required this.device});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: onTap,
      leading: Icon(Icons.devices),
      title: Text(
        device.name ?? "Unknown device",
        style: TextStyle(color: Colors.blue.shade900),
      ),
      subtitle: Text(
        device.address.toString(),
        style: TextStyle(color: Colors.blue.shade600),
      ),
      trailing: FlatButton(
        child: Text('Connect'),
        onPressed: onTap,
        color: Colors.blueAccent,
      ),
    );
  }
}
