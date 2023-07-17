import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'main.dart';

class ShopPage extends StatefulWidget {
  const ShopPage({super.key});

  @override
  State<ShopPage> createState() => _ShopPageState();
}

class _ShopPageState extends State<ShopPage> {

  @override
  Widget build(BuildContext context) {
    var appState = context.watch<TagLagState>();
    return Scaffold(
      appBar: AppBar(
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
          BuyButton(
            cost: 75,
            medium: "U-Bahn",
            mediumIcon: const Icon(Icons.train),
            onPressed: () {
              setState(() {
                appState.coinBalance = appState.coinBalance - 75;
              });
            },
          ),
        ],
      ),
    );
  }
}

class BuyButton extends StatefulWidget {
  String medium;
  int cost;
  Icon mediumIcon;
  var onPressed;

  BuyButton(
    {super.key, required this.cost, required this.medium, required this.mediumIcon, required this.onPressed}
  );

  @override
  State<BuyButton> createState() => _BuyButtonState();
}

class _BuyButtonState extends State<BuyButton> {
  @override
  Widget build(BuildContext context) {
    var appState = context.watch<TagLagState>();
    return ElevatedButton.icon(
      onPressed: widget.onPressed,
      label: Text("One ${widget.medium} station"),
      icon: widget.mediumIcon,
    );
  }
}