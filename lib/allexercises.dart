import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:docapp/games/game.dart';
import 'package:docapp/games/colormatch/colormatching.dart';
import 'package:docapp/games/mathactivity/home_page.dart';
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
  bool toggleone = true;
  bool toggletwo = true;
  bool togglethree = true;
  bool togglefourth = true;
  bool togglefivth = true;
  bool togglesixth = true;
  List<List<bool>> toggleValues = [];

  @override
  void initState() {
    super.initState();
    _fetchUserData();
  }

  Future<void> _fetchUserData() async {
    try {
      final user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        DocumentSnapshot snapshot = await FirebaseFirestore.instance
            .collection('users')
            .doc(user.uid)
            .get();

        if (snapshot.exists) {
          Map<String, dynamic> userData =
              snapshot.data() as Map<String, dynamic>;
          setState(() {
            toggleone = userData['toggleOne'];
            toggletwo = userData['toggleTwo'];
            togglethree = userData['toggleThree'];
            togglefourth = userData['toggleFourth'];
            togglefivth = userData['toggleFivth'];
            togglesixth = userData['togglesixth'];

            int trueCount = 0;
            if (toggleone == true) trueCount++;
            if (toggletwo == true) trueCount++;
            if (togglethree == true) trueCount++;
            if (togglefourth == true) trueCount++;
            if (togglefivth == true) trueCount++;
            if (togglesixth == true) trueCount++;
            progress = trueCount * 0.167;
            if (progress >= 1) progress = 1;
          });
          print('User: ${user.uid}');
          print('Name: ${userData['name']}');
          print('Age: ${userData['age']}');
          print('Contact: ${userData['phone']}');
          print('Email: ${userData['email']}');
          print('Toggle One: ${userData['toggleOne']}');
          print('Toggle Two: ${userData['toggleTwo']}');
          print('Toggle Three: ${userData['toggleThree']}');
          print('Toggle Fourth: ${userData['toggleFourth']}');
          print('Toggle Fivth: ${userData['toggleFivth']}');
          print('Toggle sixth: ${userData['togglesixth']}');
          print('Token : ${userData['token']}');

          print(progress);
        } else {
          print('User data not found.');
        }
      } else {
        print('User not logged in.');
      }
    } catch (e) {
      print('Error fetching user data: $e');
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
                          text: "Visual Memory ",
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
                          seassionNum: 4,
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
                          seassionNum: 4,
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
