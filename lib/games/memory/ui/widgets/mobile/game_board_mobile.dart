import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:docapp/allexercises.dart';
import 'package:docapp/games/memory/models/game.dart';
import 'package:docapp/games/memory/ui/widgets/game_confetti.dart';
import 'package:docapp/games/memory/ui/widgets/memory_card.dart';
import 'package:docapp/games/memory/ui/widgets/mobile/game_best_time_mobile.dart';
import 'package:docapp/games/memory/ui/widgets/mobile/game_timer_mobile.dart';
import 'package:docapp/games/memory/ui/widgets/restart_game.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class GameBoardMobile extends StatefulWidget {
  const GameBoardMobile({
    required this.gameLevel,
    super.key,
  });

  final int gameLevel;

  @override
  State<GameBoardMobile> createState() => _GameBoardMobileState();
}

class _GameBoardMobileState extends State<GameBoardMobile> {
  late Timer timer;
  late Game game;
  late Duration duration;
  int bestTime = 0;
  bool showConfetti = false;
  @override
  void initState() {
    super.initState();
    game = Game(widget.gameLevel);
    duration = const Duration();
    startTimer();
    getBestTime();
  }

  void getBestTime() async {
    SharedPreferences gameSP = await SharedPreferences.getInstance();
    if (gameSP.getInt('${widget.gameLevel.toString()}BestTime') != null) {
      bestTime = gameSP.getInt('${widget.gameLevel.toString()}BestTime')!;
    }
    setState(() {});
  }

  startTimer() {
    timer = Timer.periodic(const Duration(seconds: 1), (_) async {
      setState(() {
        final seconds = duration.inSeconds + 1;
        duration = Duration(seconds: seconds);
      });

      if (game.isGameOver) {
        timer.cancel();

        SharedPreferences gameSP = await SharedPreferences.getInstance();
        if (gameSP.getInt('${widget.gameLevel.toString()}BestTime') == null ||
            gameSP.getInt('${widget.gameLevel.toString()}BestTime')! >
                duration.inSeconds) {
          gameSP.setInt(
              '${widget.gameLevel.toString()}BestTime', duration.inSeconds);
          setState(() {
            showConfetti = true;
            bestTime = duration.inSeconds;
          });
        }
      }
    });
  }

  pauseTimer() {
    timer.cancel();
  }

  void _resetGame() {
    game.resetGame();
    setState(() {
      timer.cancel();
      duration = const Duration();
      startTimer();
    });
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    final aspectRatio = MediaQuery.of(context).size.aspectRatio;

    return SafeArea(
      child: Stack(
        children: [
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const SizedBox(
                height: 20,
              ),
              RestartGame(
                isGameOver: game.isGameOver,
                pauseGame: () => pauseTimer(),
                restartGame: () => _resetGame(),
                continueGame: () => startTimer(),
                color: Colors.amberAccent[700]!,
              ),
              GameTimerMobile(
                time: duration,
              ),
              Expanded(
                child: GridView.count(
                  crossAxisCount: game.gridSize,
                  childAspectRatio: aspectRatio * 2,
                  children: List.generate(game.cards.length, (index) {
                    return MemoryCard(
                      index: index,
                      card: game.cards[index],
                      onCardPressed: game.onCardPressed,
                    );
                  }),
                ),
              ),
              GameBestTimeMobile(
                bestTime: bestTime,
              ),
              game.isGameOver
                  ? Container(
                      height: size.height * 0.06,
                      width: size.width * 0.76,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(15),
                        color: Colors.white,
                      ),
                      child: ElevatedButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const DetailsScreen()),
                          );

                          User? user = FirebaseAuth.instance.currentUser;
                          if (user != null) {
                            String currentUserId = user.uid;
                            FirebaseFirestore.instance
                                .collection('users')
                                .doc(currentUserId)
                                .update({'togglesixth': true}).then((_) {
                              print('Field updated successfully.');
                            }).catchError((error) {
                              print('Failed to update field: $error');
                            });
                          } else {
                            print('User is not authenticated.');
                          }
                        },
                        style: ElevatedButton.styleFrom(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15),
                          ),
                          backgroundColor: Colors.green,
                        ),
                        child: const Text(
                          "isDone",
                          style: TextStyle(
                              color: Colors.black,
                              fontSize: 20,
                              fontWeight: FontWeight.w500),
                        ),
                      ),
                    )
                  : Container(),
              SizedBox(
                height: 20,
              )
            ],
          ),
          showConfetti ? GameConfetti() : const SizedBox(),
        ],
      ),
    );
  }
}
