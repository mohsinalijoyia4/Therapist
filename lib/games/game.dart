import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:docapp/constants.dart';
import 'package:docapp/userscreen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class MatchingGame extends StatefulWidget {
  const MatchingGame({Key? key}) : super(key: key);

  @override
  _MatchingGameState createState() => _MatchingGameState();
}

class _MatchingGameState extends State<MatchingGame> {
  late List<ItemModel> items;
  late List<ItemModel> items2;

  int score = 0;
  bool gameOver = false;

  @override
  void initState() {
    super.initState();
    initGame();
  }

  initGame() async {
    gameOver = false;
    score = 0;
    items = [
      ItemModel(icon: FontAwesomeIcons.coffee, name: "Coffee", value: "Coffee"),
      ItemModel(icon: FontAwesomeIcons.dog, name: "dog", value: "dog"),
      ItemModel(icon: FontAwesomeIcons.cat, name: "Cat", value: "Cat"),
      ItemModel(
        icon: FontAwesomeIcons.birthdayCake,
        name: "Cake",
        value: "Cake",
      ),
      ItemModel(icon: FontAwesomeIcons.bus, name: "bus", value: "bus"),
    ];
    items2 = List<ItemModel>.from(items);
    items.shuffle();
    items2.shuffle();
  }

  void update() async {
    User? currentUser = FirebaseAuth.instance.currentUser;
    if (currentUser != null) {
      DocumentReference userDoc =
          FirebaseFirestore.instance.collection('users').doc(currentUser.uid);

      // Update the toggleThree field if the score is 50
      if (score == 50) {
        await userDoc.update({'toggleThree': true});
        print('toggleThree updated in Firestore');
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => UserScreenOne()),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    if (items.isEmpty) gameOver = true;
    return Scaffold(
      backgroundColor: kBackgroundColor,
      appBar: AppBar(
        centerTitle: true,
        title: const Text('Matching Game'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: <Widget>[
            Text.rich(
              TextSpan(
                children: [
                  const TextSpan(
                    text: "Score: ",
                    style: const TextStyle(
                      color: Colors.green,
                      fontWeight: FontWeight.bold,
                      fontSize: 30.0,
                    ),
                  ),
                  TextSpan(
                    text: "$score",
                    style: const TextStyle(
                      color: Colors.green,
                      fontWeight: FontWeight.bold,
                      fontSize: 30.0,
                    ),
                  ),
                ],
              ),
            ),
            if (!gameOver)
              Row(
                children: <Widget>[
                  Column(
                    children: items.map((item) {
                      return Container(
                        margin: const EdgeInsets.all(8.0),
                        child: Draggable<ItemModel>(
                          data: item,
                          childWhenDragging: Icon(
                            item.icon,
                            color: Colors.grey,
                            size: 50.0,
                          ),
                          feedback: Icon(
                            item.icon,
                            color: Colors.teal,
                            size: 50,
                          ),
                          child: Icon(
                            item.icon,
                            color: Colors.teal,
                            size: 50,
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                  const Spacer(),
                  Column(
                    children: items2.map((item) {
                      return DragTarget<ItemModel>(
                        onAccept: (receivedItem) {
                          if (item.value == receivedItem.value) {
                            setState(() {
                              items.remove(receivedItem);
                              items2.remove(item);
                              score += 10;
                              item.accepting = false;
                            });
                          } else {
                            setState(() {
                              score -= 5;
                              item.accepting = false;
                            });
                          }
                        },
                        onLeave: (receivedItem) {
                          setState(() {
                            item.accepting = false;
                          });
                        },
                        onWillAccept: (receivedItem) {
                          setState(() {
                            item.accepting = true;
                          });
                          return true;
                        },
                        builder: (context, acceptedItems, rejectedItem) =>
                            Container(
                          color: item.accepting ? Colors.red : Colors.teal,
                          height: 50,
                          width: 100,
                          alignment: Alignment.center,
                          margin: const EdgeInsets.all(8.0),
                          child: Text(
                            item.name,
                            style: const TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 18.0,
                            ),
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                ],
              ),
            if (gameOver)
              const Text(
                "GameOver",
                style: TextStyle(
                  color: Colors.red,
                  fontWeight: FontWeight.bold,
                  fontSize: 24.0,
                ),
              ),
            if (gameOver && score == 50) Text("Activity Completed "),
            if (gameOver)
              Center(
                child: ElevatedButton(
                  child: Text("Make it Done"),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.pink,
                    textStyle: const TextStyle(color: Colors.white),
                  ),
                  onPressed: () {
                    // initGame();
                    update();
                  },
                ),
              ),
            if (gameOver)
              Center(
                child: ElevatedButton(
                  child: Text("New Game"),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.pink,
                    textStyle: const TextStyle(color: Colors.white),
                  ),
                  onPressed: () {
                    initGame();
                    // update();
                  },
                ),
              ),
          ],
        ),
      ),
    );
  }
}

class ItemModel {
  final String name;
  final String value;
  final IconData icon;
  bool accepting;

  ItemModel({
    required this.name,
    required this.value,
    required this.icon,
    this.accepting = false,
  });
}
