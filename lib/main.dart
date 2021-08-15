import 'package:flutter/material.dart';
import 'package:sws_app/components/constants.dart';
import 'package:sws_app/components/loading.dart';
import 'package:sws_app/router.dart';
import 'package:sws_app/screens/splashscreen/splash_screen.dart';
import 'package:firebase_core/firebase_core.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(App());
}

/// We are using a StatefulWidget such that we only create the [Future] once,
/// no matter how many times our widget rebuild.
/// If we used a [StatelessWidget], in the event where [App] is rebuilt, that
/// would re-initialize FlutterFire and make our application re-enter loading state,
/// which is undesired.
class App extends StatefulWidget {
  // Create the initialization Future outside of `build`:
  @override
  _AppState createState() => _AppState();
}

class _AppState extends State<App> {
  /// The future is part of the state of our widget. We should not call `initializeApp`
  /// directly inside [build].
  final Future<FirebaseApp> _initialization = Firebase.initializeApp();

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      // Initialize FlutterFire:
      future: _initialization,
      builder: (context, snapshot) {
        // Check for errors
        if (snapshot.hasError) {
          print(snapshot.error);
        }

        // Once complete, show your application
        if (snapshot.connectionState == ConnectionState.done) {
          return MyAwesomeApp();
        }

        // Otherwise, show something whilst waiting for initialization to complete
        return MaterialApp(
            title: 'SWS Navi',
            theme: ThemeData(
                visualDensity: VisualDensity.adaptivePlatformDensity,
                fontFamily: 'OpenSans',
                scaffoldBackgroundColor: cBackgroundColor,
                textTheme:
                    Theme.of(context).textTheme.apply(bodyColor: cTextColor)),
            debugShowCheckedModeBanner: false,
            onGenerateRoute: generateRoute,
            home: Loading());
      },
    );
  }
}

class MyAwesomeApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'SWS Navi',
      theme: ThemeData(
          visualDensity: VisualDensity.adaptivePlatformDensity,
          fontFamily: 'OpenSans',
          scaffoldBackgroundColor: cBackgroundColor,
          textTheme: Theme.of(context).textTheme.apply(bodyColor: cTextColor)),
      debugShowCheckedModeBanner: false,
      onGenerateRoute: generateRoute,
      home: SplashScreen(),
    );
  }
}
