import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:flutter/services.dart';

void main() {
  runApp(const TagLag());
}

class TagLag extends StatelessWidget {
  const TagLag({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      // Hide the debug banner
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
    );
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
  List _items = [];

  // Fetch content from the json file
  Future<void> readJson() async {
    final String response =
        await rootBundle.loadString('assets/challenges.json');
    final data = await json.decode(response);
    setState(() {
      _items = data["challenges"]..shuffle();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text("Challenges"),
        ),
        body: Padding(
            padding: const EdgeInsets.all(25),
            child: Column(
              children: [
                ElevatedButton.icon(
                    onPressed: readJson,
                    icon: const Icon(Icons.shuffle),
                    label: const Text("Pull Challenge!")),
                _items.isNotEmpty
                    ? Expanded(
                        child: ElevatedButton(
                        onPressed: () => showDialog(
                            context: context,
                            builder: (BuildContext context) => AlertDialog(
                                  title: Text(_items.first["header"]),
                                  content: Text(_items.first["text"]),
                                  actions: [
                                    IconButton(
                                        onPressed: () {},
                                        icon: const Icon(Icons.check))
                                  ],
                                )),
                        child: Text(_items.first["header"]),
                      ))
                    : Container()
              ],
            )));
  }
}

class ShopPage extends StatelessWidget {
  const ShopPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Shop"),
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
  List _items = [];

  // Fetch content from the json file
  Future<void> readJson() async {
    final String response = await rootBundle.loadString('assets/rules.json');
    final data = await json.decode(response);
    setState(() {
      _items = data["rules"];
    });
  }

  @override
  void initState() {
    super.initState();
    // Call the readJson method when the app starts
    readJson();
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
      ),
      body: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          children: [
            // Display the data loaded from sample.json
            _items.isNotEmpty
                ? Expanded(
                    child: ListView.builder(
                      itemCount: _items.length,
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
                          margin: const EdgeInsets.all(8),
                          child: Padding(
                            padding: const EdgeInsets.all(10.0),
                            child: Theme(
                              data: Theme.of(context).copyWith(
                                dividerColor: Colors.transparent,
                              ),
                              child: ExpansionTile(
                                title: Text(
                                  _items[index]["rule"],
                                ),
                                leading: Text(
                                  _items[index]["id"] + ".",
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
                                      _items[index]["explanation"],
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
