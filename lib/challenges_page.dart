// ignore_for_file: unused_local_variable

import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'dart:async';
import 'main.dart';

class ChallengesPage extends StatefulWidget {
  const ChallengesPage({super.key});

  @override
  State<ChallengesPage> createState() => _ChallengesPageState();
}

class _ChallengesPageState extends State<ChallengesPage> {
  // ignore: unused_field
  List challengesList = [];

  // Fetch content from the json file
  Future<void> readChallenges() async {
    final String response =
        await rootBundle.loadString('assets/challenges.json');
    final data = await json.decode(response);
    setState(() {
      challengesList = data["challenges"];
    });
  }

  @override
  void initState() {
    super.initState();
    // Call the readJson method when the app starts
    readChallenges();
  }

  @override
  Widget build(BuildContext context) {
    var appState = context.watch<TagLagState>();
    if (appState.challenges.isEmpty) {
      appState.challenges = challengesList;
    }
    var currentChallengeIndex = appState.currentChallengeIndex;
    return Scaffold(
      appBar: AppBar(
        title: const Text("Challenges"),
        backgroundColor: Colors.red,
      ),
      body: Padding(
        padding: const EdgeInsets.all(25),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            ConstrainedBox(
              constraints: const BoxConstraints(),
              child: ElevatedButton.icon(
                onPressed: () {
                  appState.shuffleChallenges();
                  setState(() {
                    appState.hasActiveChallenge = true;
                  });
                },
                icon: const Icon(Icons.shuffle),
                style: ButtonStyle(
                  shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                    RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10)
                    )
                  ),
                  padding: MaterialStateProperty.all<EdgeInsets>(
                    const EdgeInsets.all(30)
                  )
                ),
                label: const Text("Pull Challenge!")
              ),
            ),
            appState.hasActiveChallenge ? Expanded(
              child: TextButton(
                onPressed: () {showDialog(
                  context: context,
                  builder: (BuildContext context) => AlertDialog(
                    title: Text(appState.challenges.elementAtOrNull(appState.currentChallengeIndex)["header"]),
                    content: Column(
                      children: [
                        Text("${appState.challenges.elementAtOrNull(appState.currentChallengeIndex)["coins"]} Coins"),
                        Text(appState.challenges.elementAtOrNull(appState.currentChallengeIndex)["text"])
                      ]
                    ),
                    actions: [
                      TextButton.icon(
                        onPressed: () {
                          Navigator.pop(context);
                          showDialog(
                            context: context,
                            builder: (BuildContext context) => AlertDialog(
                              title: const Text("Confirm Veto"),
                              content: Column(
                                children: [
                                  const Text(
                                    "Are you sure you want to Veto this Challenge?"
                                  ),
                                  Text(
                                    "You and your team will have to stay exactly where you are for the next ${appState.challenges[appState.currentChallengeIndex]["veto_time"]} minutes. you may visit the nearest public toilets or get some food, but when the time is over, you and your teammates have to be exactly where you were when the veto period started. You may not pull or complete challenges, tag a team or progress in any way within this time. If you are currently on a moving vehicle (public transport), then get off at the next stop and remain there until your time is over."
                                  ),
                                ]
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
                                    setState(() {
                                      appState.hasActiveChallenge = false;
                                      appState.vetoStartTime = DateTime.now();
                                      appState.vetoTimeTotal = Duration(minutes: appState.challenges[appState.currentChallengeIndex]["veto_time"]);
                                      appState.vetoEndTime = appState.vetoStartTime.add(appState.vetoTimeTotal);
                                    });
                                  },
                                  icon: const Icon(Icons.check),
                                  label: const Text("Veto Challenge")
                                ),
                              ],
                            )
                          );
                        },
                        icon: const Icon(Icons.lock_clock_rounded),
                        label: const Text("Veto")
                      ),
                      TextButton.icon(
                        onPressed: () {
                          Navigator.pop(context);
                          showDialog(
                            context: context,
                            builder: (BuildContext context) => AlertDialog(
                              title: const Text("Confirm Challenge Completion"),
                              content: Column(
                                children: [
                                  const Text(
                                    "Are you sure you have completed your challenge?"
                                  ),
                                  Text(appState.challenges[appState.currentChallengeIndex]["header"]),
                                ]
                              ),
                              actions: [
                                TextButton.icon(
                                  onPressed: () {
                                    Navigator.pop(context);
                                  },
                                  icon: const Icon(Icons.close),
                                  label: const Text("No"),
                                ),
                                TextButton.icon(
                                  onPressed: () {
                                    Navigator.pop(context);
                                    appState.completedChallenge();
                                    setState(() {
                                      appState.hasActiveChallenge = false;
                                    });
                                  },
                                  icon: const Icon(Icons.check),
                                  label: const Text("Yes"),
                                ),
                              ],
                            ),
                          );
                        },
                        icon: const Icon(Icons.check),
                        label: const Text("Challenge Complete")
                      ),
                    ],
                  ),
                );
              },
              child: Text(appState.challenges.elementAt(appState.currentChallengeIndex)["header"]),
              ),
            )
            : Container()
          ],
        )
      )
    );
  }
}