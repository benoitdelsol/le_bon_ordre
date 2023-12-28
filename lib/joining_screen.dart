import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class JoiningScreen extends StatefulWidget {
  const JoiningScreen(
      {super.key, required this.changeState, required this.tryToJoin});

  final void Function(int) changeState;
  final void Function(String) tryToJoin;

  @override
  State<JoiningScreen> createState() => _JoiningScreenState();
}

class _JoiningScreenState extends State<JoiningScreen> {
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
                  widget.tryToJoin(value.toUpperCase());
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
