import 'package:flutter/material.dart';
import 'package:sws_app/components/constants.dart';
import 'package:sws_app/components/loading.dart';
import 'package:sws_app/components/menu_button.dart';
import 'package:sws_app/models/user.dart';
import 'package:sws_app/services/firestore_service.dart';
import 'package:url_launcher/url_launcher.dart';

class Support extends StatelessWidget {
  const Support({@required this.size, Key key}) : super(key: key);
  final Size size;

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: FirestoreService().getSupporters(),
      builder: (context, future) {
        if (future.hasData) {
          List<User> supporters = future.data;
          return Column(children: [
            SizedBox(height: size.height * 0.35),
            Expanded(
              child: GridView.count(
                crossAxisCount: 2,
                crossAxisSpacing: cDefaultPadding,
                mainAxisSpacing: cDefaultPadding,
                children: supporters
                    .map((e) => MenuButton(
                          size: size,
                          title: e.fullname,
                          asset: 'assets/icons/customer_support_64px.png',
                          onPress: () => _launchURL("tel:${e.phone}"),
                        ))
                    .toList(),
              ),
            ),
          ]);
        } else {
          return Loading();
        }
      },
    );
  }

  void _launchURL(String _url) async => await canLaunch(_url)
      ? await launch(_url)
      : throw 'Could not launch $_url';
}
