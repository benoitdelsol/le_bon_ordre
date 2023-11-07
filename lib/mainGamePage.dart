import 'dart:math';

import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:le_bon_ordre/questionClass.dart';
import 'package:le_bon_ordre/resultPage.dart';
import 'package:timer_count_down/timer_controller.dart';
import 'package:timer_count_down/timer_count_down.dart';

class MainGamePage extends StatefulWidget {
  int nombreManches;

  MainGamePage({
    super.key,
    required this.nombreManches,
  });

  @override
  State<MainGamePage> createState() => _MainGamePageState();
}

class _MainGamePageState extends State<MainGamePage> {
  final questions = [
    Question(
      "classement",
      "Classez ces sagas\nen fonction du nombre de films :",
      [
        [
          "Blade Runner",
          "https://fr.web.img4.acsta.net/pictures/15/09/23/11/37/330370.jpg"
        ],
        [
          "Qu'est-ce qu'on\na fait au bon Dieu ?",
          "https://www.francetvinfo.fr/pictures/FsDrgl5ZbupkZ_gzkjCdM08DQdg/1200x900/2019/04/11/qu-est-ce-qu-on-a-fait-au-bon-dieu-photo-52f8da36dc564.jpg"
        ],
        [
          "Saw",
          "https://www.rollingstone.com/wp-content/uploads/2023/09/saw-x-64c7aae81e569.jpg?w=1581&h=1054&crop=1"
        ],
        [
          "Fast & Furious",
          "https://www.usmagazine.com/wp-content/uploads/1428049615_mcdsaha_ec188_h_the-fast-the-furious-zoom.jpg?crop=0px%2C215px%2C1280px%2C673px&resize=1200%2C630&quality=40&strip=all"
        ],
        [
          "Godzilla",
          "https://fr.web.img6.acsta.net/pictures/14/03/25/14/43/167915.jpg"
        ]
      ],
    ),
    Question(
      "classement",
      "Classez ces chiens en fonction de leur place\ndans le classement officiel des chiens préférés des francais",
      [
        [
          "Chihuahua",
          "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcRBc269E4A6Gi86Zc2wXj9pxDDEpWVg43oSPTz30vrY9_5qMDaH"
        ],
        [
          "Beagle",
          "https://www.lesrecettesdedaniel.fr/modules/hiblog/views/img/upload/original/c5da253213c69c69585c9c00aa62e1cb.png"
        ],
        [
          "Labrador",
          "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcSqC1Gb3WabctVNJ9HO5FQu1-Io25GORzQVnQ&usqp=CAU"
        ],
        [
          "Golden Retriever",
          "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcRyqk0GvSx0Xsg476Lu5CePgAtK4dsun-g7Ng&usqp=CAU"
        ],
        [
          "Berger Australien",
          "https://media.istockphoto.com/id/493959677/fr/photo/chien-de-race.jpg?s=612x612&w=0&k=20&c=PfaGd6p6UsvdhvY-wpXkm7OpZo02hWYf9zd5JJSBjN0="
        ]
      ],
    )
  ];
  int selectedFrame = -1;

  bool finish = false;

  int mancheActuelle = 1;

  List<int> points = [0, 0];

  void addPoints(int i, int j) {
      points[0] += i;
      points[1] += j;
  }

  List<List<String>> frames = [];
  late List<List<String>> framesTemp = List.from(
      List<List<String>>.from(questions[mancheActuelle - 1].reponses));

  final CountdownController _controller = CountdownController(autoStart: true);

  void changeQuestion() {
    setState(
      () {
        finish = true;
      },
    );
  }

  void nextQuestion() {
    setState(
      () {
        finish = false;
        _controller.restart();
        mancheActuelle++;
        frames.clear();
        framesTemp = List.from(
            List<List<String>>.from(questions[mancheActuelle - 1].reponses));
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    if (!frames.isNotEmpty) {
      framesTemp.shuffle(Random());
      frames = framesTemp +
          [
            ["", ""],
            ["", ""],
            ["", ""],
            ["", ""],
            ["", ""],
          ];
    }

    print(mancheActuelle);
    return !finish
        ? Stack(
            children: [
              Positioned(
                top: 5,
                right: 5,
                child: Countdown(
                  controller: _controller,
                  seconds: 30,
                  build: (_, double time) => Text(
                    time.toString(),
                    style: GoogleFonts.getFont(
                      "Erica One",
                      fontSize: 50,
                      color: const Color.fromRGBO(226, 32, 46, 1),
                    ),
                  ),
                  interval: const Duration(milliseconds: 100),
                  onFinished: () {
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
                          borderRadius:
                              const BorderRadius.all(Radius.elliptical(50, 50)),
                        ),
                        child: Center(
                          child: Text(
                            questions[mancheActuelle - 1].type,
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
                  questions[mancheActuelle - 1].titre,
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
                                          color: Color.fromRGBO(226, 32, 46, 1),
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
                                            MediaQuery.sizeOf(context).width /
                                                7,
                                        decoration: const BoxDecoration(
                                          color: Color.fromRGBO(226, 32, 46, 1),
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
                                          MediaQuery.sizeOf(context).width / 7,
                                      width:
                                          MediaQuery.sizeOf(context).width / 7,
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
                                          MediaQuery.sizeOf(context).width / 7,
                                      width:
                                          MediaQuery.sizeOf(context).width / 7,
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
                                                borderRadius: BorderRadius.only(
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
                                  child: SizedBox(
                                    child: Container(
                                      height:
                                          MediaQuery.sizeOf(context).width / 7,
                                      width:
                                          MediaQuery.sizeOf(context).width / 7,
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
                                                borderRadius: BorderRadius.only(
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
          )
        : ResultPage(
            addPoints: addPoints,
            points: points,
            nextQuestion: nextQuestion,
            question: questions[mancheActuelle - 1],
            frames1: frames,
          );
  }
}
