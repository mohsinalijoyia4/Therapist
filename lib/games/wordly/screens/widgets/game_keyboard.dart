import 'package:docapp/firebase.dart';
import 'package:docapp/games/wordly/screens/utils/game_provider.dart';
import 'package:docapp/games/wordly/screens/widgets/game_board.dart';
import 'package:docapp/userscreen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';

class GameKeyboard extends StatefulWidget {
  GameKeyboard(this.game, {Key? key}) : super(key: key);
  final WorldeGame game;
  @override
  State<GameKeyboard> createState() => _GameKeyboardState();
}

class _GameKeyboardState extends State<GameKeyboard> {
  List row1 = "QWERTYUIOP".split("");
  List row2 = "ASDFGHJKL".split("");
  List row3 = ["DEL", "Z", "X", "C", "V", "B", "N", "M", "SUBMIT"];
  FirebaseService firebaseService = FirebaseService();
  @override
  void initState() {
    super.initState();
    WorldeGame.game_message = '';
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          WorldeGame.game_message,
          style: TextStyle(color: Colors.white),
        ),
        SizedBox(
          height: 20.0,
        ),
        GameBoard(widget.game),
        SizedBox(
          height: 40.0,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: row1.map((e) {
            return InkWell(
              onTap: () {
                print(e);
                if (widget.game.letterId < 5) {
                  print(widget.game.rowId);
                  widget.game.insertWord(widget.game.letterId, Letter(e, 0));
                  widget.game.letterId++;
                  setState(() {});
                }
              },
              child: Container(
                padding: EdgeInsets.all(10.0),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8.0),
                  color: Colors.grey.shade300,
                ),
                child: Text(
                  "${e}",
                  style: TextStyle(
                    fontSize: 18.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            );
          }).toList(),
        ),
        SizedBox(
          height: 10.0,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: row2.map((e) {
            return InkWell(
              onTap: () {
                print(e);
                if (widget.game.letterId < 5) {
                  print(widget.game.rowId);
                  widget.game.insertWord(widget.game.letterId, Letter(e, 0));
                  widget.game.letterId++;
                  setState(() {});
                }
              },
              child: Container(
                padding: EdgeInsets.all(10.0),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8.0),
                  color: Colors.grey.shade300,
                ),
                child: Text(
                  "${e}",
                  style: TextStyle(
                    fontSize: 18.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            );
          }).toList(),
        ),
        SizedBox(
          height: 10.0,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: row3.map((e) {
            return InkWell(
              onTap: () {
                print(e);

                if (e == "DEL") {
                  if (widget.game.letterId > 0) {
                    setState(() {
                      widget.game
                          .insertWord(widget.game.letterId - 1, Letter("", 0));
                      widget.game.letterId--;
                    });
                  }
                } else if (e == "SUBMIT") {
                  // setting the game rules
                  if (widget.game.letterId >= 5) {
                    /* widget.game.wordleBoard[widget.game.rowId].replaceRange(
                      0,
                      5,
                      List.generate(5, (index) => Letter("", 3)),
                    ); */
                    String guess = widget.game.wordleBoard[widget.game.rowId]
                        .map((e) => e.letter)
                        .join();
                    print(guess);
                    print(WorldeGame.game_guess == guess);
                    if (widget.game.checkWordExist(guess.toLowerCase())) {
                      if (guess == WorldeGame.game_guess) {
                        setState(() {
                          WorldeGame.game_message =
                              "Congratulations🎉 You won then Game and your activity is completed ";
                          // Logi for won players
                          widget.game.wordleBoard[widget.game.rowId]
                              .forEach((element) {
                            element.code = 1;

                            showDialog(
                              context: context,
                              builder: (BuildContext context) {
                                return AlertDialog(
                                  title: Text('Congratulations!'),
                                  content: Text('You won the activity!'),
                                  actions: [
                                    TextButton(
                                      child: Text('OK'),
                                      onPressed: () async {
                                        User? user =
                                            FirebaseAuth.instance.currentUser;
                                        if (user != null) {
                                          String currentUserId = user.uid;
                                          String? therapistId =
                                              await firebaseService
                                                  .findTherapistIdForUser(
                                                      currentUserId);
                                          if (therapistId != null &&
                                              therapistId.isNotEmpty) {
                                            firebaseService.updateToggleValue(
                                                therapistId,
                                                currentUserId,
                                                'toggleTwo',
                                                true);
                                            print(
                                                'Field updated successfully by updatetoggle.');
                                            Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                  builder: (context) =>
                                                      UserScreenOne()),
                                            );
                                          } else {
                                            print(
                                                'Therapist ID is invalid or not found.');
                                          }
                                        } else {
                                          print('User is not authenticated.');
                                        }
                                      },
                                    )
                                  ],
                                );
                              },
                            );
                          });
                        });
                      } else {
                        print(WorldeGame.game_guess);
                        int listLength = guess.length;
                        for (int i = 0; i < listLength; i++) {
                          String char = guess[i].toUpperCase();
                          print(
                              "the test: ${WorldeGame.game_guess.contains(char)}");
                          if (WorldeGame.game_guess.contains(char)) {
                            if (WorldeGame.game_guess[i] == char) {
                              setState(() {
                                print(char);
                                widget.game.wordleBoard[widget.game.rowId][i]
                                    .code = 1;
                              });
                            } else {
                              setState(() {
                                print(char);
                                widget.game.wordleBoard[widget.game.rowId][i]
                                    .code = 2;
                              });
                            }
                          }
                        }
                        widget.game.rowId++;
                        widget.game.letterId = 0;
                      }
                    } else {
                      WorldeGame.game_message =
                          "the world does not exist try again";
                    }
                  }
                } else {
                  if (widget.game.letterId < 5) {
                    print(widget.game.rowId);
                    widget.game.insertWord(widget.game.letterId, Letter(e, 0));
                    widget.game.letterId++;
                    setState(() {});
                  }
                }
              },
              child: Container(
                padding: EdgeInsets.all(10.0),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8.0),
                  color: Colors.grey.shade300,
                ),
                child: Text(
                  "${e}",
                  style: TextStyle(
                    fontSize: 18.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            );
          }).toList(),
        ),
      ],
    );
  }
}
