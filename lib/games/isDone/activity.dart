import 'package:docapp/games/minesweerpr/main_screen.dart';
import 'package:docapp/loginsignup/constants.dart';
import 'package:docapp/loginsignup/textbutton.dart';
import 'package:docapp/patientlist.dart';
import 'package:flutter/material.dart';

class ActivityOneScreen extends StatefulWidget {
  const ActivityOneScreen({super.key});

  @override
  State<ActivityOneScreen> createState() => _ActivityOneScreenState();
}

class _ActivityOneScreenState extends State<ActivityOneScreen> {
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
               Text("Activity One",
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
                      MaterialPageRoute(builder: (context) => MainScreen()),
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
