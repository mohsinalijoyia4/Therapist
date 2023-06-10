import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:docapp/constants.dart';
import 'package:docapp/loginsignup/textbutton.dart';
import 'package:docapp/usersetting.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class PinProfileScreen extends StatefulWidget {
  const PinProfileScreen({super.key});

  @override
  State<PinProfileScreen> createState() => _PinProfileScreenState();
}

class _PinProfileScreenState extends State<PinProfileScreen> {
  final TextEditingController _pinController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  bool isLoading = false;
  Future<void> initializeFirebase() async {
    await Firebase.initializeApp();
  }

  void savePinToFirestore(String pin) async {
    try {
      // Get the current user from FirebaseAuth
      User? currentUser = FirebaseAuth.instance.currentUser;

      if (currentUser != null) {
        // Retrieve the user ID
        String currentUserId = currentUser.uid;

        // Create a reference to the Firestore collection 'users' and the current user's document
        CollectionReference usersCollection =
            FirebaseFirestore.instance.collection('users');
        DocumentReference userDocument = usersCollection.doc(currentUserId);

        // Update the 'pin' field in the user's document with the input pin
        await userDocument.update({'pin': pin});

        print('Pin saved to Firestore');
        Navigator.pop(context);
      } else {
        print('No authenticated user found');
      }
    } catch (e) {
      print('Error saving pin to Firestore: $e');
    }
  }

  @override
  void initState() {
    super.initState();
    initializeFirebase();
  }

  @override
  void dispose() {
    _pinController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kBackgroundColor,
      appBar: AppBar(
        backgroundColor: kBackgroundColor,
        elevation: 0,
        leading: IconButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => UserSetting(),
              ),
            );
          },
          icon: const Icon(Icons.arrow_back_ios_sharp),
        ),
      ),
      body: SafeArea(
        //to make page scrollable
        child: CustomScrollView(
          reverse: true,
          slivers: [
            SliverFillRemaining(
              hasScrollBody: false,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Flexible(
                      fit: FlexFit.loose,
                      child: Form(
                        key: _formKey,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              "Welcome",
                              style: kHeadline,
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                            const Text(
                              "Set Your profile 4 Digit Pin Here!",
                              style: kBodyText2,
                            ),
                            const SizedBox(
                              height: 60,
                            ),
                            TextFormField(
                              controller: _pinController,

                              style: TextStyle(color: Colors.white),
                              cursorColor:
                                  Colors.white, // Set cursor color to white
                              inputFormatters: [
                                FilteringTextInputFormatter.digitsOnly
                              ],
                              decoration: InputDecoration(
                                labelText: 'Set Pin ',
                                labelStyle: TextStyle(color: Colors.white),
                                focusedBorder: OutlineInputBorder(
                                  borderSide: BorderSide(color: Colors.white),
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                enabledBorder: OutlineInputBorder(
                                  borderSide: BorderSide(color: Colors.white),
                                  borderRadius: BorderRadius.circular(10),
                                ),
                              ),
                              validator: (value) {
                                if (value!.isEmpty) {
                                  return 'Please enter a pin';
                                }
                                // Add any other validation rules as needed
                                return null; // Return null if the value is valid
                              },
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    MyTextButton(
                      buttonName: isLoading ? 'OK...' : 'OK',
                      onTap: () {
                        if (_formKey.currentState!.validate()) {
                          savePinToFirestore(_pinController.text);
                        }
                      },
                      bgColor: Colors.white,
                      textColor: Colors.black87,
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
