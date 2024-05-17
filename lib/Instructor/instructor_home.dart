import 'dart:convert';
import 'package:AAMCS_App/Instructor/instrct_Drawer/My_Course/instructor_course.dart';
import 'package:AAMCS_App/Student/stu_Drawer/user_info.dart';
import 'package:flutter/material.dart';
import 'package:AAMCS_App/Instructor/instrct_Drawer/instructor_profile.dart';
import 'package:AAMCS_App/Instructor/instrct_Drawer/sessions/session.dart';
// import 'package:AAMCS_App/Student/My_Course/student_course.dart';
import 'package:AAMCS_App/Login_out/logout.dart';
import 'package:table_calendar/table_calendar.dart';

import 'package:http/http.dart' as http;

class InstructorHome extends StatefulWidget {
  final String? My_Token;
  const InstructorHome(this.My_Token, {super.key});

  @override
  State<InstructorHome> createState() => _StudentPageState();
}

class _StudentPageState extends State<InstructorHome> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  late Future<Instructor_info> _userDataFuture;

  @override
  void initState() {
    super.initState();
    _userDataFuture = getdata();
  }

  Future<Instructor_info> getdata() async {
    final response = await http.get(
      Uri.parse("https://besufikadyilma.tech/instructor/me"),
      headers: {
        "Content-Type": "application/json",
        "Authorization": "Bearer ${widget.My_Token}"
      },
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      final user = Instructor_info(
        first_name: data['first_name'],
        middle_name: data['middle_name'],
        last_name: data['last_name'],
        email: data['email'],
        department: data['department'],
        gender: data['gender'],
        qualification: data['qualification'],
        teacher_id: data['teacher_id'].toString(),
        id_key: data['id'],
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
        title: const Text(
          'Instructor Home Page ', // Use retrieved student name
          style: TextStyle(
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
                    const CircularProgressIndicator(),
                  if (snapshot.hasData)
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(
                          'Welcome, ${snapshot.data!.first_name} ${snapshot.data!.middle_name}!',
                          style: const TextStyle(
                            fontSize: 22.0,
                            fontWeight: FontWeight.bold,
                            fontFamily: 'sedan',
                          ),
                        ),
                        const SizedBox(height: 20),
                        Text(
                          'Email: ${snapshot.data!.email}',
                          style: const TextStyle(
                            fontSize: 18.0,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  const SizedBox(height: 20),
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
                        : const CircularProgressIndicator(),
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
                        : const CircularProgressIndicator(),
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
                          builder: (context) =>
                              Instructor_course(widget.My_Token)));
                  print(
                      'My Courses button pressed!....................................${widget.My_Token}');
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
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => Session(widget.My_Token)));
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
                          builder: (context) =>
                              InstructorProfile(widget.My_Token)));
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
                  String usertype = "Teacher";
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) =>
                              LogoutPage(widget.My_Token, usertype)));
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
