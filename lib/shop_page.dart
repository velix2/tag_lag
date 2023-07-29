import 'package:flutter_spinbox/material.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
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
    final String response = await rootBundle.loadString('assets/mediums.json');
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
      Icon(
        Icons.train,
        size: 50,
      ),
      Icon(
        Icons.directions_train,
        size: 50,
      ),
      Icon(
        Icons.directions_subway,
        size: 50,
      ),
      Icon(
        Icons.directions_bus,
        size: 50,
      ),
      Icon(
        Icons.directions_walk,
        size: 50,
      )
    ];
    return Scaffold(
        appBar: AppBar(
          title: Row(
            children: [
              Icon(
                Icons.train,
                color: Theme.of(context).primaryColor,
                size: 40,
              ),
              const SizedBox(width: 15),
              Text(
                "Shop",
                style: GoogleFonts.righteous(
                  fontWeight: FontWeight.w500,
                ),
                textAlign: TextAlign.center,
              ),
              Text(
                ".",
                style: GoogleFonts.righteous(
                  fontWeight: FontWeight.w800,
                  color: Theme.of(context).primaryColor,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
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
                                child: appState.pastBuys.isEmpty
                                    ? const Text(
                                        "You haven't bought anything yet!")
                                    : ListView.builder(
                                        itemCount: appState.pastBuys.length,
                                        itemBuilder: (context, index) {
                                          return Card(
                                            child: Padding(
                                              padding:
                                                  const EdgeInsets.all(8.0),
                                              child: Text(
                                                  "${appState.pastBuys.elementAtOrNull(index).num}x ${appState.pastBuys.elementAtOrNull(index).mediumName}, ${appState.pastBuys.elementAtOrNull(index).totalCost} coins total"),
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
        body: appState.gameStarted
            ? Column(
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
                                fontSize: 30, fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                    )),
                  ),
                  const Divider(),
                  Expanded(
                    child: GridView(
                        gridDelegate:
                            const SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: 2,
                                childAspectRatio: 1.5,
                                crossAxisSpacing: 10,
                                mainAxisSpacing: 10),
                        children: [
                          for (var medium in mediumsList)
                            BuyButton(
                              cost: medium["cost"],
                              medium: medium["name"],
                              mediumIcon:
                                  mediumIcons.elementAtOrNull(medium["iconId"]),
                              onPressed: () {
                                int numToBuy = 1;
                                showDialog(
                                    context: context,
                                    builder: (BuildContext context) =>
                                        AlertDialog(
                                          title: Row(
                                            mainAxisSize: MainAxisSize.min,
                                            children: [
                                              mediumIcons.elementAtOrNull(
                                                  medium["iconId"]),
                                              SizedBox.fromSize(
                                                size: const Size(15, 15),
                                              ),
                                              Expanded(
                                                  child: Text(
                                                "Purchase ${medium["name"]}",
                                              )),
                                            ],
                                          ),
                                          content: Column(
                                            mainAxisSize: MainAxisSize.min,
                                            children: [
                                              const Text(
                                                "Purchase",
                                                style: TextStyle(
                                                    fontWeight: FontWeight.w600,
                                                    fontSize: 20),
                                              ),
                                              SpinBox(
                                                decoration:
                                                    const InputDecoration(
                                                  border: InputBorder.none,
                                                  focusedBorder:
                                                      InputBorder.none,
                                                  enabledBorder:
                                                      InputBorder.none,
                                                  errorBorder:
                                                      InputBorder.none,
                                                  disabledBorder:
                                                      InputBorder.none,                                                      
                                                ),
                                                iconColor: MaterialStateProperty.resolveWith((states) {
                                                  if (states.contains(MaterialState.disabled)) {
                                                    return Theme.of(context).disabledColor;
                                                  }
                                                  else {
                                                    return Theme.of(context).primaryColor;
                                                  }
                                                }),
                                                min: 1,
                                                max: (appState.coinBalance /
                                                        medium["cost"])
                                                    .floor()
                                                    .toDouble(), //makes the max the max you can afford, so you cannot go negative
                                                value: 1,
                                                onChanged: (value) => {
                                                  numToBuy = value.toInt()
                                                },
                                                textStyle:
                                                    GoogleFonts.righteous(
                                                        fontSize: 30,
                                                        color: Theme.of(
                                                                context)
                                                            .primaryColor),
                                              ),
                                              const Text(
                                                "Stations",
                                                style: TextStyle(
                                                    fontWeight: FontWeight.w600,
                                                    fontSize: 20),
                                              )
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
                                                  setState(() {
                                                    appState.buy(
                                                        medium["cost"] *
                                                            numToBuy);
                                                    appState.pastBuys.add(
                                                        TransportBuy(
                                                            mediumId:
                                                                medium["id"],
                                                            mediumName:
                                                                medium["name"],
                                                            mediumPrice:
                                                                medium["cost"],
                                                            num: numToBuy));
                                                  });
                                                },
                                                icon: const Icon(Icons.check),
                                                label: const Text("Confirm"))
                                          ],
                                        ));
                              },
                              enabled: (appState.coinBalance - medium["cost"])
                                      .isNegative
                                  ? false
                                  : true,
                            )
                        ]),
                  )
                ],
              )
            : const Center(child: Text("Start a new Game first!")));
  }
}

class BuyButton extends StatefulWidget {
  String medium;
  int cost;
  Icon mediumIcon;
  void Function() onPressed;
  bool enabled;

  BuyButton(
      {super.key,
      required this.cost,
      required this.medium,
      required this.mediumIcon,
      required this.onPressed,
      required this.enabled});

  @override
  State<BuyButton> createState() => _BuyButtonState();
}

class _BuyButtonState extends State<BuyButton> {
  @override
  Widget build(BuildContext context) {
    //var appState = context.watch<TagLagState>();
    return ElevatedButton(
      onPressed: widget.enabled ? widget.onPressed : null,
      style: ButtonStyle(
          shape: MaterialStatePropertyAll<RoundedRectangleBorder>(
              RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(25),
      ))),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SizedBox(
            width: 50,
            child: Center(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: [
                  widget.mediumIcon,
                  Text(
                    widget.medium,
                    style: GoogleFonts.righteous(
                        fontWeight: FontWeight.w600, fontSize: 12),
                    overflow: TextOverflow.fade,
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(
            width: 20,
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Card(
                elevation: 0,
                child: Center(
                    child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.attach_money_rounded,
                        size: 22,
                        color: Theme.of(context).primaryColor,
                      ),
                      Text(
                        widget.cost.toString(),
                        style: GoogleFonts.righteous(),
                      ),
                    ],
                  ),
                )),
              ),
              Text(
                "per Station",
                style: TextStyle(
                    color: Theme.of(context).disabledColor, fontSize: 10),
              ),
            ],
          )
        ],
      ),
    );
  }
}

class TransportBuy {
  int mediumId;
  String mediumName;
  int mediumPrice;
  int num;
  int totalCost;

  TransportBuy(
      {required this.mediumId,
      required this.mediumName,
      required this.mediumPrice,
      required this.num,
      this.totalCost = 0}) {
    totalCost = mediumPrice * num;
  }
}
