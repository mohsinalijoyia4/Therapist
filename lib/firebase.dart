import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class FirebaseService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<List<Map<String, dynamic>>> getTherapists() async {
    QuerySnapshot<Map<String, dynamic>> snapshot =
        await _firestore.collection('therapists').get();
    return snapshot.docs.map((doc) => doc.data()).toList();
  }

  Future<List<Map<String, dynamic>>> getUsers() async {
    QuerySnapshot<Map<String, dynamic>> snapshot =
        await _firestore.collection('users').get();
    return snapshot.docs.map((doc) => doc.data()).toList();
  }

  Future<String?> findTherapistIdForUser(String userId) async {
    try {
      QuerySnapshot therapistsSnapshot =
          await FirebaseFirestore.instance.collection('therapists').get();

      for (QueryDocumentSnapshot therapistDoc in therapistsSnapshot.docs) {
        // Get the therapist ID
        String therapistId = therapistDoc.id;

        // Check if the therapist has an assigned users subcollection
        QuerySnapshot assignedUsersSnapshot =
            await therapistDoc.reference.collection('assignedusers').get();

        for (QueryDocumentSnapshot assignedUserDoc
            in assignedUsersSnapshot.docs) {
          // Compare the document ID with the userId
          if (assignedUserDoc.id == userId) {
            // User ID found in the assigned users subcollection
            print("therapistID:  $therapistId");
            return therapistId;
          }
        }
      }
    } catch (error) {
      print('Error finding therapist ID: $error');
    }

    // User ID not found or an error occurred
    return null;
  }

  Future<void> updateToggleValue(
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


  String getCurrentuserId() {
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      // print("User is not null");
      return user.uid;
    } else {
      return '';
    }
  }

  Future<void> fetchUserDatafromfirestor() async {
    String currentuseID = '';
    currentuseID = getCurrentuserId();

    try {
      QuerySnapshot therapistsSnapshot =
          await FirebaseFirestore.instance.collection('therapists').get();

      List<Map<String, dynamic>> patients = [];

      for (var therapistDoc in therapistsSnapshot.docs) {
        QuerySnapshot assignedUsersSnapshot =
            await therapistDoc.reference.collection('assignedusers').get();

        for (var assignedUserDoc in assignedUsersSnapshot.docs) {
          if (assignedUserDoc.id == currentuseID) {
            Map<String, dynamic> userData =
                assignedUserDoc.data() as Map<String, dynamic>;
            userData['id'] = assignedUserDoc.id;

            // Initialize toggle values if not already present
            if (!userData.containsKey('toggleOne')) {
              userData['toggleOne'] = false;
            }
            if (!userData.containsKey('toggleTwo')) {
              userData['toggleTwo'] = false;
            }
            if (!userData.containsKey('toggleThree')) {
              userData['toggleThree'] = false;
            }
            if (!userData.containsKey('toggleFourth')) {
              userData['toggleFourth'] = false;
            }
            if (!userData.containsKey('toggleFivth')) {
              userData['toggleFivth'] = false;
            }
            if (!userData.containsKey('togglesixth')) {
              userData['togglesixth'] = false;
            }
            if (!userData.containsKey('toggleSeventh')) {
              userData['toggleSeventh'] = false;
            }
            if (!userData.containsKey('toggleEighth')) {
              userData['toggleEighth'] = false;
            }

            patients.add(userData);
            break; // Exit the loop once the desired assigned user document is found
          }
          
        }
      }


      // Print values of all attributes

      print('Patient: ${patients[0]['name']}');
      print('Age: ${patients[0]['age']}');
      print('Contact: ${patients[0]['phone']}');
      print('Email: ${patients[0]['email']}');
      print('Toggle One: ${patients[0]['toggleOne']}');
      print('Toggle Two: ${patients[0]['toggleTwo']}');
      print('Toggle Three: ${patients[0]['toggleThree']}');
      print('Toggle Fourth: ${patients[0]['toggleFourth']}');
      print('Toggle Five: ${patients[0]['toggleFivth']}');
      print('Toggle sixth: ${patients[0]['togglesixth']}');
      print('Toggle seven: ${patients[0]['toggleSeventh']}');
      print('Toggle eight: ${patients[0]['toggleEighth']}');
      print('------lkfga');
    } catch (error) {
      print('Error fetching user data: $error');
    }
  }

}
