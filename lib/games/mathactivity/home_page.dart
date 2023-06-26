import 'dart:math';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:docapp/games/mathactivity/const.dart';
import 'package:docapp/games/mathactivity/util/my_button.dart';
import 'package:docapp/games/mathactivity/util/result_message.dart';
import 'package:docapp/userscreen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  // number pad list
  List<String> numberPad = [
    '7',
    '8',
    '9',
    'C',
    '4',
    '5',
    '6',
    'DEL',
    '1',
    '2',
    '3',
    '=',
    '0',
  ];

  // number A, number B
  int numberA = 1;
  int numberB = 1;

  // user answer
  String userAnswer = '';

  // user tapped a button
  void buttonTapped(String button) {
    setState(() {
      if (button == '=') {
        // calculate if user is correct or incorrect
        checkResult();
      } else if (button == 'C') {
        // clear the input
        userAnswer = '';
      } else if (button == 'DEL') {
        // delete the last number
        if (userAnswer.isNotEmpty) {
          userAnswer = userAnswer.substring(0, userAnswer.length - 1);
        }
      } else if (userAnswer.length < 3) {
        // maximum of 3 numbers can be inputted
        userAnswer += button;
      }
    });
  }

  int consecutiveCorrectAnswers = 0;

  // check if user is correct or not
  void checkResult() {
    if (numberA + numberB == int.parse(userAnswer)) {
      consecutiveCorrectAnswers++;

      if (consecutiveCorrectAnswers == 3) {
        showDialog(
          context: context,
          builder: (context) {
            return ResultMessage(
              message: 'Congratulations, you won the activity!',
              onTap: () {
                User? user = FirebaseAuth.instance.currentUser;
                if (user != null) {
                  String currentUserId = user.uid;
                  FirebaseFirestore.instance
                      .collection('users')
                      .doc(currentUserId)
                      .update({'toggleFivth': true}).then((_) {
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
              },
              icon: Icons.check,
            );
          },
        );

        // reset consecutive correct answers count
        consecutiveCorrectAnswers = 0;
      } else {
        showDialog(
          context: context,
          builder: (context) {
            return ResultMessage(
              message: 'Correct!',
              onTap: goToNextQuestion,
              icon: Icons.arrow_forward,
            );
          },
        );
      }
    } else {
      // if the user answers incorrectly, reset consecutive correct answers count
      consecutiveCorrectAnswers = 0;

      showDialog(
        context: context,
        builder: (context) {
          return ResultMessage(
            message: 'Sorry, try again.',
            onTap: goBackToQuestion,
            icon: Icons.rotate_left,
          );
        },
      );
    }
  }

  // create random numbers
  var randomNumber = Random();

  // GO TO NEXT QUESTION
  void goToNextQuestion() {
    // dismiss alert dialog
    Navigator.of(context).pop();

    // reset values
    setState(() {
      userAnswer = '';
    });

    // create a new question
    numberA = randomNumber.nextInt(10);
    numberB = randomNumber.nextInt(10);
  }

  // GO BACK TO QUESTION
  void goBackToQuestion() {
    // dismiss alert dialog
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.deepPurple[300],
      body: Column(
        children: [
          // level progress, player needs 5 correct answers in a row to proceed to next level
          Container(
            height: 160,
            color: Colors.deepPurple,
            child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [
              Text(
                textAlign: TextAlign.start,
                softWrap: true,
                "Make three Consective Correct Answers",
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  color: Colors.white,
                ),
              )
            ]),
          ),

          // question
          Expanded(
            child: Container(
              child: Center(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // question
                    Text(
                      numberA.toString() + ' + ' + numberB.toString() + ' = ',
                      style: whiteTextStyle,
                    ),

                    // answer box
                    Container(
                      height: 50,
                      width: 100,
                      decoration: BoxDecoration(
                        color: Colors.deepPurple[400],
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Center(
                        child: Text(
                          userAnswer,
                          style: whiteTextStyle,
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ),
          ),

          // number pad
          Expanded(
            flex: 2,
            child: Padding(
              padding: const EdgeInsets.all(4.0),
              child: GridView.builder(
                itemCount: numberPad.length,
                physics: const NeverScrollableScrollPhysics(),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 4,
                ),
                itemBuilder: (context, index) {
                  return MyButton(
                    child: numberPad[index],
                    onTap: () => buttonTapped(numberPad[index]),
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}
