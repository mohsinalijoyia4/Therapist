import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';

class TherapistProfileScreen extends StatefulWidget {
  const TherapistProfileScreen({super.key});

  @override
  State<TherapistProfileScreen> createState() => _TherapistProfileScreenState();
}

class _TherapistProfileScreenState extends State<TherapistProfileScreen> {
  String _profileImageUrl = '';
  String _name = '';
  String _email = '';
  String _phone = '';
  Future<void> _fetchUserData() async {
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      String userId = user.uid;
      DocumentSnapshot snapshot = await FirebaseFirestore.instance
          .collection('therapists')
          .doc(userId)
          .get();

      if (snapshot.exists) {
        setState(() {
          _name = snapshot.get('name');
          _email = snapshot.get('email');
          _phone = snapshot.get('phone');
        });
      } else {
        print("No user exists");
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

  @override
  void initState() {
    super.initState();
    _fetchUserData();
    _loadProfileImage();
    // _fetchAndSetProfileImage();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white24,
        elevation: 0.5,
      ),
      backgroundColor: Colors.white24,
      body: SizedBox(
        height: size.height,
        width: size.width,
        child: Column(
          children: [
            SizedBox(
              height: size.height * 0.1,
            ),
            CircleAvatar(
              radius: 40,
              backgroundImage: _profileImageUrl.isNotEmpty
                  ? NetworkImage(_profileImageUrl)
                  : Image.asset('assets/images/user.png').image,
            ),
            SizedBox(
              height: size.height * 0.02,
            ),
            Text(
              "Profile",
              style: TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.w600),
            ),
            SizedBox(
              height: size.height * 0.02,
            ),
            Container(
              height: size.height * 0.3,
              width: size.width * 0.85,
              decoration: BoxDecoration(
                  border: Border.all(
                      color: Colors.blue, width: 1, style: BorderStyle.solid),
                  borderRadius: BorderRadius.circular(20),
                  color: Colors.white),
              child: Padding(
                padding: EdgeInsets.all(18.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text("Name"),
                        Text("Dr $_name"),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text("Email"),
                        Text("$_email"),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text("Contact"),
                        Text('$_phone'),
                      ],
                    ),
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
