// ignore_for_file: unused_local_variable, library_private_types_in_public_api, non_constant_identifier_names

import 'dart:convert';
import 'dart:math';
import 'package:AAMCS_App/Student/My_Course/course_list.dart';
import 'package:AAMCS_App/Student/My_Course/student_attendance.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

List<AttendanceRecord> attendanceRecords = [];
List<AttendanceRecord> attendanceLoop() {
  for (int i = 1; i <= 10; i++) {
    // Generate random date and status for each record
    final date = DateTime.now().subtract(Duration(days: i));

    final status = Random().nextBool()
        ? AttendanceStatus.present
        : AttendanceStatus.absent;
    String? clockIn;
    String? clockOut;
    if (status == AttendanceStatus.present) {
      // Generate random clock in/out times (assuming 8-hour workday)
      final hourIn = Random().nextInt(9) + 8;
      final minuteIn = Random().nextInt(60);
      final hourOut =
          hourIn + (Random().nextInt(3) + 1); // Between 1-3 hours later
      final minuteOut = minuteIn;
      clockIn =
          "${hourIn.toString().padLeft(2, '0')}:${minuteIn.toString().padLeft(2, '0')}";
      clockOut =
          "${hourOut.toString().padLeft(2, '0')}:${minuteOut.toString().padLeft(2, '0')}";
    }
    attendanceRecords.add(AttendanceRecord(date, status, clockIn, clockOut));
  }
  return attendanceRecords;
}

class StudentCourseDetail extends StatefulWidget {
  final String? My_Token;
  final String id;
  StudentCourseDetail(this.My_Token, this.id, {super.key});

  @override
  State<StudentCourseDetail> createState() => _InstructorCourseDetailState();
}

class _InstructorCourseDetailState extends State<StudentCourseDetail> {
  late Future<StuCrssDetails> _dataFuture;
  List<AttendanceRecord> attendanceRecord = attendanceLoop();

  @override
  void initState() {
    super.initState();
    _dataFuture = getdata();
  }

  Future<StuCrssDetails> getdata() async {
    final response = await http.get(
      Uri.parse("https://besufikadyilma.tech/course/getid/${widget.id}"),
      headers: {
        "Content-Type": "application/json",
        "Authorization": "Bearer ${widget.My_Token}"
      },
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      print(data);
      final courseDetails = StuCrssDetails(
        course_category: data['course_category'],
        course_code: data['course_code'],
        course_credit: data['course_credit'],
        course_department: data['course_department'],
        course_name: data['course_name'],
        id: data['id'],
      );
      return courseDetails;
    } else {
      throw Exception('Failed to load data');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Course Detail',
          style: TextStyle(
            fontFamily: 'Sedan',
            fontSize: 22,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: const Color.fromARGB(255, 170, 163, 163),
      ),
      body: FutureBuilder<StuCrssDetails>(
        future: _dataFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return const Center(child: Text('Error: Cant find anything'));
          } else {
            final courseDetails = snapshot.data!;
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text('course_code: ${snapshot.data!.course_code}'),
                  Text('course_name: ${snapshot.data!.course_name}'),
                  Text('course_category: ${snapshot.data!.course_category}} '),
                  Text(
                      'course_department: ${snapshot.data!.course_department}'),
                  Text('course_credit: ${snapshot.data!.course_credit} '),
                  Text('Id key: ${snapshot.data!.id} '),
                  Center(
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => AttendanceList(
                              attendanceRecords: attendanceRecord,
                            ),
                          ),
                        );
                      },
                      child: const Text(
                        'My Attendance',
                        style: TextStyle(
                          color: Colors.black,
                          fontFamily: 'sedan',
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            );
          }
        },
      ),
    );
  }
}
