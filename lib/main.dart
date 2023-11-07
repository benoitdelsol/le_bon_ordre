import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:le_bon_ordre/settingsPage.dart';

import 'homePage.dart';
import 'joinParty.dart';
import 'mainGamePage.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations(
      [DeviceOrientation.landscapeLeft, DeviceOrientation.landscapeRight]);
  SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersive);

  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  int _state = 0;

  void changeState(int i) {
    setState(() {
      _state = _state + i;
      if (_state > 3) {
        _state = 0;
      }
    });
  }
  int nombreManches = 3;

  changeNombreManches(int value) {
    nombreManches = value;
  }

  String code = "";

  bool isAdmin = false;

  changeIsAdmin(bool value) {
      isAdmin = value;
  }

  generateCode() {
    code = "";

    for (int i = 0; i < 5; i++) {
      code = code + String.fromCharCode(65 + (Random().nextInt(25)));
    }
  }

  verifierCode(String value) {
    code=value.toUpperCase();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      home: Scaffold(
        body: _state == 0
            ? HomePage(
                changeState: changeState,
                generateCode: generateCode,
                changeIsAdmin: changeIsAdmin,
              )
            : _state == 1
                ? JoinParty(changeState: changeState, verifierCode: verifierCode, changeIsAdmin: changeIsAdmin,)
                : _state == 2
                    ? SettingsPage(code: code, isAdmin: isAdmin, changeState: changeState, changeNombreManches: changeNombreManches,)
                    :_state==3? MainGamePage(nombreManches: nombreManches, )

        : const Placeholder(),
        backgroundColor: Colors.black54,
      ),
    );
  }
}
