// ignore_for_file: unused_local_variable

import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_spinbox/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';
import 'dart:math';
import 'package:duration/duration.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:tag_lag/db_test.dart';
import 'challenges_page.dart';
import 'rule_page.dart';
import 'shop_page.dart';
import 'game_page.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

void main() async {
  runApp(const TagLag());
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  
}

class TagLag extends StatelessWidget {
  const TagLag({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    
    SystemChrome.setPreferredOrientations(
        [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);

    return ChangeNotifierProvider(
        create: (context) => TagLagState(),
        child: MaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'Tag Lag',
          theme: ThemeData(
            useMaterial3: true,
            colorScheme: ColorScheme.fromSeed(
                seedColor: const Color.fromARGB(255, 89, 12, 14),
                brightness: Brightness.light),
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
  int coinBalance = 25; // how many coins are in the teams bank?

  // all app-wide variables having to do with TRANSPORT
  List pastBuys = [];

  // everything to do with the game as a whole
  bool gameRunning = false;
  int selectedIndex = 0;
  int numOfTeams = 2;
  int teamNum = 1;

  bool gameDataExists = false;

  Future<String> get gameDataPath async {
    final directory = await getApplicationDocumentsDirectory();
    return directory.path;
  }

  Future<File> get gameDataFile async {
    final path = await gameDataPath;
    return File("$path/gamedata.json");
  }

  Future<void> gameDataInit() async {
    final file = await gameDataFile;

    file.writeAsStringSync(jsonEncode({
      "challenges": challenges,
      "currentChallengeIndex": currentChallengeIndex,
      "hasActiveChallenge": hasActiveChallenge,
      "pastChallenges": pastChallenges,
      "coinBalance": coinBalance,
      "pastBuys": pastBuys,
      "gameRunning": gameRunning,
      "selectedIndex": selectedIndex,
      "numOfTeams": numOfTeams,
      "teamNum": teamNum,
      "vetoStartTime": vetoStartTime.toIso8601String(),
      "vetoTimeTotal": vetoTimeTotal.toString(),
      "vetoEndTime": vetoEndTime.toIso8601String(),
      "vetoTimeLeft": vetoTimeLeft.toString(),
      "hasActiveVeto": hasActiveVeto,
      "curseStartTime": curseStartTime.toIso8601String(),
      "curseEndTime": curseEndTime.toIso8601String(),
      "curseTimeLeft": curseTimeLeft.toString(),
      "curseTimeTotal": curseTimeTotal.toString(),
      "hasActiveCurse": hasActiveCurse,
    }));
  }

  /*Future<void> gameDataWrite({
    var challengesToWrite,
    var currentChallengeIndexToWrite,
    var hasActiveChallengeToWrite,
    var pastChallengesToWrite,
    var coinBalanceToWrite,
    var pastBuysToWrite,
    var gameRunningToWrite,
    var selectedIndexToWrite,
    var numOfTeamsToWrite,
    var teamNumToWrite,
    var vetoStartTimeToWrite,
    var vetoEndTimeToWrite,
    var vetoTimeTotalToWrite,
    var vetoTimeLeftToWrite,
    var hasActiveVetoToWrite,
    var curseStartTimeToWrite,
    var curseEndTimeToWrite,
    var curseTimeTotalToWrite,
    var curseTimeLeftToWrite,
    var hasActiveCurseToWrite,
  }) async {
    final file = await gameDataFile;
    final currentGameDataRaw = await gameData;
    Map<String, dynamic> currentGameData = jsonDecode(currentGameDataRaw);

    challengesToWrite != null ? currentGameData["challenges"] = challengesToWrite : ();
    currentChallengeIndexToWrite != null ? currentGameData["currentChallengeIndex"] = currentChallengeIndexToWrite : ();
    hasActiveChallengeToWrite != null ? currentGameData["hasActiveChallenge"] = hasActiveChallengeToWrite : ();
    pastChallengesToWrite != null ? currentGameData["pastChallenges"] = pastChallengesToWrite : ();
    coinBalanceToWrite != null ? currentGameData["coinBalance"] = coinBalanceToWrite : ();
    pastBuysToWrite != null ? currentGameData["pastBuys"] = pastBuysToWrite : ();
    gameRunningToWrite != null ? currentGameData["gameRunning"] = gameRunningToWrite : ();
    selectedIndexToWrite != null ? currentGameData["selectedIndex"] = selectedIndexToWrite : ();
    numOfTeamsToWrite != null ? currentGameData["numOfTeams"] = numOfTeamsToWrite : ();
    teamNumToWrite != null ? currentGameData["teamNum"] = teamNumToWrite : ();
    vetoStartTimeToWrite != null ? currentGameData["vetoStartTime"] = vetoStartTimeToWrite : ();
    vetoTimeTotalToWrite != null ? currentGameData["vetoTimeTotal"] = vetoTimeTotalToWrite : ();
    vetoEndTimeToWrite != null ? currentGameData["vetoEndTime"] = vetoEndTimeToWrite : ();
    vetoTimeLeftToWrite != null ? currentGameData["vetoTimeLeft"] = vetoTimeLeftToWrite : ();
    hasActiveVetoToWrite != null ? currentGameData["hasActiveVeto"] = hasActiveVetoToWrite : ();
    curseStartTimeToWrite != null ? currentGameData["curseStartTime"] = curseStartTimeToWrite : ();
    curseEndTimeToWrite != null ? currentGameData["curseEndTime"] = curseEndTimeToWrite : ();
    curseTimeLeftToWrite != null ? currentGameData["curseTimeLeft"] = curseTimeLeftToWrite : ();
    curseTimeTotalToWrite != null ? currentGameData["curseTimeTotal"] = curseTimeTotalToWrite : ();
    hasActiveCurseToWrite != null ? currentGameData["hasActiveCurse"] = hasActiveCurseToWrite : ();

    await file.writeAsString("");
    await file.writeAsString(jsonEncode(currentGameData));
  }*/

  Future<String> get gameData async {
    try {
      final file = await gameDataFile;
      final rawContent = await file.readAsString();
      return rawContent;
    } catch (e) {
      print("Something went wrong: $e");
      return "Something failed";
    }
  }

  Future<void> gameDataSync() async {
    final file = await gameDataFile;
    var rawContent = await file.readAsString();
    var content = await jsonDecode(rawContent);
    challenges = content["challenges"];
    currentChallengeIndex = content["currentChallengeIndex"];
    hasActiveChallenge = content["hasActiveChallenge"];
    pastChallenges = content["pastChallenges"];
    coinBalance = content["coinBalance"];
    pastBuys = content["pastBuys"];
    gameRunning = content["gameRunning"];
    selectedIndex = content["selectedIndex"];
    numOfTeams = content["numOfTeams"];
    teamNum = content["teamNum"];
    vetoStartTime = DateTime.parse(content["vetoStartTime"]);
    vetoTimeTotal = parseTime(content["vetoTimeTotal"]);
    vetoEndTime = DateTime.parse(content["vetoEndTime"]);
    vetoTimeLeft = parseTime(content["vetoTimeLeft"]);
    hasActiveVeto = content["hasActiveVeto"];
    if (hasActiveVeto) {
      startVeto();
    }
    curseStartTime = DateTime.parse(content["curseStartTime"]);
    curseEndTime = DateTime.parse(content["curseEndTime"]);
    curseTimeLeft = parseTime(content["curseTimeLeft"]);
    curseTimeTotal = parseTime(content["curseTimeTotal"]);
    hasActiveCurse = content["hasActiveCurse"];
    if (hasActiveCurse) {
      startCurse();
    }
    print("Synced, currentChallengeIndex: ${currentChallengeIndex}");
  }

  Future<void> gameDataDelete() async {
    final file = await gameDataFile;
    file.delete();
  }

  Future<void> checkForGameData() async {
    final file = await gameDataFile;
    gameDataExists = await file.exists();
  }

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

  //CURSES
  var curseStartTime = DateTime.now();
  var curseEndTime = DateTime.now();
  var curseTimeLeft = const Duration(minutes: 0);
  var curseTimeTotal = const Duration(
      minutes: 0); // The amount of time the last/current veto period lasts

  bool hasActiveCurse = false;

  late Timer curseTimer;

  void startVeto() {
    vetoTimeLeft = vetoEndTime.difference(DateTime.now());
    notifyListeners();

    vetoTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      vetoTimeLeft = vetoEndTime.difference(DateTime.now());
      if (vetoTimeLeft.isNegative) {
        hasActiveVeto = false;
        gameDataInit();
        timer.cancel();
      }
      notifyListeners();
    });
  }

  void startCurse() {
    curseTimeLeft = curseEndTime.difference(DateTime.now());
    notifyListeners();

    curseTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      curseTimeLeft = curseEndTime.difference(DateTime.now());
      if (curseTimeLeft.isNegative) {
        hasActiveCurse = false;
        gameDataInit();
        timer.cancel();
      }
      notifyListeners();
    });
  }

  @override
  void dispose() {
    vetoTimer.cancel();
    curseTimer.cancel();
    super.dispose();
  }

  void buy(int cost) {
    coinBalance = coinBalance - cost;
    gameDataInit();
  }

  //shuffle the list of challenges, for extra randomnes
  void shuffleChallenges() {
    final random = Random();
    int nextChallengeIndex = random.nextInt(challenges.length);
    //gameDataWrite(currentChallengeIndexToWrite: currentChallengeIndex);
    gameDataInit();
    currentChallengeIndex = nextChallengeIndex;
    print(currentChallengeIndex);
  }

  // when a challenge is completed, add the coins it brings to the teams wallet and moves it from challenges to pastChallenges
  void completedChallenge() {
    coinBalance += challenges[currentChallengeIndex]["coins"] as int;
    pastChallenges.add(challenges.removeAt(currentChallengeIndex));
    gameDataInit();
  }

  void setupNotifications() async {
    final fcmToken = await FirebaseMessaging.instance.getToken(
        vapidKey:
            "BG1CU6BD32t7duxBRmpEQu9gJrYHldzBBy2SV3Tb6Id7sW-dS6bA2P0G3G7zHs6Njn8pg3Pk278KiLITc6srw5A");
            print("Token is ${fcmToken}");
    await FirebaseMessaging.instance.setAutoInitEnabled(true);

    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      print('Got a message whilst in the foreground!');
      print('Message data: ${message.data}');

      if (message.notification != null) {
        print('Message also contained a notification: ${message.notification}');
      }
    });
    print("setup complete");
  }
}

