import 'package:cloud_firestore/cloud_firestore.dart';

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
}
