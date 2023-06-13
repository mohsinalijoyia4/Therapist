import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class PatientListPage extends StatefulWidget {
  const PatientListPage({Key? key});

  @override
  State<PatientListPage> createState() => _PatientListPageState();
}

class _PatientListPageState extends State<PatientListPage> {
  List<Map<String, dynamic>> patientList = [];

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
    });
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: Colors.white24,
      appBar: AppBar(
        backgroundColor: Colors.white24,
        title: Text(
          "Patient List",
          style: TextStyle(fontSize: 18, color: Colors.purpleAccent),
        ),
      ),
      body: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: Container(
          height: size.height,
          width: size.width,
          decoration: BoxDecoration(color: Colors.white24),
          child: Padding(
            padding: const EdgeInsets.all(15.0),
            child: Column(
              children: [
                ListView.builder(
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(),
                  itemCount: patientList.length,
                  itemBuilder: (context, index) {
                    return _buildPatientTile(patientList[index], index + 1);
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildPatientTile(Map<String, dynamic> patientData, int index) {
    String? age = patientData['age'] as String?;
    String? contact = patientData['contact'] as String?;
    String? email = patientData['email'] as String?;

    return Container(
      decoration: BoxDecoration(color: Colors.white),
      child: ExpansionTile(
        title: Text('Patient $index'),
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
    );
  }
}
