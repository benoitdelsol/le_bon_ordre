import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:le_bon_ordre/dio.dart';

class JoinParty extends StatefulWidget {
  var changeState;
  var changeIsAdmin;
  var setCode;

  JoinParty({super.key, required this.changeState, required this.changeIsAdmin, required this.setCode});

  @override
  State<JoinParty> createState() => _JoinPartyState();
}

class _JoinPartyState extends State<JoinParty> {
  @override
  Widget build(BuildContext context) {


    verifierCode(String code) async{
      final String response = await joinGame(code.toUpperCase()) ;
      if(response=="Joined the game"){
        widget.changeState(1);
        widget.changeIsAdmin(false);
        widget.setCode(code);
      }else {
        if (response ==
            "The game is full") {
          print("The game is full");
        }else{
          print("The game doesn't exist");
        }
      }
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
                  print('aaaaahh');
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
