import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:le_bon_ordre/dio.dart';
import 'package:socket_io_client/socket_io_client.dart';

class JoinParty extends StatefulWidget {
  var changeState;
  var setCode;
  var changeNombreManches;
  Socket socket;
  var sendMessage;
  var changeIsAdmin;

  JoinParty(
      {super.key,
        required this.changeIsAdmin,
        required this.sendMessage,
      required this.changeState,
      required this.setCode,
      required this.changeNombreManches,
      required this.socket});

  @override
  State<JoinParty> createState() => _JoinPartyState();
}

class _JoinPartyState extends State<JoinParty> {
  String connectError = "";
  @override
  Widget build(BuildContext context) {
    widget.changeIsAdmin(false);
    verifierCode(String code) async {
      var mapMessage = {
      'room': code.toUpperCase(),
    };
    widget.socket.emit('join2', mapMessage);
    widget.setCode(code.toUpperCase());
    }

    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            "Rejoindre un partie",
            style: GoogleFonts.getFont(
              "Erica One",
              fontSize: 50,
              color: const Color.fromRGBO(226, 32, 46, 1),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 20.0),
            child: SizedBox(
              width: 250,
              child: TextField(
                onSubmitted: (String value) {
                  verifierCode(value);
                },
                keyboardType: TextInputType.text,
                maxLength: 4,
                style: const TextStyle(color: Colors.white),
                decoration: const InputDecoration(
                  hintStyle: TextStyle(color: Colors.white),
                  labelStyle: TextStyle(color: Colors.white),
                  suffixIconColor: Colors.white,
                  iconColor: Colors.white,
                  prefixStyle: TextStyle(color: Colors.white),
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.white),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.white),
                  ),
                  border: OutlineInputBorder(),
                  hintText: 'Code de la partie',
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 20.0),
            child: Container(
              width: 250,
              color: const Color.fromRGBO(226, 32, 46, 1),
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
                  widget.changeState(0);
                },
                child: Text(
                  "Retour",
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
        ],
      ),
    );
  }
}
