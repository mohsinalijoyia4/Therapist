import 'package:docapp/games/memory/ui/widgets/mobile/game_board_mobile.dart';
import 'package:docapp/games/memory/ui/widgets/web/game_board.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class MemoryMatchPage extends StatelessWidget {
  const MemoryMatchPage({
    required this.gameLevel,
    super.key,
  });

  final int gameLevel;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
          child: kIsWeb
              ? GameBoard(
                  gameLevel: gameLevel,
                )
              : GameBoardMobile(
                  gameLevel: gameLevel,
                )),
    );
  }
}
