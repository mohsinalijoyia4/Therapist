import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'loginsignup/constants.dart';
import 'loginsignup/textbutton.dart';
import 'loginsignup/therapistlogin.dart';
import 'loginsignup/therapistregis.dart';

class TherapistEntryPageEntryPage extends StatelessWidget {
  const TherapistEntryPageEntryPage({super.key});

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: Colors.white24,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            children: [
              Flexible(
                child: Column(
                  children: [
                    SizedBox(
                      height: size.height * 0.05,
                    ),
                    Center(
                      child: Container(
                        height: size.height * 0.3,
                        decoration: BoxDecoration(
                            image: DecorationImage(
                          image: AssetImage('assets/images/meditation_bg.png'),
                        )),
                        width: size.width * 0.8,
                      ),
                    ),
                    SizedBox(
                      height: size.height * 0.01,
                    ),
                    const Text(
                      "Therapsit Patient \ncollaboration",
                      style: kHeadline,
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    SizedBox(
                      width: size.width * 0.8,
                      child: const Text(
                        "Bring together your user to your sellers and people as clients.",
                        style: kBodyText,
                        textAlign: TextAlign.center,
                      ),
                    ),
                    SizedBox(
                      height: size.height * 0.06,
                    ),
                  ],
                ),
              ),
              AnimatedButtonContainer(),
              SizedBox(
                height: size.height * 0.1,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class AnimatedButtonContainer extends StatefulWidget {
  const AnimatedButtonContainer({super.key});

  @override
  _AnimatedButtonContainerState createState() =>
      _AnimatedButtonContainerState();
}

class _AnimatedButtonContainerState extends State<AnimatedButtonContainer> {
  double position = 0.0;
  Color signUpTextColor = Colors.white;
  @override
  void initState() {
    super.initState();
    position = 0.0; // Initialize position to 0.0 when the page starts
  }

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;

    return Container(
      height: size.height * 0.08,
      width: size.width * 0.85,
      decoration: BoxDecoration(
        color: Colors.grey[850],
        borderRadius: BorderRadius.circular(18),
      ),
      child: Stack(
        children: [
          AnimatedContainer(
            duration: Duration(milliseconds: 200),
            margin: EdgeInsets.only(left: position),
            padding: EdgeInsets.only(right: size.width * 0.425 - 20),
            height: size.height * 0.08,
            width: size.width * 0.425,
            decoration: BoxDecoration(
              backgroundBlendMode: BlendMode.lighten,
              color: Colors.grey,
              borderRadius: BorderRadius.circular(18),
            ),
          ),
          Row(
            children: [
              Expanded(
                child: MyTextButton(
                  bgColor: Colors.white,
                  buttonName: 'Register',
                  onTap: () async {
                    setState(() {
                      position = 0.0;
                      signUpTextColor = Colors.black87;
                    });
                    await Future.delayed(Duration(
                        milliseconds: 250)); // Introduce a 0.5-second delay

                    Navigator.push(
                      context,
                      CupertinoPageRoute(
                        builder: (context) => const TherapistRegistrationPage(),
                      ),
                    );
                    setState(() {
                      position = 0.0;
                    });
                  },
                  textColor: Colors.black87,
                ),
              ),
              Expanded(
                child: MyTextButton(
                  bgColor: Colors.transparent,
                  buttonName: 'Sign In',
                  onTap: () async {
                    setState(() {
                      position = size.width * 0.425;
                      signUpTextColor = Colors.white;
                    });
                    await Future.delayed(Duration(
                        milliseconds: 250)); // Introduce a 0.5-second delay

                    Navigator.push(
                      context,
                      CupertinoPageRoute(
                        builder: (context) => TherapistLoginPage(),
                      ),
                    );
                    setState(() {
                      position = 0.0;
                    });
                  },
                  textColor: Colors.white,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
