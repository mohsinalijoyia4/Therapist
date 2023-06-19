import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:docapp/loginsignup/userlogin.dart';
import 'package:docapp/loginsignup/utilss/utils.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:image_picker/image_picker.dart';
import 'constants.dart';

class UserRegistration extends StatefulWidget {
  const UserRegistration({Key? key}) : super(key: key);

  @override
  State<UserRegistration> createState() => _UserRegistrationState();
}

class _UserRegistrationState extends State<UserRegistration> {
  FirebaseAuth _auth = FirebaseAuth.instance;
  FirebaseFirestore _firestore = FirebaseFirestore.instance;

  final _formKey = GlobalKey<FormState>();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final _nameController = TextEditingController();
  final _phoneController = TextEditingController();
  final _confirmPassController = TextEditingController();
  final _ageController = TextEditingController();
  File? _image;

  Future<void> _selectProfilePicture() async {
    final ImagePicker _picker = ImagePicker();
    final pickedFile = await _picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      setState(() {
        _image = File(pickedFile.path);
      });
    }
  }

  void _registerUser(BuildContext context) async {
    try {
      final UserCredential userCredential =
          await _auth.createUserWithEmailAndPassword(
        email: emailController.text.trim(),
        password: passwordController.text.trim(),
      );

      final userUid = userCredential.user!.uid;

      // Store additional user details in Firestore
      await _firestore
          .collection('users')
          .doc(userUid)
          .set({
            'email': emailController.text.trim(),
            'password': passwordController.text.trim(),
            'name': _nameController.text.trim(),
            'phone': _phoneController.text.trim(),
            'age': _ageController.text.trim(),
            'profileImage': '', // Placeholder for user profile image URL
          })
          .then((value) {})
          .onError((error, stackTrace) {
            Utils().toastMasseg(error.toString());
          });

      // Upload image to Firebase Storage
      if (_image != null) {
        final storageRef = FirebaseStorage.instance
            .ref()
            .child('users/profile_images/$userUid');
        final uploadTask = storageRef.putFile(_image!);
        await uploadTask.whenComplete(() => null);

        final imageUrl = await storageRef.getDownloadURL();

        // Store the image URL in the users collection
        await _firestore
            .collection('users')
            .doc(userUid)
            .update({'profileImage': imageUrl});
      }
    
      // Registration successful, navigate to the next screen
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => UserSignIn()),
      );
    } catch (e) {
      if (e is FirebaseAuthException && e.code == 'email-already-in-use') {
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: const Text('Error'),
              content: const Text('A user with this email already exists.'),
              actions: <Widget>[
                TextButton(
                  child: const Text('OK'),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
              ],
            );
          },
        );
      } else {
        // Registration failed, handle the error
        print('Error registering user: $e');
      }
    }
  }

  @override
  void initState() {
    super.initState();
    emailController.addListener(() {});
    passwordController.addListener(() {});
    _nameController.addListener(() {});
    _phoneController.addListener(() {});
    _confirmPassController.addListener(() {});
    _ageController.addListener(() {});
  }

  @override
  void dispose() {
    super.dispose();
    emailController.dispose();
    passwordController.dispose();
    _nameController.dispose();
    _phoneController.dispose();
    _confirmPassController.dispose();
    _ageController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: kBackgroundColor,
      appBar: AppBar(
        title: const Text('User Registration'),
      ),
      body: SingleChildScrollView(
        child: SizedBox(
          height: size.height,
          width: size.width,
          child: Padding(
            padding: const EdgeInsets.all(18.0),
            child: Stack(
              children: [
                Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      SizedBox(
                        height: size.height * 0.05,
                      ),
                      const Text(
                        "Register",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      GestureDetector(
                        onTap: () {
                          _selectProfilePicture();
                        },
                        child: CircleAvatar(
                          radius: 50,
                          backgroundImage:
                              _image != null ? FileImage(_image!) : null,
                          child:
                              _image == null ? const Icon(Icons.person) : null,
                        ),
                      ),
                      SizedBox(
                        height: size.height * 0.03,
                      ),
                      TextFormField(
                        controller: emailController,
                        decoration: InputDecoration(
                          filled: true,
                          fillColor: kTextFieldFill,
                          labelText: 'Email',
                          labelStyle: const TextStyle(color: Colors.white),
                          hintStyle: const TextStyle(
                              color: Colors.white), // Set hint text color
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10.0),
                            borderSide: const BorderSide(color: Colors.white),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10.0),
                            borderSide: const BorderSide(color: Colors.white),
                          ),
                          errorBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10.0),
                            borderSide: const BorderSide(color: Colors.red),
                          ),
                        ),
                        style: const TextStyle(
                            color: Colors.white), // Set input text color
                        validator: (value) {
                          if (value!.isEmpty) {
                            return 'Email is required';
                          }
                          
                          return null;
                        },
                      ),
                      SizedBox(height: size.height * 0.02),
                      TextFormField(
                        controller: _phoneController,
                        decoration: InputDecoration(
                          filled: true,
                          fillColor: kTextFieldFill,
                          labelText: 'Phone Number',
                          labelStyle: const TextStyle(color: Colors.white),
                          hintStyle: const TextStyle(
                              color: Colors.white), // Set hint text color
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10.0),
                            borderSide: const BorderSide(color: Colors.white),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10.0),
                            borderSide: const BorderSide(color: Colors.white),
                          ),
                          errorBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10.0),
                            borderSide: const BorderSide(color: Colors.red),
                          ),
                        ),
                        style: const TextStyle(
                            color: Colors.white), // Set input text color
                        validator: (value) {
                          if (value!.isEmpty) {
                            return 'Phone number is required';
                          }
                          // Add any additional phone number validation logic if needed
                          return null;
                        },
                      ),
                      SizedBox(height: size.height * 0.02),
                      TextFormField(
                        controller: _nameController,
                        decoration: InputDecoration(
                          filled: true,
                          fillColor: kTextFieldFill,
                          labelText: 'Name',
                          labelStyle: const TextStyle(color: Colors.white),
                          hintStyle: const TextStyle(
                              color: Colors.white), // Set hint text color
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10.0),
                            borderSide: const BorderSide(color: Colors.white),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10.0),
                            borderSide: const BorderSide(color: Colors.white),
                          ),
                          errorBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10.0),
                            borderSide: const BorderSide(color: Colors.red),
                          ),
                        ),
                        style: const TextStyle(
                            color: Colors.white), // Set input text color
                        validator: (value) {
                          if (value!.isEmpty) {
                            return 'Name is required';
                          }
                          // Add any additional name validation logic if needed
                          return null;
                        },
                      ),
                      SizedBox(height: size.height * 0.02),
                      TextFormField(
                        controller: passwordController,
                        obscureText: true,
                        decoration: InputDecoration(
                          filled: true,
                          fillColor: kTextFieldFill,
                          labelText: 'Password',
                          labelStyle: const TextStyle(color: Colors.white),
                          hintStyle: const TextStyle(
                              color: Colors.white), // Set hint text color
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10.0),
                            borderSide: const BorderSide(color: Colors.white),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10.0),
                            borderSide: const BorderSide(color: Colors.white),
                          ),
                          errorBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10.0),
                            borderSide: const BorderSide(color: Colors.red),
                          ),
                        ),
                        style: const TextStyle(
                            color: Colors.white), // Set input text color
                        validator: (value) {
                          if (value!.isEmpty) {
                            return 'Password is required';
                          }
                          if (value.length < 8) {
                            return 'Password should be at least 8 characters long';
                          }
                          return null;
                        },
                      ),
                      SizedBox(height: size.height * 0.02),
                      TextFormField(
                        controller: _confirmPassController,
                        obscureText: true,
                        decoration: InputDecoration(
                          filled: true,
                          fillColor: kTextFieldFill,
                          labelText: 'Confirm Password',
                          labelStyle: const TextStyle(color: Colors.white),
                          hintStyle: const TextStyle(
                              color: Colors.white), // Set hint text color
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10.0),
                            borderSide: const BorderSide(color: Colors.white),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10.0),
                            borderSide: const BorderSide(color: Colors.white),
                          ),
                          errorBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10.0),
                            borderSide: const BorderSide(color: Colors.red),
                          ),
                        ),
                        style: const TextStyle(
                            color: Colors.white), // Set input text color
                        validator: (value) {
                          if (value == null) {
                            return 'Password is required';
                          }
                          if (value.length < 8) {
                            return 'Password should be at least 8 characters long';
                          }
                          if (value != passwordController.text) {
                            return 'Passwords do not match';
                          }
                          return null;
                        },
                      ),
                      SizedBox(height: size.height * 0.02),
                      TextFormField(
                        controller: _ageController,
                        decoration: InputDecoration(
                          filled: true,
                          fillColor: kTextFieldFill,
                          labelText: 'Age',
                          labelStyle: const TextStyle(color: Colors.white),
                          hintStyle: const TextStyle(
                              color: Colors.white), // Set hint text color
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10.0),
                            borderSide: const BorderSide(color: Colors.white),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10.0),
                            borderSide: const BorderSide(color: Colors.white),
                          ),
                          errorBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10.0),
                            borderSide: const BorderSide(color: Colors.red),
                          ),
                        ),
                        style: const TextStyle(
                            color: Colors.white), // Set input text color
                        validator: (value) {
                          if (value!.isEmpty) {
                            return 'Age is required';
                          }
                          // Add any additional age validation logic if needed
                          return null;
                        },
                      ),
                      SizedBox(height: size.height * 0.02),
                      SizedBox(
                        height: size.height * 0.06,
                        child: ElevatedButton(
                          onPressed: () {
                            if (_formKey.currentState!.validate()) {
                              _registerUser(context);
                            } else {
                              showDialog(
                                context: context,
                                builder: (BuildContext context) {
                                  return AlertDialog(
                                    title: const Text('Error'),
                                    content: const Text(
                                        'Please fix the errors in the form.'),
                                    actions: <Widget>[
                                      TextButton(
                                        child: const Text('OK'),
                                        onPressed: () {
                                          Navigator.of(context).pop();
                                        },
                                      ),
                                    ],
                                  );
                                },
                              );
                            }
                          },
                          style: ButtonStyle(
                            shape: MaterialStateProperty.all<
                                RoundedRectangleBorder>(
                              RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(15),
                              ),
                            ),
                            backgroundColor:
                                MaterialStateProperty.all<Color>(Colors.white),
                          ),
                          child: const Text(
                            'Register',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w500,
                              color: Colors.black,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 16.0),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Text(
                            'Already have an account ?',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                              color: Colors.white,
                            ),
                          ),
                          const SizedBox(width: 0.0),
                          TextButton(
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => UserSignIn(),
                                ),
                              );
                            },
                            child: const Text(
                              'Login',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w500,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                // if (_auth.currentUser ==
                //     null) // Check if the user is not registered yet
                //   Container(
                //     color: Colors.black54,
                //     child: Center(
                //       child: CircularProgressIndicator(),
                //     ),
                //   ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
