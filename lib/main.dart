import 'package:flutter/material.dart';

void main() {
  runApp(const MainApp());
}

class MainApp extends StatefulWidget {
  const MainApp({super.key});

  @override
  State<MainApp> createState() => _MainAppState();
}

class _MainAppState extends State<MainApp> {
  final List<Widget> _pages = <Widget>[
    const Center(
      //PAGE 1: CHALLENGES
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          //INSERT ELEMENTS
          Text("Challenges here"),
        ],
      ),
    ),
    const Center(
      //PAGE 2: SHOP
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          //INSERT ELEMENTS
          Text("shop here"),
        ],
      ),
    ),
    Center(
      //PAGE 3: RULES
      child: SafeArea(
          child: ListView(
        primary: false,
        padding: const EdgeInsets.all(20),
        children: <Widget>[
          const Card(
            child: Text("Hiiii"),
            margin: EdgeInsets.all(20),
          ),
        ],
      )),
    ),
  ];

  int _selectedIndex = 0;
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "hi",
      home: Scaffold(
        appBar: AppBar(title: const Text("Tag Lag")),
        body: _pages.elementAt(_selectedIndex),
        bottomNavigationBar: BottomNavigationBar(
          items: const <BottomNavigationBarItem>[
            BottomNavigationBarItem(
                icon: Icon(Icons.assistant_photo), label: "Challenges"),
            BottomNavigationBarItem(
                icon: Icon(Icons.shopping_cart), label: "Shop"),
            BottomNavigationBarItem(
                icon: Icon(Icons.handshake), label: "Rules"),
          ],
          currentIndex: _selectedIndex,
          onTap: _onItemTapped,
        ),
      ),
    );
  }

  void _onItemTapped(int index) {
    setState(
      () {
        _selectedIndex = index;
      },
    );
  }
}
