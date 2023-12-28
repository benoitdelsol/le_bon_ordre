import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:le_bon_ordre_v2/question.dart';

class ResultScreen extends StatefulWidget {
  const ResultScreen({super.key,
  required this.code,
    required this.isAdmin,
    required this.frames,
    required this.question,
    required this.disposition,
    required this.nombreManches,
    required this.mancheActuelle,
    required this.next1,
    required this.next2,
    required this.sendMessage,
    required this.changeState,
    required this.gamePoints,

  });

  final String code;
  final bool isAdmin;
  final List<List<String>> frames;
  final Question question;
  final List<int> disposition;
  final int mancheActuelle;
  final int nombreManches;
  final bool next1;
  final bool next2;
  final void Function(String, String) sendMessage;
  final void Function(int) changeState;
  final List<int> gamePoints;


  @override
  State<ResultScreen> createState() => _ResultScreenState();
}

class _ResultScreenState extends State<ResultScreen> {

  bool showResult = false;
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

    questionsReconstruite = reconstructList(widget.question.reponses,widget.disposition);

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
                  widget.frames[i][0] != ""
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
                          color: widget.frames[i][0] ==
                              widget.question
                                  .reponses[i - 5][0]
                              ? Colors.green
                              : Colors.red,
                          width: 5),
                      image: DecorationImage(
                          image: NetworkImage(
                              widget.frames[i][1]),
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
                                widget.frames[i][0],
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
                  widget.frames[i][0] != ""
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
                          color: widget.frames[i][0] ==
                              widget.question
                                  .reponses[i - 5][0]
                              ? Colors.green
                              : Colors.red,
                          width: 5),
                      image: DecorationImage(
                          image: NetworkImage(
                              widget.frames[i][1]),
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
                                widget.frames[i][0],
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
                  widget.isAdmin ? widget.next1
                      ? Colors.green
                      : const Color.fromRGBO(226, 32, 46, 1) : widget.next2 ? Colors.green : const Color.fromRGBO(226, 32, 46, 1)),
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
                widget.sendMessage("",
                    widget.isAdmin ?"next1":"next2");
              }else{
                widget.sendMessage("", "leaveEnd");
                setState(() {
                  widget.changeState(0);
                });
              }
            },
            child: Text(
              widget.mancheActuelle<widget.nombreManches?"Continuer ${(widget.next1?1:0) + (widget.next2?1:0)}/2":"Quitter",
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
                  (widget.gamePoints[0]).toString(),
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
                  (widget.gamePoints[1]).toString(),
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
