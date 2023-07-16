// ignore_for_file: unused_local_variable

import 'package:flutter/material.dart'; 
import 'package:provider/provider.dart';
import 'dart:math';
import 'challenges_page.dart';
import 'rule_page.dart';
import 'shop_page.dart';

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
  List challenges = []; // a list of all challenges
  int currentChallengeIndex = 0; // what challenge is currently being done?
  bool hasActiveChallenge = false; // is there an active challenge?

  int coinBalance = 500; // how many coins are in the teams bank?

  //shuffle the list of challenges, for extra randomnes
  void shuffleChallenges() {
    final random = Random();
    currentChallengeIndex = random.nextInt(challenges.length);
  }

  // when a challenge is completed, add the coins it brings to the teams wallet
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