import 'dart:async';
import 'package:AAMCS_App/Instructor/instrct_Drawer/sessions/sessions_selector.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'booked_session.dart';
import 'package:shared_preferences/shared_preferences.dart';

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
  SessionData sessionData = SessionData(studentIds: []);
  List roomnumber = [];
  List roomID = [];
  List<dynamic> sectionList = [];
  List<dynamic> students_lister = [];
  List<dynamic> department_list = [];
  List<dynamic> batch_No = [];
  static const List<String> _time = ['20', '12', '11'];
  String? dialogue_time;

  //get time => "";
  @override
  void initState() {
    super.initState();
    _fetchCourseList();
    _fetch_Room_List();

    _fetch_Batch_List();
    _fetch_Dept_List();
    // _fetch_section_List();
    _fetch_student_List();
  }

  bool _areAllFieldsFilled() {
    return sessionData.courseName != null &&
        sessionData.roomNumber != null &&
        sessionData.department != null &&
        sessionData.batch != null &&
        sessionData.section != null &&
        sessionData.time != null;
  }
// String? _selectedDepartment;

  List<String> _getFilteredDepartments() {
    List<String> filteredDepartments = [];
    for (var dept in department_list) {
      if (!filteredDepartments.contains(dept.department_name)) {
        filteredDepartments.add(dept.department_name);
      }
    }
    return filteredDepartments;
  }

  List<String> _getUniqueBatchNumbers() {
    List<String> uniqueBatchNumbers = [];
    for (var batch in batch_No) {
      if (!uniqueBatchNumbers.contains(batch.batch_number)) {
        uniqueBatchNumbers.add(batch.batch_number);
      }
    }
    return uniqueBatchNumbers;
  }

