import 'dart:math';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:le_bon_ordre_v2/question.dart';
import 'package:socket_io_client/socket_io_client.dart';

import 'dio.dart';
import 'game_screen.dart';

class Game extends StatefulWidget {
  const Game(
      {super.key,
      required this.code,
      required this.setError,
      required this.isAdmin,
      required this.changeState,
      required this.resetConnecting});

  final String code;
  final bool isAdmin;
  final void Function(int) changeState;
  final void Function() resetConnecting;
  final void Function(String) setError;

  @override
  State<Game> createState() => _GameState();
}

class _GameState extends State<Game> {
  late Socket socket;

  @override
  void initState() {
    initSocket();
    super.initState();
  }

  final String address = 'http://bun.bun.ovh:8081';

  void getGameState(String code) {
    sendMessage("", "getNumberRounds");
    sendMessage("", "getReady1");
    sendMessage("", "getReady2");
  }

  void initSocket() {
    socket = io(
      address,
      <String, dynamic>{
        'autoConnect': false,
        'transports': ['websocket'],
        'forceNew': true,
      },
    );
    socket.connect();
    socket.onConnect(
      (_) {
        sendMessage("", "join");
        print('Connection established');
        getGameState(widget.code);
      },
    );

    socket.onDisconnect((_) => print('Connection Disconnection'));
    socket.onConnectError((err) => print(err));
    socket.onError((err) => print(err));

    socket.on(
      "join",
      (data) {
        if (data == "Joined the room") {
          widget.resetConnecting();
        }
      },
    );

    socket.on(
      "giveNumberRounds",
      (data) {
        setState(() {
          nombreManches = data;
        });
      },
    );

    socket.on(
      "giveReady1",
      (data) {
        setState(() {
          ready1 = data;
        });
      },
    );

    socket.on(
      "giveReady2",
      (data) {
        setState(() {
          ready2 = data;
        });
      },
    );

    socket.on(
      "full",
      (data) {
        setState(() {
          is2Connected = true;
        });
      },
    );

    socket.on(
      "leave1",
      (data) {
        sendMessage("", "leave2");
        widget.setError("Le joueur 1 a quitté la partie.");
        widget.changeState(0);
      },
    );
    socket.on(
      "leave2",
      (data) {
        widget.setError("Le joueur 2 a quitté la partie.");
        setState(() {
          is2Connected = false;
          ready2 = false;
        });
      },
    );
    socket.on(
      "startGame",
      (data) {
        startGame();
      },
    );
    socket.on(
      "leave",
      (data) {
        print("leave");
        widget.isAdmin
            ? widget.setError("Le joueur 2 a quitté la partie.")
            : widget.setError("Le joueur 1 a quitté la partie.");
        widget.changeState(0);
      },
    );
    socket.on(
      "skip1",
      (data) {
        setState(() {
          skip1 = data;
        });
      },
    );
    socket.on(
      "skip2",
      (data) {
        setState(() {
          skip2 = data;
        });
      },
    );
    socket.on(
      "skip",
      (data) async {
        endRound();
      },
    );
    socket.on(
      "next1",
      (data) {
        setState(() {
          next1 = data;
        });
      },
    );
    socket.on(
      "next2",
      (data) {
        setState(() {
          next2 = data;
        });
      },
    );
    socket.on(
      "next",
      (data) {
        setState(() {
          mancheActuelle = data;
          print("mancheActuelle = " + mancheActuelle.toString());
          finish = false;
          next1 = false;
          next2 = false;
          skip1 = false;
          skip2 = false;
        });
      },
    );
  }

