import 'package:flutter/material.dart';
import 'create_pdf.dart';
import 'faculty_list_page.dart'; // Import for shared feature
import 'Courses.dart'; // Import if Courses feature is shared

class TeacherDashboard extends StatelessWidget {
  const TeacherDashboard({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: const Text('Teacher Dashboard'),
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
                  _buildDashboardTile(Icons.history_edu, 'Exam History', const TeacherDashboard(), context),
                 // _buildDashboardTile(Icons.people, 'Section List', const FacultyListPage(), context),
                  _buildDashboardTile(Icons.edit_note, 'Create Exam', const Grade(), context),
                  //_buildDashboardTile(Icons.assignment_return, 'Request for Recheck', const TeacherDashboard(), context),
                ],
              ),
            ),
          ],
        ),
      ),
      drawer: _buildCommonSidebar(context, 'Teacher Dashboard'),
    );
  }

  Widget _buildDashboardTile(IconData icon, String label, Widget destination, BuildContext context) {
    return Card(
      color: Colors.grey[900],
      child: InkWell(
        onTap: () {
          Navigator.push(context, MaterialPageRoute(builder: (context) => destination));
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

  Widget _buildCommonSidebar(BuildContext context, String dashboardTitle) {
    return Drawer(
      backgroundColor: const Color(0xff1c1c1e),
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          DrawerHeader(
            decoration: const BoxDecoration(
              color: Color(0xff281537),
            ),
            child: Text(
              dashboardTitle,
              style: const TextStyle(color: Colors.white, fontSize: 24),
            ),
          ),
          _buildSidebarItem(context, Icons.person, 'Profile'),
          _buildSidebarItem(context, Icons.book, 'Courses', destination: const Courses()),
          _buildSidebarItem(context, Icons.grade, 'Grades', destination: const Grade()),
          _buildSidebarItem(context, Icons.settings, 'Settings'),
          _buildSidebarItem(context, Icons.picture_as_pdf, 'Upload PDF'),
          _buildSidebarItem(context, Icons.timer, 'Timer'),
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
          Navigator.push(context, MaterialPageRoute(builder: (context) => destination));
        }
      },
    );
  }
}