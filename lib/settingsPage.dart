import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:le_bon_ordre/dio.dart';
import 'package:socket_io_client/socket_io_client.dart';

class SettingsPage extends StatefulWidget {
  String code;
  bool isAdmin;
  bool hideCode = true;

  var changeState;
  int nombreManches;

  var changeNombreManches;
  Socket socket;
  var sendMessage;
  bool ready1;
  bool ready2;
  bool is2Connected;

  SettingsPage(
      {super.key,
      required this.is2Connected,
      required this.ready1,
      required this.ready2,
      required this.sendMessage,
      required this.socket,
      required this.nombreManches,
      required this.code,
      required this.isAdmin,
      required this.changeState,
      required this.changeNombreManches});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  @override
  Widget build(BuildContext context) {
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
                    widget.code.toUpperCase(),
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
                        widget.ready1 ? "Prêt" : "Pas prêt",
                        style: GoogleFonts.getFont(
                          "Jura",
                          fontSize: 20,
                          color: widget.ready1
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
                        widget.ready2
                            ? "Prêt"
                            : widget.is2Connected
                                ? "Pas prêt"
                                : "Pas connecté",
                        style: GoogleFonts.getFont(
                          "Jura",
                          fontSize: 20,
                          color: widget.ready2
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
                              !widget.ready1 &&
                              widget.nombreManches != 1) {
                            widget.sendMessage("", "nombreMancheMoins");
                          }
                        });
                      },
                      icon: const Icon(Icons.remove,
                          color: Color.fromRGBO(226, 32, 46, 1), size: 30),
                    ),
                    Text(
                      widget.nombreManches.toString(),
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
                              !widget.ready1 &&
                              widget.nombreManches != 15) {
                            widget.sendMessage("", "nombreManchePlus");
                          }
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
                widget.isAdmin
                    ? widget.ready1
                        ? Colors.green
                        : const Color.fromRGBO(226, 32, 46, 1)
                    : widget.ready2
                        ? Colors.green
                        : const Color.fromRGBO(226, 32, 46, 1),
              ),
              shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(18.0),
                ),
              ),
              padding: MaterialStateProperty.all<EdgeInsets>(
                  const EdgeInsets.symmetric(horizontal: 50, vertical: 10)),
            ),
            onPressed: () {
              widget.isAdmin
                  ? widget.sendMessage("ready1", "ready")
                  : widget.sendMessage("ready2", "ready");
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
              widget.sendMessage(widget.isAdmin ? "1" : "2", "leave");
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
    );
  }
}
