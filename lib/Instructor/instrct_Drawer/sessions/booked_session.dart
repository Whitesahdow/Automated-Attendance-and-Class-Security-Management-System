import 'dart:async';
import 'dart:convert';

import 'package:AAMCS_App/Instructor/instrct_Drawer/sessions/started_class.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';

import 'package:http/http.dart' as http;

class BookedSessionPage extends StatefulWidget {
  final String courseName;
  final String roomNumber;
  final String section;
  final String batch;
  final String department;
  final String time;
  final bool msg;
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
      this.msg = false,
      this.My_tokens,
      this.course_ID,
      this.instructor_id});

  @override
  State<BookedSessionPage> createState() => _BookedSessionPageState();
}

class _BookedSessionPageState extends State<BookedSessionPage> {
  late Future<BookedSessionPage> _dataFuture;
  bool _isReserved = true; // Flag to track reservation status

  @override
  void initState() {
    super.initState();
    getConfirmationMessage();
    _dataFuture = getdata();
    _startVerificationTimer();

    // Perform any initialization tasks here
    print('BookedSessionPage initialized');
    //getStoredCourseID(); // For example, retrieve stored course ID
  }

  late Timer _timer;

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  void _startVerificationTimer() {
    _timer = Timer.periodic(Duration(seconds: 2), (timer) async {
      await Verified_session(widget.My_tokens);
      if (message.msg == true) {
        // ignore: use_build_context_synchronously
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(
            builder: (context) =>
                Started_Class(widget.My_tokens, widget.course_ID),
          ),
        );
        print('Navigating to Started_Class!');
      } else {
        print("Session is not verified");
      }
    });
  }

  Future<BookedSessionPage> getdata() async {
    final response = await http.get(
      Uri.parse("https://besufikadyilma.tech/instructor/get-session"),
      headers: {
        "Content-Type": "application/json",
        "Authorization": "Bearer ${widget.My_tokens}"
      },
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      print(data);
      final bookedsession = BookedSessionPage(
        roomNumber: data['session']['room'],
        courseName: data['session']['course_name'],
        section: data['session']['section'],
        batch: data['session']['batch'],
        department: data['session']['department'],
        time: data['session']['start_time'],
        msg: data['msg'],
      );
      print("...............................${data}");
      return bookedsession;
    } else {
      throw Exception('Failed to load data');
    }
  }

  String getConfirmationMessage() {
    if (message.msg) {
      return "Attention! Once you verify your enrollment, cancellation from here is no longer possible. To cancel after verification, you'll need to end your session.";
    } else {
      return 'Are you sure you want to cancel the session?';
    }
  }

  Future<void> _refreshData() async {
    try {
      final newData = getdata();
      setState(() {
        _dataFuture = newData;
      });
      await newData; // Ensure the new future is awaited and exceptions are handled.
    } catch (e) {
      // Handle the error appropriately here
      print('Error refreshing data: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: const Color.fromARGB(255, 17, 40, 77),
          title: Text(
            _isReserved ? 'Booked Session' : 'Session Canceled',
            style: const TextStyle(
                fontFamily: 'sedan', fontSize: 22, color: Colors.white),
          ),
          leading: IconButton(
            icon: const Icon(Icons.arrow_back_ios), // Use desired arrow icon
            color: Colors.white, // Set color to white
            onPressed: () => Navigator.pop(context), // Handle back button press
          ),
        ),
        body: RefreshIndicator(
          onRefresh: _refreshData,
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Card(
                  child: Column(
                    children: [
                      Row(
                        children: [
                          Container(
                            decoration: const BoxDecoration(
                              border: Border(
                                right: BorderSide(
                                  color: Colors
                                      .blue, // Adjust border color as needed
                                  width: 1.0,
                                ),
                              ),
                            ),
                            child: const Padding(
                              padding: EdgeInsets.symmetric(
                                horizontal: 15.0,
                              ),
                              child: Text(
                                'Course Name: ',
                                style: TextStyle(
                                  fontFamily: 'sedan',
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black87,
                                ),
                              ),
                            ),
                          ),
                          Expanded(
                            child: Text(
                              widget.courseName.toString(),
                              style: const TextStyle(
                                fontFamily: 'sedan',
                                fontSize: 16,
                                color: Colors.black87,
                              ),
                            ),
                          ),
                        ],
                      ),
                      // const SizedBox(height: 5.0),
                      const Divider(),
                      Row(
                        children: [
                          Container(
                            decoration: const BoxDecoration(
                              border: Border(
                                right: BorderSide(
                                  color: Colors
                                      .blue, // Adjust border color as needed
                                  width: 1.0,
                                ),
                              ),
                            ),
                            child: const Padding(
                              padding: EdgeInsets.symmetric(horizontal: 11.9),
                              child: Text(
                                'Room Number:',
                                style: TextStyle(
                                  fontFamily: 'sedan',
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black87,
                                ),
                              ),
                            ),
                          ),
                          Text(
                            widget.roomNumber.toString(),
                            style: const TextStyle(
                              fontFamily: 'sedan',
                              fontSize: 16,
                              color: Colors.black87,
                            ),
                          ),
                        ],
                      ),
                      const Divider(),
                      Row(
                        children: [
                          Container(
                            decoration: const BoxDecoration(
                              border: Border(
                                right: BorderSide(
                                  color: Colors
                                      .blue, // Adjust border color as needed
                                  width: 1.0,
                                ),
                              ),
                            ),
                            child: const Padding(
                              padding: EdgeInsets.symmetric(horizontal: 10.0),
                              child: Text(
                                'Section: ',
                                style: TextStyle(
                                  fontFamily: 'sedan',
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black87,
                                ),
                              ),
                            ),
                          ),
                          Text(
                            widget.section.toString(),
                            style: const TextStyle(
                              fontFamily: 'sedan',
                              fontSize: 16,
                              color: Colors.black87,
                            ),
                          ),
                        ],
                      ),
                      const Divider(),
                      Row(
                        children: [
                          Container(
                            decoration: const BoxDecoration(
                              border: Border(
                                right: BorderSide(
                                  color: Colors
                                      .blue, // Adjust border color as needed
                                  width: 1.0,
                                ),
                              ),
                            ),
                            child: const Padding(
                              padding: EdgeInsets.symmetric(horizontal: 10.0),
                              child: Text(
                                'Batch/Year: ',
                                style: TextStyle(
                                  fontFamily: 'sedan',
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black87,
                                ),
                              ),
                            ),
                          ),
                          Text(
                            widget.batch.toString(),
                            style: const TextStyle(
                              fontFamily: 'sedan',
                              fontSize: 16,
                              color: Colors.black87,
                            ),
                          ),
                        ],
                      ),
                      const Divider(),
                      Row(
                        children: [
                          Container(
                            decoration: const BoxDecoration(
                              border: Border(
                                right: BorderSide(
                                  color: Colors
                                      .blue, // Adjust border color as needed
                                  width: 1.0,
                                ),
                              ),
                            ),
                            child: const Padding(
                              padding: EdgeInsets.symmetric(
                                horizontal: 8.9,
                              ),
                              child: Text(
                                'Department: ',
                                style: TextStyle(
                                  fontFamily: 'sedan',
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black87,
                                ),
                              ),
                            ),
                          ),
                          Text(
                            widget.department.toString(),
                            style: const TextStyle(
                              fontFamily: 'sedan',
                              fontSize: 16,
                              color: Colors.black87,
                            ),
                          ),
                        ],
                      ),
                      const Divider(),
                      Row(
                        children: [
                          Container(
                            decoration: const BoxDecoration(
                              border: Border(
                                right: BorderSide(
                                  color: Colors
                                      .blue, // Adjust border color as needed
                                  width: 1.0,
                                ),
                              ),
                            ),
                            child: const Padding(
                              padding: EdgeInsets.symmetric(horizontal: 10.0),
                              child: Text(
                                'Time: ',
                                style: TextStyle(
                                  fontFamily: 'sedan',
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black87,
                                ),
                              ),
                            ),
                          ),
                          Text(
                            "${widget.time} minutes",
                            style: const TextStyle(
                              fontFamily: 'sedan',
                              fontSize: 16,
                              color: Colors.black87,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20.0),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    if (_isReserved)
                      ElevatedButton(
                        onPressed: () => showDialog<bool>(
                          context: context,
                          builder: (context) => AlertDialog(
                            title: const Text(
                              'Confirmation',
                              style: TextStyle(
                                  fontFamily: 'sedan',
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                  fontStyle: FontStyle.normal),
                            ),
                            content: Text(
                                getConfirmationMessage()), // Use the dynamic message
                            actions: [
                              TextButton(
                                onPressed: () => Navigator.pop(
                                    context, false), // Cancel the dialog
                                child: const Text(
                                  'No',
                                  style: TextStyle(
                                      fontFamily: 'sedan',
                                      fontSize: 18,
                                      fontWeight: FontWeight.normal,
                                      fontStyle: FontStyle.normal),
                                ),
                              ),
                              TextButton(
                                onPressed: () {
                                  Navigator.pop(context,
                                      true); // Close dialog and perform deletion
                                  Delete_session(widget.My_tokens);
                                  setState(() => _isReserved = false);
                                  Navigator.pop(
                                      context); // Pop the current screen
                                  print('Session deleted!');
                                  // HapticFeedback
                                  //     .vibrate(); // Simulate haptic feedback on confirmation
                                },
                                child: const Text(
                                  'Yes',
                                  style: TextStyle(
                                      fontFamily: 'sedan',
                                      fontSize: 18,
                                      fontWeight: FontWeight.normal,
                                      fontStyle: FontStyle.normal),
                                ),
                              ),
                            ],
                          ),
                        ),
                        child: const Text('Cancel'),
                      ),
                    const SizedBox(
                      width: 15,
                    ),
                  ],
                ),
              ],
            ),
          ),
        ));
  }
}

Future<String?> Delete_session(String? Mytoken) async {
  const url_base = "https://besufikadyilma.tech/instructor/auth/delete-session";
// /instructor/in-class
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

class verif {
  bool msg;
  verif({
    required this.msg,
  });
}

verif message = verif(msg: false);

Future<void> Verified_session(String? Mytoken) async {
  const url_base = "https://besufikadyilma.tech/instructor/in-class";

  try {
    var response = await http.get(
      Uri.parse(url_base),
      headers: {
        "Content-Type": "application/json",
        "Authorization": "Bearer $Mytoken"
      },
    );

    if (response.statusCode == 200) {
      var verif_status = jsonDecode(response.body);
      print(verif_status);
      message.msg = verif_status['msg'];
      print(
          "................ verif is running........................................${message.msg}");
    } else {
      print("Error: ${response.body}");
    }
  } catch (e) {
    message.msg = true;
    print("Try failed so message will be: ${message.msg}");
  }
}
