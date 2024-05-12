import 'package:AAMCS_App/Instructor/instrct_Drawer/sessions/booked_session.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class Session extends StatefulWidget {
  const Session({Key? key}) : super(key: key);

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

SessionData sessionData = SessionData();

class Crs_Lists {
  final String name;
  final String pantone_value;

  Crs_Lists({
    required this.name,
    required this.pantone_value,
  });
}

class _SessionState extends State<Session> {
  List<Crs_Lists> course_list = [];
  String? _selectedCourseName;
  String? _selectedRoomNumber;
  String? _selectedSection;
  String? _selectedBatch;
  final _announcementController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _fetchCourseList();
  }

  Future<void> _fetchCourseList() async {
    try {
      var url = Uri.https('reqres.in', '/api/unknown');
      var response = await http.get(url);

      if (response.statusCode == 200) {
        var jsonData = jsonDecode(response.body);

        setState(() {
          course_list = (jsonData['data'] as List)
              .map((course) => Crs_Lists(
                    name: course['name'],
                    pantone_value: course['pantone_value'],
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
              items: course_list
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
            //c#########################################################################################################
            DropdownButtonFormField<String>(
              value: _selectedRoomNumber,
              items: course_list
                  .map((course) => DropdownMenuItem<String>(
                        value: course.name,
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
            //#############################################################################################3
            DropdownButtonFormField<String>(
              value: _selectedSection,
              items: course_list
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
            //#################################################################
            DropdownButtonFormField<String>(
              value: _selectedBatch,
              items: course_list
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
            //####################################################################################
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
            //####################################################################################
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
          'Warning: Once you confirm the session, the room will be reserved for 20 minutes. Failure to unlock it within this time will result in the room becoming available again, and the session will be canceled. ',
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
                            courseName: sessionData.courseName.toString(),
                            roomNumber: sessionData.roomNumber.toString(),
                            section: sessionData.section.toString(),
                            batch: sessionData.batch.toString(),
                            announcement: sessionData.announcement.toString(),
                          )));
            },
            child: const Text('Submit'),
          ),
        ],
      ),
    );
  }
}
