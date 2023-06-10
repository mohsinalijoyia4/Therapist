import 'package:docapp/loginsignup/userlogin.dart';
import 'package:docapp/loginsignup/userregistration.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'loginsignup/constants.dart';
import 'loginsignup/textbutton.dart';

class UserEntryPage extends StatelessWidget {
  const UserEntryPage({super.key});

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: kBackgroundColor,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            children: [
              Flexible(
                child: Column(
                  children: [
                    SizedBox(
                      height: size.height * 0.1,
                    ),
                    Center(
                      child: Container(
                        width: size.width * 0.8,
                        height: size.height * 0.3,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20),
                          image: DecorationImage(
                            fit: BoxFit.fill,
                            image: AssetImage('assets/images/user.png'),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 20,
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
                        "Well Come User We bring together users to therapist .",
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
                        builder: (context) => UserRegistration(),
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
                        builder: (context) => UserSignIn(),
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
