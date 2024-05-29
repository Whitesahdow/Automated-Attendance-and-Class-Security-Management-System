import 'dart:convert';

import 'package:AAMCS_App/Instructor/instrct_Drawer/sessions/started_class.dart';
import 'package:AAMCS_App/Instructor/instructor_home.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart'; // For HapticFeedback
import 'package:http/http.dart' as http;

class BookedSessionPage extends StatefulWidget {
  final String courseName;
  final String roomNumber;
  final String section;
  final String batch;
  final String department;
  final String time;
  final String? My_tokens;
  final String? course_ID;
  final String? instructor_id;

  const BookedSessionPage(
      {super.key,
      required this.courseName,
      required this.roomNumber,
      required this.section,
      required this.batch,
      required this.department,
      required this.time,
      this.My_tokens,
      this.course_ID,
      this.instructor_id});

  @override
  State<BookedSessionPage> createState() => _BookedSessionPageState();
}

class _BookedSessionPageState extends State<BookedSessionPage> {
  bool _isReserved = true; // Flag to track reservation status
  @override
  void initState() {
    super.initState();
    // Perform any initialization tasks here
    print('BookedSessionPage initialized');
    //getStoredCourseID(); // For example, retrieve stored course ID
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          _isReserved ? 'Booked Session' : 'Session Canceled',
          style: const TextStyle(
            fontFamily: 'sedan',
            fontSize: 22,
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (_isReserved || // Show details even if reserved but empty
                widget.courseName.isNotEmpty ||
                widget.roomNumber.isNotEmpty ||
                widget.section.isNotEmpty ||
                widget.batch.isNotEmpty ||
                widget.department.isNotEmpty ||
                widget.time.isNotEmpty)
              Text(
                'Course Name : ${widget.courseName}',
                style: const TextStyle(
                  fontFamily: 'sedan',
                  fontSize: 16,
                ),
              ),
            if (_isReserved || // Show details even if reserved but empty
                widget.courseName.isNotEmpty ||
                widget.roomNumber.isNotEmpty ||
                widget.section.isNotEmpty ||
                widget.batch.isNotEmpty ||
                widget.department.isNotEmpty ||
                widget.time.isNotEmpty)
              const SizedBox(height: 5.0),
            if (_isReserved || // Show details even if reserved but empty
                widget.courseName.isNotEmpty ||
                widget.roomNumber.isNotEmpty ||
                widget.section.isNotEmpty ||
                widget.batch.isNotEmpty ||
                widget.department.isNotEmpty ||
                widget.time.isNotEmpty)
              Text(
                'Room Number : ${widget.roomNumber}',
                style: const TextStyle(
                  fontFamily: 'sedan',
                  fontSize: 16,
                ),
              ),
            if (_isReserved || // Show details even if reserved but empty
                widget.courseName.isNotEmpty ||
                widget.roomNumber.isNotEmpty ||
                widget.section.isNotEmpty ||
                widget.batch.isNotEmpty ||
                widget.department.isNotEmpty ||
                widget.time.isNotEmpty)
              const SizedBox(height: 5.0),
            if (_isReserved || // Show details even if reserved but empty
                widget.courseName.isNotEmpty ||
                widget.roomNumber.isNotEmpty ||
                widget.section.isNotEmpty ||
                widget.batch.isNotEmpty ||
                widget.department.isNotEmpty ||
                widget.time.isNotEmpty)
              Text(
                'Section : ${widget.section}',
                style: const TextStyle(
                  fontFamily: 'sedan',
                  fontSize: 16,
                ),
              ),
            if (_isReserved || // Show details even if reserved but empty
                widget.courseName.isNotEmpty ||
                widget.roomNumber.isNotEmpty ||
                widget.section.isNotEmpty ||
                widget.batch.isNotEmpty ||
                widget.department.isNotEmpty ||
                widget.time.isNotEmpty)
              const SizedBox(height: 5.0),
            if (_isReserved || // Show details even if reserved but empty
                widget.courseName.isNotEmpty ||
                widget.roomNumber.isNotEmpty ||
                widget.section.isNotEmpty ||
                widget.batch.isNotEmpty ||
                widget.department.isNotEmpty ||
                widget.time.isNotEmpty)
              Text(
                'Batch/Year : ${widget.batch}',
                style: const TextStyle(
                  fontFamily: 'sedan',
                  fontSize: 16,
                ),
              ),
            if (_isReserved || // Show details even if reserved but empty
                widget.courseName.isNotEmpty ||
                widget.roomNumber.isNotEmpty ||
                widget.section.isNotEmpty ||
                widget.department.isNotEmpty ||
                widget.time.isNotEmpty)
              const SizedBox(height: 5.0),
            if (_isReserved || // Show details even if reserved but empty
                widget.courseName.isNotEmpty ||
                widget.roomNumber.isNotEmpty ||
                widget.section.isNotEmpty ||
                widget.department.isNotEmpty ||
                widget.time.isNotEmpty)
              Text(
                'Department : ${widget.department}',
                style: const TextStyle(
                  fontFamily: 'sedan',
                  fontSize: 16,
                ),
              ),
            if (_isReserved || // Show details even if reserved but empty
                widget.courseName.isNotEmpty ||
                widget.roomNumber.isNotEmpty ||
                widget.section.isNotEmpty ||
                widget.department.isNotEmpty ||
                widget.time.isNotEmpty)
              Text(
                'Time : in ${widget.time} minutes',
                style: const TextStyle(
                  fontFamily: 'sedan',
                  fontSize: 19,
                ),
              ),
            if (!_isReserved && // Show "No announcement today" for cancellations or empty data
                widget.courseName.isEmpty &&
                widget.roomNumber.isEmpty &&
                widget.section.isEmpty &&
                widget.department.isEmpty &&
                widget.time.isEmpty)
              const Center(
                child: Text(
                  'No announcement today',
                  style: TextStyle(
                    fontFamily: 'sedan',
                    fontSize: 16,
                  ),
                ),
              ),
            const SizedBox(height: 20.0),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                if (_isReserved)
                  ElevatedButton(
                    onPressed: () {
                      Delete_session(widget.My_tokens);
                      setState(() => _isReserved = false);
                      Navigator.pop(context);
                      print('Cancel button pressed!');
                      // Simulate haptic feedback on cancellation
                      HapticFeedback.vibrate();
                    },
                    child: const Text('Cancel'),
                  ),
                ElevatedButton(
                  onPressed: () {
                    print(widget.instructor_id);
                    Navigator.pop(context);
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => Started_Class(
                                widget.My_tokens, widget.course_ID)));
                    print('Started button pressed!');
                  },
                  child: const Text('Started class'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

// Future<String?> getStoredCourseID() async {
//   SharedPreferences prefs = await SharedPreferences.getInstance();
//   // Retrieve the stored value, default to null if the placeholder is found
//   sessionCheck.courseID = prefs.getString('selectedCourseID');
//   return sessionCheck.courseID;
// }

Future<String?> Delete_session(String? Mytoken) async {
  const url_base = "https://besufikadyilma.tech/instructor/auth/delete-session";

  try {
    var response = await http.delete(
      Uri.parse(url_base),
      headers: {
        "Content-Type": "application/json",
        "Authorization": "Bearer ${Mytoken}"
      },
    );

    if (response.statusCode == 200) {
      var delete_status = jsonDecode(response.body);

      var delete_resonse = delete_status['msg'].toString();
      print(
          "................ delete is runing........................................$delete_resonse");

      return delete_resonse;
    } else {
      print("Error : ${response.body}");
      return null;
    }
  } catch (e) {
    print("Error: $e");
    return null;
  }
}