  void endRound() async {
    disposition1 = [];
    points = 0;
    for (int i = 5; i < 10; i++) {
      if (listFrames[mancheActuelle-1][i][0] == questions[mancheActuelle - 1].reponses[i - 5][0]) {
        points += 1;
      }
    }
    List<String> names =
        questions[mancheActuelle - 1].reponses.map((e) => e[0]).toList();
    List<String> names2 = listFrames[mancheActuelle-1].sublist(5, 10).map((e) => e[0]).toList();
    String name;
    for (name in names) {
      disposition1.add(names2.indexOf(name));
    }
    for (int i = 0; i < disposition1.length; i++) {
      if (disposition1[i] == -1) {
        disposition1[i] = 6;
      }
    }
    if (widget.isAdmin) {
      response =
          await sendPoints(widget.code.toUpperCase(), points, 0, disposition1);
      gamePoints = response[0];
      disposition1 = response[1];
      print("disposition1 = " + disposition1.toString());
    } else {
      response =
          await sendPoints(widget.code.toUpperCase(), points, 1, disposition1);
      gamePoints = response[0];
      disposition1 = response[1];
      print("disposition1 = " + disposition1.toString());
    }
    finish = true;
    setState(() {});
  }

  List<int> disposition1 = [];
  int points = 0;
  List<dynamic> response = [];
  List<int> gamePoints = [];
  bool finish = false;

  void switchFrames(int i, int data) {
    setState(() {
      listFrames[mancheActuelle-1][i] = listFrames[mancheActuelle-1][data];
      listFrames[mancheActuelle-1][data] = ["", ""];
    });
  }

  void sendMessage(String message, String arg) {
    print("argument: " + arg);
    Map messageMap = {
      'message': message,
      'room': widget.code,
    };
    socket.emit(arg, messageMap);
  }

  int mancheActuelle = 1;

  List<Question> questions = [];

  bool gameStarted = false;

  bool isFramesInitialised = false;
  List<List<List<String>>> listFrames = [];

  void initiateFrames() {
    for (int i = 0; i < questions.length; i++) {
      listFrames.add(
        List.from(
          List<List<String>>.from(questions[i].reponses),
        ),
      );
      listFrames[i].shuffle(Random());
      listFrames[i]=listFrames[i]+[
        ["", ""],
        ["", ""],
        ["", ""],
        ["", ""],
        ["", ""],
      ];
    }
    print(listFrames);
  }

  void startGame() async {
    questions = await getQuestions(widget.code);
    print(" nombre de questions recu : " + questions.length.toString());
    initiateFrames();
    setState(() {
      gameStarted = true;
    });
  }

  bool skip1 = false;
  bool skip2 = false;

  bool next1 = false;
  bool next2 = false;

  bool ready1 = false;
  bool ready2 = false;
  bool is2Connected = false;
  int nombreManches = 3;

  bool hideCode = true;

