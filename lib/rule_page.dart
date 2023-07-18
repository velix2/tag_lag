import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:flutter/services.dart';
import 'dart:async';

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Rules"),
        backgroundColor: Colors.red,
      ),
      body: Padding(
        padding: const EdgeInsets.all(15),
        child: ListView.builder(
          itemCount: ruleList.length,
          itemBuilder: (context, index) {
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
                          .primary
                      ),
                    ),
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          ruleList[index]["explanation"],
                          style: TextStyle(
                            color: Theme.of(context).hintColor
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
