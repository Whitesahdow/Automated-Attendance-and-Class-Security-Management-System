import 'dart:async';

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

class _SessionState extends State<Session> {
  List<Menu_list> menu_lists = [];
  //String? _selectedCourseName;
  String? _selectedRoomNumber;
  String? _selectedSection;
  String? _selectedDepartment;
  String? _selectedBatch;
  String? _selectedtime;
  SessionData sessionData = SessionData();
  List roomnumber = [];
  List<dynamic> sectionList = [];
  List<dynamic> department_list = [];
  List<dynamic> batch_No = [];
  static const List<String> _time = ['10', '15', '20'];
  get time => "";
  @override
  void initState() {
    super.initState();
    _fetchCourseList();
    _fetch_Room_List();

    _fetch_Batch_List();
    _fetch_Dept_List();
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
      print('Errorrrrrrrrrrrrrrrrrrrr : $e');
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
        print(jsonData);
        setState(() {
          roomnumber =
              jsonData.map((element) => element['room'] as String).toList();
          print("working");
        });
      } else {
        throw Exception('.....................Failed to load Rooms. ');
      }
    } catch (e) {
      print('Erro0000000000000000r: $e');
    }
  }

  //##############################################__fetch_Section_List__#############

  Future<InstInfo> getdata() async {
    final response = await http.get(
      Uri.parse("https://besufikadyilma.tech/instructor/me"),
      headers: {
        "Content-Type": "application/json",
        "Authorization": "Bearer ${widget.myToken}"
      },
    );

    if (response.statusCode == 200) {
      var jsonData = jsonDecode(response.body);
      final user = InstInfo(
        id_key: jsonData['id'],
      );
      return user;
    } else {
      throw Exception('Failed to load data');
    }
    // return InstInfo();
  }

  Future<void> _fetchsectionList() async {
    final data = await getdata();
    const url_base = "https://besufikadyilma.tech/instructor/get-class";
    final user = data.id_key;
    String cleanedId = user!.replaceAll('-', '');
    print(cleanedId);
    // print("...................${user.toString()}");
    try {
      final response = await http.get(
        Uri.parse("$url_base?instructors_id= $cleanedId"),
        // Uri.parse(
        //     ""),
        headers: {
          "Content-Type": "application/json",
          "Authorization": "Bearer ${widget.myToken}"
        },
      );

      if (response.statusCode == 200) {
        var jsonData = jsonDecode(response.body);
        print(jsonData);
        setState(() {
          sectionList = (jsonData)
              .map((course) => ScnLists(section: course['class']['section']))
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

  //#############################################______ fetch Department List_____####################
  Future<void> _fetch_Batch_List() async {
    final dept_data = await getdata();
    const url_base = "https://besufikadyilma.tech/instructor/get-class";
    final dep_user = dept_data.id_key;
    String cleanedId = dep_user!.replaceAll('-', '');
    print(cleanedId);
    // print("...................${user.toString()}");
    try {
      final response = await http.get(
        Uri.parse("$url_base?instructors_id= $cleanedId"),
        // Uri.parse(
        //     ""),
        headers: {
          "Content-Type": "application/json",
          "Authorization": "Bearer ${widget.myToken}"
        },
      );

      if (response.statusCode == 200) {
        var jsonData = jsonDecode(response.body);
        print(jsonData);
        setState(() {
          batch_No = (jsonData)
              .map(
                  (course) => BatchList(batch_number: course['class']['batch']))
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

//################################
  Future<void> _fetch_Dept_List() async {
    final dept_data = await getdata();
    const url_base = "https://besufikadyilma.tech/instructor/get-class";
    final dep_user = dept_data.id_key;
    String cleanedId = dep_user!.replaceAll('-', '');
    print(cleanedId);
    // print("...................${user.toString()}");
    try {
      final response = await http.get(
        Uri.parse("$url_base?instructors_id= $cleanedId"),
        // Uri.parse(
        //     ""),
        headers: {
          "Content-Type": "application/json",
          "Authorization": "Bearer ${widget.myToken}"
        },
      );

      if (response.statusCode == 200) {
        var jsonData = jsonDecode(response.body);
        print(jsonData);
        setState(() {
          department_list = (jsonData)
              .map((course) =>
                  DeptList(department_name: course['class']['department']))
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

            DropdownButtonFormField<String?>(
              // value: _selectedCourseName,
              items: menu_lists
                  .map((choice) => DropdownMenuItem<String>(
                        value: choice.course_name.toString(),
                        child: Text(choice.course_name.toString()),
                      ))
                  .toList(),
              onChanged: (value) {
                setState(() {
                  //_selectedCourseName = value;
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
              items: roomnumber
                  .map((room) => DropdownMenuItem<String>(
                        value: room,
                        child: Text(room),
                      ))
                  .toList(),
              onChanged: (value) {
                print(
                    "Selected room: $value"); // Check if onChanged is triggered
                setState(() {
                  _selectedRoomNumber = value;
                  sessionData.roomNumber =
                      value; // Ensure sessionData is correctly updated
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
              value: _selectedtime,
              items: _time
                  .map((time) => DropdownMenuItem<String>(
                        value: time,
                        child: Text("$time min"),
                      ))
                  .toList(),
              onChanged: (value) => setState(() => _selectedtime = value!),
              decoration: const InputDecoration(
                labelText: 'Time ( minutes)',
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
//################################################################
            DropdownButtonFormField<String>(
              value: _selectedDepartment,
              items: department_list
                  .map((dept_choice) => DropdownMenuItem<String>(
                        value: dept_choice.department_name,
                        child: Text(dept_choice.department_name),
                      ))
                  .toList(),
              onChanged: (value) {
                setState(() {
                  _selectedDepartment = value;
                  sessionData.department = value;
                });
              },
              decoration: const InputDecoration(
                labelText: 'Department',
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
//##############################################################################
            DropdownButtonFormField<String>(
              value: _selectedBatch,
              items: batch_No
                  .map((batchchoice) => DropdownMenuItem<String>(
                        value: batchchoice.batch_number,
                        child: Text(batchchoice.batch_number),
                      ))
                  .toList(),
              onChanged: (value) {
                setState(() {
                  _selectedBatch = value;
                  sessionData.batch = value;
                });
              },
              decoration: const InputDecoration(
                labelText: 'Batch Number',
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
            //######################################################
            DropdownButtonFormField<String>(
              value: _selectedSection,
              items: sectionList
                  .map((course) => DropdownMenuItem<String>(
                        value: course.section,
                        child: Text(course.section),
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
//##############################################################################
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
                    department: sessionData.department ?? '',
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
