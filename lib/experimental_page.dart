// ignore_for_file: unused_field

import 'dart:math';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'main.dart';

class ExperimentalPage extends StatefulWidget {
  const ExperimentalPage({super.key});

  @override
  State<ExperimentalPage> createState() => _ExperimentalPageState();
}

class _ExperimentalPageState extends State<ExperimentalPage>
    with TickerProviderStateMixin {
  late AnimationController _controller;
  late Animation _animation;
  late AnimationStatus _status;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 600));
    _animation = Tween(end: 1.0, begin: 0.0).animate(_controller)
      ..addListener(() {
        setState(() {});
      })
      ..addStatusListener((status) {
        _status = status;
      });
  }

  @override
  Widget build(BuildContext context) {
    var appState = context.watch<TagLagState>();

    if(appState.hasActiveChallenge) {
      _controller.forward();
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text(
            "Test Page"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(25),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.max,
          children: [
            Center(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: SizedBox(
                  width: double.infinity,
                  height: 500,
                  child: Transform(
                      alignment: FractionalOffset.center,
                      transform: Matrix4.identity()
                        ..setEntry(3, 2, 0.0015)
                        ..rotateY(pi - pi * _animation.value),
                      child: (_animation.value <= 0.5 ||
                              !appState.hasActiveChallenge)
                          ? CardFront(controller: _controller, appState: appState)
                          : CardBack()),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class CardBack extends StatelessWidget {
  const CardBack({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
        margin: EdgeInsets.all(20),
        child: Center(child: Text("Back")));
  }
}

class CardFront extends StatelessWidget {
  const CardFront({
    super.key,
    required AnimationController controller,
    required this.appState,
  }) : _controller = controller;

  final AnimationController _controller;
  final TagLagState appState;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        onTap: () {
          _controller.forward();
          appState.hasActiveChallenge = true;
        },
        child: Card(
            margin: const EdgeInsets.all(20),
            child: Transform(
                alignment: FractionalOffset.center,
                transform: Matrix4.rotationY(pi),
                child: Center(
                  child: (!appState.hasActiveChallenge) ? const Column(
                      mainAxisAlignment:
                          MainAxisAlignment.center,
                      children: [
                        Icon(Icons.shuffle),
                        Text("Tap to pull challenge...")
                      ]) : const SizedBox(),
                ))),
      );
  }
}
