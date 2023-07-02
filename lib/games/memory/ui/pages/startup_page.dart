import 'package:docapp/games/memory/ui/widgets/game_options.dart';
import 'package:docapp/games/memory/utils/constants.dart';
import 'package:flutter/material.dart';


class StartUpPage extends StatelessWidget {
  const StartUpPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: const [
                Text(
                  gameTitle,
                  style: TextStyle(fontSize: 24, color: Colors.white),
                ),
                GameOptions(),
              ]),
        ),
      ),
    );
  }
}
