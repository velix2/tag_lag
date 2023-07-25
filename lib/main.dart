// ignore_for_file: unused_local_variable

import 'dart:async';
import 'package:flutter/material.dart';
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
          floatingActionButton: FloatingActionButton.extended(onPressed: () {
            
          }, label: Row(
            children: [
              Icon(Icons.play_arrow_rounded),
              SizedBox(width: 10),
              Text("New Game!"),
            ],
          )),
        );
      }
      else {
      return Scaffold(
        bottomNavigationBar: BottomNavigationBar(
          type: BottomNavigationBarType.fixed,
          items: const <BottomNavigationBarItem>[
            BottomNavigationBarItem(
              icon: Icon(Icons.directions_walk),
              label: "Game"
            ),
            BottomNavigationBarItem(
                icon: Icon(Icons.assistant_photo),
                label: "Challenges"
            ),
            BottomNavigationBarItem(
                icon: Icon(Icons.train),
                label: "Transport"
            ),
            BottomNavigationBarItem(
                icon: Icon(Icons.handshake),
                label: "Rules"
            ),
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
