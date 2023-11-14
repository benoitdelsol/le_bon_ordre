import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:le_bon_ordre/questionClass.dart';

import 'dio.dart';

class ResultPage extends StatefulWidget {
  var nextQuestion;
  var frames1;
  Question question;
  var resetFI;
  String code;
  List<int> points;

  ResultPage({
    super.key,
    required this.points,
    required this.code,
    required this.nextQuestion,
    required this.resetFI,
    required this.frames1,
    required this.question,
  });

  @override
  State<ResultPage> createState() => _ResultPageState();
}

class _ResultPageState extends State<ResultPage> {
  bool showResult = false;

  List<List<String>> frames2 = [
    ["", ""],
    ["", ""],
    ["", ""],
    ["", ""],
    ["", ""],
    ["", ""],
    ["", ""],
    ["", ""],
    ["", ""],
    ["", ""]
  ];
  bool donePoints = false;
  int is1Playesready = 0;
  int is2Playesready = 1;

  late Future<List<int>> points;
  bool pointsAsked = false;

  @override
  Widget build(BuildContext context) {
    if (!donePoints) {
      donePoints = true;
    } else {
      null;
    }
    return !showResult
        ? Stack(
            children: [
              Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      for (int i = 5; i < 10; i++)
                        widget.frames1[i][0] != ""
                            ? Container(
                                height: MediaQuery.sizeOf(context).width / 10,
                                width: MediaQuery.sizeOf(context).width / 10,
                                decoration: BoxDecoration(
                                  border: Border.all(
                                      color: widget.frames1[i][0] ==
                                              widget.question.reponses[i - 5][0]
                                          ? Colors.green
                                          : Colors.red,
                                      width: 5),
                                  image: DecorationImage(
                                      image: NetworkImage(widget.frames1[i][1]),
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
                                          MediaQuery.sizeOf(context).width / 10,
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
                                            widget.frames1[i][0],
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
                              )
                            : DottedBorder(
                                borderType: BorderType.RRect,
                                color: Colors.white,
                                radius: const Radius.circular(10),
                                child: Container(
                                  height: MediaQuery.sizeOf(context).width / 10,
                                  width: MediaQuery.sizeOf(context).width / 10,
                                  decoration: const BoxDecoration(
                                    borderRadius: BorderRadius.all(
                                        Radius.elliptical(10, 10)),
                                  ),
                                ),
                              ),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      for (int i = 0; i < 5; i++)
                        Container(
                          height: MediaQuery.sizeOf(context).width / 7,
                          width: MediaQuery.sizeOf(context).width / 7,
                          decoration: BoxDecoration(
                            image: DecorationImage(
                                image: NetworkImage(
                                    widget.question.reponses[i][1]),
                                fit: BoxFit.cover),
                            borderRadius: const BorderRadius.all(
                                Radius.elliptical(10, 10)),
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              Container(
                                height: 30,
                                width: MediaQuery.sizeOf(context).width / 7,
                                decoration: const BoxDecoration(
                                  color: Color.fromRGBO(226, 32, 46, 1),
                                  borderRadius: BorderRadius.only(
                                    bottomLeft: Radius.elliptical(10, 10),
                                    bottomRight: Radius.elliptical(10, 10),
                                  ),
                                ),
                                child: Center(
                                  child: FittedBox(
                                    fit: BoxFit.scaleDown,
                                    child: Text(
                                      widget.question.reponses[i][0],
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
                        )
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      for (int i = 5; i < 10; i++)
                        frames2[i][0] != ""
                            ? Container(
                                height: MediaQuery.sizeOf(context).width / 10,
                                width: MediaQuery.sizeOf(context).width / 10,
                                decoration: BoxDecoration(
                                  image: DecorationImage(
                                      image: NetworkImage(frames2[i][1]),
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
                                            frames2[i][0],
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
                              )
                            : DottedBorder(
                                borderType: BorderType.RRect,
                                color: Colors.white,
                                radius: const Radius.circular(10),
                                child: Container(
                                  height: MediaQuery.sizeOf(context).width / 10,
                                  width: MediaQuery.sizeOf(context).width / 10,
                                  decoration: const BoxDecoration(
                                    borderRadius: BorderRadius.all(
                                        Radius.elliptical(10, 10)),
                                  ),
                                ),
                              ),
                    ],
                  ),
                ],
              ),
              Positioned(
                bottom: 5,
                right: 5,
                child: Ink(
                  decoration: const ShapeDecoration(
                    color: Color.fromRGBO(226, 32, 46, 1),
                    shape: CircleBorder(),
                  ),
                  child: IconButton(
                      onPressed: () {
                        !pointsAsked ? points = askPoints(widget.code) : null;
                        setState(() {
                          showResult = true;
                        });
                      },
                      icon: const Icon(Icons.arrow_forward_ios_rounded,
                          color: Colors.white, size: 30)),
                ),
              ),
            ],
          )
        : Stack(
            children: [
              Positioned(
                bottom: 5,
                left: 5,
                child: Ink(
                  decoration: const ShapeDecoration(
                    color: Color.fromRGBO(226, 32, 46, 1),
                    shape: CircleBorder(),
                  ),
                  child: IconButton(
                      onPressed: () {
                        setState(() {
                          showResult = false;
                        });
                      },
                      icon: const Icon(Icons.arrow_back_ios_rounded,
                          color: Colors.white, size: 30)),
                ),
              ),
              Positioned(
                right: 20,
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
                    setState(
                      () {
                        if (is1Playesready == 1) {
                          is1Playesready = 0;
                        } else {
                          is1Playesready = 1;
                        }
                        if (is2Playesready == 1 && is1Playesready == 1) {
                          widget.resetFI();
                          widget.nextQuestion();
                        }
                      },
                    );
                  },
                  child: Text(
                    "Continuer ${is1Playesready + is2Playesready}/2",
                    style: GoogleFonts.getFont(
                      "Jura",
                      fontSize: 20,
                      color: Colors.white,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "Équipe 1",
                        style: GoogleFonts.getFont(
                          "Erica One",
                          fontSize: 50,
                          color: const Color.fromRGBO(226, 32, 46, 1),
                        ),
                      ),
                      Text(
                        (widget.points[0]).toString(),
                        style: GoogleFonts.getFont(
                          "Erica One",
                          fontSize: 50,
                          color: const Color.fromRGBO(226, 32, 46, 1),
                        ),
                      ),
                    ],
                  ),
                  Container(
                    height: MediaQuery.sizeOf(context).height - 100,
                    width: 5,
                    color: Colors.white,
                  ),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "Équipe 2",
                        style: GoogleFonts.getFont(
                          "Erica One",
                          fontSize: 50,
                          color: const Color.fromRGBO(226, 32, 46, 1),
                        ),
                      ),
                      Text(
                        (widget.points[1]).toString(),
                        style: GoogleFonts.getFont(
                          "Erica One",
                          fontSize: 50,
                          color: const Color.fromRGBO(226, 32, 46, 1),
                        ),
                      ),
                    ],
                  ),
                ],
              )
            ],
          );
  }
}
