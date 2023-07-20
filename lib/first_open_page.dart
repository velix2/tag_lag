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
    return Dialog.fullscreen(
      child: Center(
        child: ElevatedButton.icon(
          onPressed: () {
            setState(() {
              appState.gameStarted = true;
            });
            Navigator.pop(context);
          },
          icon: const Icon(Icons.play_arrow),
          label: const Text("Start Game!")
        ),
      ),
    );
  }
}