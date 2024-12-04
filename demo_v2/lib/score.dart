import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';

class ScoreService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  /// Save or update the scanned score for a student.
  Future<void> saveScannedScore({
    required String email,  // User's email, used as the document ID in Users collection
    required String course,  // The course name
    required String name,  // The student's name
    required int scannedScore,  // The score received from the scanner
  }) async {
    try {
      // Reference to the student's document in the 'Student' subcollection
      DocumentReference studentRef = _firestore
          .collection('Users')
          .doc(email)  // User's email is used as the document ID
          .collection('Student')
          .doc(email);  // The document ID is also email for the student (since no studentId)

      // Get the student's current document data (if exists)
      DocumentSnapshot studentDoc = await studentRef.get();

      // If the document exists
      if (studentDoc.exists) {
        int currentScore = studentDoc['Score'];

        // If the current score is negative, update it with the scanned positive score
        if (currentScore < 0) {
          await studentRef.update({
            'Score': scannedScore,
          });

          print("Score updated from negative to $scannedScore.");
        } else {
          print("Score already updated. No changes made.");
        }
      } else {
        // If the document does not exist, create a new document with the scanned score
        await studentRef.set({
          'Course': course,
          'Email': email,
          'Name': name,
          'Score': scannedScore,
        });

        print("New score for $name added successfully.");
      }

      // Create a new document every time a new score is scanned (for historical purposes)
      await _createNewScoreDocument(email, course, name, scannedScore);

    } catch (e) {
      print("Error saving student score: $e");
    }
  }

  /// Create a new document in the 'StudentScores' subcollection for each scanned score
  Future<void> _createNewScoreDocument(
      String email,
      String course,
      String name,
      int scannedScore) async {
    try {
      // Reference to the 'StudentScores' subcollection under the user's document
      CollectionReference studentScoresRef = _firestore
          .collection('Users')
          .doc(email)  // User's email as document ID
          .collection('Student')
          .doc(email)  // The same email used as the student document ID
          .collection('StudentScores');  // Nested subcollection for each score

      // Add a new document with the scanned score
      await studentScoresRef.add({
        'Course': course,
        'Name': name,
        'Email': email,
        'Score': scannedScore,
      });

      print("New score document added successfully.");
    } catch (e) {
      print("Error creating new score document: $e");
    }
  }
}


class saveTest{
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  Future<void> SaveAns({
    required String teacher_email,
    required String course_code,
    required String test_id,
    required Map<String, dynamic> ansData,
    required int questionNum
  }) async{
    final testData = _firestore.collection("Test").doc();
    var page = 0;
    for(var i = 0; i < questionNum; i++){

      if((i+4)%60 == 0){
        page = page + 1;
      }
      final answerDocRef = testData.collection('Answer').doc(questionNum.toString());

      var q = i.toString();
      answerDocRef.set({
        q: {
          'Page': page,
          'Answer': -1,
          'Teacher_id': teacher_email,
          'Course_code': course_code,
          'Date_log': FieldValue.serverTimestamp()
        },
        'Test_id': test_id
      });


    }
  }

  Future<void> SaveTest({
    required String teacher_email,
    required String course_code,
    required String title
}) async{
   final testData = _firestore.collection("Test").doc();
   testData.set({
    'Teacher_id': teacher_email,
     'Course_code': course_code,
     'title': title,
     'Created_at': FieldValue.serverTimestamp()
   });
  }

  Future<Map<int, Map<int, int>> ReadAns({required String test_id})async{
   final answers = _firestore.collection("Answer");

    Map<int, int> q_n_a;

}

}