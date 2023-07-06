import 'package:docapp/firebase.dart';
import 'package:docapp/games/jigsaw/Widgets/jigsawWidget.dart';
import 'package:docapp/userscreen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class JigsawPuzzle extends StatefulWidget {
  const JigsawPuzzle({super.key});

  @override
  State<JigsawPuzzle> createState() => _JigsawPuzzleState();
}

class _JigsawPuzzleState extends State<JigsawPuzzle> {
  //testbutton to check crop work
  GlobalKey<JigsawWidgetState> jigkey = GlobalKey<JigsawWidgetState>();
  FirebaseService firebaseService = FirebaseService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
            gradient: LinearGradient(colors: [
          Color(0xFF701ebd),
          Color(0xFF873bcc),
          Color(0xFFfe4a97),
          Color(0xFFe17763),
          Color(0xFF68998c)
        ], stops: [
          0.1,
          0.4,
          0.6,
          0.8,
          1
        ], begin: Alignment.topRight, end: Alignment.bottomLeft)),
        child: SafeArea(
          child: Column(
            children: [
              // base for the puzzle widget
              Container(
                margin: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(15),
                  // border: Border.all(width: 2)
                ),
                child: JigsawWidget(
                  callbackFinish: () {
                    showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return AlertDialog(
                          title: Text("Activity Completed"),
                          content: Text(
                              "Congratulations! You have completed the activity."),
                          actions: <Widget>[
                            TextButton(
                              child: Text("OK"),
                              onPressed: () async {
                                User? user = FirebaseAuth.instance.currentUser;
                                if (user != null) {
                                  String currentUserId = user.uid;
                                  String? therapistId = await firebaseService
                                      .findTherapistIdForUser(currentUserId);
                                  if (therapistId != null &&
                                      therapistId.isNotEmpty) {
                                    firebaseService.updateToggleValue(
                                        therapistId,
                                        currentUserId,
                                        'toggleEighth',
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

                    print("CallBackFinish");
                    print("object mine");
                  },
                  callbackSuccess: () {
                    print("CallBackSuccess");
                  },
                  key: jigkey,
                  // Container for jigsaw image
                  child: const Padding(
                    padding: EdgeInsets.all(22.0),
                    child: Image(
                      fit: BoxFit.fill,
                      image: AssetImage("assets/images/nature.png"),
                    ),
                  ),
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              Padding(
                padding: const EdgeInsets.all(15.0),
                child: ElevatedButton.icon(
                  onPressed: () async {
                    await jigkey.currentState!.generalJigsawCropImage();
                  },
                  icon: const Icon(
                    CupertinoIcons.arrow_right,
                    color: Color(0xFFFE0037),
                  ),
                  label: const Text("Start"),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.transparent,
                    minimumSize: const Size(double.infinity, 56),
                    shape: const RoundedRectangleBorder(
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(10),
                        topRight: Radius.circular(25),
                        bottomRight: Radius.circular(25),
                        bottomLeft: Radius.circular(25),
                      ),
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(15.0),
                child: ElevatedButton.icon(
                  onPressed: () {
                    jigkey.currentState!.resetJigsaw();
                  },
                  icon: const Icon(
                    CupertinoIcons.repeat,
                    color: Color(0xFFFE0037),
                  ),
                  label: const Text("Reset"),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.transparent,
                    minimumSize: const Size(double.infinity, 56),
                    shape: const RoundedRectangleBorder(
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(10),
                        topRight: Radius.circular(25),
                        bottomRight: Radius.circular(25),
                        bottomLeft: Radius.circular(25),
                      ),
                    ),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
