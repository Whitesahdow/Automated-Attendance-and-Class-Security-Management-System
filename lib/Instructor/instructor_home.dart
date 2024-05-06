import 'dart:convert';
import 'package:AAMCS_App/Instructor/My_Course/instructor_course.dart';
import 'package:flutter/material.dart';
import 'package:AAMCS_App/Instructor/instructor_profile.dart';
import 'package:AAMCS_App/Instructor/session.dart';
// import 'package:AAMCS_App/Student/My_Course/student_course.dart';
import 'package:AAMCS_App/Login_out/logout.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:AAMCS_App/Student/user_info.dart';
import 'package:http/http.dart' as http;

class InstructorHome extends StatefulWidget {
  const InstructorHome({super.key});
  @override
  State<InstructorHome> createState() => _StudentPageState();
}

class _StudentPageState extends State<InstructorHome> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  late Future<user_info> _userDataFuture;
  // Replace with actual logic to retrieve student information (e.g., API call)
  // String get firstName =>
  //     "Mr. Bereketab"; // Replace with actual student's first name
  // String get lastName => "Heyi";
  // String get middleName => 'Belete';
  // String get gender => 'Male';
  // String get instructorId => 'INS0187/10';
  // String get email => 'bereketabbelete@gmail.com';
  // String get phoneNumber => '+251934607224';
  // String get department => 'electrical and Computer engineering';
  // String get qualification => 'BSC computer en';
  // String get courseName => 'Mobile Development';
  // String get roomNumber => 'B203';
  // bool get isCancelled => false;
  // get announcement => "The session will start in 10 min";
  // get accountImage => 'assets/images/profile.png';
  @override
  void initState() {
    super.initState();
    _userDataFuture = getdata();
  }

  Future<user_info> getdata() async {
    final response = await http.get(Uri.parse("https://reqres.in/api/users/2"));

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body)['data'];
      final user = user_info(
        first_name: data['first_name'],
        last_name: data['last_name'],
        email: data['email'],
        id: data['id'].toString(),
      );
      return user;
    } else {
      throw Exception('Failed to load data');
    }
  }

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
          'Instructor Home Page ', // Use retrieved student name
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
      body: FutureBuilder(
          future: _userDataFuture,
          builder: (context, snapshot) {
            return Center(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  if (snapshot.connectionState == ConnectionState.waiting)
                    CircularProgressIndicator(),
                  if (snapshot.hasData)
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(
                          'Welcome, ${snapshot.data!.first_name} ${snapshot.data!.last_name}!',
                          style: const TextStyle(
                            fontSize: 22.0,
                            fontWeight: FontWeight.bold,
                            fontFamily: 'sedan',
                          ),
                        ),
                        SizedBox(height: 20),
                        Text(
                          'Email: ${snapshot.data!.email}',
                          style: const TextStyle(
                            fontSize: 18.0,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  SizedBox(height: 20),
                  Container(
                    margin: const EdgeInsets.all(16.0),
                    child: TableCalendar(
                      rowHeight: 40,
                      calendarFormat: CalendarFormat.month,
                      headerStyle: const HeaderStyle(
                        formatButtonVisible: false,
                        titleCentered: true,
                      ),
                      availableGestures: AvailableGestures.all,
                      selectedDayPredicate: (day) => isSameDay(day, today),
                      focusedDay: today,
                      firstDay: DateTime.utc(2019, 2, 1),
                      lastDay: DateTime.utc(2024, 11, 1),
                      onDaySelected: _onDaySelected,
                    ),
                  ),
                ],
              ),
            );
          }),
      drawer: _buildDrawer(), // Build the Drawer widget
    );
  }

  Widget _buildDrawer() {
    return Drawer(
      child: FutureBuilder(
        future: _userDataFuture,
        builder: (context, snapshot) {
          return ListView(
            shrinkWrap: true,
            padding: const EdgeInsets.only(),
            children: [
              UserAccountsDrawerHeader(
                accountName: snapshot.hasData
                    ? Text(
                        '${snapshot.data!.first_name} ${snapshot.data!.last_name}',
                        style: const TextStyle(
                          fontFamily: 'Sedan',
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      )
                    : snapshot.hasError
                        ? Text(
                            'Error Loading Name: ${snapshot.error}',
                            style: const TextStyle(
                              fontFamily: 'Sedan',
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          )
                        : CircularProgressIndicator(),
                accountEmail: snapshot.hasData
                    ? Text(
                        snapshot.data!.email,
                        style: const TextStyle(
                          fontFamily: 'Sedan',
                          fontSize: 16,
                          fontWeight: FontWeight.normal,
                          fontStyle: FontStyle.italic,
                        ),
                      )
                    : snapshot.hasError
                        ? Text(
                            'Error Loading Email: ${snapshot.error}',
                            style: const TextStyle(
                              fontFamily: 'Sedan',
                              fontSize: 16,
                              fontWeight: FontWeight.normal,
                              fontStyle: FontStyle.italic,
                            ),
                          )
                        : CircularProgressIndicator(),
                currentAccountPicture: CircleAvatar(
                  child: ClipOval(
                    child: Image.asset(
                      'assets/icons/user.png',
                      width: 90,
                      height: 90,
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                decoration: const BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage('assets/images/school1.png'),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              ListTile(
                title: Row(
                  children: [
                    Image.asset(
                      'assets/icons/course.png',
                      width: 25.0,
                      height: 25.0,
                    ),
                    const SizedBox(width: 10.0),
                    const Text(
                      'My Courses',
                      style: TextStyle(
                        fontFamily: 'Sedan',
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => Instructor_course()));
                  print('My Courses button pressed!');
                },
              ),
              ListTile(
                title: Row(
                  children: [
                    Image.asset(
                      'assets/icons/announcement.png',
                      width: 25.0,
                      height: 25.0,
                    ),
                    const SizedBox(width: 10.0),
                    const Text(
                      'Session',
                      style: TextStyle(
                        fontFamily: 'Sedan',
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                onTap: () {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => const Session()));
                  print('Session button pressed!');
                },
              ),
              ListTile(
                title: Row(
                  children: [
                    Image.asset(
                      'assets/icons/profile.png',
                      width: 25.0,
                      height: 25.0,
                    ),
                    const SizedBox(width: 10.0),
                    const Text(
                      'Profile',
                      style: TextStyle(
                        fontFamily: 'Sedan',
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => InstructorProfile(
                                first_name: snapshot.hasData
                                    ? snapshot.data!.first_name
                                    : '',
                                last_name: snapshot.hasData
                                    ? snapshot.data!.last_name
                                    : '',
                                email: snapshot.hasData
                                    ? snapshot.data!.email
                                    : '',
                                id: snapshot.hasData ? snapshot.data!.id : '',
                              )));
                  print('Profile button pressed!');
                },
              ),
              ListTile(
                title: Row(
                  children: [
                    Image.asset(
                      'assets/icons/logout.png',
                      width: 25.0,
                      height: 25.0,
                    ),
                    const SizedBox(width: 10.0),
                    const Text(
                      'Logout',
                      style: TextStyle(
                        fontFamily: 'Sedan',
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const LogoutPage()));
                  print('Logout button pressed!');
                },
              ),
            ],
          );
        },
      ),
    );
  }
}
