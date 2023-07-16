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
      body: Text(appState.coinBalance.toString()),
    );
  }
}