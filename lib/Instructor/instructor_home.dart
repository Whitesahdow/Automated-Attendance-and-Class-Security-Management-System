// ignore_for_file: avoid_print, use_build_context_synchronously, non_constant_identifier_names

import 'dart:convert';
import 'package:AAMCS_App/Instructor/instrct_Drawer/My_Course/instructor_course.dart';
import 'package:AAMCS_App/Instructor/instrct_Drawer/sessions/booked_session.dart';
import 'package:AAMCS_App/Student/stu_Drawer/user_info.dart';
import 'package:flutter/material.dart';
import 'package:AAMCS_App/Instructor/instrct_Drawer/instructor_profile.dart';
import 'package:AAMCS_App/Instructor/instrct_Drawer/sessions/session.dart';

import 'package:AAMCS_App/Login_out/logout.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:AAMCS_App/Instructor/instrct_Drawer/sessions/sessions_selector.dart';

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
    getStoredCourseID();
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
        backgroundColor: const Color.fromARGB(255, 17, 40, 77),
        shadowColor: const Color.fromARGB(255, 20, 19, 18),
        elevation: 2,
        title: const Text(
          'Instructor Home Page ', // Use retrieved student name
          style: TextStyle(
              fontSize: 22.0,
              fontWeight: FontWeight.bold,
              color: Color.fromARGB(255, 255, 255, 255),
              fontFamily: 'sedan'),
        ),
        leading: IconButton(
          icon: const Icon(Icons.menu),
          color:
              const Color.fromARGB(255, 255, 252, 252), // Three lines menu icon
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
                        const SizedBox(height: 8),
                        Text(
                          'Welcome, ${snapshot.data!.first_name} ${snapshot.data!.middle_name}!',
                          style: const TextStyle(
                            fontSize: 22.0,
                            fontWeight: FontWeight.bold,
                            fontFamily: 'sedan',
                          ),
                        ),
                      ],
                    ),
                  const SizedBox(height: 0),
                  Container(
                    margin: const EdgeInsets.all(0.0),
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
              const Divider(),
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
                onTap: () async {
                  await Session_checker(widget.My_Token);

                  if (sessionCheck.msg == false) {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => Session(widget.My_Token)));
                    print(
                        'Session button pressed! result is.........${sessionCheck.msg}');
                  } else {
                    print(
                        'Session button pressed! course ID is.........${sessionCheck.courseID}');
                    Navigator.pop(context);
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => BookedSessionPage(
                          courseName: sessionCheck.course_name ?? '',
                          roomNumber: sessionCheck.room ?? '',
                          section: sessionCheck.section ?? '',
                          batch: sessionCheck.batch ?? '',
                          department: sessionCheck.department ?? '',
                          time: sessionCheck.start_time ?? '',
                          My_tokens: widget.My_Token,
                          course_ID: sessionCheck.courseID,
                        ),
                      ),
                    );
                  }
                },
              ),
              const Divider(),
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
              const Divider(),
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
              const Divider(),
            ],
          );
        },
      ),
    );
  }
}

Session_Check sessionCheck = Session_Check(msg: false);
Future<void> Session_checker(String? Token) async {
  try {
    final response = await http.get(
      Uri.parse("https://besufikadyilma.tech/instructor/get-session"),
      headers: {
        "Content-Type": "application/json",
        "Authorization": "Bearer $Token"
      },
    );

    if (response.statusCode == 200) {
      var body = jsonDecode(response.body);
      sessionCheck.msg = body["msg"];
      if (sessionCheck.msg == true) {
        sessionCheck.course_name = body["session"]["course_name"];
        sessionCheck.room = body["session"]["room"];
        sessionCheck.start_time = body["session"]["start_time"];
        sessionCheck.department = body["session"]["department"];
        sessionCheck.section = body["session"]["section"];
        sessionCheck.batch = body["session"]["batch"];
        sessionCheck.Instructor_ID = body["session"]["instructor_id"];
      }
    } else {
      print("Failed to load session data: ${response.statusCode}");
    }
  } catch (e) {
    print("Error: $e");
  }
}

Future<String?> getStoredCourseID() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  // Retrieve the stored value, default to null if the placeholder is found
  sessionCheck.courseID = prefs.getString('selectedCourseID');
  return sessionCheck.courseID;
}
