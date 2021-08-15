import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_bluetooth_serial/flutter_bluetooth_serial.dart';
import 'package:sws_app/components/device.dart';
import 'package:sws_app/components/loading.dart';
import 'package:sws_app/models/wheelchair.dart';
import 'package:sws_app/services/firestore_service.dart';

class SelectBondedDevicePage extends StatefulWidget {
  /// If true, on page start there is performed discovery upon the bonded devices.
  /// Then, if they are not avaliable, they would be disabled from the selection.
  final bool checkAvailability;
  final Function callBack;

  const SelectBondedDevicePage(
      {this.checkAvailability = true, @required this.callBack});

  @override
  _SelectBondedDevicePage createState() => new _SelectBondedDevicePage();
}

enum _DeviceAvailability {
  no,
  maybe,
  yes,
}

class _DeviceWithAvailability extends BluetoothDevice {
  BluetoothDevice device;
  _DeviceAvailability availability;
  int rssi;
  @override
  String toString() {
    return '{ device:$device, availability:$availability, rssi:$rssi }';
  }

  _DeviceWithAvailability(this.device, this.availability, [this.rssi]);
}

class _SelectBondedDevicePage extends State<SelectBondedDevicePage> {
  List<_DeviceWithAvailability> devices = <_DeviceWithAvailability>[];
  StreamController<List<_DeviceWithAvailability>> filteredDeviceStream =
      StreamController<List<_DeviceWithAvailability>>();

  // Availability
  StreamSubscription<BluetoothDiscoveryResult> _discoveryStreamSubscription;
  bool _isDiscovering;

  _SelectBondedDevicePage();

  @override
  void initState() {
    super.initState();

    _isDiscovering = widget.checkAvailability;

    if (_isDiscovering) {
      _startDiscovery();
    }

    // Setup a list of the bonded devices

    FlutterBluetoothSerial.instance
        .getBondedDevices()
        .then((List<BluetoothDevice> bondedDevices) {
      List<_DeviceWithAvailability> result = bondedDevices
          .map(
            (device) => _DeviceWithAvailability(
              device,
              widget.checkAvailability
                  ? _DeviceAvailability.maybe
                  : _DeviceAvailability.yes,
            ),
          )
          .toList();
      filterDevices(result);
      setState(() {
        devices = result;
      });
    });
  }

  void _restartDiscovery() {
    setState(() {
      _isDiscovering = true;
    });

    _startDiscovery();
  }

  void _startDiscovery() {
    _discoveryStreamSubscription =
        FlutterBluetoothSerial.instance.startDiscovery().listen((r) {
      setState(() {
        Iterator i = devices.iterator;
        while (i.moveNext()) {
          var _device = i.current;
          if (_device.device == r.device) {
            _device.availability = _DeviceAvailability.yes;
            _device.rssi = r.rssi;
          }
        }
      });
    });

    _discoveryStreamSubscription.onDone(() {
      setState(() {
        _isDiscovering = false;
      });
    });
  }

  @override
  void dispose() {
    // Avoid memory leak (`setState` after dispose) and cancel discovery
    _discoveryStreamSubscription?.cancel();
    filteredDeviceStream.close();

    super.dispose();
  }

  void filterDevices(List<_DeviceWithAvailability> bondedDevices) async {
    List<_DeviceWithAvailability> result = <_DeviceWithAvailability>[];

    for (var i = 0; i < bondedDevices.length; i++) {
      _DeviceWithAvailability bluetoothDevice = bondedDevices[i];
      Wheelchair _wheelchair = await FirestoreService().getWheelchairDevice(
          name: bluetoothDevice.device.name,
          address: bluetoothDevice.device.address);
      if (_wheelchair != null) result.add(bluetoothDevice);
    }
    print('result: ${result.toString()}');
    filteredDeviceStream.sink.add(result);
  }

  @override
  Widget build(BuildContext context) {
    print('devices: $devices');
    return StreamBuilder<List<_DeviceWithAvailability>>(
      stream: filteredDeviceStream.stream,
      builder: (context, snapshot) {
        print('snapshot: ${snapshot.data}');
        if (snapshot.hasData) {
          List<BluetoothDeviceListEntry> list = snapshot.data
              .map(
                (_device) => BluetoothDeviceListEntry(
                  device: _device.device,
                  // rssi: _device.rssi,
                  enabled: _device.availability != _DeviceAvailability.no,
                  onTap: () {
                    filteredDeviceStream.close();
                    widget.callBack(_device.device);
                  },
                ),
              )
              .toList();
          return ListView(
            children: list,
          );
        }
        return Loading();
      },
    );
  }
}
