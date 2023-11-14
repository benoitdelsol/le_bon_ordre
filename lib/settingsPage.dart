import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:le_bon_ordre/dio.dart';

class SettingsPage extends StatefulWidget {
  String code;
  bool isAdmin;
  bool hideCode = true;

  var changeState;

  var changeNombreManches;

  SettingsPage(
      {super.key,
      required this.code,
      required this.isAdmin,
      required this.changeState,
      required this.changeNombreManches});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  bool ready1 = false;
  bool ready2 = true;
  int nombreManches = 3;

  late List<bool> ready;

  @override
  Widget build(BuildContext context) {

    ready=ready();

    return Stack(
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
                    widget.code,
                    style: GoogleFonts.getFont(
                      "Erica One",
                      fontSize: widget.hideCode ? 0 : 50,
                      color: const Color.fromRGBO(226, 32, 46, 1),
                    ),
                  ),
                ),
              ),
              IconButton(
                splashRadius: 0.1,
                onPressed: () {
                  setState(() {
                    widget.hideCode = !widget.hideCode;
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
                        ready2 ? "Prêt" : "Pas prêt",
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
                          widget.isAdmin && !ready1
                              ? nombreManches != 0
                                  ? nombreManches--
                                  : null
                              : null;
                        });
                      },
                      icon: const Icon(Icons.remove,
                          color: Color.fromRGBO(226, 32, 46, 1), size: 30),
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
                          widget.isAdmin && !ready1
                              ? nombreManches != 15
                                  ? nombreManches++
                                  : null
                              : null;
                        });
                      },
                      icon: const Icon(Icons.add,
                          color: Color.fromRGBO(226, 32, 46, 1), size: 30),
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
                  ready1 ? Colors.green : const Color.fromRGBO(226, 32, 46, 1)),
              shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(18.0),
                ),
              ),
              padding: MaterialStateProperty.all<EdgeInsets>(
                  const EdgeInsets.symmetric(horizontal: 50, vertical: 10)),
            ),
            onPressed: () {
              setState(() {
                widget.isAdmin ? ready1 = !ready1 : ready2 = !ready2;
                if (widget.isAdmin && ready1 && ready2) {
                  widget.changeState(1);
                  widget.changeNombreManches(nombreManches);
                }
              });
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
                  const EdgeInsets.symmetric(horizontal: 50, vertical: 10)),
            ),
            onPressed: () {
              deleteGame(widget.code.toUpperCase());
              widget.changeState(-2);
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
    );
  }
}
