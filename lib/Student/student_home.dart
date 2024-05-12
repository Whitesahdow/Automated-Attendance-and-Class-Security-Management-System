import 'dart:convert';
import 'package:AAMCS_App/Student/stu_Drawer/Drawer_menu.dart';
import 'package:AAMCS_App/Student/stu_Drawer/user_info.dart';
import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:http/http.dart' as http;

class StudentHome extends StatefulWidget {
  @override
  State<StudentHome> createState() => _StudentPageState();
}

class _StudentPageState extends State<StudentHome> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  late Future<user_info> _userDataFuture;
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        // backgroundColor: Color.fromARGB(255, 174, 138, 47), AASTU brand colors
        backgroundColor: Color.fromARGB(255, 17, 40, 77),
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
          onPressed: () => _scaffoldKey.currentState!.openDrawer(),
        ),
      ),
      body: Container(
        color: Color.fromARGB(205, 198, 200, 202),
        child: FutureBuilder<user_info>(
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
          },
        ),
      ),
      drawer: const DrawerWidget(),
    );
  }
}
