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

  SettingsPage(
      {super.key,
      required this.nombreManches,
      required this.code,
      required this.isAdmin,
      required this.changeState,
      required this.changeNombreManches});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  bool ready1 = false;
  bool ready2 = false;
  late int nombreManches;

  late List<bool> ready;
  bool isConnected = false;

  late Socket socket;

  @override
  void initState() {
    initSocket();
    super.initState();
  }

  initSocket() {
    socket = io('http://192.168.1.48:8080', <String, dynamic>{
      'forceNew': true,
      'autoConnect': false,
      'transports': ['websocket'],
    });
    socket.connect();
    Map messageMap = {
      'room': widget.code.toUpperCase(),
    };
    socket.emit('join', messageMap);
    socket.onConnect((_) {
      print('Connection established');
    });
    socket.onDisconnect((_) => print('Connection Disconnection'));
    socket.onConnectError((err) => print(err));
    socket.onError((err) => print(err));
    socket.on('ready', (newMessage) {
      messageList.add(newMessage);
      if (newMessage == "ready1") {
        ready1 = !ready1;
        if (ready1 == true && ready2 == true) {
          socket.disconnect();
          socket.close();
          print("should start");
          widget.changeState(1);
        } else {
          setState(() {
          });
        }
      }
      if (newMessage == "ready2") {
        ready2 = !ready2;
        if (ready1 == true && ready2 == true) {
          socket.close();
          widget.changeState(1);
        } else {
          setState(() {
          });
        }
      }
    });

    socket.on("nombreMancheMoins", (newMessage) {
      widget.changeNombreManches(nombreManches - 1);
      setState(() {
        print("nombreMancheMoins");
        nombreManches--;
      });
    });
    socket.on("nombreManchePlus", (newMessage) {
      widget.changeNombreManches(nombreManches + 1);
      setState(() {
        print("nombreManchePlus");
        nombreManches++;
      });
    });
  }

  bool mancheInit = false;

  List<String> messageList = [];
  bool shouldStart = false;

  @override
  Widget build(BuildContext context) {
    if (!mancheInit) {
      nombreManches = widget.nombreManches;
      mancheInit = true;
    }
    sendMessage(String message, String arg) {
      print("argument: " + arg);
      if (message.isEmpty) return;
      Map messageMap = {
        'message': message,
        'room': widget.code.toUpperCase(),
      };
      socket.emit(arg, messageMap);
    }

    return StreamBuilder(
      stream: null,
      builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
        if (snapshot.hasData) {
          print(snapshot.data);
        }
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
                              if (widget.isAdmin &&
                                  !ready1 &&
                                  nombreManches != 1) {
                                sendMessage("test", "nombreMancheMoins");
                              }
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
                              if (widget.isAdmin &&
                                  !ready1 &&
                                  nombreManches != 15) {
                                sendMessage("test", "nombreManchePlus");
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
                      const EdgeInsets.symmetric(horizontal: 50, vertical: 10)),
                ),
                onPressed: () {
                  widget.isAdmin
                      ? sendMessage("ready1", "ready")
                      : sendMessage("ready2", "ready");
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
                  socket.disconnect();
                  socket.close();
                  isConnected = false;
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
      },
    );
  }
}
