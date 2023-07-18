// ignore_for_file: must_be_immutable

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'main.dart';
import 'dart:convert';

class ShopPage extends StatefulWidget {
  const ShopPage({super.key});

  @override
  State<ShopPage> createState() => _ShopPageState();
}

class _ShopPageState extends State<ShopPage> {

  List mediumsList = [];

  // Fetch content from the json file
  Future<void> readMediums() async {
    final String response =
        await rootBundle.loadString('assets/mediums.json');
    final data = await json.decode(response);
    setState(() {
      mediumsList = data["mediums"];
      print(mediumsList);
    });
  }

  @override
  void initState() {
    super.initState();
    // Call the readJson method when this page gets loaded
    readMediums();
  }

  @override
  Widget build(BuildContext context) {
    var appState = context.watch<TagLagState>();
    return Scaffold(
      appBar: AppBar(
        leading: const Icon(Icons.train),
        title: const Text("Shop"),
        backgroundColor: Colors.red,
      ),
      body: Column(
        children: [
          Card(
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Text("You have ${appState.coinBalance.toString()} Coins"),
            )
          ),
          const Divider(),
          Column(
            children: [
              for (var medium in mediumsList)
                Padding(
                  padding: const EdgeInsets.all(20),
                  child: BuyButton(
                    cost: medium["cost"],
                    medium: medium["name"],
                    mediumIcon: const Icon(Icons.train),
                    onPressed: () {
                      setState(() {
                        appState.buy(medium["cost"]);
                      });
                    },
                    enabled: (appState.coinBalance - medium["cost"]).isNegative?
                      false:
                      true,
                  ),
                )
            ]
          )
        ],
      ),
    );
  }
}

class BuyButton extends StatefulWidget {
  String medium;
  int cost;
  var mediumIcon;
  void Function() onPressed;
  bool enabled;

  BuyButton(
    {super.key, required this.cost, required this.medium, required this.mediumIcon, required this.onPressed, required this.enabled}
  );

  @override
  State<BuyButton> createState() => _BuyButtonState();
}

class _BuyButtonState extends State<BuyButton> {
  @override
  Widget build(BuildContext context) {
    //var appState = context.watch<TagLagState>();
    return ElevatedButton.icon(
      onPressed: widget.enabled?
        widget.onPressed:
        null,
      label: Text("One ${widget.medium} station, Price: ${widget.cost}"),
      icon: widget.mediumIcon,
    );
  }
}