import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'booked_session.dart';

class Session extends StatefulWidget {
  final String? myToken;

  const Session(this.myToken, {super.key});

  @override
  State<Session> createState() => _SessionState();
}

class SessionData {
  String? courseName;
  String? roomNumber;
  String? section;
  String? batch;
  String? announcement;

  SessionData({
    this.courseName,
    this.roomNumber,
    this.section,
    this.batch,
    this.announcement,
  });
}

class CrsLists {
  final String name;
  final String pantoneValue;
  final String color;

  CrsLists({
    required this.name,
    required this.pantoneValue,
    required this.color,
  });
}

class _SessionState extends State<Session> {
  List<CrsLists> courseList = [];
  String? _selectedCourseName;
  String? _selectedRoomNumber;
  String? _selectedSection;
  String? _selectedBatch;
  final _announcementController = TextEditingController();
  SessionData sessionData = SessionData();

  @override
  void initState() {
    super.initState();
    _fetchCourseList();
  }

  @override
  void dispose() {
    _announcementController.dispose();
    super.dispose();
  }

  Future<void> _fetchCourseList() async {
    try {
      final response = await http.get(
        Uri.parse("https://besufikadyilma.tech/instructor/my-courses"),
        headers: {
          "Content-Type": "application/json",
          "Authorization": "Bearer ${widget.myToken}"
        },
      );

      if (response.statusCode == 200) {
        var jsonData = jsonDecode(response.body);

        setState(() {
          courseList = (jsonData as List)
              .map((course) => CrsLists(
                    name: course['course_name'],
                    pantoneValue: course['course_code'],
                    color: course['id'].toString(),
                  ))
              .toList();
        });
      } else {
        throw Exception('Failed to load courses');
      }
    } catch (e) {
      print('Error: $e');
      // Handle error
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Session',
          style: TextStyle(
            fontFamily: 'Sedan',
            fontSize: 22,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            DropdownButtonFormField<String>(
              value: _selectedCourseName,
              items: courseList
                  .map((course) => DropdownMenuItem<String>(
                        value: course.name,
                        child: Text(course.name),
                      ))
                  .toList(),
              onChanged: (value) {
                setState(() {
                  _selectedCourseName = value;
                  sessionData.courseName = value;
                });
              },
              decoration: const InputDecoration(
                labelText: 'Course Name',
                labelStyle: TextStyle(
                  fontFamily: 'Sedan',
                  fontSize: 16,
                  fontWeight: FontWeight.normal,
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(10)),
                ),
              ),
            ),
            const SizedBox(height: 30),
            DropdownButtonFormField<String>(
              value: _selectedRoomNumber,
              items: courseList
                  .map((course) => DropdownMenuItem<String>(
                        value: course.color,
                        child: Text(course.name),
                      ))
                  .toList(),
              onChanged: (value) {
                setState(() {
                  _selectedRoomNumber = value;
                  sessionData.roomNumber = value;
                });
              },
              decoration: const InputDecoration(
                labelText: 'Room Number',
                labelStyle: TextStyle(
                  fontFamily: 'Sedan',
                  fontSize: 16,
                  fontWeight: FontWeight.normal,
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(10)),
                ),
              ),
            ),
            const SizedBox(height: 30),
            DropdownButtonFormField<String>(
              value: _selectedSection,
              items: courseList
                  .map((course) => DropdownMenuItem<String>(
                        value: course.name,
                        child: Text(course.name),
                      ))
                  .toList(),
              onChanged: (value) {
                setState(() {
                  _selectedSection = value;
                  sessionData.section = value;
                });
              },
              decoration: const InputDecoration(
                labelText: 'Section',
                labelStyle: TextStyle(
                  fontFamily: 'Sedan',
                  fontSize: 16,
                  fontWeight: FontWeight.normal,
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(10)),
                ),
              ),
            ),
            const SizedBox(height: 30),
            DropdownButtonFormField<String>(
              value: _selectedBatch,
              items: courseList
                  .map((course) => DropdownMenuItem<String>(
                        value: course.name,
                        child: Text(course.name),
                      ))
                  .toList(),
              onChanged: (value) {
                setState(() {
                  _selectedBatch = value;
                  sessionData.batch = value;
                });
              },
              decoration: const InputDecoration(
                labelText: 'Batch',
                labelStyle: TextStyle(
                  fontFamily: 'Sedan',
                  fontSize: 16,
                  fontWeight: FontWeight.normal,
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(10)),
                ),
              ),
            ),
            const SizedBox(height: 30),
            TextField(
              controller: _announcementController,
              onChanged: (value) {
                sessionData.announcement = value;
              },
              decoration: const InputDecoration(
                labelText: 'Announcement (Optional)',
                labelStyle: TextStyle(
                  fontFamily: 'Sedan',
                  fontSize: 16,
                  fontWeight: FontWeight.normal,
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(10)),
                ),
              ),
            ),
            const SizedBox(height: 30),
            ElevatedButton(
              onPressed: () {
                _showConfirmationDialog(context);
              },
              child: const Text(
                'Submit',
                style: TextStyle(
                  fontFamily: 'sedan',
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showConfirmationDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text(
          'Confirm Announcement',
          style: TextStyle(
            fontFamily: 'Sedan',
            fontSize: 20,
            fontWeight: FontWeight.bold,
            fontStyle: FontStyle.normal,
          ),
        ),
        content: const Text(
          'Warning: Once you confirm the session, the room will be reserved for 20 minutes. Failure to unlock it within this time will result in the room becoming available again, and the session will be canceled.',
          style: TextStyle(
            fontFamily: 'sedan',
            fontSize: 17,
            fontWeight: FontWeight.normal,
            fontStyle: FontStyle.italic,
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false), // Close dialog (no)
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => BookedSessionPage(
                    courseName: sessionData.courseName ?? '',
                    roomNumber: sessionData.roomNumber ?? '',
                    section: sessionData.section ?? '',
                    batch: sessionData.batch ?? '',
                    announcement: sessionData.announcement ?? '',
                  ),
                ),
              );
            },
            child: const Text('Submit'),
          ),
        ],
      ),
    );
  }
}
