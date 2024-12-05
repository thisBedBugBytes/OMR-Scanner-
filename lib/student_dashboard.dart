import 'package:demo_v2/request.dart';
import 'package:demo_v2/scanner.dart';
import 'package:demo_v2/score.dart'; // Import the score page
import 'package:flutter/material.dart';
import 'faculty_list_page.dart';
import 'Courses.dart';

class StudentDashboard extends StatelessWidget {
  const StudentDashboard({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: const Text('Student Dashboard'),
        backgroundColor: const Color(0xff6a3f7b),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // Search Bar
            TextField(
              decoration: InputDecoration(
                hintText: 'Search',
                prefixIcon: const Icon(Icons.search),
                filled: true,
                fillColor: Colors.white,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
            const SizedBox(height: 20),
            // Dashboard Options
            Expanded(
              child: GridView(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 16,
                  mainAxisSpacing: 16,
                ),
                children: [
                  _buildDashboardTile(Icons.people, 'Faculty List', const FacultyListPage(), context),
                  _buildDashboardTile(Icons.edit_note, 'Current Exam', const StudentDashboard(), context),
                 // _buildDashboardTile(Icons.upload_file, 'Upload OMR', const Scanner(), context),
                  _buildDashboardTile(Icons.assignment_return, 'Request for Recheck', const request(), context),
                ],
              ),
            ),
          ],
        ),
      ),
      drawer: _buildStudentSidebar(context),
    );
  }

  Widget _buildDashboardTile(IconData icon, String label, Widget? destination, BuildContext context) {
    if (label == 'Upload OMR') {
      // Handle Upload OMR functionality
      return Card(
        color: Colors.grey[900],
        child: InkWell(
          onTap: () async {
            Scanner scanner = Scanner(context);
            await scanner.onPressed();
          },
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, size: 50, color: Colors.white),
              const SizedBox(height: 10),
              Text(
                label,
                style: const TextStyle(color: Colors.white, fontSize: 16),
              ),
            ],
          ),
        ),
      );
    } else {
      return Card(
        color: Colors.grey[900],
        child: InkWell(
          onTap: () {
            if (destination != null) {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => destination),
              );
            }
          },
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, size: 50, color: Colors.white),
              const SizedBox(height: 10),
              Text(
                label,
                style: const TextStyle(color: Colors.white, fontSize: 16),
              ),
            ],
          ),
        ),
      );
    }
  }

  Widget _buildStudentSidebar(BuildContext context) {
    return Drawer(
      backgroundColor: const Color(0xff1c1c1e),
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          const DrawerHeader(
            decoration: BoxDecoration(
              color: Color(0xff281537),
            ),
            child: Text(
              'Student Dashboard',
              style: TextStyle(color: Colors.white, fontSize: 24),
            ),
          ),
          _buildSidebarItem(context, Icons.person, 'Profile'),
          _buildSidebarItem(context, Icons.book, 'Courses', destination: const Courses()),
          _buildSidebarItem(context, Icons.grade, 'Grades', destination: const ScorePage()),
          _buildSidebarItem(context, Icons.settings, 'Settings'),
          _buildSidebarItem(context, Icons.upload_file, 'Upload OMR'),
          _buildSidebarItem(context, Icons.people, 'Faculty Lists', destination: const FacultyListPage()),
          _buildSidebarItem(context, Icons.exit_to_app, 'Sign Out', isSignOut: true),
        ],
      ),
    );
  }

  ListTile _buildSidebarItem(BuildContext context, IconData icon, String title, {Widget? destination, bool isSignOut = false}) {
    return ListTile(
      leading: Icon(icon, color: Colors.white),
      title: Text(title, style: const TextStyle(color: Colors.white)),
      onTap: () {
        if (isSignOut) {
          Navigator.popUntil(context, ModalRoute.withName('/')); // Sign out logic
        } else if (destination != null) {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => destination),
          );
        }
      },
    );
  }
}