  Widget build(BuildContext context) {
    return !gameStarted
        ? Stack(
            children: [
              Positioned(
                top: 5,
                right: 5,
                child: Row(
                  children: [
                    AnimatedSize(
                      duration: const Duration(milliseconds: 500),
                      child: Align(
                        alignment: Alignment.topRight,
                        child: Text(
                          widget.code.toUpperCase(),
                          style: GoogleFonts.getFont(
                            "Erica One",
                            fontSize: hideCode ? 0 : 50,
                            color: const Color.fromRGBO(226, 32, 46, 1),
                          ),
                        ),
                      ),
                    ),
                    IconButton(
                      splashRadius: 0.1,
                      onPressed: () {
                        setState(() {
                          hideCode = !hideCode;
                        });
                      },
                      icon: const Icon(Icons.remove_red_eye,
                          color: Color.fromRGBO(226, 32, 46, 1), size: 40),
                    ),
                  ],
                ),
              ),
              Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      "SETTINGS",
                      style: GoogleFonts.getFont(
                        "Erica One",
                        fontSize: 50,
                        color: const Color.fromRGBO(226, 32, 46, 1),
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Column(
                          children: [
                            Text(
                              widget.isAdmin ? "Équipe 1 (Vous)" : "Équipe 1",
                              style: GoogleFonts.getFont(
                                "Jura",
                                fontSize: 20,
                                color: Colors.white,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            Text(
                              ready1 ? "Prêt" : "Pas prêt",
                              style: GoogleFonts.getFont(
                                "Jura",
                                fontSize: 20,
                                color: ready1
                                    ? Colors.green
                                    : const Color.fromRGBO(226, 32, 46, 1),
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                        Column(
                          children: [
                            Text(
                              widget.isAdmin ? "Équipe 2" : "Équipe 2 (Vous)",
                              style: GoogleFonts.getFont(
                                "Jura",
                                fontSize: 20,
                                color: Colors.white,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            Text(
                              ready2
                                  ? "Prêt"
                                  : is2Connected
                                      ? "Pas prêt"
                                      : "Pas connecté",
                              style: GoogleFonts.getFont(
                                "Jura",
                                fontSize: 20,
                                color: ready2
                                    ? Colors.green
                                    : const Color.fromRGBO(226, 32, 46, 1),
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        )
                      ],
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 20.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text(
                            "Nombre de manche :",
                            style: GoogleFonts.getFont(
                              "Jura",
                              fontSize: 30,
                              color: Colors.white,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          IconButton(
                            splashRadius: 0.1,
                            onPressed: () {
                              setState(() {
                                if (widget.isAdmin &&
                                    !ready1 &&
                                    nombreManches != 1) {
                                  sendMessage("moins", "nombreManche");
                                }
                              });
                            },
                            icon: const Icon(Icons.remove,
                                color: Color.fromRGBO(226, 32, 46, 1),
                                size: 30),
                          ),
                          Text(
                            nombreManches.toString(),
                            style: GoogleFonts.getFont(
                              "Jura",
                              fontSize: 30,
                              color: Colors.white,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          IconButton(
                            splashRadius: 0.1,
                            onPressed: () {
                              setState(() {
                                if (widget.isAdmin &&
                                    !ready1 &&
                                    nombreManches != 15) {
                                  sendMessage("plus", "nombreManche");
                                }
                              });
                            },
                            icon: const Icon(Icons.add,
                                color: Color.fromRGBO(226, 32, 46, 1),
                                size: 30),
                          ),
                        ],
                      ),
                    )
                  ],
                ),
              ),
              Positioned(
                right: 20,
                bottom: 5,
                child: TextButton(
                  style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all<Color>(
                      widget.isAdmin
                          ? ready1
                              ? Colors.green
                              : const Color.fromRGBO(226, 32, 46, 1)
                          : ready2
                              ? Colors.green
                              : const Color.fromRGBO(226, 32, 46, 1),
                    ),
                    shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                      RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(18.0),
                      ),
                    ),
                    padding: MaterialStateProperty.all<EdgeInsets>(
                        const EdgeInsets.symmetric(
                            horizontal: 50, vertical: 10)),
                  ),
                  onPressed: () {
                    widget.isAdmin
                        ? sendMessage("", "ready1")
                        : sendMessage("", "ready2");
                  },
                  child: Text(
                    "Prêt",
                    style: GoogleFonts.getFont(
                      "Jura",
                      fontSize: 20,
                      color: Colors.white,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ),
              Positioned(
                left: 20,
                bottom: 5,
                child: TextButton(
                  style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all<Color>(
                        const Color.fromRGBO(226, 32, 46, 1)),
                    shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                      RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(18.0),
                      ),
                    ),
                    padding: MaterialStateProperty.all<EdgeInsets>(
                        const EdgeInsets.symmetric(
                            horizontal: 50, vertical: 10)),
                  ),
                  onPressed: () {
                    sendMessage("", widget.isAdmin ? "leave1" : "leave2");
                    widget.changeState(0);
                  },
                  child: Text(
                    "Quitter",
                    style: GoogleFonts.getFont(
                      "Jura",
                      fontSize: 20,
                      color: Colors.white,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ),
            ],
          )
        : GameScreen(
            switchFrames: switchFrames,
            next1: next1,
            next2: next2,
            code: widget.code,
            isAdmin: widget.isAdmin,
            questions: questions,
            skip1: skip1,
            skip2: skip2,
            nombreManches: nombreManches,
            changeState: widget.changeState,
            sendMessage: sendMessage,
            mancheActuelle: mancheActuelle,
            frames: listFrames[mancheActuelle - 1],
            disposition1: disposition1,
            gamePoints: gamePoints,
            finish: finish,
            initiateFrames: initiateFrames,
            endRound: endRound,
            isFramesInitialised: isFramesInitialised,
          );
  }
}
