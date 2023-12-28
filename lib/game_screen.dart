import 'dart:math';

import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:le_bon_ordre_v2/result_screen.dart';
import 'package:timer_count_down/timer_controller.dart';
import 'package:timer_count_down/timer_count_down.dart';

import 'dio.dart';
import 'question.dart';

class GameScreen extends StatefulWidget {
  const GameScreen({
    super.key,
    required this.isAdmin,
    required this.skip1,
    required this.skip2,
    required this.next1,
    required this.next2,
    required this.sendMessage,
    required this.nombreManches,
    required this.mancheActuelle,
    required this.questions,
    required this.changeState,
    required this.code,
    required this.frames,
    required this.initiateFrames,
    required this.finish,
    required this.disposition1,
    required this.endRound,
    required this.switchFrames,
    required this.gamePoints,
    required this.isFramesInitialised,
  });

  final bool isAdmin;
  final bool skip1;
  final bool skip2;
  final bool next1;
  final bool next2;
  final void Function(String, String) sendMessage;
  final int nombreManches;
  final int mancheActuelle;
  final List<Question> questions;
  final void Function(int) changeState;
  final String code;
  final List<List<String>> frames;
  final void Function() initiateFrames;
  final bool finish;
  final List<int>  disposition1;
  final void Function() endRound;
  final void Function(int,int) switchFrames;
  final List<int> gamePoints;
  final bool isFramesInitialised;

  @override
  State<GameScreen> createState() => _GameScreenState();
}

class _GameScreenState extends State<GameScreen> {
  int selectedFrame = -1;


  final CountdownController _controller = CountdownController(autoStart: true);

  bool displayMessage = false;

  int mancheActuelle = 1;



  late List<List<String>> frames2;




  @override
  Widget build(BuildContext context) {
    if (!widget.finish) {
      return Stack(
        children: [
          Positioned(
              top: 5,
              right: 5,
              child: Column(
                children: [
                  Container(
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
                        ),
                      ),
                    ),
                  ),
                  Container(
                    width: 50,
                    height: 50,
                    decoration: BoxDecoration(
                      color: widget.isAdmin
                          ? widget.skip1
                              ? Colors.green
                              : const Color.fromRGBO(226, 32, 46, 1)
                          : widget.skip2
                              ? Colors.green
                              : const Color.fromRGBO(226, 32, 46, 1),
                      borderRadius:
                          const BorderRadius.all(Radius.elliptical(25, 25)),
                    ),
                    child: Center(
                      child: IconButton(
                          splashRadius: 0.1,
                          onPressed: () {
                            widget.sendMessage(
                                "", widget.isAdmin ? "skip1" : "skip2");
                          },
                          icon: const Icon(
                            Icons.check,
                            color: Colors.white,
                          )),
                    ),
                  ),
                ],
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
                    padding: const EdgeInsets.only(left: 20),
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
                        widget.endRound();
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
                      widget.frames[i][0] != ""
                          ? Draggable(
                              data: i,
                              feedback: Container(
                                height: MediaQuery.sizeOf(context).width / 7,
                                width: MediaQuery.sizeOf(context).width / 7,
                                decoration: BoxDecoration(
                                  image: DecorationImage(
                                      image: NetworkImage(widget.frames[i][1]),
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
                                            widget.frames[i][0]
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
                                      image: NetworkImage(widget.frames[i][1]),
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
                                            widget.frames[i][0]
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
                                widget.switchFrames(i, data);
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
                      widget.frames[i][0] != ""
                          ? Draggable(
                              data: i,
                              feedback: SizedBox(
                                child: Container(
                                  height: MediaQuery.sizeOf(context).width / 7,
                                  width: MediaQuery.sizeOf(context).width / 7,
                                  decoration: BoxDecoration(
                                    image: DecorationImage(
                                        image: NetworkImage(widget.frames[i][1]),
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
                                              widget.frames[i][0]
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
                                        image: NetworkImage(widget.frames[i][1]),
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
                                              widget.frames[i][0]
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
                                widget.switchFrames(i, data);
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
                                backgroundColor:
                                    MaterialStateProperty.all<Color>(
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
                                backgroundColor:
                                    MaterialStateProperty.all<Color>(
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
                                widget.sendMessage("", "leave");
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
      return ResultScreen(
        changeState: widget.changeState,
        nombreManches: widget.nombreManches,
        mancheActuelle: widget.mancheActuelle,
        disposition: widget.disposition1,
        isAdmin: widget.isAdmin,
        gamePoints: widget.gamePoints,
        code: widget.code,
        frames: widget.frames,
        question: widget.questions[widget.mancheActuelle - 1],
        next1: widget.next1,
        next2: widget.next2,
        sendMessage: widget.sendMessage,
      );
    }
  }
}
