import 'dart:math';

import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:le_bon_ordre/dio.dart';
import 'package:le_bon_ordre/questionClass.dart';
import 'package:le_bon_ordre/resultPage.dart';
import 'package:timer_count_down/timer_controller.dart';
import 'package:timer_count_down/timer_count_down.dart';

class MainGamePage extends StatefulWidget {
  int nombreManches;
  bool isAdmin;
  String code;

  MainGamePage({
    super.key,
    required this.nombreManches,
    required this.isAdmin,
    required this.code,
  });

  @override
  State<MainGamePage> createState() => _MainGamePageState();
}

class _MainGamePageState extends State<MainGamePage> {
  int selectedFrame = -1;

  bool finish = false;

  int mancheActuelle = 1;

  int points =0;

  List<List<String>> frames = [];

  final CountdownController _controller = CountdownController(autoStart: true);

  void changeQuestion() {
    setState(
      () {
        finish = true;
      },
    );
  }

  List<List<String>> framesTemp = [];

  void nextQuestion() {
    setState(
      () {
        finish = false;
        _controller.restart();
        mancheActuelle++;
        isFramesInitialised = false;
        frames.clear();
      },
    );
  }
  late List<int> gamePoints;
  List<dynamic> response = [];


  List<int> disposition1 = [];

  bool isFramesInitialised = false;

  resetFI() {
    isFramesInitialised = false;
  }

