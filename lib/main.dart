import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'dart:math';

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

  void shuffleChallenges() {
    final _random = new Random();
    currentChallengeIndex = _random.nextInt(challenges.length);
    print("TESTTESTTEST");
    print(currentChallengeIndex);
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
    appState.challenges = challengesList;
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
                  constraints: BoxConstraints(),
                  child: ElevatedButton.icon(
                      onPressed: appState.shuffleChallenges,
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
                appState.challenges.isNotEmpty
                    ? Expanded(
                        child: Card(
                            child: TextButton(
                        onPressed: () => showDialog(
                            context: context,
                            builder: (BuildContext context) => AlertDialog(
                                  title: Text(appState.challenges.elementAt(appState.currentChallengeIndex)["header"]),
                                  content: Text(appState.challenges.elementAt(appState.currentChallengeIndex)["text"]),
                                  actions: [
                                    IconButton(
                                        onPressed: () {},
                                        icon: const Icon(Icons.check))
                                  ],
                                )
                              ),
                        child: Text(appState.challenges.elementAt(appState.currentChallengeIndex)["header"]),
                            )
                        )
                    )
                    : Container()
              ],
            )
        )
    );
  }
}
class ShopPage extends StatelessWidget {
  const ShopPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Shop"),
        backgroundColor: Colors.red,
      ),
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
