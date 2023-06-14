import 'package:docapp/games/wordly/screens/game_screen.dart';
import 'package:docapp/loginsignup/constants.dart';
import 'package:docapp/loginsignup/textbutton.dart';
import 'package:docapp/patientlist.dart';
import 'package:flutter/material.dart';

class ActivityTwoScreen extends StatefulWidget {
  const ActivityTwoScreen({super.key});

  @override
  State<ActivityTwoScreen> createState() => _ActivityTwoScreenState();
}

class _ActivityTwoScreenState extends State<ActivityTwoScreen> {
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      body: Container(
        width: size.width,
        height: size.height,
        decoration: const BoxDecoration(
          color: kBackgroundColor,
          image: DecorationImage(
            image: AssetImage("assets/images/meditation_bg.png"),
            fit: BoxFit.fitWidth,
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(18.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text("Activity Two",
                  style: TextStyle(
                      fontSize: 20,
                      color: Colors.white,
                      fontWeight: FontWeight.w700)),
              SizedBox(
                height: size.height * 0.03,
              ),
              MyTextButton(
                  bgColor: Colors.white,
                  textColor: Colors.black,
                  buttonName: 'Play Game',
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => GameScreen()),
                    );
                  }),
              SizedBox(
                height: size.height * 0.03,
              ),
              MyTextButton(
                  bgColor: Colors.white,
                  textColor: Colors.black,
                  buttonName: 'isDone',
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => PatientListPage()),
                    );
                  }),
            ],
          ),
        ),
      ),
    );
  }
}
