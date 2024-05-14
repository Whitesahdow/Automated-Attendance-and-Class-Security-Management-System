import 'dart:convert';
import 'package:AAMCS_App/Student/stu_Drawer/Drawer_menu.dart';
import 'package:AAMCS_App/Student/stu_Drawer/user_info.dart';
import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:http/http.dart' as http;

import 'package:AAMCS_App/Login_out/controllers/auth_cntrl.dart';

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
    // print(
    //     'My_Token received in StudentHome: ${auth_controller.reuest_responese.token}');
    AuthController auth_controller = AuthController();

    _userDataFuture = getdata();
  }

  // dynamic get beki => widget.My_Token;

  Future<Student_info> getdata() async {
    // print(auth_controller.loginArr.toString());

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
      );
      print(data);
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
                          'Welcome, ${snapshot.data!.first_name} ${snapshot.data!.last_name}!',
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
          },
        ),
      ),
      drawer: DrawerWidget(widget.My_Token),
    );
  }
}
