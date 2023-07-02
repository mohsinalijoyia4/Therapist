import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';

class PatientListPage extends StatefulWidget {
  const PatientListPage({Key? key});

  @override
  State<PatientListPage> createState() => _PatientListPageState();
}

class _PatientListPageState extends State<PatientListPage> {
  // final FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;

  List<Map<String, dynamic>> patientList = [];
  late double progress;

  @override
  void initState() {
    super.initState();
    // Fetch user data from Firestore
    _fetchUserData();
  }

  Future<void> _fetchUserData() async {
    QuerySnapshot snapshot =
        await FirebaseFirestore.instance.collection('users').get();

    List<Map<String, dynamic>> patients = [];

    for (var doc in snapshot.docs) {
      Map<String, dynamic> userData = doc.data() as Map<String, dynamic>;
      userData['id'] = doc.id;
      patients.add(userData);
    }

    setState(() {
      patientList = patients;
    });

    // Print initial values of all attributes
    for (var patient in patientList) {
      print('Patient: ${patient['name']}');
      print('Age: ${patient['age']}');
      print('Contact: ${patient['phone']}');
      print('Email: ${patient['email']}');
      print('Toggle One: ${patient['toggleOne']}');
      print('Toggle Two: ${patient['toggleTwo']}');
      print('Toggle Three: ${patient['toggleThree']}');
      print('Toggle Fourth: ${patient['toggleFourth']}');
      print('Toggle Five: ${patient['toggleFivth']}');
      print('Toggle sixth: ${patient['togglesixth']}');

      print('------lkfga');
    }
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

    progress = trueCount / 6;

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
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
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
                                patientData['id'] as String,
                                'toggleOne',
                                newValue,
                              );
                            },
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
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
                                patientData['id'] as String,
                                'toggleTwo',
                                newValue,
                              );
                            },
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
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
                                patientData['id'] as String,
                                'toggleThree',
                                newValue,
                              );
                            },
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
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
                                patientData['id'] as String,
                                'toggleFourth',
                                newValue,
                              );
                            },
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
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
                                patientData['id'] as String,
                                'toggleFivth',
                                newValue,
                              );
                            },
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
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
                                patientData['id'] as String,
                                'togglesixth',
                                newValue,
                              );
                            },
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _updateToggleValue(
    String patientId,
    String fieldToUpdate,
    bool newValue,
  ) async {
    try {
      await FirebaseFirestore.instance
          .collection('users')
          .doc(patientId)
          .update({fieldToUpdate: newValue});
      print('updateddd ');

      // Send notification to the patient
      // _sendNotification(patientId, fieldToUpdate);
    } catch (error) {
      print('Error updating toggle value: $error');
    }
  }



}

// class PushNotificationMessage {
//   final String title;
//   final String body;
//   final String token;

//   PushNotificationMessage({
//     required this.title,
//     required this.body,
//     required this.token,
//   });

//   Map<String, dynamic> toMap() {
//     return {
//       'notification': {
//         'title': title,
//         'body': body,
//       },
//       'to': token,
//     };
//   }
// }
