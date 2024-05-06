import 'dart:math';
import 'package:flutter/material.dart';
import 'package:AAMCS_App/Student/My_Course/student_attendance.dart';
import 'package:url_launcher/url_launcher_string.dart'; // Import url_launcher package

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

// ignore: must_be_immutable
class CourseDetails extends StatelessWidget {
  final String courseName;
  CourseDetails({super.key, required this.courseName});
  List<AttendanceRecord> attendanceRecord = attendanceLoop();
  void launchPdf() async {
    if (!await canLaunchUrlString(
        'https://drive.google.com/file/d/17w_klSUok6w2OtuPFUz8shuWnRC_aiUh/view?usp=sharing')) {
      throw 'Could not launch PDF';
    }
    await launchUrlString(
        'https://drive.google.com/file/d/17w_klSUok6w2OtuPFUz8shuWnRC_aiUh/view?usp=sharing');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          courseName,
          style: const TextStyle(
              fontFamily: 'Sedan', fontSize: 22, fontWeight: FontWeight.bold),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Center(
              child: Text(
                'Course Details',
                style: TextStyle(
                    fontFamily: 'Sedan',
                    fontSize: 20,
                    fontWeight: FontWeight.bold),
              ),
            ),
            const SizedBox(height: 10.0),
            Text(
              'Course Name: $courseName',
              style: const TextStyle(
                  fontFamily: 'Sedan',
                  fontSize: 16,
                  fontWeight: FontWeight.normal),
            ),
            const SizedBox(height: 5.0),
            const Text(
              'Course Code: CSCE320',
              style: TextStyle(
                  fontFamily: 'Sedan',
                  fontSize: 16,
                  fontWeight: FontWeight.normal),
            ), // Replace with actual course code
            const SizedBox(height: 5.0),
            const Text('Credit Hours: 3',
                style: TextStyle(
                    fontFamily: 'Sedan',
                    fontSize: 16,
                    fontWeight:
                        FontWeight.normal)), // Replace with actual credit hours
            const SizedBox(height: 5.0),
            const Text('Category: Computer Science',
                style: TextStyle(
                    fontFamily: 'Sedan',
                    fontSize: 16,
                    fontWeight:
                        FontWeight.normal)), // Replace with actual category
            const SizedBox(height: 5.0),
            const Text('Instructor Name: Prof. John Doe',
                style: TextStyle(
                    fontFamily: 'Sedan',
                    fontSize: 16,
                    fontWeight: FontWeight
                        .normal)), // Replace with actual instructor name
            const Divider(thickness: 1.0),
            const Text('Attendance:',
                style: TextStyle(
                    fontFamily: 'Sedan',
                    fontSize: 16,
                    fontWeight: FontWeight.bold)),
            const SizedBox(height: 10.0),
            TextButton(
              onPressed: () {
                // Navigate to the attendance details page
                Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => AttendanceList(
                        attendanceRecords: attendanceRecord,
                      ),
                    ));
              },
              child: const Text('View Attendance Details',
                  style: TextStyle(
                      fontFamily: 'Sedan',
                      fontSize: 16,
                      fontWeight: FontWeight.normal,
                      fontStyle: FontStyle.italic)),
            ),
            const SizedBox(height: 10.0),
            // TextButton.icon(
            //   onPressed: () => launchPdf(), // Call the launchPdf method
            //   icon: const Icon(Icons.picture_as_pdf),
            //   label: const Text('View Course Outline (.pdf)'),
            // ),
          ],
        ),
      ),
    );
  }
}
// This is a placeholder class for your attendance details page