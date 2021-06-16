import 'package:url_launcher/url_launcher.dart';

void customLauncher(String param) async {
  if (await canLaunch(param)) {
    launch(param);
  } else {
    print('Can not launch the command');
  }
}
