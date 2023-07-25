import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_spinbox/material.dart';
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
        leading: const Icon(Icons.directions_walk),
        title: const Text("Game"),
        backgroundColor: Colors.red,
      ),
      body: !appState.gameStarted ? Center(
        child: ElevatedButton.icon(
          onPressed: () {
            showDialog(
              context: context,
              builder: (BuildContext context) => AlertDialog(
                title: const Text('Start new Game'),
                content: Column(
                  children: [
                    const Text("How many teams are playing?"),
                    SpinBox(
                      min: 2,
                      max: 5,
                      value: 2,
                      onChanged: (value) => appState.numOfTeams = value.toInt(),
                    ),
                  ],
                ),
                actions: [
                  TextButton.icon(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    icon: const Icon(Icons.close),
                    label: const Text("Cancel")
                  ),
                  TextButton.icon(
                    onPressed: () {
                      Navigator.pop(context);
                      showDialog(
                        context: context,
                        builder: (BuildContext context) => AlertDialog(
                          title: const Text('Start new Game'),
                          content: Column(
                            children: [
                              const Text("What is your teams number?"),
                              Text("Make sure to assign every team an individual number from 1 to ${appState.numOfTeams}"),
                              SpinBox(
                                min: 1,
                                max: appState.numOfTeams.toDouble(),
                                value: 1,
                                onChanged: (value) => appState.teamNum = value.toInt(),
                              ),
                            ],
                          ),
                          actions: [
                            TextButton.icon(
                              onPressed: () {
                                Navigator.pop(context);
                              },
                              icon: const Icon(Icons.close),
                              label: const Text("Cancel")
                            ),
                            TextButton.icon(
                              onPressed: () {
                                setState(() {
                                  appState.gameStarted = true;
                                });
                                Navigator.pop(context);
                              },
                              icon: const Icon(Icons.check),
                              label: const Text("Start Game!")
                            )
                          ],
                        )
                      );
                    },
                    icon: const Icon(Icons.check),
                    label: const Text("Continue")
                  )
                ],
              )
            );
          },
          icon: const Icon(Icons.play_arrow),
          label: const Text("Start new Game!")
        ),
      ) : Text(appState.gameStarted.toString()),
    );
  }
}