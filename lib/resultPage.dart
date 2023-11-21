import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:le_bon_ordre/questionClass.dart';
import 'package:socket_io_client/socket_io_client.dart';

import 'dio.dart';

class ResultPage extends StatefulWidget {
  var frames1;
  Question question;
  String code;
  List<int> points;
  bool isAdmin;
  List<int> disposition;
  int mancheActuelle;
  int nombreManches;
  var changeState;
  Socket socket;
  var sendMessage;
  bool ready1;
  bool ready2;
  var resetGotQuestions;
  var resetMancheActuelle;

  ResultPage({super.key,
    required this.resetGotQuestions,
    required this.resetMancheActuelle,
    required this.ready1,
    required this.ready2,
    required this.sendMessage,
    required this.socket,
    required this.changeState,
    required this.nombreManches,
    required this.mancheActuelle,
    required this.points,
    required this.code,
    required this.frames1,
    required this.question,
    required this.isAdmin,
    required this.disposition});

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

  late List<List<String>> questionsReconstruite;

  List<List<String>> reconstructList(List<List<String>> originalList, List<int> positions) {
    List<List<String>> reconstructedList = List.filled(originalList.length, ["",""]);

    for (int i = 0; i < positions.length; i++) {
      if (positions[i] != 6) {
        int index = positions[i];
        reconstructedList[index] = originalList[i];
      }
    }

    return reconstructedList;
  }

  @override
  Widget build(BuildContext context) {
    int readyValue = widget.ready1?1:0;
    readyValue = widget.ready2?readyValue+1:readyValue;

    questionsReconstruite = reconstructList(widget.question.reponses,widget.disposition);


    print(widget.disposition);

    return !showResult
        ? Stack(
      children: [
        Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            widget.isAdmin
                ? Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                for (int i = 5; i < 10; i++)
                  widget.frames1[i][0] != ""
                      ? Container(
                    height:
                    MediaQuery
                        .sizeOf(context)
                        .width / 10,
                    width:
                    MediaQuery
                        .sizeOf(context)
                        .width / 10,
                    decoration: BoxDecoration(
                      border: Border.all(
                          color: widget.frames1[i][0] ==
                              widget.question
                                  .reponses[i - 5][0]
                              ? Colors.green
                              : Colors.red,
                          width: 5),
                      image: DecorationImage(
                          image: NetworkImage(
                              widget.frames1[i][1]),
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
                          width: MediaQuery
                              .sizeOf(context)
                              .width /
                              10,
                          decoration: const BoxDecoration(
                            color: Color.fromRGBO(
                                226, 32, 46, 1),
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
                      height:
                      MediaQuery
                          .sizeOf(context)
                          .width /
                          10,
                      width:
                      MediaQuery
                          .sizeOf(context)
                          .width /
                          10,
                      decoration: const BoxDecoration(
                        borderRadius: BorderRadius.all(
                            Radius.elliptical(10, 10)),
                      ),
                    ),
                  ),
              ],
            )
                : Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                for (int i = 0; i < 5; i++)
                  questionsReconstruite[i][0] != ""
                      ? Container(
                    height:
                    MediaQuery
                        .sizeOf(context)
                        .width / 10,
                    width:
                    MediaQuery
                        .sizeOf(context)
                        .width / 10,
                    decoration: BoxDecoration(
                      border: Border.all(
                          color: widget.disposition[i] == i
                              ? Colors.green
                              : Colors.red,
                          width: 5),
                      image: DecorationImage(
                          image: NetworkImage(
                              questionsReconstruite[i][1]),
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
                          width: MediaQuery
                              .sizeOf(context)
                              .width /
                              10,
                          decoration: const BoxDecoration(
                            color: Color.fromRGBO(
                                226, 32, 46, 1),
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
                                questionsReconstruite[i][0],
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
                      height:
                      MediaQuery
                          .sizeOf(context)
                          .width /
                          10,
                      width:
                      MediaQuery
                          .sizeOf(context)
                          .width /
                          10,
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
                    height: MediaQuery
                        .sizeOf(context)
                        .width / 7,
                    width: MediaQuery
                        .sizeOf(context)
                        .width / 7,
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
                          width: MediaQuery
                              .sizeOf(context)
                              .width / 7,
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
            widget.isAdmin
                ? Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                for (int i = 0; i < 5; i++)
                  questionsReconstruite[i][0] != ""
                      ? Container(
                    height:
                    MediaQuery
                        .sizeOf(context)
                        .width / 10,
                    width:
                    MediaQuery
                        .sizeOf(context)
                        .width / 10,
                    decoration: BoxDecoration(
                      border: Border.all(
                          color: widget.disposition[i] == i
                              ? Colors.green
                              : Colors.red,
                          width: 5),
                      image: DecorationImage(
                          image: NetworkImage(
                              questionsReconstruite[i][1]),
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
                          width: MediaQuery
                              .sizeOf(context)
                              .width /
                              10,
                          decoration: const BoxDecoration(
                            color: Color.fromRGBO(
                                226, 32, 46, 1),
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
                                questionsReconstruite[i][0],
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
                      height:
                      MediaQuery
                          .sizeOf(context)
                          .width /
                          10,
                      width:
                      MediaQuery
                          .sizeOf(context)
                          .width /
                          10,
                      decoration: const BoxDecoration(
                        borderRadius: BorderRadius.all(
                            Radius.elliptical(10, 10)),
                      ),
                    ),
                  ),
              ],
            )
                : Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                for (int i = 5; i < 10; i++)
                  widget.frames1[i][0] != ""
                      ? Container(
                    height:
                    MediaQuery
                        .sizeOf(context)
                        .width / 10,
                    width:
                    MediaQuery
                        .sizeOf(context)
                        .width / 10,
                    decoration: BoxDecoration(
                      border: Border.all(
                          color: widget.frames1[i][0] ==
                              widget.question
                                  .reponses[i - 5][0]
                              ? Colors.green
                              : Colors.red,
                          width: 5),
                      image: DecorationImage(
                          image: NetworkImage(
                              widget.frames1[i][1]),
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
                          width: MediaQuery
                              .sizeOf(context)
                              .width /
                              10,
                          decoration: const BoxDecoration(
                            color: Color.fromRGBO(
                                226, 32, 46, 1),
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
                      height:
                      MediaQuery
                          .sizeOf(context)
                          .width /
                          10,
                      width:
                      MediaQuery
                          .sizeOf(context)
                          .width /
                          10,
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
                  widget.isAdmin ? widget.ready1 == true
                      ? Colors.green
                      : const Color.fromRGBO(226, 32, 46, 1) : widget.ready2 ==
                      1 ? Colors.green : const Color.fromRGBO(226, 32, 46, 1)),
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
              if (widget.mancheActuelle <widget.nombreManches) {
                widget.sendMessage(
                    widget.isAdmin ? "ready1" : "ready2", "ready");
              }else{
                widget.sendMessage("0", "leave");
                widget.resetGotQuestions();
                widget.resetMancheActuelle();
                setState(() {
                  widget.changeState(0);
                });
              }
            },
            child: Text(
              widget.mancheActuelle<widget.nombreManches?"Continuer ${readyValue}/2":"Quitter",
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
                )
              ],
            ),
            Container(
              height: MediaQuery
                  .sizeOf(context)
                  .height - 100,
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
