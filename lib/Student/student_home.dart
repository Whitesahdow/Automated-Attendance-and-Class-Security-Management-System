// ignore_for_file: non_constant_identifier_names

import 'dart:convert';
import 'package:AAMCS_App/Login_out/logout.dart';
import 'package:AAMCS_App/Student/My_Course/student_course.dart';
import 'package:AAMCS_App/Student/stu_Drawer/student_announcement.dart';
import 'package:AAMCS_App/Student/stu_Drawer/student_profile.dart';
import 'package:AAMCS_App/Student/stu_Drawer/user_info.dart';
import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:http/http.dart' as http;

// import 'package:AAMCS_App/Login_out/controllers/auth_cntrl.dart';

class StudentHome extends StatefulWidget {
  final String? My_Token;

  const StudentHome(this.My_Token, {super.key});

  @override
  State<StudentHome> createState() => _StudentPageState();
}

class _StudentPageState extends State<StudentHome> {
  //final String? My_Token = ;
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  late Future<Student_info> _userDataFuture;
  DateTime today = DateTime.now();

  void _onDaySelected(DateTime day, DateTime focusday) {
    setState(() {
      today = day;
    });
  }

  @override
  void initState() {
    super.initState();

    _userDataFuture = getdata();
  }

  Future<Student_info> getdata() async {
    final response = await http.get(
      Uri.parse("https://besufikadyilma.tech/student/me"),
      headers: {
        "Content-Type": "application/json",
        "Authorization": "Bearer ${widget.My_Token}"
      },
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      final user = Student_info(
        first_name: data['first_name'],
        middle_name: data['middle_name'],
        last_name: data['last_name'],
        email: data['email'],
        department: data['department'],
        gender: data['gender'],
        batch: data['batch'],
        section: data['section'],
        id: data['student_id'].toString(),
        id_key: data['id'],
      );
      //print(data);
      return user;
    } else {
      throw Exception('Failed to load data');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        // backgroundColor: Color.fromARGB(255, 174, 138, 47), AASTU brand colors
        backgroundColor: const Color.fromARGB(255, 17, 40, 77),
        elevation: 3,
        shadowColor: const Color.fromARGB(255, 20, 19, 18),
        title: const Text(
          'Student Home Page',
          style: TextStyle(
            fontSize: 22.0,
            fontWeight: FontWeight.bold,
            fontFamily: 'sedan',
            color: Color.fromARGB(255, 255, 255, 255),
          ),
        ),
        leading: IconButton(
            icon: const Icon(
              Icons.menu,
              color: Color.fromARGB(255, 255, 252, 252),
            ),
            onPressed: () {
              _scaffoldKey.currentState!.openDrawer();
              //print();
            }),
      ),
      body: Container(
        color: const Color.fromARGB(205, 198, 200, 202),
        child: FutureBuilder<Student_info>(
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
                  Expanded(
                    child: Image.asset("assets/images/Maps.jpg"),
                  ),
                ],
              ),
            );
          },
        ),
      ),
      drawer: _buildDrawer(),
    );
  }

  Widget _buildDrawer() {
    return Drawer(
      child: FutureBuilder(
        future: _userDataFuture,
        builder: (context, AsyncSnapshot<Student_info> snapshot) {
          return ListView(
            shrinkWrap: true,
            padding: const EdgeInsets.only(),
            children: [
              UserAccountsDrawerHeader(
                accountName: snapshot.hasData
                    ? Text(
                        '${snapshot.data!.first_name} ${snapshot.data!.middle_name}',
                        style: const TextStyle(
                          fontFamily: 'Sedan',
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      )
                    : const Text(
                        'Error Loading Data.........',
                        style: TextStyle(
                          fontFamily: 'Sedan',
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
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
                    : const Text(
                        'Error Loading Data',
                        style: TextStyle(
                          fontFamily: 'Sedan',
                          fontSize: 16,
                          fontWeight: FontWeight.normal,
                          fontStyle: FontStyle.italic,
                        ),
                      ),
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
                        builder: (context) => Student_Course(
                            widget.My_Token, snapshot.data!.id_key)),
                  );
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
                      'Announcements',
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
                      builder: (context) => Announcement(
                        my_token: widget.My_Token,
                      ),
                    ),
                  );
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
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => StudentProfile(widget.My_Token),
                    ),
                  );
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
                  String usertype = "Student";
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) =>
                            LogoutPage(widget.My_Token, usertype)),
                  );
                },
              ),
            ],
          );
        },
      ),
    );
  }
}