//#############################################______fetchCourseList_____####################
  Map<String?, String?> course_dictionary =
      {}; // Define course_dictionary at class level

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
                    course_id: choice['id'],
                  ))
              .toList();
        });

        course_dictionary.clear(); // Clear previous data
        menu_lists.forEach((course) {
          course_dictionary[course.course_name] = course.course_id;
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
  Map<String?, String?> room_dictionary = {};

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

        // Filter the jsonData to include only rooms that are not booked
        var availableRooms =
            jsonData.where((element) => element['is_booked'] == false).toList();

        setState(() {
          // Extract room numbers and IDs from the filtered data
          roomnumber = availableRooms
              .map((element) => element['room'] as String)
              .toList();
          roomID = availableRooms.map((room) => room['id'] as String).toList();

          print("working");
        });

        room_dictionary.clear();
        for (var i = 0; i < roomnumber.length; i++) {
          room_dictionary[roomnumber[i]] = roomID[i];
        }
        print(room_dictionary);
      } else {
        throw Exception('Failed to load Rooms.');
      }
    } catch (e) {
      print('Error: $e');
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

  //#############################################______ fetch Department List_____####################
  Future<void> _fetch_Batch_List() async {
    final dept_data = await getdata();
    const url_base = "https://besufikadyilma.tech/instructor/get-class";
    final dep_user = dept_data.id_key;
    String cleanedId = dep_user!.replaceAll('-', '');

    // print("...................${user.toString()}");
    try {
      final response = await http.get(
        Uri.parse("$url_base?instructors_id=$cleanedId"),
        // Uri.parse(
        //     ""),
        headers: {
          "Content-Type": "application/json",
          "Authorization": "Bearer ${widget.myToken}"
        },
      );

      if (response.statusCode == 200) {
        var jsonData = jsonDecode(response.body);
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
    sessionData.instructorID = cleanedId;

    // print("...................${user.toString()}");
    try {
      final response = await http.get(
        Uri.parse("$url_base?instructors_id=$cleanedId"),
        // Uri.parse(
        //     ""),
        headers: {
          "Content-Type": "application/json",
          "Authorization": "Bearer ${widget.myToken}"
        },
      );

      if (response.statusCode == 200) {
        var jsonData = jsonDecode(response.body);

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

  Future<void> _fetch_section_List(
      var ins_id, var crs_id, var btch, var deprtm) async {
    final dept_data = await getdata();
    var url_base =
        "https://besufikadyilma.tech/instructor/get-class?course_id=${crs_id}&batch=$btch&department=${deprtm}";
    final dep_user = dept_data.id_key;
    String cleanedId = dep_user!.replaceAll('-', '');

    // print("...................${user.toString()}");
    try {
      final response = await http.get(
        Uri.parse(url_base),
        // Uri.parse(
        //     ""),
        headers: {
          "Content-Type": "application/json",
          "Authorization": "Bearer ${widget.myToken}"
        },
      );

      if (response.statusCode == 200) {
        var jsonData = jsonDecode(response.body);

        setState(() {
          sectionList = (jsonData)
              .map((element) => ScnLists(section: element['class']['section']))
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

  //########################################### Student list fetcher
  Future<void> _fetch_student_List() async {
    final data = await getdata();
    const url_base = "https://besufikadyilma.tech/instructor/get-class";
    final user = data.id_key;
    String cleanedId = user!.replaceAll('-', '');

    try {
      final response = await http.get(
        Uri.parse("$url_base?instructors_id=$cleanedId"),
        // Uri.parse(
        //     ""),
        headers: {
          "Content-Type": "application/json",
          "Authorization": "Bearer ${widget.myToken}"
        },
      );

      if (response.statusCode == 200) {
        var jsonData = jsonDecode(response.body);

        setState(() {
          students_lister =
              (jsonData[0]['students'] as List<dynamic>).map((student) {
            String studentId = student["id"].toString(); // Extract student ID
            sessionData.studentIds.add(studentId); // Add student ID to the list
            print('Student ID...........: ${sessionData.studentIds}');
            return Students_list(
              batch: student["batch"].toString(),
              department: student["department"].toString(),
              email: student["email"].toString(),
              first_name: student["first_name"].toString(),
              gender: student["gender"].toString(),
              id: studentId, // Use the extracted student ID
              last_name: student["last_name"].toString(),
              middle_name: student["middle_name"].toString(),
              section: student["section"].toString(),
            );
          }).toList();
        });
      } else {
        throw Exception('Failed to load courses');
      }
    } catch (e) {
      print('Chigirrrrrrrrrrrrrrrrrrrrrrrrrr: $e');
      // Handle error
    }
  }

  //##############################################################################
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 17, 40, 77),
        title: const Text(
          'Session',
          style: TextStyle(
            fontFamily: 'Sedan',
            fontSize: 22,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios), // Use desired arrow icon
          color: Colors.white, // Set color to white
          onPressed: () => Navigator.pop(context), // Handle back button press
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
//#######################################################################################################

            DropdownButtonFormField<String?>(
              isExpanded: true,
              value: sessionData.courseName,
              items: menu_lists
                  .map((choice) => DropdownMenuItem<String>(
                        value: choice.course_name.toString(),
                        child: Text(choice.course_name.toString()),
                      ))
                  .toList(),
              onChanged: (value) async {
                setState(() {
                  sessionData.courseName = value;
                  sessionData.courseID = course_dictionary[value];
                  print("Selected Course ID: ${sessionData.courseID}");
                });

                // Store the selected course ID locally
                SharedPreferences prefs = await SharedPreferences.getInstance();
                await prefs.setString(
                    'selectedCourseID', sessionData.courseID ?? '');
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

                  // Look up the room ID using the selected room number
                  sessionData.roomID = room_dictionary[value];
                  print("Selected Room ID: ${sessionData.roomID}");
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

//###############################################################################################
            DropdownButtonFormField<String>(
              value: _selectedDepartment,
              items: _getFilteredDepartments()
                  .map((dept_choice) => DropdownMenuItem<String>(
                        value: dept_choice,
                        child: Text(dept_choice),
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
              items: _getUniqueBatchNumbers()
                  .map((batchchoice) => DropdownMenuItem<String>(
                        value: batchchoice,
                        child: Text(batchchoice),
                      ))
                  .toList(),
              onChanged: (value) async {
                setState(() {
                  _selectedBatch = value;
                  sessionData.batch = value;
                });
                try {
                  await _fetch_section_List(
                      sessionData.instructorID,
                      sessionData.courseID,
                      sessionData.batch,
                      sessionData.department);
                } catch (error) {
                  // Handle errors here if necessary
                  print('Error fetching section list: $error');
                }
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

//String? _selectedBatch;

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
            DropdownButtonFormField<String>(
              value: _selectedtime,
              items: _time
                  .map((time) => DropdownMenuItem<String>(
                        value: time,
                        child: Text("$time min"),
                      ))
                  .toList(),
              onChanged: (value) => setState(() {
                _selectedtime = value!;
                sessionData.time = value;
              }),
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
//#####################################################################################
            ElevatedButton(
              onPressed: _areAllFieldsFilled()
                  ? () {
                      _showConfirmationDialog(context, sessionData.time);
                    }
                  : null, // Disable the button if not all fields are filled
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

  void _showConfirmationDialog(BuildContext context, String? dialogue_time) {
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
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Warning: Once you confirm the session, the room will be reserved for $dialogue_time minutes. Failure to unlock it within this time will result in the room becoming available again, and the session will be canceled.',
              style: const TextStyle(
                fontFamily: 'sedan',
                fontSize: 17,
                fontWeight: FontWeight.normal,
                fontStyle: FontStyle.italic,
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false), // Close dialog (no)
            child: const Text(
              'Cancel',
              style: TextStyle(
                  fontFamily: 'sedan',
                  fontSize: 18,
                  fontWeight: FontWeight.normal,
                  fontStyle: FontStyle.normal),
            ),
          ),
          TextButton(
            onPressed: () async {
              await createSession(sessionData.roomID, sessionData.courseID,
                  sessionData.studentIds, _selectedtime, widget.myToken);
              if (message.message == true) {
                print(message.message);

                Navigator.pop(
                    context); // Remove the current page from the stack
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (context) => BookedSessionPage(
                      courseName: sessionData.courseName ?? '',
                      roomNumber: sessionData.roomNumber ?? '',
                      section: sessionData.section ?? '',
                      batch: sessionData.batch ?? '',
                      department: sessionData.department ?? '',
                      time: sessionData.time ?? '',
                      My_tokens: widget.myToken,
                      course_ID: sessionData.courseID,
                    ),
                  ),
                );
              } else {
                Navigator.pop(context);
                _showLoginFailedDialog(context);
              }
            },
            child: const Text(
              'Submit',
              style: TextStyle(
                  fontFamily: 'sedan',
                  fontSize: 18,
                  fontWeight: FontWeight.normal,
                  fontStyle: FontStyle.normal),
            ),
          ),
        ],
      ),
    );
  }
}

class Sessionresponse {
  var message;
  Sessionresponse({this.message});
}

Sessionresponse message = Sessionresponse();

Future<void> createSession(
  var roomID,
  var course_id,
  List<String> studentsList,
  var selectedTime,
  var token,
  //String studentId, // Add studentId parameter
) async {
  const urlBase = "https://besufikadyilma.tech/instructor/auth/create-session";
  print(studentsList);
  try {
    var response = await http.post(
      Uri.parse(urlBase),
      body: jsonEncode({
        "room_id": roomID,
        "course_id": course_id,
        "student_list": studentsList,
        "start_time": selectedTime,
        // Pass studentId here
      }),
      headers: {
        "Content-Type": "application/json",
        "Authorization": "Bearer $token"
      },
    );

    if (response.statusCode == 201) {
      var sessionStatus = jsonDecode(response.body);
      print(sessionStatus['msg']);
      message.message = sessionStatus['msg'];
      print("Message status: ${message.message}");
    } else {
      message.message = false;
      print("Error : ${response.body}");
      return null;
    }
  } catch (e) {
    print("Error: $e");
    return null;
  }
}

void _showLoginFailedDialog(BuildContext context) {
  showDialog(
    context: context,
    builder: (context) => AlertDialog(
      title: const Text(
        'Session Failed',
        style: TextStyle(
          fontFamily: 'Sedan',
          fontSize: 20,
          fontWeight: FontWeight.bold,
          fontStyle: FontStyle.normal,
        ),
      ),
      content: const Text(
        'Input values are wrong please try again.',
        style: TextStyle(
          fontFamily: 'Sedan',
          fontSize: 17,
          fontWeight: FontWeight.normal,
          // fontStyle: FontStyle.italic,
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(
              context), // Close dialog and return to the same page
          child: const Text('Okay'),
        ),
      ],
    ),
  );
}
