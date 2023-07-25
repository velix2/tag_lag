// ignore_for_file: unused_local_variable

import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_spinbox/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'dart:math';
import 'challenges_page.dart';
import 'rule_page.dart';
import 'shop_page.dart';
import 'game_page.dart';

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
        ));
  }
}

class TagLagState extends ChangeNotifier {
  // all app-wide variables having to do with CHALLENGES
  List challenges = ["empty"]; // a list of all challenges
  int currentChallengeIndex = 0; // what challenge is currently being done?
  bool hasActiveChallenge = false; // is there an active challenge?
  List pastChallenges = [];

  // all app-wide variables having to do with COINS
  int coinBalance = 50; // how many coins are in the teams bank?

  // all app-wide variables having to do with TRANSPORT
  List pastBuys = [];

  // everything to do with the game as a whole
  bool gameStarted = false;
  int selectedIndex = 0;
  int numOfTeams = 2;
  int teamNum = 1;

  // all app-wide variables having to do with VETOING
  var vetoStartTime = DateTime
      .now(); // Storing the timepoint that the last veto period was started
  var vetoTimeTotal = const Duration(
      minutes: 0); // The amount of time the last/current veto period lasts
  var vetoEndTime =
      DateTime.now(); // The point in time where the veto period ends
  var vetoTimeLeft = const Duration(minutes: 0);
  bool hasActiveVeto = false;

  late Timer vetoTimer;

  void startVeto() {
    vetoTimeLeft = vetoEndTime.difference(DateTime.now());
    notifyListeners();

    vetoTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      vetoTimeLeft = vetoEndTime.difference(DateTime.now());
      if (vetoTimeLeft.isNegative) {
        hasActiveVeto = false;
        timer.cancel();
      }
      notifyListeners();
    });
  }

  @override
  void dispose() {
    vetoTimer.cancel();
    super.dispose();
  }

  void buy(int cost) {
    coinBalance = coinBalance - cost;
  }

  //shuffle the list of challenges, for extra randomnes
  void shuffleChallenges() {
    final random = Random();
    currentChallengeIndex = random.nextInt(challenges.length);
  }

  // when a challenge is completed, add the coins it brings to the teams wallet and moves it from challenges to pastChallenges
  void completedChallenge() {
    coinBalance += challenges[currentChallengeIndex]["coins"] as int;
    pastChallenges.add(challenges.removeAt(currentChallengeIndex));
  }
}

class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  @override
  Widget build(BuildContext context) {
    var appState = context.watch<TagLagState>();
    Widget page;
    switch (appState.selectedIndex) {
      case 0:
        page = const FirstOpenPage();
        break;
      case 1:
        page = const ChallengesPage();
        break;
      case 2:
        page = const ShopPage();
        break;
      case 3:
        page = const RulePage();
        break;
      default:
        throw UnimplementedError('no widget for $appState.selectedIndex');
    }

    return LayoutBuilder(builder: (context, constraints) {
      if (!appState.gameStarted) {
        return Scaffold(
          body: Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text("Welcome to", style: TextStyle(fontSize: 24),),
                Text("TAG LAG", style: GoogleFonts.righteous(fontSize: 120, fontWeight: FontWeight.w800, letterSpacing: -5, height: .8, color: const Color.fromARGB(255, 220, 40, 16)), textAlign: TextAlign.center,),
              ],
            ),
          ),
          floatingActionButton: FloatingActionButton.extended(
              onPressed: () {
                appState.numOfTeams = 2;
                showDialog(
                    context: context,
                    builder: (BuildContext context) => AlertDialog(
                          title: Row(
                            children: [
                              const Icon(Icons.play_arrow_rounded),
                              SizedBox.fromSize(
                                size: const Size(15, 15),
                              ),
                              const Text("Start new Game"),
                            ],
                          ),
                          content: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Center(child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text("How many teams are playing?", style: Theme.of(context).textTheme.bodyLarge,),
                              )),
                              SpinBox(
                                min: 2,
                                max: 5,
                                value: 2,
                                onChanged: (value) =>
                                    appState.numOfTeams = value.toInt(),
                              ),
                            ],
                          ),
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
                                  showDialog(
                                      context: context,
                                      builder: (BuildContext context) =>
                                          AlertDialog(
                                            title: Row(
                                              children: [
                                                const Icon(
                                                    Icons.play_arrow_rounded),
                                                SizedBox.fromSize(
                                                  size: const Size(15, 15),
                                                ),
                                                const Text("Start new Game"),
                                              ],
                                            ),
                                            content: Column(
                                              mainAxisSize: MainAxisSize.min,
                                              children: [
                                                 Text(
                                                    "What is your team's number?", style: Theme.of(context).textTheme.bodyLarge),
                                                Center(
                                                  child: Padding(
                                                    padding: const EdgeInsets.all(8.0),
                                                    child: Text(
                                                        "Make sure to assign every team an individual number from 1 to ${appState.numOfTeams}."),
                                                  ),
                                                ),
                                                SpinBox(
                                                  min: 1,
                                                  max: appState.numOfTeams
                                                      .toDouble(),
                                                  value: 1,
                                                  onChanged: (value) => appState
                                                      .teamNum = value.toInt(),
                                                      
                                                ),
                                              ],
                                            ),
                                            actions: [
                                              TextButton.icon(
                                                  onPressed: () {
                                                    Navigator.pop(context);
                                                  },
                                                  icon: const Icon(Icons.close),
                                                  label: const Text("Cancel")),
                                              TextButton.icon(
                                                  onPressed: () {
                                                    setState(() {
                                                      appState.gameStarted =
                                                          true;
                                                    });
                                                    Navigator.pop(context);
                                                  },
                                                  icon: const Icon(Icons.check),
                                                  label:
                                                      const Text("Start Game!"))
                                            ],
                                          ));
                                },
                                icon: const Icon(Icons.check),
                                label: const Text("Continue"))
                          ],
                        ));
              },
              label: const Row(
                children: [
                  Icon(Icons.play_arrow_rounded),
                  SizedBox(width: 10),
                  Text("New Game!"),
                ],
              )),
        );
      } else {
        return Scaffold(
          bottomNavigationBar: BottomNavigationBar(
            type: BottomNavigationBarType.fixed,
            items: const <BottomNavigationBarItem>[
              BottomNavigationBarItem(
                  icon: Icon(Icons.directions_walk), label: "Game"),
              BottomNavigationBarItem(
                  icon: Icon(Icons.assistant_photo), label: "Challenges"),
              BottomNavigationBarItem(
                  icon: Icon(Icons.train), label: "Transport"),
              BottomNavigationBarItem(
                  icon: Icon(Icons.handshake), label: "Rules"),
            ],
            currentIndex: appState.selectedIndex,
            onTap: (value) {
              setState(() {
                appState.selectedIndex = value;
              });
            },
          ),
          body: page,
        );
      }
    });
  }
}
