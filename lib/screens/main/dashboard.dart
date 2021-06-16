import 'package:flutter/material.dart';
import 'package:sws_app/components/constants.dart';
import 'package:sws_app/components/custom_text.dart';
import 'package:sws_app/components/detail_card.dart';
import 'package:sws_app/components/menu_button.dart';
import 'package:sws_app/models/wheelchair.dart';

class Dashboard extends StatelessWidget {
  const Dashboard(
      {@required this.wheelchair,
      @required this.size,
      @required this.speed,
      @required this.isConnecting,
      @required this.isConnected,
      @required this.setView,
      @required this.setSpeed,
      Key key})
      : super(key: key);
  final Wheelchair wheelchair;
  final Size size;
  final String speed;
  final bool isConnecting;
  final bool isConnected;
  final Function setView;
  final Function setSpeed;

  _buildStatusBox() => Container(
        margin: EdgeInsets.symmetric(horizontal: cDefaultPadding),
        padding:
            EdgeInsets.symmetric(vertical: 10.0, horizontal: cDefaultPadding),
        height: 64.0,
        width: double.infinity,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12.0),
          border: Border.all(color: Colors.black45),
          boxShadow: [
            BoxShadow(color: Colors.grey, offset: Offset(0, 3), blurRadius: 24)
          ],
        ),
        child: Center(
          child: (isConnecting
              ? CustomText(
                  text: 'Connecting chat to ' + wheelchair.name + '...')
              : isConnected
                  ? CustomText(text: 'Live chat with ' + wheelchair.name)
                  : CustomText(text: 'Chat log with ' + wheelchair.name)),
        ),
      );

  _buildInfo() => Padding(
        padding: EdgeInsets.symmetric(horizontal: cDefaultPadding),
        child: Column(
          children: [
            CustomText(
                text: 'Wheelchair Details',
                size: 24.0,
                weight: FontWeight.bold,
                color: Colors.lightBlue.shade900),
            Container(
              height: 175,
              child: ListView(
                scrollDirection: Axis.horizontal,
                padding: EdgeInsets.all(cDefaultPadding),
                children: [
                  DetailCard(
                    title: 'Plate',
                    data: '${wheelchair.plate}',
                    color: Colors.lightBlue.shade900,
                  ),
                  DetailCard(
                    title: '${wheelchair.name}',
                    data: '${wheelchair.address}',
                    color: Colors.lightBlue,
                  ),
                  DetailCard(
                    title: 'Battery',
                    data: isConnected ? wheelchair.battery : '-',
                    color: isConnected
                        ? (wheelchair.battery == 'HIGH'
                            ? Colors.lightGreen
                            : Colors.red)
                        : Colors.grey,
                  ),
                  DetailCard(
                    title: 'Status',
                    data: isConnected
                        ? (wheelchair.status == 'A'
                            ? 'AVAILABLE'
                            : 'UNAVAILABLE')
                        : '-',
                    color: isConnected
                        ? (wheelchair.status == 'A'
                            ? Colors.lightGreen
                            : Colors.red)
                        : Colors.grey,
                  ),
                ],
              ),
            ),
          ],
        ),
      );

  @override
  Widget build(BuildContext context) {
    return Container(
      height: size.height,
      width: size.width,
      child: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: Column(
          children: [
            SizedBox(height: size.height * 0.35),
            _buildStatusBox(),
            SizedBox(height: cDefaultPadding),
            _buildInfo(),
            SizedBox(height: cDefaultPadding * 2),
            CustomText(
                text: 'Navigation',
                size: 24.0,
                weight: FontWeight.bold,
                color: Colors.lightBlue.shade900),
            SizedBox(height: cDefaultPadding),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                MenuButton(
                  size: size,
                  title: 'D-Pad',
                  asset: 'assets/icons/game_controller_64px.png',
                  enabled: isConnected,
                  onPress: isConnected ? () => setView(param: 'dpad') : null,
                ),
                MenuButton(
                  size: size,
                  title: 'Voice',
                  asset: 'assets/icons/voice_64px.png',
                  enabled: isConnected,
                  onPress: isConnected ? () => setView(param: 'voice') : null,
                ),
              ],
            ),
            SizedBox(height: cDefaultPadding),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                MenuButton(
                  size: size,
                  title: 'Swipe',
                  asset: 'assets/icons/swipe_right_gesture_64px.png',
                  enabled: isConnected,
                  onPress: isConnected ? () => setView(param: 'swipe') : null,
                ),
                MenuButton(
                  size: size,
                  title: 'Tilt',
                  asset: 'assets/icons/tilt_64px.png',
                  enabled: isConnected,
                  onPress:
                      isConnected ? () => () => setView(param: 'accel') : null,
                ),
              ],
            ),
            SizedBox(height: cDefaultPadding),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                MenuButton(
                  size: size,
                  title: 'Semi-Auto',
                  asset: 'assets/icons/autopilot_96px.png',
                  enabled: isConnected,
                  onPress:
                      isConnected ? () => setView(param: 'semiauto') : null,
                ),
              ],
            ),
            SizedBox(height: cDefaultPadding),
            CustomText(
                text: 'Others',
                size: 24.0,
                weight: FontWeight.bold,
                color: Colors.lightBlue.shade900),
            SizedBox(height: cDefaultPadding),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                MenuButton(
                  size: size,
                  title: 'Console',
                  asset: 'assets/icons/console_64px.png',
                  enabled: isConnected,
                  onPress: isConnected ? () => setView(param: 'console') : null,
                ),
                MenuButton(
                  size: size,
                  title: 'Support',
                  asset: 'assets/icons/customer_support_64px.png',
                  onPress: () => setView(param: 'support'),
                ),
              ],
            ),
            SizedBox(height: cDefaultPadding),
            CustomText(
                text: 'Settings',
                size: 24.0,
                weight: FontWeight.bold,
                color: Colors.lightBlue.shade900),
            SizedBox(height: cDefaultPadding),
            CustomText(
                text: 'Speed',
                size: 16.0,
                weight: FontWeight.bold,
                color: Colors.lightBlue.shade900),
            Slider(
              min: 0,
              max: 100,
              value: double.tryParse(speed),
              onChanged: (value) {
                setSpeed(value.toString());
              },
            ),
            CustomText(
                text: 'Speed: $speed',
                size: 16.0,
                weight: FontWeight.bold,
                color: Colors.lightBlue.shade900),
            SizedBox(height: cDefaultPadding),
          ],
        ),
      ),
    );
  }
}
