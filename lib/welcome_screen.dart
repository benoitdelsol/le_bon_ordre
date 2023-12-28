import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class WelcomeScreen extends StatefulWidget {
  const WelcomeScreen({
    super.key,
    required this.connecting,
    required this.changeState,
    required this.createGame,
    required this.tryToConnect,
  });

  final void Function(int) changeState;
  final Future<void> Function() createGame;
  final void Function() tryToConnect;
  final bool connecting;

  @override
  State<WelcomeScreen> createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            "BIENVENUE",
            style: GoogleFonts.getFont(
              "Erica One",
              fontSize: 50,
              color: const Color.fromRGBO(226, 32, 46, 1),
            ),
          ),
          Text(
            "Es-tu prêt à trier des choses !",
            style: GoogleFonts.getFont(
              "Jura",
              fontSize: 20,
              color: Colors.white,
              fontWeight: FontWeight.w500,
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 20.0),
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
                widget.changeState(1);
              },
              child: Text(
                "Rejoindre une partie",
                style: GoogleFonts.getFont(
                  "Jura",
                  fontSize: 20,
                  color: Colors.white,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 20.0),
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
                widget.connecting==false?widget.tryToConnect():null;
              },
              child: Text(
                "Créer une partie",
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
      ),
    );
  }
}
