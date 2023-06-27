import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:docapp/constants.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class TherapistForUser extends StatefulWidget {
  TherapistForUser({Key? key, required this.therapistData}) : super(key: key);

  final Map<String, dynamic> therapistData;

  @override
  State<TherapistForUser> createState() => _TherapistForUserState();
}

class _TherapistForUserState extends State<TherapistForUser> {
  List<Map<String, dynamic>> patientList = [];

  Future<void> addAssignedUserToTherapist(
      String therapistId, String userId) async {
    CollectionReference therapistsCollection =
        FirebaseFirestore.instance.collection('therapists');

    DocumentReference therapistDocRef = therapistsCollection.doc(therapistId);

    CollectionReference assignedUsersCollection =
        therapistDocRef.collection('assignedusers');

    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      DocumentSnapshot userSnapshot = await FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .get();

      if (userSnapshot.exists) {
        Map<String, dynamic> userData =
            userSnapshot.data() as Map<String, dynamic>;

        await assignedUsersCollection.doc(userId).set({
          'name': userData['name'],
          'age': userData['age'],
          'phone': userData['phone'],
          'email': userData['email'],
          'toggleOne': userData['toggleOne'],
          'toggleTwo': userData['toggleTwo'],
          'toggleThree': userData['toggleThree'],
          'toggleFourth': userData['toggleFourth'],
          'toggleFivth': userData['toggleFivth'],
          'togglesixth': userData['togglesixth'],
        });

        print("User added to assignedusers collection");
      } else {
        print('User data does not exist');
      }
    } else {
      print('User is not authenticated');
    }
  }

  String userid = '';
  Future<void> _fetchUserData() async {
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      userid = user.uid;
    }
    DocumentSnapshot snapshot = await FirebaseFirestore.instance
        .collection('users')
        .doc(user?.uid)
        .get();

    if (snapshot.exists) {
      Map<String, dynamic> userData = snapshot.data() as Map<String, dynamic>;

      // Access the user data fields
      String name = userData['name'];
      String age = userData['age'];
      String phone = userData['phone'];
      String email = userData['email'];
      // ... access other fields as needed

      print('Name: $name');
      print('Age: $age');
      print('Phone: $phone');
      print('Email: $email');
      // ... print or use other fields as needed
    } else {
      print('User data does not exist');
    }
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    String profileImageUrl =
        widget.therapistData['profileImage'] ?? 'assets/images/user.png';
    String name = widget.therapistData['name'] ?? '';
    String specialization = widget.therapistData['specialization'] ?? "Anxiety";
    String phone = widget.therapistData['phone'] ?? '00000785650';
    String email = widget.therapistData['email'];
    return Scaffold(
      backgroundColor: kTextColor,
      appBar: AppBar(
        backgroundColor: kTextColor,
        title: const Text('Therapist Profile'),
      ),
      body: Align(
        alignment: Alignment(0, 0),
        child: Card(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30.0),
          ),
          child: Container(
            height: size.height * 0.7,
            width: size.width * .8,
            decoration: BoxDecoration(
              color: kBackgroundColor,
              borderRadius: BorderRadius.circular(30),
            ),
            child: Padding(
              padding: const EdgeInsets.all(25.0),
              child: Column(
                children: [
                  SizedBox(height: size.height * 0.03),
                  CircleAvatar(
                    radius: 70,
                    backgroundImage: profileImageUrl.isNotEmpty
                        ? NetworkImage(profileImageUrl)
                        : Image.asset('assets/images/user.png').image,
                  ),
                  SizedBox(height: size.height * 0.03),
                  Text(
                    name,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: size.height * 0.03),
                  Text(
                    specialization,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: size.height * 0.03),
                  Text(
                    phone,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: size.height * 0.03),
                  Text(
                    email,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: size.height * 0.05),
                  ElevatedButton(
                    onPressed: () {
                      _fetchUserData();
                      print("Confirm is pressed");
                      addAssignedUserToTherapist(
                          widget.therapistData['id'], userid);
                    },
                    child: const Text('Confirm Therapist'),
                    style: ElevatedButton.styleFrom(
                      primary: const Color.fromARGB(255, 243, 227,
                          79), // Set the background color to yellow
                      shape: RoundedRectangleBorder(
                        borderRadius:
                            BorderRadius.circular(10), // Set the border radius
                      ),
                      minimumSize: Size(size.width * 0.6,
                          size.height * 0.06), // Set the button size
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
