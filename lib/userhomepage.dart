import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:docapp/userpinprofile.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'loginsignup/constants.dart';

class UserHomePage extends StatefulWidget {
  const UserHomePage({Key? key}) : super(key: key);

  @override
  State<UserHomePage> createState() => _UserHomePageState();
}

class _UserHomePageState extends State<UserHomePage> {
  GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  void _showPinDialog(BuildContext context) async {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        String enteredPin = '';

        return Dialog(
          backgroundColor: kBackgroundColor,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20.0),
          ),
          child: Container(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text('Enter 4-digit PIN to open drawer',
                    style: TextStyle(fontSize: 16.0, color: Colors.white)),
                const SizedBox(height: 20.0),
                TextField(
                  onChanged: (value) {
                    enteredPin = value;
                  },
                  keyboardType: TextInputType.number,
                  obscureText: true,
                  maxLength: 4,
                  cursorColor: Colors.white,
                  style: TextStyle(
                      color: Colors.white), // Set the input text color to white
                  decoration: InputDecoration(
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10.0),
                      borderSide: BorderSide(color: Colors.white),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10.0),
                      borderSide: BorderSide(color: Colors.white),
                    ),
                    labelText: 'PIN',
                    labelStyle: TextStyle(color: Colors.white),
                  ),
                ),
                const SizedBox(height: 20.0),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    TextButton(
                      child: const Text('Cancel'),
                      onPressed: () {
                        Navigator.pop(context);
                      },
                    ),
                    ElevatedButton(
                      child: const Text('OK'),
                      onPressed: () async {
                        if (enteredPin.length == 4) {
                          bool isPinVerified = false;

                          try {
                            // Get the current user from FirebaseAuth
                            User? currentUser =
                                FirebaseAuth.instance.currentUser;

                            if (currentUser != null) {
                              // Retrieve the user ID
                              String currentUserId = currentUser.uid;

                              // Create a reference to the Firestore collection 'users' and the current user's document
                              CollectionReference usersCollection =
                                  FirebaseFirestore.instance
                                      .collection('users');
                              DocumentReference userDocument =
                                  usersCollection.doc(currentUserId);

                              // Retrieve the user's document from Firestore
                              DocumentSnapshot userSnapshot =
                                  await userDocument.get();
                              Map<String, dynamic>? userData =
                                  userSnapshot.data() as Map<String, dynamic>?;

                              if (userData != null &&
                                  userData.containsKey('pin')) {
                                String storedPin = userData['pin'];

                                if (storedPin == enteredPin) {
                                  isPinVerified = true;
                                } else {
                                  showDialog(
                                    context: context,
                                    builder: (BuildContext context) {
                                      return AlertDialog(
                                        title: const Text('Incorrect PIN'),
                                        content:
                                            const Text('Please try again.'),
                                        actions: [
                                          TextButton(
                                            child: const Text('OK'),
                                            onPressed: () {
                                              Navigator.pop(context);
                                            },
                                          ),
                                        ],
                                      );
                                    },
                                  );
                                }
                              } else {
                                // PIN is not set for the user, prompt for setting PIN
                                Navigator.pop(context); // Close the PIN dialog
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => PinProfileScreen()),
                                );
                              }
                            } else {
                              print('No authenticated user found');
                            }
                          } catch (e) {
                            print('Error verifying PIN from Firestore: $e');
                          }

                          if (isPinVerified) {
                            _scaffoldKey.currentState?.openDrawer();
                            Navigator.pop(context);
                          }
                        }
                      },
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: Colors.white,
      drawer: DrawerWidget(),
      body: Stack(
        children: <Widget>[
          Container(
            height: size.height * .45,
            decoration: const BoxDecoration(
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(150),
              ),
              color: kTextFieldFill,
            ),
          ),
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Align(
                    alignment: Alignment.topRight,
                    child: GestureDetector(
                      onTap: () {
                        _showPinDialog(context);
                        // _scaffoldKey.currentState?.openDrawer();
                      },
                      child: Container(
                        alignment: Alignment.center,
                        height: 52,
                        width: 52,
                        decoration: const BoxDecoration(
                          color: Colors.black,
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(
                          Icons.menu,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                  const Padding(
                    padding: EdgeInsets.only(left: 30),
                    child: Text(
                      "Good Morning \nShishir",
                      style: TextStyle(color: Colors.white, fontSize: 20),
                    ),
                  ),
                  SizedBox(
                    height: size.height * 0.03,
                  ),
                  const SearchBar(),
                  SizedBox(
                    height: size.height * 0.05,
                  ),
                  const Text(
                    "Categorys",
                    style: TextStyle(
                        fontSize: 20,
                        color: Colors.white,
                        fontWeight: FontWeight.w600),
                  ),
                  SizedBox(
                    height: size.height * 0.03,
                  ),
                  Container(
                    decoration:
                        BoxDecoration(borderRadius: BorderRadius.circular(10)),
                    height: 300.0,
                    child: ListView(
                      scrollDirection: Axis.horizontal,
                      children: [
                        _buildTherapistCard(
                          name: 'Dr. Emma Thompson',
                          specialization: 'Depression, Anxiety',
                          imageUrl: 'assets/images/therapist1.jpg',
                        ),
                        _buildTherapistCard(
                          name: 'Dr. Mark Johnson',
                          specialization: 'Relationships, Stress',
                          imageUrl: 'assets/images/therapist2.jpg',
                        ),
                        _buildTherapistCard(
                          name: 'Dr. Sarah Collins',
                          specialization: 'Trauma, Grief',
                          imageUrl: 'assets/images/therapist3.jpg',
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }

  Widget _buildTherapistCard(
      {required String name,
      required String specialization,
      required String imageUrl}) {
    return Container(
      decoration: BoxDecoration(borderRadius: BorderRadius.circular(10)),
      width: 200.0,
      child: Card(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircleAvatar(
              radius: 60.0,
              backgroundImage: AssetImage(imageUrl),
            ),
            const SizedBox(height: 10.0),
            Text(
              name,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 5.0),
            Text(
              specialization,
              style: const TextStyle(
                fontSize: 14,
                color: Colors.grey,
              ),
            ),
            const SizedBox(height: 10.0),
            ElevatedButton(
              onPressed: () {
                // Handle therapist card press
              },
              // color: Colors.blue,
              child: const Text(
                'View Profile',
                style: TextStyle(
                  color: Colors.white,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class CategoryCard extends StatelessWidget {
  final String imageSrc;
  final String title;
  final void Function() press;
  const CategoryCard({
    Key? key,
    required this.imageSrc,
    required this.title,
    required this.press,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 5,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(13)),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(13),
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(13),
            boxShadow: [
              const BoxShadow(
                offset: Offset(0, 17),
                blurRadius: 17,
                spreadRadius: -23,
                color: Colors.black12,
              ),
            ],
          ),
          child: Material(
            color: Colors.transparent,
            child: InkWell(
              onTap: press,
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  children: <Widget>[
                    const Spacer(),
                    Container(
                      height: 80,
                      child: Image.asset(
                        imageSrc,
                        width: 64,
                        height: 64,
                      ),
                    ),
                    const Spacer(),
                    Text(
                      title,
                      textAlign: TextAlign.center,
                      style: const TextStyle(color: kTextFieldFill),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
