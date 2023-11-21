import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:le_bon_ordre/dio.dart';
import 'package:le_bon_ordre/questionClass.dart';
import 'package:le_bon_ordre/settingsPage.dart';
import 'package:socket_io_client/socket_io_client.dart';

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
  late Socket socket;

  @override
  void initState() {
    initSocket();
    super.initState();
  }

  bool connectionError = false;
  List<Question> questions = [];
  bool isFramesInitialised = false;
  bool finish = false;

  String errorMessage = "";

  bool is2Connected = false;

  initSocket() {
    socket = io('http://bun.bun.ovh:8080', <String, dynamic>{
      'autoConnect': false,
      'transports': ['websocket'],
    });
    socket.connect();
    socket.onConnect((_) {
      print('Connection established');
    });
    socket.onDisconnect((_) => print('Connection Disconnection'));
    socket.onConnectError((err) => print(err));
    socket.onError((err) => print(err));
    socket.on('ready', (newMessage) async {
      print(newMessage);
      print(ready1);
      print(ready2);
      if (newMessage == "ready1") {
        ready1 = !ready1;
        if (ready1 == true && ready2 == true) {
          isFramesInitialised = false;
          finish = false;
          mancheactuelle++;
          print(nombreManches);
          if (gotQuestions == false) {
            questions = await getQuestions(nombreManches, code);
            gotQuestions = true;
          }
          print(questions.length);
          print(questions[0].titre);
          changeState(3);
          ready1 = false;
          ready2 = false;
        } else {
          setState(() {});
        }
      }
      if (newMessage == "ready2") {
        ready2 = !ready2;
        if (ready1 == true && ready2 == true) {
          isFramesInitialised = false;
          finish = false;
          if (gotQuestions == false) {
            questions = await getQuestions(nombreManches, code);
            gotQuestions = true;
          }
          mancheactuelle++;
          changeState(3);
          ready1 = false;
          ready2 = false;
        } else {
          setState(() {});
        }
      }
    });

    socket.on("nombreMancheMoins", (newMessage) {
      setState(() {
        print("nombreMancheMoins");
        nombreManches--;
      });
    });
    socket.on("join", (newMessage) {
      print(newMessage);
      if (newMessage == "Joined the game") {
        setState(() {
          changeState(2);
        });
      }
    });
    socket.on("join2", (newMessage) {
      print(newMessage);
      if (newMessage == "Game not find") {
        print("Game not find");
      } else {
        nombreManches = newMessage as int;
        setState(() {
          is2Connected = true;
          changeState(2);
        });
      }
    });
    socket.on("leave", (newMessage) {
      if (newMessage == "Le joueur 2 à quitté la partie") {
        if(_state==2){
          setState(() {
            is2Connected = false;
          });
        }
        if(_state==3){
          errorMessage = "Le joueur 2 à quitté la partie";
          sendMessage("1", "leave");
          setState(() {
            changeState(0);
          });
        }
      } else {
        if (newMessage == "Le joueur 1 à quitté la partie") {
          errorMessage = "Le joueur 1 à quitté la partie";
          sendMessage("2", "leave");
          setState(() {
            changeState(0);
          });
        }
      }
    });
    socket.on("nombreManchePlus", (newMessage) {
      setState(() {
        print("nombreManchePlus");
        nombreManches++;
      });
    });
  }

  bool gotQuestions = false;

  changeFrames(List<List<String>> newFrames) {
    frames = newFrames;
    isFramesInitialised = true;
  }

  resetGotQuestions() {
    gotQuestions = false;
  }

  int mancheactuelle = 0;

  List<List<String>> frames = [];

  sendMessage(String message, String arg) {
    print("argument: " + arg);
    Map messageMap = {
      'message': message,
      'room': code.toUpperCase(),
    };
    socket.emit(arg, messageMap);
  }

  bool ready1 = false;
  bool ready2 = false;
  int _state = 0;

  void changeFinishState() {
    setState(() {
      finish = !finish;
    });
  }

  void changeState(int i) {
    setState(() {
      _state = i;
    });
  }

  int nombreManches = 3;

  changeNombreManches(int value) {
    setState(() {
      print("nombre de manche = " + value.toString());
      nombreManches = value;
    });
  }

  String code = "";

  bool isAdmin = false;

  generateCode() async {
    is2Connected = false;
    nombreManches = 3;
    isAdmin = true;
    code = "";

    for (int i = 0; i < 4; i++) {
      code = code + String.fromCharCode(65 + (Random().nextInt(25)));
      code = code.toUpperCase();
    }
    String reponse = await createGame(code);

    print(code);

    if (reponse == "Game as been created") {
      var mapMessage = {
        'room': code.toUpperCase(),
      };
      socket.emit('join', mapMessage);
    } else {
      generateCode();
    }
  }

  setCode(String value) {
    code = value;
  }

  changeIsAdmin(bool value) {
    isAdmin = value;
  }

  resetMancheActuelle() {
    mancheactuelle = 0;
    nombreManches = 3;
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      home: Scaffold(
        body: Stack(
          alignment: Alignment.center,
          children: [
            _state == 0
                ? Center(
                    child: HomePage(
                      code: code,
                      changeState: changeState,
                      generateCode: generateCode,
                    ),
                  )
                : _state == 1
                    ? Center(
                        child: JoinParty(
                          changeIsAdmin: changeIsAdmin,
                          sendMessage: sendMessage,
                          socket: socket,
                          changeState: changeState,
                          setCode: setCode,
                          changeNombreManches: changeNombreManches,
                        ),
                      )
                    : _state == 2
                        ? Center(
                            child: SettingsPage(
                                is2Connected: is2Connected,
                                ready1: ready1,
                                ready2: ready2,
                                sendMessage: sendMessage,
                                socket: socket,
                                code: code,
                                isAdmin: isAdmin,
                                changeState: changeState,
                                changeNombreManches: changeNombreManches,
                                nombreManches: nombreManches),
                          )
                        : _state == 3
                            ? Center(
                                child: MainGamePage(
                                  resetGotQuestions: resetGotQuestions,
                                  resetMancheActuelle: resetMancheActuelle,
                                  finish: finish,
                                  changeFrames: changeFrames,
                                  questions: questions,
                                  mancheActuelle: mancheactuelle,
                                  sendMessage: sendMessage,
                                  ready1: ready1,
                                  ready2: ready2,
                                  socket: socket,
                                  changeState: changeState,
                                  nombreManches: nombreManches,
                                  isAdmin: isAdmin,
                                  code: code,
                                  isFramesInitialised: isFramesInitialised,
                                  changeFinishState: changeFinishState,
                                ),
                              )
                            : const Placeholder(),
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
                  width: errorMessage == ""
                      ? 0
                      : MediaQuery.of(context).size.width * 0.7,
                  height: errorMessage == ""
                      ? 0
                      : MediaQuery.of(context).size.height * 0.7,
                  child: Stack(
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Center(
                          child: Text(
                            errorMessage,
                            style: GoogleFonts.getFont(
                              "Erica One",
                              fontSize: 50,
                              color: const Color.fromRGBO(226, 32, 46, 1),
                            ),
                          ),
                        ),
                      ),
                      Align(
                        alignment: Alignment.bottomCenter,
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: TextButton(
                            style: ButtonStyle(

                              backgroundColor: MaterialStateProperty.all<Color>(
                                  const Color.fromRGBO(226, 32, 46, 1)),
                              shape: MaterialStateProperty.all<
                                  RoundedRectangleBorder>(
                                RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(18.0),

                                ),
                              ),
                              padding: MaterialStateProperty.all<EdgeInsets>(
                                  const EdgeInsets.symmetric(
                                      horizontal: 50, vertical: 10)),
                            ),
                            onPressed: () {
                              setState(() {
                                setState(() {
                                  errorMessage = "";
                                });
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
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
        backgroundColor: Colors.black54,
      ),
    );
  }
}
