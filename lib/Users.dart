
import 'package:cloud_firestore/cloud_firestore.dart';


class Users{

  late String email;
  late String name;



  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
//teacher(email): Courses [section+course_code]
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
  //student: name, course_list [course_code+section] test subcollection: testid, score
  void insertStudent(String email){
    _firestore.collection('Student').doc(email).set({

      'Courses':[]

    });
    //section: course_code+sectionnumber, teacherId(email)
    //test: testId, courseId+sectionnumber, Answer(question): answer_key
  }

}