  @override
  Widget build(BuildContext context) {
    String disposition="";
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
    Future<List<Question>> questions;
    return FutureBuilder(
      future: questions = getQuestions(),
      builder: (BuildContext context, AsyncSnapshot<List<Question>> snapshot) {
        if (snapshot.data != null) {
          print(snapshot.data!.length);
          if (!isFramesInitialised) {
            frames = List.from(List<List<String>>.from(
                snapshot.data![mancheActuelle - 1].reponses));
            frames.shuffle(Random());
            frames = frames +
                [
                  ["", ""],
                  ["", ""],
                  ["", ""],
                  ["", ""],
                  ["", ""],
                ];
            isFramesInitialised = true;
          }

          if (!finish) {
            return Stack(
              children: [
                Positioned(
                  top: 5,
                  right: 5,
                  child: Countdown(
                    controller: _controller,
                    seconds: 10,
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
                      disposition1= [];
                      points=0;
                      for (int i = 5; i < 10; i++) {
                        if (frames[i][0] == snapshot.data![mancheActuelle-1].reponses[i-5][0]) {
                            points+=1;
                        }
                      }

                      List<String> names = snapshot.data![mancheActuelle-1].reponses.map((e) => e[0]).toList();
                      List<String>names2 = frames.sublist(5,10).map((e) => e[0]).toList();
                      String name;

                      for(name in names){
                        disposition1.add(names2.indexOf(name));
                      }

                      for(int i =0; i<disposition1.length;i++){
                        if (disposition1[i] == -1){
                          disposition1[i] = 6;
                        }
                      }


                      if(widget.isAdmin){
                        response = await sendPoints(widget.code.toUpperCase(), points, 0, disposition1);
                        gamePoints = response[0];
                        disposition1 = response[1];
                      }else{
                        response =await sendPoints(widget.code.toUpperCase(), points, 1, disposition1);
                        gamePoints = response[0];
                        disposition1 = response[1];
                      }

                      setState(() {

                        changeQuestion();
                      });
                    },
                  ),
                ),
                Positioned(
                  top: 0,
                  child: Row(
                    children: [
                      Text(
                        "ROUND #$mancheActuelle",
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
                            borderRadius: const BorderRadius.all(
                                Radius.elliptical(50, 50)),
                          ),
                          child: Center(
                            child: Text(
                              snapshot.data![mancheActuelle - 1].type,
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
                    ],
                  ),
                ),
                Positioned(
                  left: 5,
                  top: 80,
                  child: Text(
                    snapshot.data![mancheActuelle - 1].titre,
                    style: GoogleFonts.getFont(
                      "Jura",
                      fontSize: 20,
                      color: Colors.white,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
                Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        for (int i = 0; i < 5; i++)
                          frames[i][0] != ""
                              ? Draggable(
                                  data: i,
                                  feedback: Container(
                                    height:
                                        MediaQuery.sizeOf(context).width / 7,
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
                                                  Radius.elliptical(10, 10),
                                            ),
                                          ),
                                          child: Center(
                                            child: FittedBox(
                                              fit: BoxFit.scaleDown,
                                              child: Text(
                                                frames[i][0],
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
                                      height:
                                          MediaQuery.sizeOf(context).width / 7,
                                      width:
                                          MediaQuery.sizeOf(context).width / 7,
                                      decoration: const BoxDecoration(
                                        borderRadius: BorderRadius.all(
                                            Radius.elliptical(10, 10)),
                                      ),
                                    ),
                                  ),
                                  child: Container(
                                    height:
                                        MediaQuery.sizeOf(context).width / 7,
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
                                                  Radius.elliptical(10, 10),
                                            ),
                                          ),
                                          child: Center(
                                            child: FittedBox(
                                              fit: BoxFit.scaleDown,
                                              child: Text(
                                                frames[i][0],
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
                                            MediaQuery.sizeOf(context).width /
                                                7,
                                        width:
                                            MediaQuery.sizeOf(context).width /
                                                7,
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
                                        height:
                                            MediaQuery.sizeOf(context).width /
                                                7,
                                        width:
                                            MediaQuery.sizeOf(context).width /
                                                7,
                                        decoration: BoxDecoration(
                                          image: DecorationImage(
                                              image: NetworkImage(frames[i][1]),
                                              fit: BoxFit.cover),
                                          borderRadius: const BorderRadius.all(
                                              Radius.elliptical(10, 10)),
                                        ),
                                        child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.end,
                                          children: [
                                            Container(
                                              height: 30,
                                              width: MediaQuery.sizeOf(context)
                                                      .width /
                                                  7,
                                              decoration: const BoxDecoration(
                                                  color: Color.fromRGBO(
                                                      226, 32, 46, 1),
                                                  borderRadius:
                                                      BorderRadius.only(
                                                          bottomLeft:
                                                              Radius.elliptical(
                                                                  10, 10),
                                                          bottomRight:
                                                              Radius.elliptical(
                                                                  10, 10))),
                                              child: Center(
                                                child: FittedBox(
                                                  fit: BoxFit.scaleDown,
                                                  child: Text(
                                                    frames[i][0],
                                                    style: GoogleFonts.getFont(
                                                      "Jura",
                                                      color: Colors.white,
                                                      fontWeight:
                                                          FontWeight.w500,
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
                                        height:
                                            MediaQuery.sizeOf(context).width /
                                                7,
                                        width:
                                            MediaQuery.sizeOf(context).width /
                                                7,
                                        decoration: const BoxDecoration(
                                          borderRadius: BorderRadius.all(
                                              Radius.elliptical(10, 10)),
                                        ),
                                      ),
                                    ),
                                    child: SizedBox(
                                      child: Container(
                                        height:
                                            MediaQuery.sizeOf(context).width /
                                                7,
                                        width:
                                            MediaQuery.sizeOf(context).width /
                                                7,
                                        decoration: BoxDecoration(
                                          image: DecorationImage(
                                              image: NetworkImage(frames[i][1]),
                                              fit: BoxFit.cover),
                                          borderRadius: const BorderRadius.all(
                                              Radius.elliptical(10, 10)),
                                        ),
                                        child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.end,
                                          children: [
                                            Container(
                                              height: 30,
                                              width: MediaQuery.sizeOf(context)
                                                      .width /
                                                  7,
                                              decoration: const BoxDecoration(
                                                  color: Color.fromRGBO(
                                                      226, 32, 46, 1),
                                                  borderRadius:
                                                      BorderRadius.only(
                                                          bottomLeft:
                                                              Radius.elliptical(
                                                                  10, 10),
                                                          bottomRight:
                                                              Radius.elliptical(
                                                                  10, 10))),
                                              child: Center(
                                                child: FittedBox(
                                                  fit: BoxFit.scaleDown,
                                                  child: Text(
                                                    frames[i][0],
                                                    style: GoogleFonts.getFont(
                                                      "Jura",
                                                      color: Colors.white,
                                                      fontWeight:
                                                          FontWeight.w500,
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
                                              MediaQuery.sizeOf(context).width /
                                                  7,
                                          width:
                                              MediaQuery.sizeOf(context).width /
                                                  7,
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
                )
              ],
            );
          } else {
            return ResultPage(
              disposition: disposition1,
              isAdmin: widget.isAdmin,
              points: gamePoints,
              code: widget.code,
              nextQuestion: nextQuestion,
              frames1: frames,
              question: snapshot.data![mancheActuelle - 1],
              resetFI: resetFI,
            );
          }
        } else {
          return const Center(
            child: CircularProgressIndicator(
              color: Color.fromRGBO(226, 32, 46, 1),
            ),
          );
        }
        return Text("no widget");
      },
    );
  }
}
