import 'package:flutter/material.dart';
import 'package:AAMCS_App/Instructor/instructor_profile.dart';
import 'package:AAMCS_App/Instructor/session.dart';
import 'package:AAMCS_App/Student/My_Course/student_course.dart';
import 'package:AAMCS_App/Login_out/logout.dart';
import 'package:table_calendar/table_calendar.dart';

class InstructorHome extends StatefulWidget {
  const InstructorHome({super.key});
  @override
  State<InstructorHome> createState() => _StudentPageState();
}

class _StudentPageState extends State<InstructorHome> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  // Replace with actual logic to retrieve student information (e.g., API call)
  String get firstName =>
      "Mr. Bereketab"; // Replace with actual student's first name
  String get lastName => "Heyi";
  String get middleName => 'Belete';
  String get gender => 'Male';
  String get instructorId => 'INS0187/10';
  String get email => 'bereketabbelete@gmail.com';
  String get phoneNumber => '+251934607224';
  String get department => 'electrical and Computer engineering';
  String get qualification => 'BSC computer en';
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
                  'assets/icons/course.png',
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
                  'assets/icons/announcement.png',
                  width: 25.0,
                  height: 25.0,
                ),
                const SizedBox(width: 10.0), // Spacing between icon and text
                const Text(
                  'Session',
                  style: TextStyle(
                      fontFamily: 'Sedan',
                      fontSize: 16,
                      fontWeight: FontWeight.bold),
                ),
              ],
            ),
            onTap: () {
              // Navigate to Announcements page (implementation needed)
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => const Session()));
              // ignore: avoid_print
              print('Session button pressed!');
            },
          ),
          // profile
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
                      builder: (context) => InstructorProfile(
                            firstName: firstName,
                            lastName: lastName,
                            middleName: middleName,
                            gender: gender,
                            instructorId: instructorId,
                            email: email,
                            phoneNumber: phoneNumber,
                            department: department,
                            qualification: qualification,
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
