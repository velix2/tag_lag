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
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              "HIT THE BUTTON TO",
              style: GoogleFonts.righteous(),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: SizedBox.fromSize(
                size: const Size(300, 175),
                child: ElevatedButton(
                    onPressed: () {
                      showDialog(
                          context: context,
                          builder: (BuildContext context) => AlertDialog(
                                insetPadding: const EdgeInsets.symmetric(
                                    horizontal: 20.0, vertical: 160.0),
                                title: Row(
                                  children: [
                                    const Icon(Icons.connect_without_contact_rounded),
                                    SizedBox.fromSize(
                                      size: const Size(15, 15),
                                    ),
                                    const Text("CONFIRM TAG"),
                                  ],
                                ),
                                content:  Column(
                                  mainAxisSize: MainAxisSize.min
                                  ,children: [
                                  Text(
                                    "Are you sure you PROPERLY tagged the runners?",
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 24, color: Theme.of(context).colorScheme.error),
                                    textAlign: TextAlign.center,
                                  ),
                                  const SizedBox(height: 25,),
                                  const Center(
                                    child: Text("Reward: 300 Coins"),
                                  ),
                                ]),
                                actions: [
                                  TextButton.icon(
                                      onPressed: () {
                                        Navigator.pop(context);
                                      },
                                      icon: const Icon(Icons.close),
                                      label: const Text("Cancel")),
                                  TextButton.icon(
                                      onPressed: () {
                                        Navigator.pop(context);
                                        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("You were awarded \$300 for tagging!")));
                                        setState(() {
                                          appState.coinBalance += 300;
                                        });
                                      },
                                      icon: const Icon(Icons.check),
                                      label: const Text("Confirm Tag!")),
                                ],
                              ));
                    },
                    style: ButtonStyle(
                      backgroundColor: MaterialStatePropertyAll(
                          Theme.of(context).colorScheme.error),
                      shape: MaterialStatePropertyAll(RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(75))),
                      shadowColor: const MaterialStatePropertyAll(Colors.black),
                    ),
                    child: Text(
                      "TAG!",
                      style: GoogleFonts.righteous(
                          color: Theme.of(context).colorScheme.onPrimary,
                          fontWeight: FontWeight.w700,
                          fontSize: 96),
                    )),
              ),
            ),
            Text(
              "A TEAM!",
              style: GoogleFonts.righteous(),
            ),
          ],
        ),
      ),
    );
  }
}
