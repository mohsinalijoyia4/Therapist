import 'package:docapp/games/wordly/screens/utils/game_provider.dart';
import 'package:docapp/games/wordly/screens/widgets/game_keyboard.dart';
import 'package:flutter/material.dart';

class GameScreen extends StatefulWidget {
  const GameScreen({Key? key}) : super(key: key);

  @override
  State<GameScreen> createState() => _GameScreenState();
}

class _GameScreenState extends State<GameScreen> {
  WorldeGame _game = WorldeGame();
  late String word;
  @override
  void initState() {
    super.initState();
    WorldeGame.initGame();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF212121),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            "Wordle",
            style: TextStyle(
              color: Colors.white,
              fontSize: 36,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(
            height: 20.0,
          ),
          GameKeyboard(_game),
        ],
      ),
    );
  }
}
