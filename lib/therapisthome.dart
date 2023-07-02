import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:docapp/constants.dart';
import 'package:docapp/patients.dart';
import 'package:docapp/therapistprofile.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';

class TherapistAppHomePage extends StatefulWidget {
  TherapistAppHomePage({super.key});

  @override
  State<TherapistAppHomePage> createState() => _TherapistAppHomePageState();
}

class _TherapistAppHomePageState extends State<TherapistAppHomePage> {
  String _profileImageUrl = '';
  String nameofTherapist = 'John';
  Future<String?> fetchTherapistName(String therapistId) async {
    try {
      final snapshot = await FirebaseFirestore.instance
          .collection('therapists')
          .doc(therapistId)
          .get();
      if (snapshot.exists) {
        final data = snapshot.data() as Map<String, dynamic>;
        final therapistName = data['name'] as String?;
        return therapistName;
      }
    } catch (e) {
      print('Error fetching therapist name: $e');
    }
    return null;
  }

  Future<void> _fetchTherapistName() async {
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      String therapistId = user.uid;
      String? therapistName = await fetchTherapistName(therapistId);
      if (therapistName != null) {
        setState(() {
          nameofTherapist = therapistName;
        });
      }
    }
  }

  Future<void> _loadProfileImage() async {
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      String userId = user.uid;
      Reference storageRef = FirebaseStorage.instance
          .ref()
          .child('therapists')
          .child('profile_images')
          .child(userId);

      try {
        String downloadURL = await storageRef.getDownloadURL();
        setState(() {
          _profileImageUrl = downloadURL;
        });
      } catch (error) {
        // Handle the error by setting a default profile picture or displaying an error message
        setState(() {
          _profileImageUrl = 'assets/images/user.png';
        });
        print('Error loading profile image: $error');
      }
    }
  }

  // Future<void> _fetchAndSetProfileImage() async {
  //   User? user = FirebaseAuth.instance.currentUser;
  //   if (user != null) {
  //     String imagePath =
  //         'therapists/profile_images/${user.uid}.jpg'; // Update with the correct image path
  //     String? imageUrl = await fetchImageURL(imagePath);
  //     if (imageUrl != null) {
  //       setState(() {
  //         _profileImageUrl = imageUrl;
  //       });
  //     }
  //   }
  // }
  GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  @override
  void initState() {
    super.initState();
    _loadProfileImage();
    _fetchTherapistName();
    // _fetchAndSetProfileImage();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: Colors.white24,
      drawer: DrawerTherapist(),
      appBar: AppBar(
        // title: const Text(
        //   'Therapist App',
        //   style: TextStyle(color: Colors.white),
        // ),
        backgroundColor: Colors.white24,
        leading: IconButton(
          icon: Icon(Icons.menu),
          onPressed: () {
            _scaffoldKey.currentState?.openDrawer(); // Open the drawer
          },
        ),

        elevation: 1.5,
        actions: [
          GestureDetector(
            onTap: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => TherapistProfileScreen()));
            },
            child: CircleAvatar(
              radius: 40,
              backgroundImage: _profileImageUrl.isNotEmpty
                  ? NetworkImage(_profileImageUrl)
                  : Image.asset('assets/images/user.png').image,
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Container(
          height: size.height,
          width: size.width,
          color: Colors.white24,
          child: Padding(
            padding:
                const EdgeInsets.symmetric(horizontal: 20.0, vertical: 30.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Welcome, $nameofTherapist!',
                  style: TextStyle(
                    fontSize: 20,
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 20.0),
                const Text(
                  'How are you today?',
                  style: TextStyle(
                    fontSize: 25,
                    color: Colors.white,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 20.0),
                GestureDetector(
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => TherapistPatients()));
                  },
                  child: Container(
                    width: size.width,
                    height: size.height * 0.1,
                    child: Center(
                      child: Text(
                        "Patient List",
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w500,
                          color: Colors.black, // Set the text color to black
                        ),
                      ),
                    ),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ),
                const SizedBox(height: 40.0),
                const Text(
                  'Exercise Demo',
                  style: TextStyle(
                    fontSize: 20,
                    color: Colors.white,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 10.0),
                SizedBox(
                  height: size.height * 0.2,
                  child: ListView(
                    scrollDirection: Axis.horizontal,
                    children: [
                      Container(
                        width: size.width * 0.4,
                        child: Padding(
                          padding: const EdgeInsets.only(
                              left: 20, right: 20, bottom: 20, top: 5),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Image.asset("assets/images/exercisedemo3.png"),
                              Text(
                                "Video 1",
                                style: TextStyle(
                                    color: Colors.blueAccent, fontSize: 15),
                              )
                            ],
                          ),
                        ),
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20),
                            color: Colors.white),
                      ),
                      SizedBox(
                        width: size.width * 0.08,
                      ),
                      Container(
                        width: size.width * 0.4,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20),
                            color: Colors.white),
                        child: Padding(
                          padding: const EdgeInsets.only(
                              left: 20, right: 20, bottom: 22, top: 0),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Image.asset("assets/images/exercisedemo2.png"),
                              const Text(
                                "Video 1",
                                style: TextStyle(
                                    color: Colors.blueAccent, fontSize: 15),
                              )
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  height: size.height * 0.021,
                ),
                Container(
                  decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(10)),
                  height: size.height * 0.09,
                  width: size.width,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      children: [
                        Icon(
                          Icons.check_circle,
                          size: 40,
                        ),
                        SizedBox(
                          width: size.width * 0.051,
                        ),
                        Column(
                          children: [
                            Text(
                              "Matching Game",
                              style: TextStyle(
                                  fontSize: 15,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.black),
                            ),
                            SizedBox(
                              height: size.height * 0.021,
                            ),
                            SizedBox(
                              width: size.width * 0.6,
                              child: LinearProgressIndicator(
                                minHeight: 20,
                                value:
                                    0.5, // Set the progress value (between 0.0 and 1.0)
                                valueColor: AlwaysStoppedAnimation<Color>(
                                    Colors.blue), // Set the filled color
                                backgroundColor: Colors
                                    .grey, // Set the background color of the progress bar
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(
                  height: size.height * 0.021,
                ),
                Container(
                  decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(10)),
                  height: size.height * 0.09,
                  width: size.width,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      children: [
                        Icon(
                          Icons.check_circle,
                          size: 40,
                        ),
                        SizedBox(
                          width: size.width * 0.051,
                        ),
                        Column(
                          children: [
                            Text(
                              "Matching Game",
                              style: TextStyle(
                                  fontSize: 15,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.black),
                            ),
                            SizedBox(
                              height: size.height * 0.021,
                            ),
                            SizedBox(
                              width: size.width * 0.6,
                              child: LinearProgressIndicator(
                                minHeight: 20,
                                value:
                                    0.5, // Set the progress value (between 0.0 and 1.0)
                                valueColor: AlwaysStoppedAnimation<Color>(
                                    Colors.blue), // Set the filled color
                                backgroundColor: Colors
                                    .grey, // Set the background color of the progress bar
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),

                // ListTile(
                //   tileColor: Colors.white, // Set the background color to white
                // leading: LinearProgressIndicator(
                //   value: 0.5, // Set the progress value (between 0.0 and 1.0)
                //   valueColor: AlwaysStoppedAnimation<Color>(
                //       Colors.blue), // Set the filled color
                //   backgroundColor: Colors
                //       .grey, // Set the background color of the progress bar
                // ),
                //   title: Text(
                //     "Patient List",
                //     style: TextStyle(
                //       color: Colors.black, // Set the text color to black
                //     ),
                //   ),
                // ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class DrawerTherapist extends StatefulWidget {
  const DrawerTherapist({super.key});

  @override
  _DrawerTherapistState createState() => _DrawerTherapistState();
}

class _DrawerTherapistState extends State<DrawerTherapist> {
  String? _profileImageUrl;
  String? nameofTherapist;

  Future<void> fetchUserName() async {
    final userId = FirebaseAuth.instance.currentUser!.uid;
    final userDoc = await FirebaseFirestore.instance
        .collection('therapists')
        .doc(userId)
        .get();
    if (userDoc.exists) {
      setState(() {
        nameofTherapist = userDoc['name'];
      });
    }
  }

  Future<void> _loadProfileImage() async {
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      String userId = user.uid;
      Reference storageRef = FirebaseStorage.instance
          .ref()
          .child('therapists')
          .child('profile_images')
          .child(userId);

      try {
        String downloadURL = await storageRef.getDownloadURL();
        setState(() {
          _profileImageUrl = downloadURL;
        });
      } catch (error) {
        // Handle the error by setting a default profile picture
        setState(() {
          _profileImageUrl = 'assets/images/therapist.png';
        });
        print('Error loading profile image: $error');
      }
    }
  }

  @override
  void initState() {
    super.initState();
    fetchUserName();
    _loadProfileImage();
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          DrawerHeader(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.only(topRight: Radius.circular(20)),
              color: kBackgroundColor,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CircleAvatar(
                  radius: 40,
                  backgroundImage: _profileImageUrl!.isNotEmpty
                      ? NetworkImage(_profileImageUrl!)
                      : Image.asset('assets/images/therapist.png').image,
                ),
                SizedBox(height: 10),
                Text(
                  '$nameofTherapist',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 24,
                  ),
                ),
              ],
            ),
          ),
          ListTile(
            title: Text('Notification'),
            onTap: () {
              // Handle notification tap
            },
          ),
          ListTile(
            title: Text('Edit Profile'),
            onTap: () {
              // Handle edit profile tap
            },
          ),
          // Add more items as needed
        ],
      ),
    );
  }
}
