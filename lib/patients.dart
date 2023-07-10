import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:docapp/firebase.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';

class TherapistPatients extends StatefulWidget {
  const TherapistPatients({super.key});

  @override
  State<TherapistPatients> createState() => _TherapistPatientsState();
}

class _TherapistPatientsState extends State<TherapistPatients> {
  List<Map<String, dynamic>> patientList = [];
  late double progress;

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
    String therapistId = '';
    therapistId = getCurrentTherapistId();

    try {
      QuerySnapshot snapshot = await FirebaseFirestore.instance
          .collection('therapists')
          .doc(therapistId)
          .collection('assignedusers')
          .get();

      List<Map<String, dynamic>> patients = [];

      for (var doc in snapshot.docs) {
        Map<String, dynamic> userData = doc.data() as Map<String, dynamic>;
        userData['id'] = doc.id;
        patients.add(userData);
      }

      setState(() {
        patientList = patients;
        print("Patients:   $patients");
      });

      // Print values of all attributes
      for (var patient in patientList) {
        print('Patient: ${patient['name']}');
        print('Age: ${patient['age']}');
        print('Contact: ${patient['phone']}');
        print('Email: ${patient['email']}');
        print('Toggle One: ${patient['toggleOne'] ?? false}');
        print('Toggle Two: ${patient['toggleTwo'] ?? false}');
        print('Toggle Three: ${patient['toggleThree'] ?? false}');
        print('Toggle Fourth: ${patient['toggleFourth'] ?? false}');
        print('Toggle Five: ${patient['toggleFivth'] ?? false}');
        print('Toggle sixth: ${patient['togglesixth'] ?? false}');
        print('Toggle seventth: ${patient['toggleSeventh'] ?? false}');
        print('Toggle Eighth: ${patient['toggleEighth'] ?? false}');
        print('------lkfga');
      }
    } catch (error) {
      print('Error fetching user data: $error');
    }
  }
  // final FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;

  @override
  void initState() {
    super.initState();
    // Fetch user data from Firestore
    _fetchUserData();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: Colors.white24,
      appBar: AppBar(
        backgroundColor: Colors.white24,
        title: const Text(
          "Patient List",
          style: TextStyle(fontSize: 18, color: Colors.white),
        ),
      ),
      body: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: Padding(
          padding: const EdgeInsets.all(15.0),
          child: Column(
            children: [
              ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: patientList.length,
                itemBuilder: (context, index) {
                  return _buildPatientTile(patientList[index], index, size);
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  String therapistId = '';
  Widget _buildPatientTile(
      Map<String, dynamic> patientData, int index, Size size) {
    String? age = patientData['age'] as String?;
    String? contact = patientData['phone'] as String?;
    String? email = patientData['email'] as String?;
    FirebaseService firebaseService = FirebaseService();

    int trueCount = 0;
    if (patientData['toggleOne'] == true) trueCount++;
    if (patientData['toggleTwo'] == true) trueCount++;
    if (patientData['toggleThree'] == true) trueCount++;
    if (patientData['toggleFourth'] == true) trueCount++;
    if (patientData['toggleFivth'] == true) trueCount++;
    if (patientData['togglesixth'] == true) trueCount++;
    if (patientData['toggleSeventh'] == true) trueCount++;
    if (patientData['toggleEighth'] == true) trueCount++;

    therapistId = getCurrentTherapistId();

    progress = trueCount / 8;

    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        width: size.width * 0.8,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: CircularPercentIndicator(
                    radius: 50,
                    lineWidth: 20,
                    percent: progress,
                    progressColor: Colors.deepPurple,
                    circularStrokeCap: CircularStrokeCap.round,
                    backgroundColor: Colors.deepPurple.shade100,
                    center: Text(
                      (progress * 100).toStringAsFixed(2),
                      style: const TextStyle(color: Colors.black),
                    ),
                  ),
                ),
                Container(
                  width: 200, // Adjust the width according to your needs
                  child: const Text(
                    "This progress indicator shows the percentage of total Completed Activities",
                    style: TextStyle(
                        color: Colors.black,
                        fontSize: 14,
                        fontWeight: FontWeight.w400),
                    textAlign: TextAlign.start,
                    softWrap: true,
                  ),
                )
              ],
            ),
            ExpansionTile(
              title: Text('Patient ${index + 1}'),
              children: [
                ListTile(
                  title: Text('Age: ${age ?? ''}'),
                ),
                ListTile(
                  title: Text('Contact: ${contact ?? ''}'),
                ),
                ListTile(
                  title: Text('Email: ${email ?? ''}'),
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.all(18.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "Activity 1",
                            style: TextStyle(fontSize: 14),
                          ),
                          Row(
                            children: [
                              Text("OFF"),
                              Switch(
                                value: patientData['toggleOne'] ? false : true,
                                onChanged: (newValue) {
                                  if (newValue == true) {
                                    setState(() {
                                      patientData['toggleOne'] = false;
                                    });
                                    firebaseService.updateToggleValue(
                                      therapistId,
                                      patientData['id'] as String,
                                      'toggleOne',
                                      false,
                                    );
                                  }
                                },
                              ),
                              Text("ON"),
                            ],
                          ),
                        ],
                      ),
                      Container(
                        decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(10)),
                        height: size.height * 0.09,
                        width: size.width * 0.8,
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              // Icon(
                              //   Icons.check_circle,
                              //   size: 40,
                              // ),
                              // SizedBox(
                              //   width: size.width * 0.051,
                              // ),
                              Column(
                                children: [
                                  Text(
                                    "Turn ON the toggle to assigne the Activity again",
                                    style: TextStyle(
                                        fontSize: 13,
                                        fontWeight: FontWeight.w500,
                                        color: Colors.black),
                                  ),
                                  SizedBox(
                                    height: size.height * 0.021,
                                  ),
                                  Row(
                                    children: [
                                      Text(
                                        "0%",
                                        style: TextStyle(
                                            fontSize: 14,
                                            fontWeight: FontWeight.w600,
                                            color: Colors.black),
                                      ),
                                      SizedBox(
                                        width: size.width * 0.6,
                                        child: LinearProgressIndicator(
                                          minHeight: 20,
                                          value: patientData['toggleOne']
                                              ? 1
                                              : 0, // Set the progress value (between 0.0 and 1.0)
                                          valueColor: AlwaysStoppedAnimation<
                                                  Color>(
                                              Colors
                                                  .blue), // Set the filled color
                                          backgroundColor: Colors
                                              .grey, // Set the background color of the progress bar
                                        ),
                                      ),
                                      Text(
                                        "100%",
                                        style: TextStyle(
                                            fontSize: 14,
                                            fontWeight: FontWeight.w600,
                                            color: Colors.black),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                  Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "Activity 2",
                            style: TextStyle(fontSize: 14),
                          ),
                          Row(
                            children: [
                              Text("OFF"),
                              Switch(
                                value: patientData['toggleTwo'] ? false : true,
                                onChanged: (newValue) {
                                  if (newValue == true) {
                                    setState(() {
                                      patientData['toggleTwo'] = false;
                                    });
                                    firebaseService.updateToggleValue(
                                      therapistId,
                                      patientData['id'] as String,
                                      'toggleTwo',
                                      false,
                                    );
                                  }
                                },
                              ),
                              Text("ON"),
                            ],
                          ),
                        ],
                      ),
                      Container(
                        decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(10)),
                        height: size.height * 0.09,
                        width: size.width * 0.8,
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Column(
                                children: [
                                  Text(
                                    "Turn ON the toggle to assigne the Activity again",
                                    style: TextStyle(
                                        fontSize: 13,
                                        fontWeight: FontWeight.w500,
                                        color: Colors.black),
                                  ),
                                  SizedBox(
                                    height: size.height * 0.021,
                                  ),
                                  Row(
                                    children: [
                                      Text(
                                        "0%",
                                        style: TextStyle(
                                            fontSize: 14,
                                            fontWeight: FontWeight.w600,
                                            color: Colors.black),
                                      ),
                                      SizedBox(
                                        width: size.width * 0.6,
                                        child: LinearProgressIndicator(
                                          minHeight: 20,
                                          value: patientData['toggleTwo']
                                              ? 1
                                              : 0, // Set the progress value (between 0.0 and 1.0)
                                          valueColor: AlwaysStoppedAnimation<
                                                  Color>(
                                              Colors
                                                  .blue), // Set the filled color
                                          backgroundColor: Colors
                                              .grey, // Set the background color of the progress bar
                                        ),
                                      ),
                                      Text(
                                        "100%",
                                        style: TextStyle(
                                            fontSize: 14,
                                            fontWeight: FontWeight.w600,
                                            color: Colors.black),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                  Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "Activity 3",
                            style: TextStyle(fontSize: 14),
                          ),
                          Row(
                            children: [
                              Text("OFF"),
                              Switch(
                                value:
                                    patientData['toggleThree'] ? false : true,
                                onChanged: (newValue) {
                                  if (newValue == true) {
                                    setState(() {
                                      patientData['toggleThree'] = false;
                                    });
                                    firebaseService.updateToggleValue(
                                      therapistId,
                                      patientData['id'] as String,
                                      'toggleThree',
                                      false,
                                    );
                                  }
                                },
                              ),
                              Text("ON"),
                            ],
                          ),
                        ],
                      ),
                      Container(
                        decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(10)),
                        height: size.height * 0.09,
                        width: size.width * 0.8,
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              // Icon(
                              //   Icons.check_circle,
                              //   size: 40,
                              // ),
                              // SizedBox(
                              //   width: size.width * 0.051,
                              // ),
                              Column(
                                children: [
                                  Text(
                                    "Turn ON the toggle to assigne the Activity again",
                                    style: TextStyle(
                                        fontSize: 13,
                                        fontWeight: FontWeight.w500,
                                        color: Colors.black),
                                  ),
                                  SizedBox(
                                    height: size.height * 0.021,
                                  ),
                                  Row(
                                    children: [
                                      Text(
                                        "0%",
                                        style: TextStyle(
                                            fontSize: 14,
                                            fontWeight: FontWeight.w600,
                                            color: Colors.black),
                                      ),
                                      SizedBox(
                                        width: size.width * 0.6,
                                        child: LinearProgressIndicator(
                                          minHeight: 20,
                                          value: patientData['toggleThree']
                                              ? 1
                                              : 0, // Set the progress value (between 0.0 and 1.0)
                                          valueColor: AlwaysStoppedAnimation<
                                                  Color>(
                                              Colors
                                                  .blue), // Set the filled color
                                          backgroundColor: Colors
                                              .grey, // Set the background color of the progress bar
                                        ),
                                      ),
                                      Text(
                                        "100%",
                                        style: TextStyle(
                                            fontSize: 14,
                                            fontWeight: FontWeight.w600,
                                            color: Colors.black),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                  Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "Activity 4",
                            style: TextStyle(fontSize: 14),
                          ),
                          Row(
                            children: [
                              Text("OFF"),
                              Switch(
                                value:
                                    patientData['toggleFourth'] ? false : true,
                                onChanged: (newValue) {
                                  if (newValue == true) {
                                    setState(() {
                                      patientData['toggleFourth'] = false;
                                    });

                                    firebaseService.updateToggleValue(
                                      therapistId,
                                      patientData['id'] as String,
                                      'toggleFourth',
                                      false,
                                    );
                                  }
                                },
                              ),
                              Text("ON"),
                            ],
                          ),
                        ],
                      ),
                      Container(
                        decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(10)),
                        height: size.height * 0.09,
                        width: size.width * 0.8,
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              // Icon(
                              //   Icons.check_circle,
                              //   size: 40,
                              // ),
                              // SizedBox(
                              //   width: size.width * 0.051,
                              // ),
                              Column(
                                children: [
                                  Text(
                                    "Turn ON the toggle to assigne the Activity again",
                                    style: TextStyle(
                                        fontSize: 13,
                                        fontWeight: FontWeight.w500,
                                        color: Colors.black),
                                  ),
                                  SizedBox(
                                    height: size.height * 0.021,
                                  ),
                                  Row(
                                    children: [
                                      Text(
                                        "0%",
                                        style: TextStyle(
                                            fontSize: 14,
                                            fontWeight: FontWeight.w600,
                                            color: Colors.black),
                                      ),
                                      SizedBox(
                                        width: size.width * 0.6,
                                        child: LinearProgressIndicator(
                                          minHeight: 20,
                                          value: patientData['toggleFourth']
                                              ? 1
                                              : 0, // Set the progress value (between 0.0 and 1.0)
                                          valueColor: AlwaysStoppedAnimation<
                                                  Color>(
                                              Colors
                                                  .blue), // Set the filled color
                                          backgroundColor: Colors
                                              .grey, // Set the background color of the progress bar
                                        ),
                                      ),
                                      Text(
                                        "100%",
                                        style: TextStyle(
                                            fontSize: 14,
                                            fontWeight: FontWeight.w600,
                                            color: Colors.black),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                  Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "Activity 5",
                            style: TextStyle(fontSize: 14),
                          ),
                          Row(
                            children: [
                              Text("OFF"),
                              Switch(
                                value:
                                    patientData['toggleFivth'] ? false : true,
                                onChanged: (newValue) {
                                  if (newValue == true) {
                                    setState(() {
                                      patientData['toggleFivth'] = false;
                                    });

                                    firebaseService.updateToggleValue(
                                      therapistId,
                                      patientData['id'] as String,
                                      'toggleFivth',
                                      false,
                                    );
                                  }
                                },
                              ),
                              Text("ON"),
                            ],
                          ),
                        ],
                      ),
                      Container(
                        decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(10)),
                        height: size.height * 0.09,
                        width: size.width * 0.8,
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              // Icon(
                              //   Icons.check_circle,
                              //   size: 40,
                              // ),
                              // SizedBox(
                              //   width: size.width * 0.051,
                              // ),
                              Column(
                                children: [
                                  Text(
                                    "Turn ON the toggle to assigne the Activity again",
                                    style: TextStyle(
                                        fontSize: 13,
                                        fontWeight: FontWeight.w500,
                                        color: Colors.black),
                                  ),
                                  SizedBox(
                                    height: size.height * 0.021,
                                  ),
                                  Row(
                                    children: [
                                      Text(
                                        "0%",
                                        style: TextStyle(
                                            fontSize: 14,
                                            fontWeight: FontWeight.w600,
                                            color: Colors.black),
                                      ),
                                      SizedBox(
                                        width: size.width * 0.6,
                                        child: LinearProgressIndicator(
                                          minHeight: 20,
                                          value: patientData['toggleFivth']
                                              ? 1
                                              : 0, // Set the progress value (between 0.0 and 1.0)
                                          valueColor: AlwaysStoppedAnimation<
                                                  Color>(
                                              Colors
                                                  .blue), // Set the filled color
                                          backgroundColor: Colors
                                              .grey, // Set the background color of the progress bar
                                        ),
                                      ),
                                      Text(
                                        "100%",
                                        style: TextStyle(
                                            fontSize: 14,
                                            fontWeight: FontWeight.w600,
                                            color: Colors.black),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                  Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "Activity 6",
                            style: TextStyle(fontSize: 14),
                          ),
                          Row(
                            children: [
                              Text("OFF"),
                              Switch(
                                value:
                                    patientData['togglesixth'] ? false : true,
                                onChanged: (newValue) {
                                  if (newValue == true) {
                                    setState(() {
                                      patientData['togglesixth'] = false;
                                    });

                                    firebaseService.updateToggleValue(
                                      therapistId,
                                      patientData['id'] as String,
                                      'togglesixth',
                                      false,
                                    );
                                  }
                                },
                              ),
                              Text("ON"),
                            ],
                          ),
                        ],
                      ),
                      Container(
                        decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(10)),
                        height: size.height * 0.09,
                        width: size.width * 0.8,
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              // Icon(
                              //   Icons.check_circle,
                              //   size: 40,
                              // ),
                              // SizedBox(
                              //   width: size.width * 0.051,
                              // ),
                              Column(
                                children: [
                                  Text(
                                    "Turn ON the toggle to assigne the Activity again",
                                    style: TextStyle(
                                        fontSize: 13,
                                        fontWeight: FontWeight.w500,
                                        color: Colors.black),
                                  ),
                                  SizedBox(
                                    height: size.height * 0.021,
                                  ),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text(
                                        "0%",
                                        style: TextStyle(
                                            fontSize: 14,
                                            fontWeight: FontWeight.w600,
                                            color: Colors.black),
                                      ),
                                      SizedBox(
                                        width: size.width * 0.6,
                                        child: LinearProgressIndicator(
                                          minHeight: 20,
                                          value: patientData['togglesixth']
                                              ? 1
                                              : 0, // Set the progress value (between 0.0 and 1.0)
                                          valueColor: AlwaysStoppedAnimation<
                                                  Color>(
                                              Colors
                                                  .blue), // Set the filled color
                                          backgroundColor: Colors
                                              .grey, // Set the background color of the progress bar
                                        ),
                                      ),
                                      Text(
                                        "100%",
                                        style: TextStyle(
                                            fontSize: 14,
                                            fontWeight: FontWeight.w600,
                                            color: Colors.black),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                  Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "Activity 7",
                            style: TextStyle(fontSize: 14),
                          ),
                          Row(
                            children: [
                              Text("OFF"),
                              Switch(
                                value:
                                    patientData['toggleSeventh'] ? false : true,
                                onChanged: (newValue) {
                                  if (newValue == true) {
                                    setState(() {
                                      patientData['toggleSeventh'] = false;
                                    });

                                    firebaseService.updateToggleValue(
                                      therapistId,
                                      patientData['id'] as String,
                                      'toggleSeventh',
                                      false,
                                    );
                                  }
                                },
                              ),
                              Text("ON"),
                            ],
                          ),
                        ],
                      ),
                      Container(
                        decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(10)),
                        height: size.height * 0.09,
                        width: size.width * 0.8,
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              // Icon(
                              //   Icons.check_circle,
                              //   size: 40,
                              // ),
                              // SizedBox(
                              //   width: size.width * 0.051,
                              // ),
                              Column(
                                children: [
                                  Text(
                                    "Turn ON the toggle to assigne the Activity again",
                                    style: TextStyle(
                                        fontSize: 13,
                                        fontWeight: FontWeight.w500,
                                        color: Colors.black),
                                  ),
                                  SizedBox(
                                    height: size.height * 0.021,
                                  ),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text(
                                        "0%",
                                        style: TextStyle(
                                            fontSize: 14,
                                            fontWeight: FontWeight.w600,
                                            color: Colors.black),
                                      ),
                                      SizedBox(
                                        width: size.width * 0.6,
                                        child: LinearProgressIndicator(
                                          minHeight: 20,
                                          value: patientData['toggleSeventh']
                                              ? 1
                                              : 0, // Set the progress value (between 0.0 and 1.0)
                                          valueColor: AlwaysStoppedAnimation<
                                                  Color>(
                                              Colors
                                                  .blue), // Set the filled color
                                          backgroundColor: Colors
                                              .grey, // Set the background color of the progress bar
                                        ),
                                      ),
                                      Text(
                                        "100%",
                                        style: TextStyle(
                                            fontSize: 14,
                                            fontWeight: FontWeight.w600,
                                            color: Colors.black),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                  Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "Activity 8",
                            style: TextStyle(fontSize: 14),
                          ),
                          Row(
                            children: [
                              Text("OFF"),
                              Switch(
                                value:
                                    patientData['toggleEighth'] ? false : true,
                                onChanged: (newValue) {
                                  if (newValue == true) {
                                    setState(() {
                                      patientData['toggleEighth'] = false;
                                    });
                                    firebaseService.updateToggleValue(
                                      therapistId,
                                      patientData['id'] as String,
                                      'toggleEighth',
                                      false,
                                    );
                                  }
                                },
                              ),
                              Text("ON"),
                            ],
                          ),
                        ],
                      ),
                      Container(
                        decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(10)),
                        height: size.height * 0.09,
                        width: size.width * 0.8,
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              // Icon(
                              //   Icons.check_circle,
                              //   size: 40,
                              // ),
                              // SizedBox(
                              //   width: size.width * 0.051,
                              // ),
                              Column(
                                children: [
                                  Text(
                                    "Turn ON the toggle to assigne the Activity again",
                                    style: TextStyle(
                                        fontSize: 13,
                                        fontWeight: FontWeight.w500,
                                        color: Colors.black),
                                  ),
                                  SizedBox(
                                    height: size.height * 0.021,
                                  ),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text(
                                        "0%",
                                        style: TextStyle(
                                            fontSize: 14,
                                            fontWeight: FontWeight.w600,
                                            color: Colors.black),
                                      ),
                                      SizedBox(
                                        width: size.width * 0.6,
                                        child: LinearProgressIndicator(
                                          minHeight: 20,
                                          value: patientData['toggleEighth']
                                              ? 1
                                              : 0, // Set the progress value (between 0.0 and 1.0)
                                          valueColor: AlwaysStoppedAnimation<
                                                  Color>(
                                              Colors
                                                  .blue), // Set the filled color
                                          backgroundColor: Colors
                                              .grey, // Set the background color of the progress bar
                                        ),
                                      ),
                                      Text(
                                        "100%",
                                        style: TextStyle(
                                            fontSize: 14,
                                            fontWeight: FontWeight.w600,
                                            color: Colors.black),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
