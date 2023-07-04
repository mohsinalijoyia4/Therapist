import 'dart:async';
import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:docapp/games/tetris/pacman.dart';
import 'package:docapp/userscreen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'barriers.dart';
import 'ghost.dart';
import 'pixel.dart';

class HomePagePackman extends StatefulWidget {
  @override
  _HomePagePackmanState createState() => _HomePagePackmanState();
}

class _HomePagePackmanState extends State<HomePagePackman> {
  static int numberOfSquares = numberInRow * 17;
  static int numberInRow = 11;
  int player = 166;
  int ghost = -1;
  bool mouthClosed = true;
  int score = 0;

  static List<int> barriers = [
    0,
    1,
    2,
    3,
    4,
    5,
    6,
    7,
    8,
    9,
    10,
    11,
    22,
    33,
    44,
    55,
    66,
    77,
    99,
    110,
    121,
    132,
    143,
    154,
    165,
    176,
    177,
    178,
    179,
    180,
    181,
    182,
    183,
    184,
    185,
    186,
    175,
    164,
    153,
    142,
    131,
    120,
    109,
    87,
    76,
    65,
    54,
    43,
    32,
    21,
    78,
    79,
    80,
    100,
    101,
    102,
    84,
    85,
    86,
    106,
    107,
    108,
    24,
    35,
    46,
    57,
    30,
    41,
    52,
    63,
    81,
    70,
    59,
    61,
    72,
    83,
    26,
    28,
    37,
    38,
    39,
    123,
    134,
    145,
    156,
    129,
    140,
    151,
    162,
    103,
    114,
    125,
    105,
    116,
    127,
    147,
    148,
    149,
    158,
    160
  ];

  List<int> food = [];

  void getFood() {
    for (int i = 0; i < numberOfSquares; i++) {
      if (!barriers.contains(i)) {
        food.add(i);
      }
    }
  }

  void _updateToggleValueForCurrentUser() async {
    User? user = FirebaseAuth.instance.currentUser;

    if (user != null) {
      String currentUserId = user.uid;

      QuerySnapshot therapistsSnapshot =
          await FirebaseFirestore.instance.collection('therapists').get();

      therapistsSnapshot.docs.forEach((therapistDoc) async {
        String therapistId = therapistDoc.id;
        QuerySnapshot assignedUsersSnapshot = await FirebaseFirestore.instance
            .collection('therapists')
            .doc(therapistId)
            .collection('assignedusers')
            .where('id', isEqualTo: currentUserId)
            .get();

        assignedUsersSnapshot.docs.forEach((assignedUserDoc) async {
          String assignedUserId = assignedUserDoc.id;
          await FirebaseFirestore.instance
              .collection('therapists')
              .doc(therapistId)
              .collection('assignedusers')
              .doc(assignedUserId)
              .update({'toggleFivth': true}).then((_) {
            print(
                'Field updated successfully for therapist in usrs: $therapistId');
          }).catchError((error) {
            print(
                'Failed to update field for therapist: $therapistId - $error');
          });
        });
      });
    } else {
      print('User is not authenticated.');
    }
  }

