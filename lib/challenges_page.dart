// ignore_for_file: unused_local_variable

import 'dart:math';

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

class _ChallengesPageState extends State<ChallengesPage>
    with TickerProviderStateMixin {
  // ignore: unused_field
  List challengesList = [];

  //Stuff for card animation
  late AnimationController _controller;
  late Animation _animation;
  // ignore: unused_field
  static AnimationStatus _status = AnimationStatus.dismissed;

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
    // Call the readJson method when this page gets loaded
    readChallenges();

    _controller = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 600));
    _animation = Tween(end: 1.0, begin: 0.0).animate(_controller)
      ..addListener(() {
        setState(() {});
      })
      ..addStatusListener((status) {
        _status = status;
      });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var appState = context.watch<TagLagState>();

    if (appState.hasActiveChallenge) {
      _controller.forward();
    }

    if (appState.challenges.isEmpty) {
      appState.challenges = challengesList;
    }
    //appState.checkVetoTime();
    var currentChallengeIndex = appState.currentChallengeIndex;
    return Scaffold(
        appBar: AppBar(
          leading: const Icon(Icons.flag),
          title: const Text("Challenges"),
          backgroundColor: Colors.red,
          actions: [
            Padding(
              padding: const EdgeInsets.all(5.0),
              child: IconButton(
                  onPressed: () {
                    showDialog(
                        context: context,
                        builder: (BuildContext context) => AlertDialog(
                              title: const Text("History"),
                              content: SizedBox(
                                width: 200,
                                height: 400,
                                child: ListView.builder(
                                    itemCount: appState.pastChallenges.length,
                                    itemBuilder: (context, index) {
                                      return Card(
                                        child: Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: Text("${index + 1}. ${appState.pastChallenges.elementAtOrNull(index)['header']}"),
                                        ),
                                      );
                                    }),
                              ),
                            ));
                  },
                  icon: const Icon(Icons.history)),
            )
          ],
        ),
        /*body: Padding(
            padding: const EdgeInsets.all(25),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                (appState.hasActiveVeto)
                    ? Expanded(
                        //During Veto
                        child: Column(children: [
                        Card(
                          child: Padding(
                            padding: const EdgeInsets.all(20),
                            child: Column(
                              children: [
                                Text(
                                    "You're currently blocked by a veto period. You have ${appState.vetoTimeLeft.abs().toString().substring(0, 1)} hours, ${appState.vetoTimeLeft.abs().toString().substring(2, 4)} minutes and ${appState.vetoTimeLeft.abs().toString().substring(5, 7)} seconds left to wait"),
                                ElevatedButton.icon(
                                    onPressed: () {
                                      setState(() {
                                        appState.vetoTimeLeft = appState
                                            .vetoEndTime
                                            .difference(DateTime.now());
                                        appState.checkVetoTime();
                                      });
                                    },
                                    icon: const Icon(Icons.refresh),
                                    label: const Text("Refresh"))
                              ],
                            ),
                          ),
                        ),
                      ]))
                    : Container(),
                (!appState.hasActiveVeto && !appState.hasActiveChallenge)
                    ? Expanded(
                        //No Challenge active and no Veto
                        child: ElevatedButton.icon(
                            onPressed: () {
                              appState.shuffleChallenges();
                              setState(() {
                                appState.hasActiveChallenge = true;
                              });
                            },
                            icon: const Icon(Icons.shuffle),
                            style: ButtonStyle(
                                shape: MaterialStateProperty.all<
                                        RoundedRectangleBorder>(
                                    RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(10))),
                                padding: MaterialStateProperty.all<EdgeInsets>(
                                    const EdgeInsets.all(30))),
                            label: const Text("Pull Challenge!")),
                      )
                    : Container(),
                (appState.hasActiveChallenge && !appState.hasActiveVeto)
                    ? Expanded(
                        //Challenge Active
                        child: TextButton(
                          onPressed: () {
                            showDialog(
                              context: context,
                              builder: (BuildContext context) => AlertDialog(
                                title: Text(appState.challenges.elementAtOrNull(
                                    appState.currentChallengeIndex)["header"]),
                                content: Column(children: [
                                  Text(
                                      "${appState.challenges.elementAtOrNull(appState.currentChallengeIndex)["coins"]} Coins"),
                                  Text(appState.challenges.elementAtOrNull(
                                      appState.currentChallengeIndex)["text"])
                                ]),
                                actions: [
                                  TextButton.icon(
                                      onPressed: () {
                                        Navigator.pop(context);
                                        showDialog(
                                            context: context,
                                            builder:
                                                (BuildContext context) =>
                                                    AlertDialog(
                                                      title: const Text(
                                                          "Confirm Veto"),
                                                      content:
                                                          Column(children: [
                                                        const Text(
                                                            "Are you sure you want to Veto this Challenge?"),
                                                        Text(
                                                            "You and your team will have to stay exactly where you are for the next ${appState.challenges[appState.currentChallengeIndex]["veto_time"]} minutes. you may visit the nearest public toilets or get some food, but when the time is over, you and your teammates have to be exactly where you were when the veto period started. You may not pull or complete challenges, tag a team or progress in any way within this time. If you are currently on a moving vehicle (public transport), then get off at the next stop and remain there until your time is over."),
                                                      ]),
                                                      actions: [
                                                        TextButton.icon(
                                                            onPressed: () {
                                                              Navigator.pop(
                                                                  context);
                                                            },
                                                            icon: const Icon(
                                                                Icons.close),
                                                            label: const Text(
                                                                "Cancel")),
                                                        TextButton.icon(
                                                            onPressed: () {
                                                              Navigator.pop(
                                                                  context);
                                                              setState(() {
                                                                appState.hasActiveChallenge =
                                                                    false;
                                                                appState.hasActiveVeto =
                                                                    true;
                                                                appState.vetoTimeTotal = Duration(
                                                                    minutes: appState
                                                                            .challenges[
                                                                        appState
                                                                            .currentChallengeIndex]["veto_time"]);
                                                                appState.vetoStartTime =
                                                                    DateTime
                                                                        .now();
                                                                appState
                                                                    .vetoEndTime = DateTime
                                                                        .now()
                                                                    .add(Duration(
                                                                        minutes:
                                                                            appState.challenges[appState.currentChallengeIndex]["veto_time"]));
                                                                appState
                                                                    .checkVetoTime();
                                                              });
                                                            },
                                                            icon: const Icon(
                                                                Icons.check),
                                                            label: const Text(
                                                                "Veto Challenge")),
                                                      ],
                                                    ));
                                      },
                                      icon:
                                          const Icon(Icons.lock_clock_rounded),
                                      label: const Text("Veto")),
                                  TextButton.icon(
                                      onPressed: () {
                                        Navigator.pop(context);
                                        showDialog(
                                          context: context,
                                          builder: (BuildContext context) =>
                                              AlertDialog(
                                            title: const Text(
                                                "Confirm Challenge Completion"),
                                            content: Column(children: [
                                              const Text(
                                                  "Are you sure you have completed your challenge?"),
                                              Text(appState.challenges[appState
                                                      .currentChallengeIndex]
                                                  ["header"]),
                                            ]),
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
                                                    appState.hasActiveChallenge =
                                                        false;
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
                                      label: const Text("Challenge Complete")),
                                ],
                              ),
                            );
                          },
                          child: Text(appState.challenges.elementAt(
                              appState.currentChallengeIndex)["header"]),
                        ),
                      )
                    : Container()
              ],
            ))
            */
        body: Padding(
          padding: const EdgeInsets.all(25),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.max,
            children: [
              Center(
                child: (appState.hasActiveVeto)
                    ? Column(
                        children: [
                          const Text(
                            "You're blocked by a",
                            style: TextStyle(fontSize: 24),
                            textAlign: TextAlign.center,
                          ),
                          Text("🚨VETO PERIOD!🚨",
                              style: TextStyle(
                                  fontSize: 35,
                                  fontWeight: FontWeight.w800,
                                  color: Theme.of(context).colorScheme.error),
                              textAlign: TextAlign.center),
                          const Text(
                            "Ends in:",
                            style: TextStyle(fontSize: 21),
                            textAlign: TextAlign.center,
                          ),
                          Card(
                            color: Theme.of(context).primaryColor,
                            child: Padding(
                              padding: const EdgeInsets.symmetric(
                                  vertical: 8.0, horizontal: 20),
                              child: Text(_printDuration(appState.vetoTimeLeft),
                                  style: TextStyle(
                                      fontSize: 42,
                                      fontWeight: FontWeight.w800,
                                      color: Theme.of(context)
                                          .colorScheme
                                          .onPrimary),
                                  textAlign: TextAlign.center),
                            ),
                          )
                        ],
                      )
                    : Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: SizedBox(
                          width: double.infinity,
                          height: 500,
                          child: Transform(
                              alignment: FractionalOffset.center,
                              transform: Matrix4.identity()
                                ..setEntry(3, 2, 0.0015)
                                ..rotateY(pi - pi * _animation.value),
                              child:
                                  (_animation.value <= 0.5 ||
                                          !appState.hasActiveChallenge)
                                      ? CardFront(
                                          controller: _controller,
                                          appState: appState)
                                      : Card(
                                          margin: const EdgeInsets.all(20),
                                          child: Padding(
                                            padding: const EdgeInsets.all(12.0),
                                            child: Column(
                                              children: [
                                                Row(
                                                  children: [
                                                    Expanded(
                                                        flex: 2,
                                                        child: Text(
                                                            appState.challenges
                                                                    .elementAtOrNull(
                                                                        appState
                                                                            .currentChallengeIndex)[
                                                                "header"],
                                                            style: TextStyle(
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold,
                                                                fontSize: 24,
                                                                color: (appState.challenges.elementAtOrNull(appState.currentChallengeIndex)["header"] == "Curse!")?
                                                                  const Color.fromARGB(255, 255, 0, 0):
                                                                  const Color.fromARGB(255, 0, 0, 0)
                                                            ),
                                                            textAlign: TextAlign
                                                                .left)),
                                                    Expanded(
                                                      flex: 1,
                                                      child: Card(
                                                        color: Colors.white,
                                                        elevation: 0,
                                                        child: Padding(
                                                          padding:
                                                              const EdgeInsets
                                                                  .all(5),
                                                          child: Row(
                                                            children: [
                                                              Icon(
                                                                Icons
                                                                    .attach_money_rounded,
                                                                size: 30,
                                                                color: Theme.of(
                                                                        context)
                                                                    .primaryColor,
                                                              ),
                                                              Expanded(
                                                                  child: Text(
                                                                appState
                                                                    .challenges
                                                                    .elementAtOrNull(
                                                                        appState
                                                                            .currentChallengeIndex)[
                                                                        "coins"]
                                                                    .toString(),
                                                                style: const TextStyle(
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .bold,
                                                                    fontSize:
                                                                        20,
                                                                    color: Color
                                                                        .fromARGB(
                                                                            255,
                                                                            35,
                                                                            35,
                                                                            35)),
                                                                textAlign:
                                                                    TextAlign
                                                                        .center,
                                                              )),
                                                            ],
                                                          ),
                                                        ),
                                                      ),
                                                    )
                                                  ],
                                                ),
                                                if (appState.challenges.elementAtOrNull(appState.currentChallengeIndex)["header"] == "Curse!") const Text("You have been cursed!"),
                                                Expanded(
                                                    child: Text(appState
                                                            .challenges
                                                            .elementAtOrNull(
                                                                appState
                                                                    .currentChallengeIndex)[
                                                        "text"])),
                                                Row(
                                                  children: [
                                                    TextButton.icon(
                                                        onPressed: () {
                                                          //ON TAP
                                                          //Navigator.pop(context);
                                                          (appState.challenges.elementAtOrNull(appState.currentChallengeIndex)["header"] == "Curse!")?
                                                          ScaffoldMessenger.of(context).showSnackBar(
                                                            SnackBar(
                                                              content: Text("You can't do this, you're cursed!"),
                                                              action: SnackBarAction(
                                                                label: "Ok",
                                                                onPressed: () {},
                                                              ),
                                                            )
                                                          ):
                                                          showDialog(
                                                              context: context,
                                                              builder: (BuildContext
                                                                      context) =>
                                                                  AlertDialog(
                                                                    insetPadding: const EdgeInsets
                                                                            .symmetric(
                                                                        horizontal:
                                                                            20.0,
                                                                        vertical:
                                                                            160.0),
                                                                    title: Row(
                                                                      children: [
                                                                        const Icon(
                                                                            Icons.lock_clock_rounded),
                                                                        SizedBox
                                                                            .fromSize(
                                                                          size: const Size(
                                                                              15,
                                                                              15),
                                                                        ),
                                                                        const Text(
                                                                            "Confirm Veto"),
                                                                      ],
                                                                    ),
                                                                    content: Column(
                                                                        children: [
                                                                          const Text(
                                                                            "Are you sure you want to Veto this Challenge?",
                                                                            style:
                                                                                TextStyle(fontWeight: FontWeight.bold, fontSize: 24),
                                                                            textAlign:
                                                                                TextAlign.center,
                                                                          ),
                                                                          Expanded(
                                                                            child:
                                                                                Center(
                                                                              child: Text("You and your team will have to stay exactly where you are for the next ${appState.challenges[appState.currentChallengeIndex]["veto_time"]} minutes. you may visit the nearest public toilets or get some food, but when the time is over, you and your teammates have to be exactly where you were when the veto period started. You may not pull or complete challenges, tag a team or progress in any way within this time. If you are currently on a moving vehicle (public transport), then get off at the next stop and remain there until your time is over."),
                                                                            ),
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

                                                                            _controller.reset();

                                                                            setState(() {
                                                                              appState.hasActiveChallenge = false;
                                                                              appState.hasActiveVeto = true;
                                                                              appState.vetoTimeTotal = Duration(minutes: appState.challenges[appState.currentChallengeIndex]["veto_time"]);
                                                                              appState.vetoStartTime = DateTime.now();
                                                                              appState.vetoEndTime = DateTime.now().add(Duration(minutes: appState.challenges[appState.currentChallengeIndex]["veto_time"]));
                                                                              appState.startVeto();
                                                                            });
                                                                          },
                                                                          icon: const Icon(Icons.check),
                                                                          label: const Text("Veto Challenge")),
                                                                    ],
                                                                  ));
                                                        },
                                                        icon: const Icon(Icons
                                                            .lock_clock_rounded),
                                                        label:
                                                            const Text("Veto")),
                                                    const Expanded(
                                                      child: SizedBox(),
                                                    ),
                                                    ElevatedButton.icon(
                                                      onPressed: () {
                                                        //ON TAP: COMPLETE
                                                        (appState.challenges.elementAtOrNull(appState.currentChallengeIndex)["header"] == "Curse!")?
                                                        ScaffoldMessenger.of(context).showSnackBar(
                                                            SnackBar(
                                                              content: Text("You can't do this, you're cursed!"),
                                                              action: SnackBarAction(
                                                                label: "Ok",
                                                                onPressed: () {},
                                                              ),
                                                            )
                                                          ):
                                                        showDialog(
                                                            context: context,
                                                            builder: (BuildContext
                                                                    context) =>
                                                                AlertDialog(
                                                                  insetPadding: const EdgeInsets
                                                                          .symmetric(
                                                                      horizontal:
                                                                          20.0,
                                                                      vertical:
                                                                          200.0),
                                                                  title: Row(
                                                                    children: [
                                                                      const Icon(
                                                                          Icons
                                                                              .check_circle_outline_rounded),
                                                                      SizedBox
                                                                          .fromSize(
                                                                        size: const Size(
                                                                            15,
                                                                            15),
                                                                      ),
                                                                      const Text(
                                                                          "Confirm Challenge"),
                                                                    ],
                                                                  ),
                                                                  content: Column(
                                                                      children: [
                                                                        const Text(
                                                                          "Are you sure you completed this Challenge?",
                                                                          style: TextStyle(
                                                                              fontWeight: FontWeight.bold,
                                                                              fontSize: 24),
                                                                          textAlign:
                                                                              TextAlign.center,
                                                                        ),
                                                                        Expanded(
                                                                          child:
                                                                              Center(
                                                                            child:
                                                                                Text(
                                                                              appState.challenges.elementAtOrNull(appState.currentChallengeIndex)["header"],
                                                                              style: TextStyle(fontSize: 24, color: Theme.of(context).colorScheme.error, fontWeight: FontWeight.w900),
                                                                            ),
                                                                          ),
                                                                        ),
                                                                      ]),
                                                                  actions: [
                                                                    TextButton.icon(
                                                                        onPressed: () {
                                                                          Navigator.pop(
                                                                              context);
                                                                        },
                                                                        icon: const Icon(Icons.close),
                                                                        label: const Text("No")),
                                                                    TextButton.icon(
                                                                        onPressed: () {
                                                                          Navigator.pop(
                                                                              context);
                                                                          appState
                                                                              .completedChallenge();
                                                                          setState(
                                                                              () {
                                                                            appState.hasActiveChallenge =
                                                                                false;
                                                                          });
                                                                          _controller
                                                                              .reverse();
                                                                        },
                                                                        icon: const Icon(Icons.check),
                                                                        label: const Text("Complete")),
                                                                  ],
                                                                ));
                                                      },
                                                      icon: const Icon(Icons
                                                          .check_circle_rounded),
                                                      label: const Text(
                                                          "Complete"),
                                                    ),
                                                  ],
                                                ),
                                              ],
                                            ),
                                          ))),
                        ),
                      ),
              ),
            ],
          ),
        ));
  }

  String _printDuration(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, "0");
    String twoDigitMinutes = twoDigits(duration.inMinutes.remainder(60));
    String twoDigitSeconds = twoDigits(duration.inSeconds.remainder(60));
    return "$twoDigitMinutes:$twoDigitSeconds";
  }
}

class CardFront extends StatelessWidget {
  const CardFront({
    super.key,
    required AnimationController controller,
    required this.appState,
  }) : _controller = controller;

  final AnimationController _controller;
  final TagLagState appState;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        _controller.forward();
        appState.hasActiveChallenge = true;
        appState.shuffleChallenges();
      },
      child: Card(
          margin: const EdgeInsets.all(20),
          child: Transform(
              alignment: FractionalOffset.center,
              transform: Matrix4.rotationY(pi),
              child: Center(
                child: (!appState.hasActiveChallenge)
                    ? const Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                            Icon(Icons.shuffle),
                            Text("Tap to pull challenge...")
                          ])
                    : const SizedBox(),
              ))),
    );
  }
}
