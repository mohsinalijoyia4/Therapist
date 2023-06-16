import 'package:docapp/allexercises.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class PatientListPage extends StatefulWidget {
  const PatientListPage({Key? key});

  @override
  State<PatientListPage> createState() => _PatientListPageState();
}

class _PatientListPageState extends State<PatientListPage> {
  List<Map<String, dynamic>> patientList = [];
  DetailsScreen detailobj = DetailsScreen();
  bool? toggleone;
  bool? toggletwo;
  bool? togglethree;
  bool? togglefourth;
  
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
      patients.add(userData);
    }

    setState(() {
      patientList = patients;
      toggleValues = List.generate(
        patientList.length,
        (index) => [false, false, false, false],
      );
    });
  }

  void setToggleValue(int patientIndex, int toggleIndex, bool newValue) async {
    setState(() {
      toggleValues[patientIndex][toggleIndex] = newValue;
    });

    String patientId = patientList[patientIndex]['id'] as String;
    String fieldToUpdate;
    switch (toggleIndex) {
      case 0:
        fieldToUpdate = 'toggleOne';
        break;
      case 1:
        fieldToUpdate = 'toggleTwo';
        break;
      case 2:
        fieldToUpdate = 'toggleThree';
        break;
      case 3:
        fieldToUpdate = 'toggleFourth';
        break;
      default:
        return;
    }

    try {
      await FirebaseFirestore.instance
          .collection('users')
          .doc(patientId)
          .update({fieldToUpdate: newValue});
    } catch (error) {
      // Handle the error
    }
  }

  @override
  Widget build(BuildContext context) {
    // Size size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: Colors.white24,
      appBar: AppBar(
        backgroundColor: Colors.white24,
        title: Text(
          "Patient List",
          style: TextStyle(fontSize: 18, color: Colors.white),
        ),
      ),
      body: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: Expanded(
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
      ),
    );
  }

  List<List<bool>> toggleValues = [];
  Widget _buildPatientTile(Map<String, dynamic> patientData, int index) {
    String? age = patientData['age'] as String?;
    String? contact = patientData['contact'] as String?;
    String? email = patientData['email'] as String?;

    List<bool> patientToggleValues = toggleValues[index];

    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Column(
          children: [
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
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
                            value: patientToggleValues[0],
                            onChanged: (newValue) {
                              setToggleValue(index, 0, newValue);
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
                            value: patientToggleValues[1],
                            onChanged: (newValue) {
                              setToggleValue(index, 1, newValue);
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
                            "Activity ",
                            style: TextStyle(fontSize: 14),
                          ),
                          Switch(
                            value: patientToggleValues[2],
                            onChanged: (newValue) {
                              setToggleValue(index, 2, newValue);
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
                            value: patientToggleValues[3],
                            onChanged: (newValue) {
                              setToggleValue(index, 3, newValue);
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

  bool patientToggleOne = false;
  bool patientToggleTwo = false;
  bool patientToggleThree = false;
  bool patientToggleFour = false;
}
