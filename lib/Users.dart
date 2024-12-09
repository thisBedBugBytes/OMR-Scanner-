
import 'package:cloud_firestore/cloud_firestore.dart';


class Users{

  late String email;
  late String name;



  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  void insertTeacher(String email){
    _firestore.collection('Faculties').doc(email).set({

      'Courses':[]
    });
  }
  dynamic selectTeacher(String email){
   var teach = _firestore.collection('Faculties').doc(email).get();
   return teach;
  }
  Future<dynamic> getTeacherCourse(String email) async {
    final query = await _firestore.collection('Faculties').doc(email).get();
    List <String> courseList = [];
    if(query.exists){
      var data = query.data();
      courseList = data?['Courses'];
    }
    return courseList;
  }
  void insertStudent(String email){
    _firestore.collection('Student').doc(email).set({

      'Courses':[]

    });
  }

}