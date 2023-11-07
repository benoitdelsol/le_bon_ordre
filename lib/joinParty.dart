import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';

class JoinParty extends StatefulWidget {
  var changeState;
  var verifierCode;
  var changeIsAdmin;

  JoinParty({super.key, required this.changeState, required this.verifierCode, required this.changeIsAdmin});

  @override
  State<JoinParty> createState() => _JoinPartyState();
}

class _JoinPartyState extends State<JoinParty> {
  @override
  Widget build(BuildContext context) {
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
                  widget.changeState(1);
                  widget.verifierCode(value);
                  widget.changeIsAdmin(false);


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
                onPressed: () {
                  widget.changeState(-1);
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
