import 'package:flutter/material.dart';
import 'package:AAMCS_App/Student/My_Course/student_course.dart';
import 'package:AAMCS_App/Login_out/logout.dart';
import 'package:AAMCS_App/Student/student_announcement.dart';
import 'package:AAMCS_App/Student/student_profile.dart';
import 'package:table_calendar/table_calendar.dart';

class StudentHome extends StatefulWidget {
  const StudentHome({super.key});
  @override
  State<StudentHome> createState() => _StudentPageState();
}

class _StudentPageState extends State<StudentHome> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  // Replace with actual logic to retrieve student information (e.g., API call)
  String get firstName =>
      "Bereketeab"; // Replace with actual student's first name
  String get lastName => "Heyi";
  String get middleName => 'Belete';
  String get gender => 'Male';
  String get studentId => 'ETS0966/12';
  String get email => 'bereketab@gmail.com';
  String get department => 'electrical and Computer engineering';
  String get batchSection => '5th year section A';
  String get courseName => 'Mobile Development';
  String get roomNumber => 'B203';
  bool get isCancelled => false;
  get announcement => "The session will start in 10 min";
  get accountImage => 'assets/images/profile.png';
  DateTime today = DateTime.now();
  void _onDaySelected(DateTime day, DateTime focusday) {
    setState(() {
      today = day;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey, // Assign key to Scaffold
      appBar: AppBar(
        title: Text(
          'Welcome, $firstName !', // Use retrieved student name
          style: const TextStyle(
              fontSize: 22.0,
              fontWeight: FontWeight.bold,
              fontFamily: 'sedan'), // Adjust title font size
        ),
        leading: IconButton(
          icon: const Icon(Icons.menu), // Three lines menu icon
          onPressed: () =>
              _scaffoldKey.currentState!.openDrawer(), // Open Drawer on tap
        ),
      ),
      body: Center(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          // Center content vertically
          children: [
            const SizedBox(child: Center()),
            Container(
              // Use a container to wrap the calendar
              margin: const EdgeInsets.all(16.0),
              child: TableCalendar(
                rowHeight: 40,
                calendarFormat: CalendarFormat.month,
                headerStyle: const HeaderStyle(
                    formatButtonVisible: false, titleCentered: true),
                availableGestures: AvailableGestures.all,
                selectedDayPredicate: (day) => isSameDay(day, today),
                focusedDay: today,
                firstDay: DateTime.utc(2019, 2, 1),
                lastDay: DateTime.utc(2024, 11, 1),
                onDaySelected: _onDaySelected,
              ),
            )
          ],
        ),
      ),
      drawer: _buildDrawer(), // Build the Drawer widget
    );
  }

  Widget _buildDrawer() {
    return Drawer(
      child: ListView(
        // Avoids scrolling issues with a limited number of items

        shrinkWrap: true,
        padding: const EdgeInsets.only(),
        children: [
          UserAccountsDrawerHeader(
            accountName: Text(
              firstName,
              style: const TextStyle(
                fontFamily: 'Sedan',
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            accountEmail: Text(
              email,
              style: const TextStyle(
                  fontFamily: 'Sedan',
                  fontSize: 16,
                  fontWeight: FontWeight.normal,
                  fontStyle: FontStyle.italic),
            ),
            currentAccountPicture: CircleAvatar(
                child: ClipOval(
              child: Image.asset(
                'assets/icons/user.png',
                width: 90,
                height: 90,
                fit: BoxFit.cover,
              ),
            )),
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/images/school1.png'),
                fit: BoxFit.cover,
              ),
            ),
          ),
          ListTile(
            title: Row(
              // Combine icon and text in a Row
              children: [
                Image.asset(
                  // Use Image.asset for assets within your project
                  'assets/icons/course.png', // Replace with your icon path
                  width: 25.0, // Adjust width as needed
                  height: 25.0, // Adjust height as needed
                ),
                const SizedBox(width: 10.0), // Spacing between icon and text
                const Text(
                  'My Courses',
                  style: TextStyle(
                      fontFamily: 'Sedan',
                      fontSize: 16,
                      fontWeight: FontWeight.bold),
                ),
              ],
            ),
            onTap: () {
              // Navigate to My Courses page
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => MyCourses()));
              // ignore: avoid_print
              print('My Courses button pressed!');
            },
          ),
          ListTile(
            title: Row(
              // Combine icon and text in a Row
              children: [
                Image.asset(
                  // Use Image.asset for assets within your project
                  'assets/icons/announcement.png', // Replace with your icon path
                  width: 25.0, // Adjust width as needed
                  height: 25.0, // Adjust height as needed
                ),
                const SizedBox(width: 10.0), // Spacing between icon and text
                const Text(
                  'Announcements',
                  style: TextStyle(
                      fontFamily: 'Sedan',
                      fontSize: 16,
                      fontWeight: FontWeight.bold),
                ),
              ],
            ),
            onTap: () {
              // Navigate to Announcements page (implementation needed)
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => Announcement(
                            courseName: courseName,
                            roomNumber: roomNumber,
                            isCancelled: isCancelled,
                            announcement: announcement,
                          )));
              // ignore: avoid_print
              print('Announcements button pressed!');
            },
          ),
          ListTile(
            title: Row(
              // Combine icon and text in a Row
              children: [
                Image.asset(
                  // Use Image.asset for assets within your project
                  'assets/icons/profile.png', // Replace with your icon path
                  width: 25.0, // Adjust width as needed
                  height: 25.0, // Adjust height as needed
                ),
                const SizedBox(width: 10.0), // Spacing between icon and text
                const Text(
                  'Profile',
                  style: TextStyle(
                      fontFamily: 'Sedan',
                      fontSize: 16,
                      fontWeight: FontWeight.bold),
                ),
              ],
            ),
            onTap: () {
              // Navigate to Profile page
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => StudentProfile(
                            firstName: firstName,
                            lastName: lastName,
                            middleName: middleName,
                            gender: gender,
                            studentId: studentId,
                            email: email,
                            department: department,
                            batchSection: batchSection,
                          )));
              // ignore: avoid_print
              print('Profile button pressed!');
            },
          ),
          ListTile(
            title: Row(
              // Combine icon and text in a Row
              children: [
                Image.asset(
                  // Use Image.asset for assets within your project
                  'assets/icons/logout.png', // Replace with your icon path
                  width: 25.0, // Adjust width as needed
                  height: 25.0, // Adjust height as needed
                ),
                const SizedBox(width: 10.0), // Spacing between icon and text
                const Text(
                  'Logout',
                  style: TextStyle(
                      fontFamily: 'Sedan',
                      fontSize: 16,
                      fontWeight: FontWeight.bold),
                ),
              ],
            ),
            onTap: () {
              // Navigate to Logout page or implement logout logic
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => const LogoutPage()));
              // ignore: avoid_print
              print('Logout button pressed!');
            },
          ),
        ],
      ),
    );
  }
}
