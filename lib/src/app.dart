import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:chit_chat/src/app/constants/constants.dart';
import 'package:chit_chat/src/app/pages/splash/splash_view.dart';

class App extends StatelessWidget {
  const App({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
    ]);

    return MaterialApp(
      home: SplashView(),
      theme: ThemeData(
        fontFamily: 'Montserrat',
        scaffoldBackgroundColor: kBackground,
      ),
      debugShowCheckedModeBanner: false,
    );
  }
}
