import 'package:flutter_spinbox/material.dart';
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
    const List mediumIcons = [
      Icon(Icons.train),
      Icon(Icons.directions_train),
      Icon(Icons.directions_subway),
      Icon(Icons.directions_bus),
      Icon(Icons.directions_walk)
    ];
    return Scaffold(
      appBar: AppBar(
        leading: const Icon(Icons.train),
        title: const Text("Shop"),
        backgroundColor: Theme.of(context).colorScheme.primary,
        actions: [
            Padding(
              padding: const EdgeInsets.all(5.0),
              child: IconButton(
                  onPressed: () {
                    showDialog(
                        context: context,
                        builder: (BuildContext context) => AlertDialog(
                              title: const Text("History"),
                              content: SizedBox(
                                width: 200,
                                height: 400,
                                child: appState.pastBuys.isEmpty ? const Text("You haven't bought anything yet!")
                                  : ListView.builder(
                                    itemCount: appState.pastBuys.length,
                                    itemBuilder: (context, index) {
                                      return Card(
                                        child: Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: Text("${appState.pastBuys.elementAtOrNull(index).num}x ${appState.pastBuys.elementAtOrNull(index).mediumName}, ${appState.pastBuys.elementAtOrNull(index).totalCost} coins total"),
                                        ),
                                      );
                                    }),
                              ),
                            ));
                  },
                  icon: const Icon(Icons.history)),
            )
          ],
      ),
      body: appState.gameStarted ? Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(20),
            child: Card(
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  children: [
                    const Text("You have"),
                    Text(
                      "${appState.coinBalance.toString()} Coins",
                      style: const TextStyle(
                        fontSize: 30,
                        fontWeight: FontWeight.bold
                      ),
                    ),
                  ],
                ),
              )
            ),
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
                    mediumIcon: mediumIcons.elementAtOrNull(medium["iconId"]),
                    onPressed: () {
                      int numToBuy = 1;
                      showDialog(
                        context: context,
                        builder: (BuildContext context) => AlertDialog(
                          title: const Text("Confirm"),
                          content: Column(
                            children: [
                              const Text("You're buying"),
                              SpinBox(
                                min: 1,
                                max: (appState.coinBalance / medium["cost"]).floor().toDouble(), //makes the max the max you can afford, so you cannot go negative
                                value: 1,
                                onChanged: (value) => {
                                  numToBuy = value.toInt()
                                },
                              ),
                              Text("Stations of ${medium['name']}")
                            ],
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
                                  appState.buy(medium["cost"] * numToBuy);
                                  appState.pastBuys.add(TransportBuy(
                                    mediumId: medium["id"],
                                    mediumName: medium["name"],
                                    mediumPrice: medium["cost"],
                                    num: numToBuy
                                  ));
                                 });
                              },
                              icon: const Icon(Icons.check),
                              label: const Text("Confirm")
                            )
                          ],
                        )
                      );
                    },
                    enabled: (appState.coinBalance - medium["cost"]).isNegative?
                      false:
                      true,
                  ),
                )
            ]
          )
        ],
      ) : const Center(child: Text("Start a new Game first!"))
    );
  }
}

class BuyButton extends StatefulWidget {
  String medium;
  int cost;
  Icon mediumIcon;
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
      label: Column(
        children: [
          Text(
            "Buy ${widget.medium} ticket",
            style: const TextStyle(
              fontWeight: FontWeight.bold
            ),
          ),
          Text(
            "Price per Station: ${widget.cost}"
          )
        ],
      ),
      icon: widget.mediumIcon,
    );
  }
}

class TransportBuy {
  int mediumId;
  String mediumName;
  int mediumPrice;
  int num;
  int totalCost;

  TransportBuy({required this.mediumId, required this.mediumName, required this.mediumPrice, required this.num, this.totalCost = 0}) {
    totalCost = mediumPrice * num;
  }
}