  String direction = "right";
  bool gameStarted = false;
  void checkWin() {
    if (score == 10) {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text("Activity Completed"),
            content: Text("Congratulations! You have completed the activity."),
            actions: <Widget>[
              TextButton(
                child: Text("OK"),
                onPressed: () async {
                  User? user = FirebaseAuth.instance.currentUser;
                  if (user != null) {
                    String currentUserId = user.uid;
                    print("Enter the update block");
                    // Find the therapist document for the current user
                    QuerySnapshot therapistsSnapshot = await FirebaseFirestore
                        .instance
                        .collection('therapists')
                        .get();

                    for (var therapistDoc in therapistsSnapshot.docs) {
                      QuerySnapshot assignedUsersSnapshot = await therapistDoc
                          .reference
                          .collection('assignedusers')
                          .where('id', isEqualTo: currentUserId)
                          .get();

                      if (assignedUsersSnapshot.docs.isNotEmpty) {
                        String therapistId = therapistDoc.id;
                        print("Before _update method");
                        // Update the toggle value using the _updateToggleValue method
                        await _updateToggleValue(
                          therapistId,
                          currentUserId,
                          'toggleEighth',
                          true,
                        );

                        break; // Exit the loop once the desired assigned user document is found
                      }
                    }
                  } else {
                    print('User is not authenticated.');
                  }
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => UserScreenOne()),
                  ); // Close the dialog
                },
              )
            ],
          );
        },
      );
    }
  }

  Future<void> _updateToggleValue(
    String therapistId,
    String patientId,
    String fieldToUpdate,
    bool newValue,
  ) async {
    try {
      await FirebaseFirestore.instance
          .collection('therapists')
          .doc(therapistId)
          .collection('assignedusers')
          .doc(patientId)
          .update({fieldToUpdate: newValue});
      await FirebaseFirestore.instance
          .collection('users')
          .doc(patientId)
          .update({fieldToUpdate: newValue});

      print('Updated successfully');
      // Send notification to the patient
      // _sendNotification(patientId, fieldToUpdate);
    } catch (error) {
      print('Error updating toggle value: $error');
    }
  }

  void startGame() {
    print(MediaQuery.of(context).size.width);
    moveGhost();
    gameStarted = true;
    getFood();
    Duration duration = Duration(milliseconds: 120);
    Timer.periodic(duration, (timer) {
      if (food.contains(player)) {
        food.remove(player);
        score++;
        checkWin();
      }

      switch (direction) {
        case "right":
          moveRight();
          break;

        case "up":
          moveUp();

          break;

        case "left":
          moveLeft();

          break;

        case "down":
          moveDown();

          break;
      }
    });
  }

  String ghostDirection = "left"; // initial
  void moveGhost() {
    Duration ghostSpeed = Duration(milliseconds: 500);
    Timer.periodic(ghostSpeed, (timer) {
      if (!barriers.contains(ghost - 1) && ghostDirection != "right") {
        ghostDirection = "left";
      } else if (!barriers.contains(ghost - numberInRow) &&
          ghostDirection != "down") {
        ghostDirection = "up";
      } else if (!barriers.contains(ghost + numberInRow) &&
          ghostDirection != "up") {
        ghostDirection = "down";
      } else if (!barriers.contains(ghost + 1) && ghostDirection != "left") {
        ghostDirection = "right";
      }

      switch (ghostDirection) {
        case "right":
          setState(() {
            ghost++;
          });
          break;

        case "up":
          setState(() {
            ghost -= numberInRow;
          });
          break;

        case "left":
          setState(() {
            ghost--;
          });
          break;

        case "down":
          setState(() {
            ghost += numberInRow;
          });
          break;
      }
    });
  }

  void moveRight() {
    setState(() {
      if (!barriers.contains(player + 1)) {
        player += 1;
      }
    });
  }

  void moveUp() {
    setState(() {
      if (!barriers.contains(player - numberInRow)) {
        player -= numberInRow;
      }
    });
  }

  void moveLeft() {
    setState(() {
      if (!barriers.contains(player - 1)) {
        player -= 1;
      }
    });
  }

  void moveDown() {
    setState(() {
      if (!barriers.contains(player + numberInRow)) {
        player += numberInRow;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Center(
        child: SafeArea(
          child: Container(
            width: 400,
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(18.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Card(
                        elevation: 1,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15)),
                        child: Container(
                          height: 35,
                          width: 80,
                          decoration: BoxDecoration(
                              color: Colors.green,
                              borderRadius: BorderRadius.circular(15)),
                          child: GestureDetector(
                            onTap: startGame,
                            child: Center(
                              child: Text(
                                "P L A Y",
                                style: TextStyle(
                                    color: Colors.grey[300], fontSize: 20),
                              ),
                            ),
                          ),
                        ),
                      ),
                      Container(
                        height: 35,
                        child: Text(
                          "S C O R E :  $score ",
                          style:
                              TextStyle(color: Colors.grey[300], fontSize: 20),
                        ),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: Center(
                    child: Container(
                      child: GestureDetector(
                        onVerticalDragUpdate: (details) {
                          if (details.delta.dy > 0) {
                            direction = "down";
                          } else if (details.delta.dy < 0) {
                            direction = "up";
                          }
                        },
                        onHorizontalDragUpdate: (details) {
                          if (details.delta.dx > 0) {
                            direction = "right";
                          } else if (details.delta.dx < 0) {
                            direction = "left";
                          }
                        },
                        child: Container(
                          child: GridView.builder(
                              physics: NeverScrollableScrollPhysics(),
                              itemCount: numberOfSquares,
                              gridDelegate:
                                  SliverGridDelegateWithFixedCrossAxisCount(
                                      crossAxisCount: numberInRow),
                              itemBuilder: (BuildContext context, int index) {
                                if (player == index) {
                                  if (!mouthClosed) {
                                    return Padding(
                                      padding: EdgeInsets.all(4),
                                      child: Container(
                                          decoration: BoxDecoration(
                                        shape: BoxShape.circle,
                                        color: Colors.yellow,
                                      )),
                                    );
                                  } else {
                                    if (direction == "right") {
                                      return PacmanDude();
                                    } else if (direction == "up") {
                                      return Transform.rotate(
                                          angle: 3 * pi / 2,
                                          child: PacmanDude());
                                    } else if (direction == "left") {
                                      return Transform.rotate(
                                          angle: pi, child: PacmanDude());
                                    } else if (direction == "down") {
                                      return Transform.rotate(
                                          angle: pi / 2, child: PacmanDude());
                                    }
                                  }
                                } else if (ghost == index) {
                                  return Ghost();
                                } else if (barriers.contains(index)) {
                                  return MyBarrier(
                                    innerColor: Colors.blue[800],
                                    outerColor: Colors.blue[900],
                                    //child: Center(child: Text(index.toString(), style: TextStyle(fontSize: 10,color: Colors.white),)),
                                  );
                                } else if (food.contains(index) ||
                                    !gameStarted) {
                                  return MyPixel(
                                    innerColor: Colors.yellow,
                                    outerColor: Colors.black,
                                    //child: Center(child: Text(index.toString(), style: TextStyle(fontSize: 10,color: Colors.white),)),
                                  );
                                } else {
                                  return MyPixel(
                                    innerColor: Colors.black,
                                    outerColor: Colors.black,
                                    //child: Center(child: Text(index.toString(), style: TextStyle(fontSize: 10,color: Colors.white),)),
                                  );
                                }
                                return null;
                              }),
                        ),
                      ),
                    ),
                  ),
                ),
                Text(
                  "Press PLAY to Start",
                  style: TextStyle(color: Colors.grey[300], fontSize: 20),
                ),
                Text(
                  "Get 25 score to Complete Activity",
                  style: TextStyle(color: Colors.grey[300], fontSize: 20),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
