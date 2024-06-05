import 'dart:convert';
import 'package:AAMCS_App/Instructor/instrct_Drawer/My_Course/student_attendance/stu_att_list.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class Started_Class extends StatefulWidget {
  final String? myToken;
  final String? Course_id;
  const Started_Class(this.myToken, this.Course_id, {super.key});

  @override
  State<Started_Class> createState() => _StuAttendanceState();
}

class _StuAttendanceState extends State<Started_Class> {
  List<In_class_STU> studentList = [];
  // List<stuList> filteredList = []; // List for search results
  bool isLoading = false; // Flag to indicate data fetching state

  Future<void> getstuList() async {
    setState(() {
      isLoading = false; // Set loading state to true
    });
    var response = await http.get(
      Uri.parse("https://besufikadyilma.tech/instructor/in-class"),
      headers: {
        "Content-Type": "application/json",
        "Authorization": "Bearer ${widget.myToken}"
      },
    );
    //print(response.body);
    if (response.statusCode == 200) {
      var jsonData = jsonDecode(response.body);
      print("........... get student list...........${widget.Course_id}");
      studentList.clear();
      for (var eachStudentData in jsonData) {
        final In_class_STU newStudent = In_class_STU(
          student_id: eachStudentData['student_id'],
          first_name: eachStudentData['first_name'].toString(),
          arrived_time: eachStudentData['arrived_time'].toString(),
        );

        studentList.add(newStudent);
      }
      // filteredList = studentList; // Initially set filteredList to full list

      setState(() {
        isLoading = false; // Set loading state to false after successful fetch
      });
    } else {
      // Handle error here
      throw Exception('Failed to load teams');
    }
  }

  @override
  void initState() {
    super.initState();
    getstuList(); // Call getStuList on initialization
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text(
            'Student Attendance List',
            style: TextStyle(
              fontFamily: 'Sedan',
              fontSize: 22,
              fontWeight: FontWeight.bold,
            ),
          ),
          backgroundColor: const Color.fromARGB(255, 170, 163, 163),
        ),
        body: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(children: [
            Expanded(
                child: isLoading
                    ? const CircularProgressIndicator(color: Colors.green)
                    : SingleChildScrollView(
                        child: Table(
                            columnWidths: const {
                              0: FlexColumnWidth(1),
                              1: FlexColumnWidth(2.5),
                              2: FlexColumnWidth(2.5),
                              3: FlexColumnWidth(2.5),
                            },
                            border: TableBorder.all(
                              color: Colors.grey,
                              width: 1.0,
                            ),
                            children: [
                              TableRow(
                                  // Header row with decoration and text styling
                                  decoration: BoxDecoration(
                                    color: Colors.grey[200],
                                  ),
                                  children: const [
                                    TableCell(
                                        child: Center(
                                            child: Text("No",
                                                style: TextStyle(
                                                    fontSize: 16.0,
                                                    fontWeight: FontWeight.bold,
                                                    color: Colors.black)))),
                                    TableCell(
                                        child: Center(
                                            child: Text("ID",
                                                style: TextStyle(
                                                    fontSize: 16.0,
                                                    fontWeight: FontWeight.bold,
                                                    color: Colors.black)))),
                                    TableCell(
                                        child: Center(
                                      child: Text("First Name",
                                          style: TextStyle(
                                              fontSize: 16.0,
                                              fontWeight: FontWeight.bold,
                                              color: Colors.black)),
                                    )),
                                    TableCell(
                                        child: Center(
                                            child: Text("Arrived",
                                                style: TextStyle(
                                                    fontSize: 16.0,
                                                    fontWeight: FontWeight.bold,
                                                    color: Colors.black))))
                                  ]),
                              // Data rows with colored backgrounds
                              for (int i = 0; i < studentList.length; i++)
                                TableRow(
                                    decoration: BoxDecoration(
                                        color: i % 2 == 0
                                            ? Colors.grey[200]
                                            : null),
                                    children: [
                                      TableCell(
                                        child: Center(
                                            child: Text((i + 1).toString())),
                                      ),
                                      TableCell(
                                        child: Center(
                                            child: Text(
                                                studentList[i].student_id!)),
                                      ),
                                      TableCell(
                                          child: Center(
                                              child: Text(
                                                  studentList[i].first_name!))),
                                      TableCell(
                                          child: Center(
                                              child: Text(studentList[i]
                                                  .arrived_time!)))
                                    ])
                            ])))
          ]),
        ));
  }
}

class In_class_STU {
  late String? first_name;
  late String? student_id;
  late String? arrived_time;

  In_class_STU({
    required this.first_name,
    required this.student_id,
    required this.arrived_time,
  });
}
