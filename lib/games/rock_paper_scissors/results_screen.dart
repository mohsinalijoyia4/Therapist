import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:docapp/games/rock_paper_scissors/button.dart';
import 'package:docapp/games/rock_paper_scissors/game.dart';
import 'package:docapp/games/rock_paper_scissors/main_screen.dart';
import 'package:docapp/userscreen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class GameScreenRocks extends StatefulWidget {
  GameScreenRocks(this.gameChoice, {Key? key}) : super(key: key);
  final GameChoice gameChoice;
  @override
  _GameScreenState createState() => _GameScreenState();
}

class _GameScreenState extends State<GameScreenRocks> {
  /* Generating random choice */
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    Game.gameScore = 0;
  }

  String? randomChoice() {
    Random random = new Random();
    int robotChoiceIndex = random.nextInt(3);
    return Game.choices[robotChoiceIndex];
  }

  void showWinDialog() {
    if (Game.gameScore >= 1) {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text("Congratulations!"),
            content: Text("You won the game!"),
            actions: [
              ElevatedButton(
                onPressed: () {
                  Navigator.of(context).pop(); // Dismiss the dialog
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => UserScreenOne()),
                  );
                },
                child: Text("OK"),
              ),
            ],
          );
        },
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    String robotChoice = randomChoice()!;
    String? robotChoicePath;
    switch (robotChoice) {
      case "Rock":
        robotChoicePath = "assets/rock_btn.png";
        break;
      case "Paper":
        robotChoicePath = "assets/paper_btn.png";
        break;
      case "Scisors":
        robotChoicePath = "assets/scisor_btn.png";
        break;
      default:
    }
    String? player_choice;
    switch (widget.gameChoice.type) {
      case "Rock":
        player_choice = "assets/rock_btn.png";
        break;
      case "Paper":
        player_choice = "assets/paper_btn.png";
        break;
      case "Scisors":
        player_choice = "assets/scisor_btn.png";
        break;
      default:
    }
    if (GameChoice.gameRules[widget.gameChoice.type]![robotChoice] ==
        "You Win") {
      Game.gameScore++;
      if (Game.gameScore >= 1) {
        Game.gameScore = 0;
        User? user = FirebaseAuth.instance.currentUser;
        if (user != null) {
          String currentUserId = user.uid;
          FirebaseFirestore.instance
              .collection('users')
              .doc(currentUserId)
              .update({'toggleFourth': true}).then((_) {
            print('Field updated successfully.');
          }).catchError((error) {
            print('Failed to update field: $error');
          });
        } else {
          print('User is not authenticated.');
        }
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => UserScreenOne()),
        );
      }
      // showWinDialog;
    }
    double btnWidth = MediaQuery.of(context).size.width / 2 - 40;
    return Scaffold(
      backgroundColor: Color(0xFF060A47),
      body: Padding(
        padding: const EdgeInsets.symmetric(vertical: 34, horizontal: 20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              padding: EdgeInsets.all(16),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.white, width: 5.0),
                borderRadius: BorderRadius.circular(8.0),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "SCORE",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 32.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    "${Game.gameScore}",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 32.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),

            /* Setting the Game play pad */
            Expanded(
              child: Center(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Hero(
                      tag: "${widget.gameChoice.type}",
                      child: gameBtn(() {}, player_choice!, btnWidth - 20),
                    ),
                    Text(
                      "VS",
                      style: TextStyle(color: Colors.white, fontSize: 26.0),
                    ),
                    AnimatedOpacity(
                      opacity: 1,
                      duration: Duration(seconds: 3),
                      child: gameBtn(() {}, robotChoicePath!, btnWidth - 20),
                    )
                  ],
                ),
              ),
            ),
            Text(
              "${GameChoice.gameRules[widget.gameChoice.type]![robotChoice]}",
              style: TextStyle(color: Colors.white, fontSize: 36.0),
            ),
            SizedBox(
              height: 30.0,
            ),
            Container(
              width: double.infinity,
              child: RawMaterialButton(
                padding: EdgeInsets.all(24.0),
                onPressed: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => MainScreenRock(),
                      ));
                },
                shape: StadiumBorder(),
                fillColor: Colors.white,
                child: Text(
                  "Play Again",
                  style: TextStyle(
                      color: Color(0xFF060A47),
                      fontSize: 26.0,
                      fontWeight: FontWeight.bold),
                ),
              ),
            ),
            SizedBox(
              height: 20.0,
            ),
            Container(
              width: double.infinity,
              child: RawMaterialButton(
                padding: EdgeInsets.all(24.0),
                onPressed: () {},
                shape: StadiumBorder(
                    side: BorderSide(color: Colors.white, width: 5)),
                child: Text(
                  "Rules",
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 26.0,
                      fontWeight: FontWeight.bold),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
