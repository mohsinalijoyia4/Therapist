import 'dart:async';

import 'package:docapp/games/memory/ui/pages/startup_page.dart';
import 'package:docapp/games/memory/ui/widgets/game_controls_bottomsheet.dart';
import 'package:flutter/material.dart';

class RestartGame extends StatelessWidget {
  final bool isGameOver;
  final VoidCallback pauseGame;
  final VoidCallback restartGame;
  final VoidCallback continueGame;
  final Color color;

  const RestartGame({
    Key? key,
    required this.isGameOver,
    required this.pauseGame,
    required this.restartGame,
    required this.continueGame,
    this.color = Colors.white,
  }) : super(key: key);

  Future<void> showGameControls(BuildContext context) async {
    pauseGame();
    var value = await showModalBottomSheet<bool>(
      isScrollControlled: true,
      elevation: 5,
      context: context,
      builder: (sheetContext) {
        return const GameControlsBottomSheet();
      },
    );

    value ??= false;

    if (value) {
      restartGame();
    } else {
      continueGame();
    }
  }

  void navigateback(BuildContext context) {
    Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(builder: (BuildContext context) {
      return const StartUpPage();
    }), (Route<dynamic> route) => false);
  }

  @override
  Widget build(BuildContext context) {
    return IconButton(
      color: color,
      icon: (isGameOver)
          ? const Icon(Icons.replay_circle_filled)
          : const Icon(Icons.pause_circle_filled),
      iconSize: 40,
      onPressed: () =>
          isGameOver ? navigateback(context) : showGameControls(context),
    );
  }
}
