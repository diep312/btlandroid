import 'dart:async';

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:chit_chat/src/app.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:flutter/services.dart';

void main() {
  runZonedGuarded(() async {
    WidgetsFlutterBinding.ensureInitialized();
    await Hive.initFlutter();
    await Hive.openBox('permanentBox');
    await Hive.openBox('temporaryBox');

    await Firebase.initializeApp();
    FlutterError.onError = (FlutterErrorDetails details) {
      print(details);
    };
    SystemChrome.setSystemUIOverlayStyle(
      SystemUiOverlayStyle(
        statusBarColor: Colors.white,
        statusBarIconBrightness: Brightness.dark,
        statusBarBrightness: Brightness.light,
      ),
    );
    runApp(const App());
  }, (Object error, StackTrace stackTrace) {
    print(error);
    print(stackTrace);
  });
}
