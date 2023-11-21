import 'dart:math';

import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:le_bon_ordre/dio.dart';
import 'package:le_bon_ordre/questionClass.dart';
import 'package:le_bon_ordre/resultPage.dart';
import 'package:socket_io_client/socket_io_client.dart';
import 'package:timer_count_down/timer_controller.dart';
import 'package:timer_count_down/timer_count_down.dart';

class MainGamePage extends StatefulWidget {
  int nombreManches;
  bool isAdmin;
  String code;
  var changeState;
  Socket socket;
  bool ready1;
  bool ready2;
  var sendMessage;
  int mancheActuelle;
  List<Question> questions;
  var changeFinishState;
  bool isFramesInitialised;
  bool finish;
  var changeFrames;
  var resetMancheActuelle;
  var resetGotQuestions;

  MainGamePage(
      {required this.resetGotQuestions,
      required this.resetMancheActuelle,
      required this.finish,
      required this.changeFrames,
      required this.isFramesInitialised,
      required this.changeFinishState,
      required this.ready1,
      required this.mancheActuelle,
      required this.ready2,
      required this.sendMessage,
      super.key,
      required this.socket,
      required this.nombreManches,
      required this.isAdmin,
      required this.code,
      required this.changeState,
      required this.questions});

  @override
  State<MainGamePage> createState() => _MainGamePageState();
}

class _MainGamePageState extends State<MainGamePage> {
  int selectedFrame = -1;

  int points = 0;

  List<List<String>> frames = [];

  final CountdownController _controller = CountdownController(autoStart: true);

  List<List<String>> framesTemp = [];

  late List<int> gamePoints;
  List<dynamic> response = [];

  List<int> disposition1 = [];
  bool displayMessage = false;

