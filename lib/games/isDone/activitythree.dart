import 'package:docapp/game.dart';
import 'package:docapp/loginsignup/constants.dart';
import 'package:docapp/loginsignup/textbutton.dart';
import 'package:docapp/patientlist.dart';
import 'package:flutter/material.dart';

class ActivityThreeScreen extends StatefulWidget {
  const ActivityThreeScreen({super.key});

  @override
  State<ActivityThreeScreen> createState() => _ActivityThreeScreenState();
}

class _ActivityThreeScreenState extends State<ActivityThreeScreen> {
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
              Text("Activity Three",
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
                      MaterialPageRoute(builder: (context) => MatchingGame()),
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