class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  final iconAssetPath = 'assets/logo.svg';

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
      Widget standartChild = Scaffold(
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
      if (!appState.gameRunning) {
        return FutureBuilder<void>(
            future: appState.checkForGameData(),
            builder: (BuildContext context, AsyncSnapshot<void> snapshot) {
              Widget child;
              bool showStartScreen = false;
              if (snapshot.connectionState == ConnectionState.done) {
                if (!appState.gameDataExists) {
                  showStartScreen = true;
                } else {
                  if (!appState.gameRunning) {
                    appState.gameRunning = true;
                  }
                  appState.gameDataSync();
                }
              } else {
                child = const Scaffold(body: CircularProgressIndicator());
              }
              if (showStartScreen) {
                child = Scaffold(
                  body: Center(
                    child: Column(
                      children: [
                        const SizedBox(
                          height: 100,
                        ),
                        SvgPicture.asset(iconAssetPath,
                            height: 200,
                            width: 200,
                            colorFilter: ColorFilter.mode(
                              Theme.of(context).primaryColor,
                              BlendMode.srcIn,
                            )),
                        const SizedBox(
                          height: 50,
                        ),
                        Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Text(
                              "Welcome to",
                              style: TextStyle(fontSize: 24),
                            ),
                            Text(
                              "TAG LAG",
                              style: GoogleFonts.righteous(
                                  fontSize: 120,
                                  fontWeight: FontWeight.w800,
                                  letterSpacing: -5,
                                  height: .8,
                                  color: Theme.of(context).colorScheme.primary),
                              textAlign: TextAlign.center,
                            ),
                            FloatingActionButton(onPressed: () {appState.setupNotifications();}),
                          ],
                        ),
                      ],
                    ),
                  ),
                  floatingActionButton: FloatingActionButton.extended(
                      onPressed: () {
                        DbTest().test();

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
                                      Center(
                                          child: Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Text(
                                          "How many teams are playing?",
                                          style: Theme.of(context)
                                              .textTheme
                                              .bodyLarge,
                                        ),
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
                                                        const Icon(Icons
                                                            .play_arrow_rounded),
                                                        SizedBox.fromSize(
                                                          size: const Size(
                                                              15, 15),
                                                        ),
                                                        const Text(
                                                            "Start new Game"),
                                                      ],
                                                    ),
                                                    content: Column(
                                                      mainAxisSize:
                                                          MainAxisSize.min,
                                                      children: [
                                                        Text(
                                                            "What is your team's number?",
                                                            style: Theme.of(
                                                                    context)
                                                                .textTheme
                                                                .bodyLarge),
                                                        Center(
                                                          child: Padding(
                                                            padding:
                                                                const EdgeInsets
                                                                    .all(8.0),
                                                            child: Text(
                                                                "Make sure to assign every team an individual number from 1 to ${appState.numOfTeams}."),
                                                          ),
                                                        ),
                                                        SpinBox(
                                                          min: 1,
                                                          max: appState
                                                              .numOfTeams
                                                              .toDouble(),
                                                          value: 1,
                                                          onChanged: (value) =>
                                                              appState.teamNum =
                                                                  value.toInt(),
                                                        ),
                                                      ],
                                                    ),
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
                                                            setState(() {
                                                              appState.gameRunning =
                                                                  true;
                                                            });
                                                            appState
                                                                .gameDataInit();
                                                            Navigator.pop(
                                                                context);
                                                          },
                                                          icon: const Icon(
                                                              Icons.check),
                                                          label: const Text(
                                                              "Start Game!"))
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
                child = standartChild;
              }
              return child;
            });
      } else {
        return standartChild;
      }
    });
  }
}