  @override
  Widget build(BuildContext context) {
    String disposition = "";
    if (!frames.isNotEmpty) {
      frames = [
        ["", ""],
        ["", ""],
        ["", ""],
        ["", ""],
        ["", ""],
        ["", ""],
        ["", ""],
        ["", ""],
        ["", ""],
        ["", ""],
      ];
    }
    if (!widget.isFramesInitialised) {
      frames = List.from(List<List<String>>.from(
          widget.questions[widget.mancheActuelle - 1].reponses));
      frames.shuffle(Random());
      frames = frames +
          [
            ["", ""],
            ["", ""],
            ["", ""],
            ["", ""],
            ["", ""],
          ];
      widget.isFramesInitialised = true;
    }

    if (!widget.finish) {
      return Stack(
        children: [
          Positioned(
              top: 5,
              right: 5,
              child: Container(
                width: 50,
                height: 50,
                decoration: const BoxDecoration(
                  color: Color.fromRGBO(226, 32, 46, 1),
                  borderRadius: BorderRadius.all(Radius.elliptical(25, 25)),
                ),
                child: Center(
                  child: IconButton(
                    splashRadius: 0.1,
                      onPressed: () {
                        setState(() {
                          displayMessage = !displayMessage;
                        });
                      },
                      icon: const Icon(
                        Icons.home,
                        color: Colors.white,
                      )),
                ),
              )),
          Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Text(
                    "ROUND #${widget.mancheActuelle}",
                    style: GoogleFonts.getFont(
                      "Erica One",
                      fontSize: 50,
                      color: const Color.fromRGBO(226, 32, 46, 1),
                    ),
                  ),
                  Align(
                    child: Container(
                      height: 40,
                      width: 150,
                      margin: const EdgeInsets.only(top: 5, left: 40),
                      decoration: BoxDecoration(
                        border: Border.all(
                            color: const Color.fromRGBO(226, 32, 46, 1),
                            width: 1.0),
                        borderRadius:
                            const BorderRadius.all(Radius.elliptical(50, 50)),
                      ),
                      child: Center(
                        child: Text(
                          widget.questions[widget.mancheActuelle - 1].type,
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
                  Padding(
                    padding: const EdgeInsets.only(left:20),
                    child: Countdown(
                      controller: _controller,
                      seconds: 60,
                      build: (_, double time) => Text(
                        time.toString(),
                        style: GoogleFonts.getFont(
                          "Erica One",
                          fontSize: 50,
                          color: const Color.fromRGBO(226, 32, 46, 1),
                        ),
                      ),
                      interval: const Duration(milliseconds: 100),
                      onFinished: () async {
                        disposition1 = [];
                        points = 0;
                        for (int i = 5; i < 10; i++) {
                          if (frames[i][0] ==
                              widget.questions[widget.mancheActuelle - 1]
                                  .reponses[i - 5][0]) {
                            points += 1;
                          }
                        }
                        List<String> names = widget
                            .questions[widget.mancheActuelle - 1].reponses
                            .map((e) => e[0])
                            .toList();
                        List<String> names2 =
                            frames.sublist(5, 10).map((e) => e[0]).toList();
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
                          response = await sendPoints(
                              widget.code.toUpperCase(), points, 0, disposition1);
                          gamePoints = response[0];
                          disposition1 = response[1];
                          print("disposition1 = " + disposition1.toString());
                        } else {
                          response = await sendPoints(
                              widget.code.toUpperCase(), points, 1, disposition1);
                          gamePoints = response[0];
                          disposition1 = response[1];
                          print("disposition1 = " + disposition1.toString());
                        }
                        widget.changeFrames(frames);
                        widget.changeFinishState();
                        setState(() {});
                      },
                    ),
                  ),
                ],
              ),
              Text(
                widget.questions[widget.mancheActuelle - 1].titre
                    .replaceAll("\\n", "\n"),
                style: GoogleFonts.getFont(
                  "Jura",
                  fontSize: 20,
                  color: Colors.white,
                  fontWeight: FontWeight.w500,
                ),
              ),
              SizedBox(
                width: MediaQuery.sizeOf(context).width,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    for (int i = 0; i < 5; i++)
                      frames[i][0] != ""
                          ? Draggable(
                              data: i,
                              feedback: Container(
                                height: MediaQuery.sizeOf(context).width / 7,
                                width: MediaQuery.sizeOf(context).width / 7,
                                decoration: BoxDecoration(
                                  image: DecorationImage(
                                      image: NetworkImage(frames[i][1]),
                                      fit: BoxFit.cover),
                                  borderRadius: const BorderRadius.all(
                                      Radius.elliptical(10, 10)),
                                ),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: [
                                    Container(
                                      height: 30,
                                      width:
                                          MediaQuery.sizeOf(context).width / 7,
                                      decoration: const BoxDecoration(
                                        color: Color.fromRGBO(226, 32, 46, 1),
                                        borderRadius: BorderRadius.only(
                                          bottomLeft: Radius.elliptical(10, 10),
                                          bottomRight:
                                              Radius.elliptical(10, 10),
                                        ),
                                      ),
                                      child: Center(
                                        child: FittedBox(
                                          fit: BoxFit.scaleDown,
                                          child: Text(
                                            frames[i][0]
                                                .replaceAll("\\n", "\n"),
                                            style: GoogleFonts.getFont(
                                              "Jura",
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
                              childWhenDragging: DottedBorder(
                                borderType: BorderType.RRect,
                                color: Colors.white,
                                radius: const Radius.circular(10),
                                child: Container(
                                  height: MediaQuery.sizeOf(context).width / 7,
                                  width: MediaQuery.sizeOf(context).width / 7,
                                  decoration: const BoxDecoration(
                                    borderRadius: BorderRadius.all(
                                        Radius.elliptical(10, 10)),
                                  ),
                                ),
                              ),
                              child: Container(
                                height: MediaQuery.sizeOf(context).width / 7,
                                width: MediaQuery.sizeOf(context).width / 7,
                                decoration: BoxDecoration(
                                  image: DecorationImage(
                                      image: NetworkImage(frames[i][1]),
                                      fit: BoxFit.cover),
                                  borderRadius: const BorderRadius.all(
                                      Radius.elliptical(10, 10)),
                                ),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: [
                                    Container(
                                      height: 30,
                                      width:
                                          MediaQuery.sizeOf(context).width / 7,
                                      decoration: const BoxDecoration(
                                        color: Color.fromRGBO(226, 32, 46, 1),
                                        borderRadius: BorderRadius.only(
                                          bottomLeft: Radius.elliptical(10, 10),
                                          bottomRight:
                                              Radius.elliptical(10, 10),
                                        ),
                                      ),
                                      child: Center(
                                        child: FittedBox(
                                          fit: BoxFit.scaleDown,
                                          child: Text(
                                            frames[i][0]
                                                .replaceAll("\\n", "\n"),
                                            style: GoogleFonts.getFont(
                                              "Jura",
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
                            )
                          : DragTarget(
                              onAccept: (int data) {
                                setState(() {
                                  frames[i] = frames[data];
                                  frames[data] = ["", ""];
                                });
                              },
                              builder: (BuildContext context,
                                  List<dynamic> accepted,
                                  List<dynamic> rejected) {
                                return DottedBorder(
                                  borderType: BorderType.RRect,
                                  color: Colors.white,
                                  radius: const Radius.circular(10),
                                  child: Container(
                                    height:
                                        MediaQuery.sizeOf(context).width / 7,
                                    width: MediaQuery.sizeOf(context).width / 7,
                                    decoration: const BoxDecoration(
                                      borderRadius: BorderRadius.all(
                                        Radius.elliptical(10, 10),
                                      ),
                                    ),
                                  ),
                                );
                              },
                            ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 10.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    const Icon(
                      Icons.remove,
                      color: Color.fromRGBO(226, 32, 46, 1),
                    ),
                    for (int i = 5; i < 10; i++)
                      frames[i][0] != ""
                          ? Draggable(
                              data: i,
                              feedback: SizedBox(
                                child: Container(
                                  height: MediaQuery.sizeOf(context).width / 7,
                                  width: MediaQuery.sizeOf(context).width / 7,
                                  decoration: BoxDecoration(
                                    image: DecorationImage(
                                        image: NetworkImage(frames[i][1]),
                                        fit: BoxFit.cover),
                                    borderRadius: const BorderRadius.all(
                                        Radius.elliptical(10, 10)),
                                  ),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    children: [
                                      Container(
                                        height: 30,
                                        width:
                                            MediaQuery.sizeOf(context).width /
                                                7,
                                        decoration: const BoxDecoration(
                                            color:
                                                Color.fromRGBO(226, 32, 46, 1),
                                            borderRadius: BorderRadius.only(
                                                bottomLeft:
                                                    Radius.elliptical(10, 10),
                                                bottomRight:
                                                    Radius.elliptical(10, 10))),
                                        child: Center(
                                          child: FittedBox(
                                            fit: BoxFit.scaleDown,
                                            child: Text(
                                              frames[i][0]
                                                  .replaceAll("\\n", "\n"),
                                              style: GoogleFonts.getFont(
                                                "Jura",
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
                              childWhenDragging: DottedBorder(
                                borderType: BorderType.RRect,
                                color: Colors.white,
                                radius: const Radius.circular(10),
                                child: Container(
                                  height: MediaQuery.sizeOf(context).width / 7,
                                  width: MediaQuery.sizeOf(context).width / 7,
                                  decoration: const BoxDecoration(
                                    borderRadius: BorderRadius.all(
                                        Radius.elliptical(10, 10)),
                                  ),
                                ),
                              ),
                              child: SizedBox(
                                child: Container(
                                  height: MediaQuery.sizeOf(context).width / 7,
                                  width: MediaQuery.sizeOf(context).width / 7,
                                  decoration: BoxDecoration(
                                    image: DecorationImage(
                                        image: NetworkImage(frames[i][1]),
                                        fit: BoxFit.cover),
                                    borderRadius: const BorderRadius.all(
                                        Radius.elliptical(10, 10)),
                                  ),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    children: [
                                      Container(
                                        height: 30,
                                        width:
                                            MediaQuery.sizeOf(context).width /
                                                7,
                                        decoration: const BoxDecoration(
                                            color:
                                                Color.fromRGBO(226, 32, 46, 1),
                                            borderRadius: BorderRadius.only(
                                                bottomLeft:
                                                    Radius.elliptical(10, 10),
                                                bottomRight:
                                                    Radius.elliptical(10, 10))),
                                        child: Center(
                                          child: FittedBox(
                                            fit: BoxFit.scaleDown,
                                            child: Text(
                                              frames[i][0]
                                                  .replaceAll("\\n", "\n"),
                                              style: GoogleFonts.getFont(
                                                "Jura",
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
                            )
                          : DragTarget(
                              onAccept: (int data) {
                                setState(
                                  () {
                                    frames[i] = frames[data];
                                    frames[data] = ["", ""];
                                  },
                                );
                              },
                              builder: (BuildContext context,
                                  List<dynamic> accepted,
                                  List<dynamic> rejected) {
                                return DottedBorder(
                                  borderType: BorderType.RRect,
                                  color: Colors.white,
                                  radius: const Radius.circular(10),
                                  child: Container(
                                    height:
                                        MediaQuery.sizeOf(context).width / 7,
                                    width: MediaQuery.sizeOf(context).width / 7,
                                    decoration: const BoxDecoration(
                                      borderRadius: BorderRadius.all(
                                          Radius.elliptical(10, 10)),
                                    ),
                                  ),
                                );
                              },
                            ),
                    const Icon(
                      Icons.add,
                      color: Color.fromRGBO(226, 32, 46, 1),
                    ),
                  ],
                ),
              )
            ],
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
                width: !displayMessage
                    ? 0
                    : MediaQuery.of(context).size.width * 0.7,
                height: !displayMessage
                    ? 0
                    : MediaQuery.of(context).size.height * 0.7,
                child: Stack(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Center(
                        child: SizedBox(
                          height: MediaQuery.of(context).size.height * 0.7,
                          child: FittedBox(
                            fit: BoxFit.scaleDown,
                            child: Text(
                              "Voulez-vous vraiment quitter la partie ?",
                              style: GoogleFonts.getFont(
                                "Erica One",
                                color: const Color.fromRGBO(226, 32, 46, 1),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                    Align(
                      alignment: Alignment.bottomCenter,
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            TextButton(
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
                                    displayMessage = false;
                                  });
                                });
                              },
                              child: Text(
                                "Non",
                                style: GoogleFonts.getFont(
                                  "Jura",
                                  fontSize: 20,
                                  color: Colors.white,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                            TextButton(
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
                                    widget.isAdmin?widget.sendMessage("1","leave"):widget.sendMessage("2","leave");
                                    widget.changeState(0);
                              },
                              child: Text(
                                "Oui",
                                style: GoogleFonts.getFont(
                                  "Jura",
                                  fontSize: 20,
                                  color: Colors.white,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      );
    } else {
      return ResultPage(
        resetGotQuestions: widget.resetGotQuestions,
        resetMancheActuelle: widget.resetMancheActuelle,
        changeState: widget.changeState,
        nombreManches: widget.nombreManches,
        mancheActuelle: widget.mancheActuelle,
        disposition: disposition1,
        isAdmin: widget.isAdmin,
        points: gamePoints,
        code: widget.code,
        frames1: frames,
        question: widget.questions[widget.mancheActuelle - 1],
        ready1: widget.ready1,
        ready2: widget.ready2,
        sendMessage: widget.sendMessage,
        socket: widget.socket,
      );
    }
  }
}
