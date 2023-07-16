// ignore_for_file: unused_local_variable

import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'dart:math';
import 'dart:async';

void main() {
  runApp(const TagLag());
}

class TagLag extends StatelessWidget {
  const TagLag({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {

    return ChangeNotifierProvider(
      create: (context) => TagLagState(),
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Tag Lag',
        theme: ThemeData(
          useMaterial3: true,
          colorScheme: ColorScheme.fromSeed(
              seedColor: Colors.red, brightness: Brightness.light),
        ),
        // darkTheme: ThemeData.dark(useMaterial3: true),
        // themeMode: ThemeMode.dark,

        home: const MainPage(),
      )
    );
  }
}

class TagLagState extends ChangeNotifier {
  List challenges = [];
  int currentChallengeIndex = 0;
  bool hasActiveChallenge = false;
  int coinBalance = 500;

  void shuffleChallenges() {
    final random = Random();
    currentChallengeIndex = random.nextInt(challenges.length);
  }

  void completedChallenge() {
    coinBalance += challenges[currentChallengeIndex]["coins"] as int;
  }
}

class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  int selectedIndex = 0;
  @override
  Widget build(BuildContext context) {
    Widget page;
    switch (selectedIndex) {
      case 0:
        page = const ChallengesPage();
        break;
      case 1:
        page = const ShopPage();
        break;
      case 2:
        page = const RulePage();
        break;
      default:
        throw UnimplementedError('no widget for $selectedIndex');
    }

    return LayoutBuilder(builder: (context, constraints) {
      return Scaffold(
        bottomNavigationBar: BottomNavigationBar(
          items: const <BottomNavigationBarItem>[
            BottomNavigationBarItem(
                icon: Icon(Icons.assistant_photo), label: "Challenges"),
            BottomNavigationBarItem(
                icon: Icon(Icons.shopping_cart), label: "Shop"),
            BottomNavigationBarItem(
                icon: Icon(Icons.handshake), label: "Rules"),
          ],
          currentIndex: selectedIndex,
          onTap: (value) {
            setState(() {
              selectedIndex = value;
            });
          },
        ),
        body: page,
      );
    });
  }
}

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
                          shape:
                              MaterialStateProperty.all<RoundedRectangleBorder>(
                                  RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10))),
                          padding: MaterialStateProperty.all<EdgeInsets>(
                              const EdgeInsets.all(30))),
                      label: const Text("Pull Challenge!")),
                ),
                appState.hasActiveChallenge
                    ? Expanded(
                        child: Card(
                            child: TextButton(
                        onPressed: () {showDialog(
                            context: context,
                            builder: (BuildContext context) => AlertDialog(
                                  title: Text(appState.challenges.elementAtOrNull(appState.currentChallengeIndex)["header"]),
                                  content: Column(
                                    children: [
                                      Text("${appState.challenges.elementAtOrNull(appState.currentChallengeIndex)["coins"]} Coins"),
                                      Text(appState.challenges.elementAtOrNull(appState.currentChallengeIndex)["text"])]),
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
                                                Text(
                                                  "If you confirm, please set a timer on your phone for ${appState.challenges[appState.currentChallengeIndex]["veto_time"]} minutes."
                                                )
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
                                      label: const Text("Veto")),
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
                                                icon: Icon(Icons.close),
                                                label: Text("No"),
                                              ),
                                              TextButton.icon(
                                                onPressed: () {
                                                  Navigator.pop(context);
                                                  appState.completedChallenge();
                                                  setState(() {
                                                    appState.hasActiveChallenge = false;
                                                  });
                                                },
                                                icon: Icon(Icons.check),
                                                label: Text("Yes"),
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
                        child: Text(appState.challenges.elementAt(appState.currentChallengeIndex)["header"]),
                            ),
                        ),
                    )
                    : Container()
              ],
            )
        )
    );
  }
}

class ShopPage extends StatefulWidget {
  const ShopPage({super.key});

  @override
  State<ShopPage> createState() => _ShopPageState();
}

class _ShopPageState extends State<ShopPage> {

  @override
  Widget build(BuildContext context) {
    var appState = context.watch<TagLagState>();
    return Scaffold(
      appBar: AppBar(
        title: const Text("Shop"),
        backgroundColor: Colors.red,
      ),
      body: Text(appState.coinBalance.toString()),
    );
  }
}

class RulePage extends StatefulWidget {
  const RulePage({Key? key}) : super(key: key);

  @override
  State<RulePage> createState() => _RulePageState();
}

class _RulePageState extends State<RulePage> {
  List ruleList = [];

  // Fetch content from the json file
  Future<void> readRules() async {
    final String response = await rootBundle.loadString('assets/rules.json');
    final data = await json.decode(response);
    setState(() {
      ruleList = data["rules"];
    });
  }

  @override
  void initState() {
    super.initState();
    // Call the readJson method when the app starts
    readRules();
  }

  // Just experimented with the app bar a bit, can be removed. :)S
/*
  void onPressedSettings() {
    print("Settings");
  } */

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Tag Lag"),
        backgroundColor: Colors.red,
      ),
      body: Padding(
        padding: const EdgeInsets.all(15),
        child: Column(
          children: [
            // Display the data loaded from sample.json
            ruleList.isNotEmpty
                ? Expanded(
                    child: ListView.builder(
                      itemCount: ruleList.length,
                      itemBuilder: (context, index) {
                        /*
                        return Card(
                          color: Theme.of(context).cardColor,
                          key: ValueKey(_items[index]["id"]),
                          margin: const EdgeInsets.all(10),
                          child: ListTile(
                            leading: Text(_items[index]["id"]),
                            title: Text(_items[index]["rule"]),
                            subtitle: Text(_items[index]["explanation"]),
                          ),
                        ); */

                        return Card(
                          color: Theme.of(context).cardColor,
                          margin: const EdgeInsets.all(10),
                          child: Padding(
                            padding: const EdgeInsets.all(10.0),
                            child: Theme(
                              data: Theme.of(context).copyWith(
                                dividerColor: Colors.transparent,
                              ),
                              child: ExpansionTile(
                                title: Text(
                                  ruleList[index]["rule"],
                                ),
                                leading: Text(
                                  ruleList[index]["id"] + ".",
                                  textScaleFactor: 2,
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: Theme.of(context)
                                          .colorScheme
                                          .primary),
                                ),
                                children: <Widget>[
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Text(
                                      ruleList[index]["explanation"],
                                      style: TextStyle(
                                          color: Theme.of(context).hintColor),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  )
                : Container()
          ],
        ),
      ),
    );
  }
}
