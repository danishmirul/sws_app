import 'package:flutter/material.dart';
import 'package:flutter_bluetooth_serial/flutter_bluetooth_serial.dart';

class BluetoothDeviceListEntry extends StatelessWidget {
  final Function onTap;
  final BluetoothDevice device;
  final bool enabled;

  BluetoothDeviceListEntry(
      {this.onTap, @required this.device, this.enabled = false});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      enabled: enabled,
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
      trailing: TextButton(
        child: Text('Connect'),
        onPressed: enabled ? onTap : null,
        style: TextButton.styleFrom(
          backgroundColor: enabled ? Colors.blueAccent : Colors.grey,
          textStyle: TextStyle(color: Colors.white),
        ),
      ),
    );
  }
}
