import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';

// Colors
const kBackgroundColor = Color(0xff191720);
const kTextFieldFill = Color(0xff1E1C24);

const kBackgroundColortwo = Color(0xFFF8F8F8);
const kActiveIconColor = Color(0xFFE68342);
const kTextColor = Color(0xFF222B45);
const kBlueLightColor = Color(0xFFC7B8F5);
const kBlueColor = Color(0xFF817DC0);
const kShadowColor = Color(0xFFE6E6E6);
// TextStyles
const kHeadline = TextStyle(
  color: Colors.white,
  fontSize: 34,
  fontWeight: FontWeight.bold,
);

const kBodyText = TextStyle(
  color: Colors.grey,
  fontSize: 15,
);

const kButtonText = TextStyle(
  color: Colors.black87,
  fontSize: 16,
  fontWeight: FontWeight.bold,
);

const kBodyText2 =
    TextStyle(fontSize: 28, fontWeight: FontWeight.w500, color: Colors.white);

class MyTextField extends StatelessWidget {
  const MyTextField({
    Key? key,
    required this.hintText,
    required this.inputType,
  }) : super(key: key);
  final String hintText;
  final TextInputType inputType;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: TextField(
        style: kBodyText.copyWith(color: Colors.white),
        keyboardType: inputType,
        textInputAction: TextInputAction.next,
        decoration: InputDecoration(
          contentPadding: EdgeInsets.all(20),
          hintText: hintText,
          hintStyle: kBodyText,
          enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(
              color: Colors.grey,
              width: 1,
            ),
            borderRadius: BorderRadius.circular(18),
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(
              color: Colors.grey,
              width: 1,
            ),
            borderRadius: BorderRadius.circular(18),
          ),
        ),
      ),
    );
  }
}

class MyPasswordField extends StatelessWidget {
  const MyPasswordField({
    Key? key,
    required this.isPasswordVisible,
    required this.onTap,
  }) : super(key: key);

  final bool isPasswordVisible;
  final void Function() onTap;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: TextField(
        style: kBodyText.copyWith(
          color: Colors.white,
        ),
        obscureText: isPasswordVisible,
        keyboardType: TextInputType.text,
        textInputAction: TextInputAction.done,
        decoration: InputDecoration(
          suffixIcon: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: IconButton(
              splashColor: Colors.transparent,
              highlightColor: Colors.transparent,
              onPressed: onTap,
              icon: Icon(
                isPasswordVisible ? Icons.visibility : Icons.visibility_off,
                color: Colors.grey,
              ),
            ),
          ),
          contentPadding: EdgeInsets.all(20),
          hintText: 'Password',
          hintStyle: kBodyText,
          enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(
              color: Colors.grey,
              width: 1,
            ),
            borderRadius: BorderRadius.circular(18),
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(
              color: Colors.grey,
              width: 1,
            ),
            borderRadius: BorderRadius.circular(18),
          ),
        ),
      ),
    );
  }
}

class DrawerWidget extends StatefulWidget {
  const DrawerWidget({super.key});

  @override
  _DrawerWidgetState createState() => _DrawerWidgetState();
}

class _DrawerWidgetState extends State<DrawerWidget> {
  String? _profileImageUrl;
  String? nameofTherapist;

  Future<void> fetchUserName() async {
    final userId = FirebaseAuth.instance.currentUser!.uid;
    final userDoc =
        await FirebaseFirestore.instance.collection('users').doc(userId).get();
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
                      : Image.asset('assets/images/user.png').image,
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


// class BottomNavBar extends StatefulWidget {
//   const BottomNavBar({
//     Key? key,
//   }) : super(key: key);

//   @override
//   State<BottomNavBar> createState() => _BottomNavBarState();
// }

// class _BottomNavBarState extends State<BottomNavBar> {
//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       padding: EdgeInsets.symmetric(horizontal: 40, vertical: 10),
//       height: 80,
//       color: Colors.white,
//       child: Row(
//         mainAxisAlignment: MainAxisAlignment.spaceBetween,
//         children: <Widget>[
//           BottomNavItem(
//             press: () {
              
//             },
//             title: "Today",
//             svgScr: Icons.today,
//           ),
//           BottomNavItem(
//             press: () {
//               setState(() {
//                 // isActive = true;
//               });
//             },
//             title: "All Exercises",
//             svgScr: Icons.work_history,
//             isActive: true,
//           ),
//           BottomNavItem(
//             press: () {},
//             title: "Settings",
//             svgScr: Icons.settings,
//           ),
//         ],
//       ),
//     );
//   }
// }

// class BottomNavItem extends StatelessWidget {
//   final IconData svgScr;
//   final String title;
//   final Function() press;
//   final bool isActive;
//   const BottomNavItem({
//     Key? key,
//     required this.svgScr,
//     this.title = "",
//     required this.press,
//     this.isActive = false,
//   }) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     return GestureDetector(
//       onTap: press,
//       child: Column(
//         mainAxisAlignment: MainAxisAlignment.spaceAround,
//         children: <Widget>[
//           Icon(
//             svgScr,
//             color: isActive ? kActiveIconColor : kTextColor,
//           ),
//           Text(
//             title,
//             style: TextStyle(color: isActive ? kActiveIconColor : kTextColor),
//           ),
//         ],
//       ),
//     );
//   }
// }
