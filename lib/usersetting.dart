import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:docapp/loginsignup/userlogin.dart';
import 'package:docapp/userpinprofile.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'loginsignup/constants.dart';

class UserSetting extends StatefulWidget {
  const UserSetting({super.key});

  @override
  State<UserSetting> createState() => _UserSettingState();
}

class _UserSettingState extends State<UserSetting> {
  String? userName;
  String _profileImageUrl = '';

  @override
  void initState() {
    super.initState();
    _loadProfileImage();
    fetchUserName();
  }

  Future<void> _loadProfileImage() async {
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      String userId = user.uid;
      Reference storageRef = FirebaseStorage.instance
          .ref()
          .child('users')
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
          _profileImageUrl = 'assets/images/user.png';
        });
        print('Error loading profile image: $error');
      }
    }
  }

  Future<void> fetchUserName() async {
    final userId = FirebaseAuth.instance.currentUser!.uid;
    final userDoc =
        await FirebaseFirestore.instance.collection('users').doc(userId).get();
    if (userDoc.exists) {
      setState(() {
        userName = userDoc['name'];
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView(
        padding: EdgeInsets.zero,
        children: [
          Container(
            decoration: BoxDecoration(
              color: kBackgroundColor, //Theme.of(context).primaryColor,
              borderRadius: const BorderRadius.only(
                bottomRight: Radius.circular(50),
              ),
            ),
            child: Column(
              children: [
                const SizedBox(height: 50),
                ListTile(
                  contentPadding: const EdgeInsets.symmetric(horizontal: 30),
                  title: Text(
                    'Hello ${userName ?? ""}!',
                    style: Theme.of(context)
                        .textTheme
                        .headlineSmall
                        ?.copyWith(color: Colors.white),
                  ),
                  subtitle: Text(
                    'Good Morning',
                    style: Theme.of(context)
                        .textTheme
                        .titleMedium
                        ?.copyWith(color: Colors.white54),
                  ),
                  trailing: CircleAvatar(
                    radius: 40,
                    backgroundImage: _profileImageUrl.isNotEmpty
                        ? NetworkImage(_profileImageUrl)
                        : Image.asset('assets/images/user.png').image,
                  ),
                ),
                const SizedBox(height: 30)
              ],
            ),
          ),
          Container(
            color: kBackgroundColor, //Theme.of(context).primaryColor,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 30),
              decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius:
                      BorderRadius.only(topLeft: Radius.circular(200))),
              child: GridView.count(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                crossAxisCount: 2,
                crossAxisSpacing: 40,
                mainAxisSpacing: 30,
                children: [
                  itemDashboard('Set Pin of profile ', CupertinoIcons.pin_slash,
                      Colors.deepOrange, () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => PinProfileScreen()),
                    );
                  }),
                  itemDashboard(
                      'LogOut', CupertinoIcons.graph_circle, Colors.green, () {
                    FirebaseAuth.instance.signOut().then((value) {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => UserSignIn()),
                      );
                    }).catchError((error) {
                      // Handle error while signing out
                      print('Error signing out: $error');
                    });
                  }),
                  itemDashboard('Audience', CupertinoIcons.person_2,
                      Colors.purple, () {}),
                  itemDashboard('Comments', CupertinoIcons.chat_bubble_2,
                      Colors.brown, () {}),
                ],
              ),
            ),
          ),
          const SizedBox(height: 20)
        ],
      ),
    );
  }

  itemDashboard(String title, IconData iconData, Color background, ontap) =>
      GestureDetector(
        onTap: ontap,
        child: Container(
          decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(10),
              boxShadow: [
                BoxShadow(
                    offset: const Offset(0, 5),
                    color: Theme.of(context).primaryColor.withOpacity(.2),
                    spreadRadius: 2,
                    blurRadius: 5)
              ]),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: background,
                    shape: BoxShape.circle,
                  ),
                  child: Icon(iconData, color: Colors.white)),
              const SizedBox(height: 8),
              Text(title.toUpperCase(),
                  style: Theme.of(context).textTheme.titleMedium)
            ],
          ),
        ),
      );
}
