import 'package:AAMCS_App/Instructor/instrct_Drawer/sessions/sessions_selector.dart';
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

// "course_category": "Major",
//         "course_code": "ECEg4103",
//         "course_credit": "4",
//         "course_department": "Electrical",
//         "course_name": "Computer Architecture and Organization",

class _SessionState extends State<Session> {
  List<Menu_list> menu_lists = [];
  String? _selectedCourseName;
  String? _selectedRoomNumber;
  String? _selectedSection;
  String? _selectedBatch;
  String? _selectedtime;

  SessionData sessionData = SessionData();

  static const List<String> _time = ['10', '15', '20'];
  get time => "";
  @override
  void initState() {
    super.initState();
    _fetchCourseList();
    _fetch_Room_List();
    print(menu_lists);
    // _fetch_Section_List();
    //_fetch_Batch_List();
  }

  // @override
  // void dispose() {
  //   _announcementController.dispose();
  //   super.dispose();
  // }
//#############################################______fetchCourseList_____####################
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
          menu_lists = (jsonData as List)
              .map((choice) => Menu_list(
                    course_name: choice['course_name'],
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

//#############################################_______fetch_Room_List _____####################
  Future<void> _fetch_Room_List() async {
    try {
      final response = await http.get(
        Uri.parse("https://besufikadyilma.tech/room/get"),
        headers: {
          "Content-Type": "application/json",
          "Authorization": "Bearer ${widget.myToken}"
        },
      );

      if (response.statusCode == 200) {
        var jsonData = jsonDecode(response.body);

        setState(() {
          menu_lists = (jsonData["rooms"]["room_no"] as List)
              .map((choice) => Menu_list(
                    Room_number: choice['Room_number'],
                  ))
              .toList();
        });
      } else {
        throw Exception('.....................Failed to load Rooms. ');
      }
    } catch (e) {
      print('Error: $e');
      // Handle error
    }
  }

  //##############################################__fetch_Section_List__#############
  Future<void> _fetch_Section_List() async {
    try {
      final response = await http.get(
        Uri.parse("https://besufikadyilma.tech/room/get"),
        headers: {
          "Content-Type": "application/json",
          "Authorization": "Bearer ${widget.myToken}"
        },
      );

      if (response.statusCode == 200) {
        var jsonData = jsonDecode(response.body);

        setState(() {
          menu_lists = (jsonData["section"] as List)
              .map((choice) => Menu_list(
                    Section: choice['Room_number'],
                  ))
              .toList();
        });
      } else {
        throw Exception('............Failed to load Sections');
      }
    } catch (e) {
      print('Error: $e');
      // Handle error
    }
  }

  //#############################################______ fetch Batch List_____####################
  Future<void> _fetch_Batch_List() async {
    try {
      final response = await http.get(
        Uri.parse("https://besufikadyilma.tech/room/get"),
        headers: {
          "Content-Type": "application/json",
          "Authorization": "Bearer ${widget.myToken}"
        },
      );

      if (response.statusCode == 200) {
        var jsonData = jsonDecode(response.body);

        setState(() {
          menu_lists = (jsonData["Batch_No"] as List)
              .map((choice) => Menu_list(
                    Batch_No: choice['Batch_No'],
                  ))
              .toList();
        });
      } else {
        throw Exception('Failed to load batch list');
      }
    } catch (e) {
      print('Error: $e');
      // Handle error
    }
  }

  //##############################################################################
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
//#############################################################################################

            DropdownButtonFormField<String>(
              value: _selectedCourseName,
              items: menu_lists
                  .map((choice) => DropdownMenuItem<String>(
                        value: choice.course_name,
                        child: Text(choice.course_name.toString()),
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

//#############################################################################################

            DropdownButtonFormField<String>(
              value: _selectedRoomNumber,
              items: menu_lists
                  .map((choice) => DropdownMenuItem<String>(
                        value: choice.Room_number,
                        child: Text(choice.Room_number.toString()),
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

//#############################################################################################

            DropdownButtonFormField<String>(
              value: _selectedSection,
              items: menu_lists
                  .map((choice) => DropdownMenuItem<String>(
                        value: choice.course_name,
                        child: Text(choice.course_name.toString()),
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

//#############################################################################################

            DropdownButtonFormField<String>(
              value: _selectedBatch,
              items: menu_lists
                  .map((course) => DropdownMenuItem<String>(
                        value: course.course_name,
                        child: Text(course.course_name.toString()),
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

//#############################################################################################

            DropdownButtonFormField<String>(
              value: _selectedtime,
              items: _time
                  .map((time) => DropdownMenuItem<String>(
                        value: time,
                        child: Text("$time min"),
                      ))
                  .toList(),
              onChanged: (value) => setState(() => _selectedtime = value!),
              decoration: const InputDecoration(
                labelText: 'Time (in minuts)',
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
