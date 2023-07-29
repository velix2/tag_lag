import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'main.dart';

class FirstOpenPage extends StatefulWidget {
  const FirstOpenPage({super.key});

  @override
  State<FirstOpenPage> createState() => _FirstOpenPageState();
}

class _FirstOpenPageState extends State<FirstOpenPage> {
  @override
  Widget build(BuildContext context) {
    var appState = context.watch<TagLagState>();
    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            Icon(
              Icons.directions_walk,
              color: Theme.of(context).primaryColor,
              size: 40,
            ),
            const SizedBox(width: 15),
            Text(
              "Game",
              style: GoogleFonts.righteous(
                fontWeight: FontWeight.w500,
              ),
              textAlign: TextAlign.center,
            ),
            Text(
              ".",
              style: GoogleFonts.righteous(
                fontWeight: FontWeight.w800,
                color: Theme.of(context).primaryColor,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
      body: Column(
        children: [
          ElevatedButton(
            onPressed: () {
              appState.gameDataRead();
            },
            child: const Text("Read")
          ),
          ElevatedButton(
            onPressed: () {
              appState.gameDataDelete();
            },
            child: const Text("Delete")
          ),
          ElevatedButton(
            onPressed: () {
              appState.gameDataInit();
            },
            child: const Text("Init")
          ),
        ],
      ),
    );
  }
}
