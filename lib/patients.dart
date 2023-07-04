import 'package:cloud_firestore/cloud_firestore.dart';
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
                  return _buildPatientTile(patientList[index], index);
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  String therapistId = '';
  Widget _buildPatientTile(Map<String, dynamic> patientData, int index) {
    String? age = patientData['age'] as String?;
    String? contact = patientData['phone'] as String?;
    String? email = patientData['email'] as String?;
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
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
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
                  Padding(
                    padding: const EdgeInsets.only(left: 0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          children: [
                            Text(
                              "Activity 1",
                              style: TextStyle(fontSize: 14),
                            ),
                            Switch(
                              value: patientData['toggleOne'] ?? false,
                              onChanged: (newValue) {
                                setState(() {
                                  patientData['toggleOne'] = newValue;
                                });
                                _updateToggleValue(
                                  therapistId,
                                  patientData['id'] as String,
                                  'toggleOne',
                                  newValue,
                                );
                              },
                            ),
                          ],
                        ),
                        Column(
                          children: [
                            Text(
                              "Activity 2",
                              style: TextStyle(fontSize: 14),
                            ),
                            Switch(
                              value: patientData['toggleTwo'] ?? false,
                              onChanged: (newValue) {
                                setState(() {
                                  patientData['toggleTwo'] = newValue;
                                });
                                _updateToggleValue(
                                  therapistId,
                                  patientData['id'] as String,
                                  'toggleTwo',
                                  newValue,
                                );
                              },
                            ),
                          ],
                        ),
                        Column(
                          children: [
                            Text(
                              "Activity 3",
                              style: TextStyle(fontSize: 14),
                            ),
                            Switch(
                              value: patientData['toggleThree'] ?? false,
                              onChanged: (newValue) {
                                setState(() {
                                  patientData['toggleThree'] = newValue;
                                });
                                _updateToggleValue(
                                  therapistId,
                                  patientData['id'] as String,
                                  'toggleThree',
                                  newValue,
                                );
                              },
                            ),
                          ],
                        ),
                        Column(
                          children: [
                            Text(
                              "Activity 4",
                              style: TextStyle(fontSize: 14),
                            ),
                            Switch(
                              value: patientData['toggleFourth'] ?? false,
                              onChanged: (newValue) {
                                setState(() {
                                  patientData['toggleFourth'] = newValue;
                                });

                                _updateToggleValue(
                                  therapistId,
                                  patientData['id'] as String,
                                  'toggleFourth',
                                  newValue,
                                );
                              },
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          children: [
                            Text(
                              "Activity 5",
                              style: TextStyle(fontSize: 14),
                            ),
                            Switch(
                              value: patientData['toggleFivth'] ?? false,
                              onChanged: (newValue) {
                                setState(() {
                                  patientData['toggleFivth'] = newValue;
                                });

                                _updateToggleValue(
                                  therapistId,
                                  patientData['id'] as String,
                                  'toggleFivth',
                                  newValue,
                                );
                              },
                            ),
                          ],
                        ),
                        Column(
                          children: [
                            Text(
                              "Activity 6",
                              style: TextStyle(fontSize: 14),
                            ),
                            Switch(
                              value: patientData['togglesixth'] ?? false,
                              onChanged: (newValue) {
                                setState(() {
                                  patientData['togglesixth'] = newValue;
                                });

                                _updateToggleValue(
                                  therapistId,
                                  patientData['id'] as String,
                                  'togglesixth',
                                  newValue,
                                );
                              },
                            ),
                          ],
                        ),
                        Column(
                          children: [
                            Text(
                              "Activity 7",
                              style: TextStyle(fontSize: 14),
                            ),
                            Switch(
                              value: patientData['toggleSeventh'] ?? false,
                              onChanged: (newValue) {
                                setState(() {
                                  patientData['toggleEighth'] = newValue;
                                });

                                _updateToggleValue(
                                  therapistId,
                                  patientData['id'] as String,
                                  'toggleEighth',
                                  newValue,
                                );
                              },
                            ),
                          ],
                        ),
                        Column(
                          children: [
                            Text(
                              "Activity 8",
                              style: TextStyle(fontSize: 14),
                            ),
                            Switch(
                              value: patientData['toggleEighth'] ?? false,
                              onChanged: (newValue) {
                                setState(() {
                                  patientData['toggleEighth'] = newValue;
                                });

                                _updateToggleValue(
                                  therapistId,
                                  patientData['id'] as String,
                                  'toggleEighth',
                                  newValue,
                                );
                              },
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _updateToggleValue(
    String therapistId,
    String patientId,
    String fieldToUpdate,
    bool newValue,
  ) async {
    try {
      await FirebaseFirestore.instance
          .collection('therapists')
          .doc(therapistId)
          .collection('assignedusers')
          .doc(patientId)
          .update({fieldToUpdate: newValue});
      await FirebaseFirestore.instance
          .collection('users')
          .doc(patientId)
          .update({fieldToUpdate: newValue});

      print('Updated successfully');
      // Send notification to the patient
      // _sendNotification(patientId, fieldToUpdate);
    } catch (error) {
      print('Error updating toggle value: $error');
    }
  }
}
