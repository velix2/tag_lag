import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'main.dart';

class FirstOpenPage extends StatefulWidget {
  const FirstOpenPage({super.key});

  @override
  State<FirstOpenPage> createState() => _FirstOpenPageState();
}

class _FirstOpenPageState extends State<FirstOpenPage> {
  @override
  Widget build(BuildContext context) {
    var appState = context.watch<TagLagState>();
    return Scaffold(
      appBar: AppBar(
        leading: const Icon(Icons.directions_walk),
        title: const Text("Game"),
        backgroundColor: Theme.of(context).colorScheme.primary,
      ),
      body: const Text("Statistics"),
    );
  }
}