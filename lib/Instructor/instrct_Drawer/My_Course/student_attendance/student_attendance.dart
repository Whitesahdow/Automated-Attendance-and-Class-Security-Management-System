import 'dart:convert';
// import 'dart:math';

import 'package:AAMCS_App/Instructor/instrct_Drawer/My_Course/student_attendance/stu_att_list.dart';
import 'package:flutter/material.dart';
// import 'package:flutter/widgets.dart';
import 'package:http/http.dart' as http;

class StuAttendance extends StatefulWidget {
  final String? myToken;
  final String? id;
  const StuAttendance(this.myToken, this.id, {super.key});

  @override
  State<StuAttendance> createState() => _StuAttendanceState();
}

class _StuAttendanceState extends State<StuAttendance> {
  List<stuList> studentList = [];
  // List<stuList> filteredList = []; // List for search results
  bool isLoading = false; // Flag to indicate data fetching state
  // String searchText = ""; // Stores the entered student ID for search

  Future<void> getstuList() async {
    setState(() {
      isLoading = false; // Set loading state to true
    });
    var response = await http.get(
      Uri.parse("https://besufikadyilma.tech/student/attendance/${widget.id}"),
      headers: {
        "Content-Type": "application/json",
        "Authorization": "Bearer ${widget.myToken}"
      },
    );
    if (response.statusCode == 200) {
      var jsonData = jsonDecode(response.body);
      print("......................${jsonData}");
      // studentList.clear();
      for (var eachStudentData in jsonData) {
        final stuList newStudent = stuList(
          student_id: eachStudentData['student_id'],
          total_no: eachStudentData['total_class'].toString(),
          attended_no: eachStudentData['attended'].toString(),
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
              color: Colors.white,
            ),
          ),
          backgroundColor: const Color.fromARGB(255, 17, 40, 77),
          leading: IconButton(
            icon: const Icon(Icons.arrow_back_ios), // Use desired arrow icon
            color: Colors.white, // Set color to white
            onPressed: () => Navigator.pop(context), // Handle back button press
          ),
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
                                      child: Text("ATTENDED",
                                          style: TextStyle(
                                              fontSize: 16.0,
                                              fontWeight: FontWeight.bold,
                                              color: Colors.black)),
                                    )),
                                    TableCell(
                                        child: Center(
                                            child: Text("SESSIONS",
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
                                                studentList[i].student_id)),
                                      ),
                                      TableCell(
                                          child: Center(
                                              child: Text(
                                                  studentList[i].attended_no))),
                                      TableCell(
                                          child: Center(
                                              child: Text(
                                                  studentList[i].total_no)))
                                    ])
                            ])))
          ]),
        ));
  }
}
