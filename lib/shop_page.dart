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
      ),
      Icon(
        Icons.tram,
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
                        builder: (BuildContext context) {
                          return StatefulBuilder(
                              builder: (context, setStateAlert) {
                            return AlertDialog(
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
                                              child: Stack(
                                                children: [
                                                  Align(
                                                    alignment:
                                                        Alignment.centerLeft,
                                                    child: Text(
                                                        "${appState.pastBuys.elementAtOrNull(index)["num"]}x ${appState.pastBuys.elementAtOrNull(index)["mediumName"]}\n${appState.pastBuys.elementAtOrNull(index)["totalCost"]} coins total"),
                                                  ),
                                                  Align(
                                                    alignment: Alignment.centerRight,
                                                    child: IconButton(
                                                      onPressed: () {
                                                        setState(() {
                                                          appState.coinBalance = appState.coinBalance + appState.pastBuys.elementAtOrNull(index)["totalCost"] as int;
                                                          appState.pastBuys.removeAt(index);
                                                          appState.gameDataInit();
                                                        });
                                                      },
                                                      icon: const Icon(
                                                        Icons.delete,
                                                        size: 20,
                                                      )
                                                    ),
                                                  )
                                                ],
                                              ),
                                            ),
                                          );
                                        }
                                    ),
                                ),
                                actions: [
                                  TextButton.icon(
                                    onPressed: () {
                                      Navigator.pop(context);
                                      setState(() {
                                        appState.coinBalance =
                                            appState.coinBalance;
                                      });
                                    },
                                    icon: const Icon(Icons.check),
                                    label: const Text("Done"))
                              ],
                            );
                          });
                        });
                  },
                  icon: const Icon(Icons.history)),
            )
          ],
        ),
        body: appState.gameRunning
            ? Column(
                children: [
                  const SizedBox(
                    height: 25,
                  ),
                  Text(
                    "Balance:",
                    style: GoogleFonts.righteous(
                        fontSize: 15,
                        color: Theme.of(context).colorScheme.onBackground),
                  ),
                  const SizedBox(
                    height: 5,
                  ),
                  Card(
                    color: Theme.of(context).indicatorColor,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                          vertical: 15, horizontal: 20),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            Icons.attach_money_rounded,
                            size: 50,
                            color: Theme.of(context).primaryColor,
                          ),
                          Text(
                            appState.coinBalance.toString(),
                            style: GoogleFonts.righteous(
                                fontSize: 40,
                                color:
                                    Theme.of(context).colorScheme.onBackground),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 25,
                  ),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.all(5),
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
                                mediumIcon: mediumIcons
                                    .elementAtOrNull(medium["iconId"]),
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
                                                      fontWeight:
                                                          FontWeight.w600,
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
                                                  iconColor:
                                                      MaterialStateProperty
                                                          .resolveWith(
                                                              (states) {
                                                    if (states.contains(
                                                        MaterialState
                                                            .disabled)) {
                                                      return Theme.of(context)
                                                          .disabledColor;
                                                    } else {
                                                      return Theme.of(context)
                                                          .primaryColor;
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
                                                      fontWeight:
                                                          FontWeight.w600,
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
                                                      appState.pastBuys.add({
                                                              "mediumId" : medium["id"],
                                                              "mediumName" : medium["name"],
                                                              "mediumPrice" : medium["cost"],
                                                              "num" : numToBuy,
                                                              "totalCost" : numToBuy * medium["cost"]});
                                                    });
                                                    appState.gameDataInit();
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
                    ),
                  )
                ],
              )
            : const Text(
                "The Game isn't running at the moment! Make sure to either Start a game or resume it."));
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
