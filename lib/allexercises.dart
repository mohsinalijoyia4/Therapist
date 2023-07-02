import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:docapp/games/game.dart';
import 'package:docapp/games/colormatch/colormatching.dart';
import 'package:docapp/games/mathactivity/home_page.dart';
import 'package:docapp/games/memory/ui/pages/startup_page.dart';
import 'package:docapp/games/nwe/Board.dart';
import 'package:docapp/games/rock_paper_scissors/main_screen.dart';
import 'package:docapp/games/wordly/screens/game_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'loginsignup/constants.dart';
import 'package:percent_indicator/percent_indicator.dart';

class DetailsScreen extends StatefulWidget {
  const DetailsScreen({super.key});

  @override
  State<DetailsScreen> createState() => _DetailsScreenState();
}

class _DetailsScreenState extends State<DetailsScreen> {
  double progress = 0.0;
  List<Map<String, dynamic>> patientList = [];
  bool toggleone = false;
  bool toggletwo = false;
  bool togglethree = false;
  bool togglefourth = false;
  bool togglefivth = false;
  bool togglesixth = false;
  bool toggleseven = false;
  bool toogleeight = false;
  List<List<bool>> toggleValues = [];

  @override
  void initState() {
    super.initState();
    _fetchUserData();
  }

  String getCurrentTherapistId() {
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      print("User is not null");
      return user.uid;
    } else {
      return '';
    }
  }

  Future<void> _fetchUserData() async {
    String currentuseID = '';
    currentuseID = getCurrentTherapistId();

    try {
      QuerySnapshot therapistsSnapshot =
          await FirebaseFirestore.instance.collection('therapists').get();

      List<Map<String, dynamic>> patients = [];

      for (var therapistDoc in therapistsSnapshot.docs) {
        QuerySnapshot assignedUsersSnapshot =
            await therapistDoc.reference.collection('assignedusers').get();

        for (var assignedUserDoc in assignedUsersSnapshot.docs) {
          if (assignedUserDoc.id == currentuseID) {
            Map<String, dynamic> userData =
                assignedUserDoc.data() as Map<String, dynamic>;
            userData['id'] = assignedUserDoc.id;

            // Initialize toggle values if not already present
            if (!userData.containsKey('toggleOne')) {
              userData['toggleOne'] = false;
            }
            if (!userData.containsKey('toggleTwo')) {
              userData['toggleTwo'] = false;
            }
            if (!userData.containsKey('toggleThree')) {
              userData['toggleThree'] = false;
            }
            if (!userData.containsKey('toggleFourth')) {
              userData['toggleFourth'] = false;
            }
            if (!userData.containsKey('toggleFivth')) {
              userData['toggleFivth'] = false;
            }
            if (!userData.containsKey('togglesixth')) {
              userData['togglesixth'] = false;
            }
            if (!userData.containsKey('toggleSeventh')) {
              userData['toggleSeventh'] = false;
            }
            if (!userData.containsKey('toggleEighth')) {
              userData['toggleEighth'] = false;
            }

            patients.add(userData);
            break; // Exit the loop once the desired assigned user document is found
          }
        }
      }

      setState(() {
        patientList = patients;
        if (patients.isNotEmpty) {
          toggleone = patients[0]['toggleOne'];
          toggletwo = patients[0]['toggleTwo'];
          togglethree = patients[0]['toggleThree'];
          togglefourth = patients[0]['toggleFourth'];
          togglefivth = patients[0]['toggleFivth'];
          togglesixth = patients[0]['togglesixth'];
          toggleseven = patients[0]['toggleSeventh'];
          toogleeight = patients[0]['toggleEighth'];
        }
        int trueCount = 0;
        if (toggleone == true) trueCount++;
        if (toggletwo == true) trueCount++;
        if (togglethree == true) trueCount++;
        if (togglefourth == true) trueCount++;
        if (togglefivth == true) trueCount++;
        if (togglesixth == true) trueCount++;
        if (toggleseven == true) trueCount++;
        if (toogleeight == true) trueCount++;
        progress = trueCount * 0.125;
        if (progress >= 1) progress = 1;
        print("Patients:   $patients");
      });

      // Print values of all attributes

      print('Patient: ${patients[0]['name']}');
      print('Age: ${patients[0]['age']}');
      print('Contact: ${patients[0]['phone']}');
      print('Email: ${patients[0]['email']}');
      print('Toggle One: ${patients[0]['toggleOne']}');
      print('Toggle Two: ${patients[0]['toggleTwo']}');
      print('Toggle Three: ${patients[0]['toggleThree']}');
      print('Toggle Fourth: ${patients[0]['toggleFourth']}');
      print('Toggle Five: ${patients[0]['toggleFivth']}');
      print('Toggle sixth: ${patients[0]['togglesixth']}');
      print('Toggle seven: ${patients[0]['toggleSeventh']}');
      print('Toggle eight: ${patients[0]['toggleEighth']}');
      print('------lkfga');
    } catch (error) {
      print('Error fetching user data: $error');
    }
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      // bottomNavigationBar: BottomNavBar(),
      body: Stack(
        children: <Widget>[
          Container(
            width: size.width,
            height: size.height,
            decoration: const BoxDecoration(
              color: kBackgroundColor,
              image: DecorationImage(
                image: AssetImage("assets/images/meditation_bg.png"),
                fit: BoxFit.fitWidth,
              ),
            ),
          ),
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    SizedBox(
                      height: size.height * 0.05,
                    ),
                    const Text(
                      "Meditation",
                      style: TextStyle(
                          fontSize: 20,
                          color: Colors.white,
                          fontWeight: FontWeight.w600),
                    ),
                    const SizedBox(height: 10),
                    const Text(
                      "3-10 MIN Course",
                      style: TextStyle(
                          fontSize: 12,
                          color: Colors.white,
                          fontWeight: FontWeight.w600),
                    ),
                    const SizedBox(height: 10),
                    SizedBox(
                      width: size.width * .6, // it just take 60% of total width
                      child: const Text(
                        "Live happier and healthier by learning the fundamentals of meditation and mindfulness",
                        style: TextStyle(
                            fontSize: 10,
                            color: Colors.white,
                            fontWeight: FontWeight.w600),
                      ),
                    ),
                    const SizedBox(height: 20),
                    // SizedBox(
                    //   width: size.width * .5, // it just take the 50% width
                    //   child: const SearchBar(),
                    // ),
                    Row(
                      children: [
                        CircularPercentIndicator(
                          radius: 50,
                          lineWidth: 20,
                          percent: progress,
                          progressColor: Colors.deepPurple,
                          circularStrokeCap: CircularStrokeCap.round,
                          backgroundColor: Colors.deepPurple.shade100,
                          center: Text(
                            (progress * 100).toStringAsFixed(2),
                            style: TextStyle(color: Colors.white),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),

                    Wrap(
                      spacing: 20,
                      runSpacing: 20,
                      children: <Widget>[
                        SeassionCard(
                          isDone: toggleone,
                          text: "Puzzle  ",
                          seassionNum: 1,
                          // isDone: true,
                          press: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => Board()), //MainScreen
                            );
                          },
                        ), //MainScreen
                        SeassionCard(
                          isDone: toggletwo,
                          text: "Word Formation ",
                          seassionNum: 2,
                          press: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => const GameScreen()),
                            );
                          },
                        ),
                        SeassionCard(
                          isDone: togglethree,
                          text: "Matching Game ",
                          seassionNum: 3,
                          press: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => const MatchingGame()),
                            );
                          },
                        ),
                        SeassionCard(
                          isDone: togglefourth,
                          text: "Rock Scissors ",
                          seassionNum: 4,
                          press: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => const MainScreenRock()),
                            );
                          },
                        ),
                        SeassionCard(
                          isDone: togglefivth,
                          text: "Math Memory",
                          seassionNum: 5,
                          press: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => const HomePage()),
                            );
                          },
                        ),
                        SeassionCard(
                          isDone: togglesixth,
                          text: "Color Matching ",
                          seassionNum: 6,
                          press: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => MyHomePage()),
                            );
                          },
                        ),
                        SeassionCard(
                          isDone: toggleseven,
                          text: "Memory ",
                          seassionNum: 7,
                          press: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => StartUpPage()),
                            );
                          },
                        ),
                        SeassionCard(
                          isDone: toogleeight,
                          text: "Color Matching ",
                          seassionNum: 8,
                          press: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => MyHomePage()),
                            );
                          },
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),
                    const Text(
                      "Meditation",
                      style: TextStyle(color: Colors.white),
                    ),
                    Container(
                      margin: const EdgeInsets.symmetric(vertical: 20),
                      padding: const EdgeInsets.all(10),
                      height: 90,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(13),
                      ),
                      child: const Row(
                        children: <Widget>[
                          SizedBox(width: 20),
                          Expanded(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Text(
                                  "Basic 2",
                                  // style: Theme.of(context).textTheme.subtitle,
                                ),
                                Text("Start your deepen you practice")
                              ],
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.all(10),
                            // child: SvgPicture.asset("assets/icons/Lock.svg"),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 20),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class SeassionCard extends StatelessWidget {
  final int seassionNum;
  final bool isDone;
  final String text;
  final Function() press;
  SeassionCard({
    Key? key,
    required this.seassionNum,
    this.isDone = false,
    this.text = '',
    required this.press,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, constraint) {
      Size size = MediaQuery.of(context).size;

      return ClipRRect(
        borderRadius: BorderRadius.circular(13),
        child: Container(
          width: size.width * 0.4,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(13),
            boxShadow: const [
              BoxShadow(
                offset: Offset(0, 17),
                blurRadius: 23,
                spreadRadius: -13,
                color: kShadowColor,
              ),
            ],
          ),
          child: Material(
            color: Colors.transparent,
            child: InkWell(
              onTap: press,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Row(
                  children: <Widget>[
                    Container(
                      height: 32,
                      width: 25,
                      decoration: BoxDecoration(
                        color: isDone ? kBlueColor : Colors.white,
                        shape: BoxShape.circle,
                        border: Border.all(color: kBlueColor),
                      ),
                      child: Icon(
                        size: 17,
                        Icons.play_arrow,
                        color: isDone ? Colors.white : kBlueColor,
                      ),
                    ),
                    const SizedBox(width: 10),
                    Text(
                      softWrap: true,
                      textAlign: TextAlign.start,
                      text,
                      style: const TextStyle(color: Colors.black, fontSize: 13),
                    )
                  ],
                ),
              ),
            ),
          ),
        ),
      );
    });
  }
}
