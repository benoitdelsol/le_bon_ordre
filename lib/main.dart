import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:le_bon_ordre_v2/welcome_screen.dart';

import 'dio.dart';
import 'game.dart';
import 'joining_screen.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations(
      [DeviceOrientation.landscapeLeft, DeviceOrientation.landscapeRight]);
  SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersive);

  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  int state = 0;

  bool isAdmin = false;

  void changeState(int newState) {
    setState(() {
      state = newState;
    });
  }

  String code = "";

  String error = "";
  bool connecting = false;

  void setError(String error1) {
    setState(() {
      error = error1;
    });
  }

  void tryToConnect() {
    createGame();

    setState(() {
      connecting = true;
    });
  }

  void resetConnecting() {
    setState(() {
      connecting = false;
    });
  }

  void tryToJoin(String code) {
    joinGame(code);
    setState(() {
      connecting = true;
    });
  }

  Future<void> joinGame(String code) async {
    String response = await joinGameBack(code);

    if (response == "0") {
      this.code = code;
      isAdmin = false;
      changeState(2);
      connecting = false;
    } else {
      connecting = false;
      setState(() {
        error = response;
      });
    }
  }

  Future<void> createGame() async {
    List<String> response = await createGameBack();

    if (response[0] == "0") {
      code = response[1];
      isAdmin = true;
      changeState(2);
      connecting = false;
    } else {
      connecting = false;
      setState(() {
        error = response[1];
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        backgroundColor: Colors.black,
        body: Stack(
          children: [
            Center(
              child: state == 0
                  ? WelcomeScreen(
                      connecting: connecting,
                      tryToConnect: tryToConnect,
                      changeState: changeState,
                      createGame: createGame,
                    )
                  : state == 1
                      ? JoiningScreen(
                          changeState: changeState,
                          tryToJoin: tryToJoin,
                        )
                      : Game(
                          setError: setError,
                          resetConnecting: resetConnecting,
                          code: code,
                          isAdmin: isAdmin,
                          changeState: changeState,
                        ),
            ),
            Center(
              child: AnimatedSize(
                duration: const Duration(milliseconds: 500),
                child: Container(
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: const Color.fromRGBO(226, 32, 46, 1),
                      width: 3,
                    ),
                    color: Colors.grey[900],
                    borderRadius: BorderRadius.circular(20),
                  ),
                  width: error == "" && connecting == false
                      ? 0
                      : MediaQuery.of(context).size.width * 0.7,
                  height: error == "" && connecting == false
                      ? 0
                      : MediaQuery.of(context).size.height * 0.7,
                  child: Stack(
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Center(
                          child: Text(
                            error,
                            style: GoogleFonts.getFont(
                              "Erica One",
                              fontSize: 50,
                              color: const Color.fromRGBO(226, 32, 46, 1),
                            ),
                          ),
                        ),
                      ),
                      Center(
                        child: connecting
                            ? const CircularProgressIndicator(
                                color: Color.fromRGBO(226, 32, 46, 1),
                              )
                            : const SizedBox.shrink(),
                      ),
                      error != ""
                          ? Align(
                              alignment: Alignment.bottomCenter,
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: TextButton(
                                  style: ButtonStyle(
                                    backgroundColor: MaterialStateProperty.all<
                                            Color>(
                                        const Color.fromRGBO(226, 32, 46, 1)),
                                    shape: MaterialStateProperty.all<
                                        RoundedRectangleBorder>(
                                      RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(18.0),
                                      ),
                                    ),
                                    padding:
                                        MaterialStateProperty.all<EdgeInsets>(
                                            const EdgeInsets.symmetric(
                                                horizontal: 50, vertical: 10)),
                                  ),
                                  onPressed: () {
                                    setState(() {
                                      error = "";
                                    });
                                  },
                                  child: Text(
                                    "Retour",
                                    style: GoogleFonts.getFont(
                                      "Jura",
                                      fontSize: 20,
                                      color: Colors.white,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ),
                              ),
                            )
                          : const SizedBox.shrink(),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
