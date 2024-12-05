import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class Courses extends StatefulWidget {
  const Courses({Key? key}) : super(key: key);

  @override
  _CoursesPageState createState() => _CoursesPageState();
}

class _CoursesPageState extends State<Courses> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Fetch the current user's admitted courses
  Future<List<Map<String, dynamic>>> _getUserCourses() async {
    User? user = _auth.currentUser;
    if (user != null) {
      var userCoursesSnapshot = await _firestore
          .collection('UserCourses')
          .where('userId', isEqualTo: user.uid)
          .get();

      List<Map<String, dynamic>> userCourses = [];
      for (var doc in userCoursesSnapshot.docs) {
        var courseData = doc.data();
        userCourses.add({
          'Course Name': courseData['Course Name'],
          'Course ID': courseData['Course ID'],
          'Credit': courseData['Credit'],
          'id': doc.id, // Include document ID for deletion
        });
      }
      return userCourses;
    }
    return [];
  }

  // Fetch available courses from the main courses collection
  Future<List<Map<String, dynamic>>> _getAvailableCourses() async {
  try {
    var coursesSnapshot = await _firestore.collection('Course List').get();
    List<Map<String, dynamic>> courses = [];
    for (var doc in coursesSnapshot.docs) {
      courses.add(doc.data());
    }
    print('Fetched courses: $courses'); // Debugging
    return courses;
  } catch (e) {
    print('Error fetching courses: $e');
    return [];
  }
}

  // Add a course to the user's admitted courses
  Future<void> _addCourse(Map<String, dynamic> course) async {
    User? user = _auth.currentUser;
    if (user != null) {
      await _firestore.collection('UserCourses').add({
        'userId': user.uid,
        'Course Name': course['Course Name'],
        'Course ID': course['Course ID'],
        'Credit': course['Credit'],
      });
      setState(() {});
    }
  }

  // Remove a course from the user's admitted courses
  Future<void> _removeCourse(String courseId) async {
    User? user = _auth.currentUser;
    if (user != null) {
      var userCoursesSnapshot = await _firestore
          .collection('UserCourses')
          .where('userId', isEqualTo: user.uid)
          .where('Course ID', isEqualTo: courseId)
          .get();

      for (var doc in userCoursesSnapshot.docs) {
        await doc.reference.delete();
      }
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Courses'),
        backgroundColor: const Color(0xff6a3f7b),
      ),
      body: FutureBuilder<List<Map<String, dynamic>>>(
        future: _getUserCourses(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('No admitted courses.'));
          }

          List<Map<String, dynamic>> courses = snapshot.data!;
          return ListView.builder(
            itemCount: courses.length,
            itemBuilder: (context, index) {
              return Card(
                color: Colors.grey[900],
                margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
                child: ListTile(
                  title: Text(
                    courses[index]['Course Name'],
                    style: const TextStyle(color: Colors.white),
                  ),
                  subtitle: Text(
                    'Course ID: ${courses[index]['Course ID']}, Credits: ${courses[index]['Credit']}',
                    style: const TextStyle(color: Colors.white70),
                  ),
                  trailing: IconButton(
                    icon: const Icon(Icons.delete, color: Colors.white),
                    onPressed: () {
                      _removeCourse(courses[index]['Course ID']);
                    },
                  ),
                ),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _showAddCourseDialog(context);
        },
        child: const Icon(Icons.add),
        backgroundColor: const Color(0xff6a3f7b),
      ),
    );
  }

  // Show dialog to add courses from available options
void _showAddCourseDialog(BuildContext context) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return FutureBuilder<List<Map<String, dynamic>>>(
        future: _getAvailableCourses(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return AlertDialog(
              title: const Text('Error'),
              content: const Text('Failed to fetch courses. Please try again.'),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: const Text('Close'),
                ),
              ],
            );
          }

          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return AlertDialog(
              title: const Text('No Courses Available'),
              content: const Text('There are no available courses to add.'),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: const Text('Close'),
                ),
              ],
            );
          }

          List<Map<String, dynamic>> courses = snapshot.data!;
          return AlertDialog(
            title: const Text('Add Course'),
            content: SizedBox(
              width: double.maxFinite,
              height: 300,
              child: ListView.builder(
                itemCount: courses.length,
                itemBuilder: (context, index) {
                  return ListTile(
                    title: Text(courses[index]['Course Name']),
                    subtitle: Text(
                        'Course ID: ${courses[index]['Course ID']}, Credits: ${courses[index]['Credit']}'),
                    onTap: () {
                      _addCourse(courses[index]);
                      Navigator.of(context).pop();
                    },
                  );
                },
              ),
            ),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: const Text('Cancel'),
              ),
            ],
          );
        },
      );
    },
  );
}
}