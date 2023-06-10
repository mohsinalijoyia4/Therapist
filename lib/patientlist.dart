import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

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
    // _fetchProfilePictureURL();
  }

  Future<String> _fetchProfilePictureURL(String imagePath) async {
    FirebaseStorage storage = FirebaseStorage.instance;

    try {
      Reference ref = storage.ref(imagePath);
      String downloadURL = await ref.getDownloadURL();
      return downloadURL;
    } catch (e) {
      print('Error fetching profile picture: $e');
      return ''; // Return empty string if an error occurs
    }
  }

  Future<void> _fetchUserData() async {
    FirebaseFirestore firestore = FirebaseFirestore.instance;

    try {
      QuerySnapshot querySnapshot = await firestore.collection('users').get();
      List<Map<String, dynamic>> users = [];

      querySnapshot.docs.forEach((doc) {
        Map<String, dynamic> user = doc.data()! as Map<String,
            dynamic>; // Cast to Map<String, dynamic> with assertion
        users.add(user);
      });

      setState(() {
        patientList = users;
      });
    } catch (e) {
      print('Error fetching user data: $e');
    }
  }

// void addPatientToList() {
    // Create a map for the patient details
    // Map<String, dynamic> patientDetails = {
    //   'name': patientName,
    //   'age': patientAge,
    //   'contact': patientContact,
    //   'id': id,
    // };

    // Add the patient details to the list
    // patientList.add(patientDetails);
  // }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: Colors.white24,
      appBar: AppBar(
        backgroundColor: Colors.white24,
        leading: Icon(
          Icons.arrow_back,
          color: Colors.purpleAccent,
        ),
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
                  itemCount: patientList.length,
                  itemBuilder: (BuildContext context, int index) {
                    Map<String, dynamic> userDetails = patientList[index];
                    return detailedContainer(
                      size,
                      userDetails['name'],
                      userDetails['age'],
                      userDetails['contact'],
                      userDetails['id'],
                      userDetails['profileImage'],
                    );
                  },
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget detailedContainer(Size size, String patientName, String patientAge,
      String patientContact, int id, String profilePictureURL) {
    bool isExpanded = false;

    void toggleExpansion() {
      setState(() {
        isExpanded = !isExpanded;
      });
    }

    return Container(
      height: isExpanded ? size.height * 0.5 : size.height * 0.25,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
      ),
      child: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  height: size.height * 0.12,
                  width: size.width * 0.22,
                  decoration: BoxDecoration(
                    color: Colors.black26,
                    borderRadius: BorderRadius.circular(size.height * 0.2),
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(size.height * 0.2),
                    child: CachedNetworkImage(
                      imageUrl: profilePictureURL,
                      fit: BoxFit.cover,
                      placeholder: (context, url) =>
                          CircularProgressIndicator(),
                      errorWidget: (context, url, error) => Icon(Icons.error),
                    ),
                  ),
                ),
                SizedBox(
                  width: size.width * 0.05,
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Text(
                          "Patient Details:",
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.w700,
                            color: Colors.blueAccent,
                          ),
                        ),
                        SizedBox(
                          width: size.width * 0.2,
                        ),
                        Icon(
                          Icons.chat_rounded,
                        ),
                      ],
                    ),
                    Text(
                      "Name: $patientName",
                      style: TextStyle(fontSize: 15, color: Colors.black),
                    ),
                    Text(
                      "Age: $patientAge",
                      style: TextStyle(fontSize: 15, color: Colors.black),
                    ),
                    Text(
                      "Contact: $patientContact",
                      style: TextStyle(fontSize: 15, color: Colors.black),
                    ),
                    Text(
                      "ID: $id",
                      style: TextStyle(fontSize: 15, color: Colors.black),
                    ),
                  ],
                ),
              ],
            ),
            SizedBox(
              height: size.height * 0.02,
            ),
            Divider(
              color: Colors.grey,
              thickness: 1.0,
            ),
            GestureDetector(
              onTap: toggleExpansion,
              child: Row(
                children: [
                  Icon(
                    isExpanded ? Icons.arrow_drop_up : Icons.arrow_drop_down,
                  ),
                  SizedBox(width: 8),
                  Text(
                    "Progress Details",
                    style: TextStyle(
                      fontWeight: FontWeight.w700,
                      fontSize: 15,
                      color: Colors.black,
                    ),
                  ),
                ],
              ),
            ),
            if (isExpanded)
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  "Diagnosis",
                  style: TextStyle(
                    fontSize: 15,
                    color: Colors.black,
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
