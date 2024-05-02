import 'dart:math';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart'; // Import intl package

class AttendanceRecord {
  final DateTime date;
  final AttendanceStatus status;
  final String? clockIn;
  final String? clockOut;
  AttendanceRecord(this.date, this.status, this.clockIn, this.clockOut);
}

List<AttendanceRecord> attendanceRecords = [];
List<AttendanceRecord> attendanceLoop() {
  for (int i = 1; i <= 2; i++) {
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

enum AttendanceStatus { present, absent }

class AttendanceList extends StatefulWidget {
  final List<AttendanceRecord> attendanceRecords;
  const AttendanceList({super.key, required this.attendanceRecords});
  @override
  State<AttendanceList> createState() => _AttendanceListState();
}

class _AttendanceListState extends State<AttendanceList> {
  @override
  Widget build(BuildContext context) {
    final attendanceRecords = widget.attendanceRecords;
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Attendance List',
          style: TextStyle(
              fontSize: 22, fontWeight: FontWeight.bold, fontFamily: 'sedan'),
        ),
        backgroundColor: const Color.fromARGB(255, 181, 175, 175),
      ),
      backgroundColor: const Color.fromARGB(255, 181, 175, 175),
      body: ListView.builder(
        itemCount: attendanceRecords.length,
        itemBuilder: (context, index) {
          final attendanceRecord = attendanceRecords[index];
          return ListTile(
            subtitle: Row(
              children: [
                Expanded(
                  child: Container(
                    padding: const EdgeInsets.all(8.0),
                    decoration: BoxDecoration(
                      color: attendanceRecord.status == AttendanceStatus.present
                          ? const Color.fromARGB(175, 100, 180, 100)
                          : const Color.fromARGB(175, 180, 100, 100),
                      borderRadius: BorderRadius.circular(5.0),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      // Use Column to stack information vertically
                      children: [
                        Text(
                          attendanceRecord.status == AttendanceStatus.present
                              ? 'Attended'
                              : 'Missed/Skipped/Unavailable',
                          style: const TextStyle(
                              fontSize: 17,
                              fontWeight: FontWeight.bold,
                              color: Colors.black,
                              fontFamily: 'sedan'),
                        ),
                        const SizedBox(
                            height:
                                null), // Add some spacing between text lines
                        if (attendanceRecord.status ==
                            AttendanceStatus.present) ...[
                          Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            // Use Row for clock in/out information
                            children: [
                              Text(
                                'Time In: ${attendanceRecord.clockIn}',
                                style: const TextStyle(
                                    fontSize: 14,
                                    fontFamily: 'sedan',
                                    color: Colors.black),
                              ),
                              const SizedBox(width: 10.0),
                              Text(
                                'Time Out: ${attendanceRecord.clockOut}',
                                style: const TextStyle(
                                    fontSize: 14,
                                    fontFamily: 'sedan',
                                    color: Colors.black),
                              ),
                            ],
                          ),
                        ],
                        Text(
                          DateFormat.yMMMEd().format(attendanceRecord.date),
                          style: const TextStyle(
                              fontSize: 14,
                              fontFamily: 'sedan',
                              fontStyle: FontStyle.italic,
                              fontWeight: FontWeight.bold,
                              color: Colors.black),
                        ),
                      ],
                    ),
                  ),
                )
              ],
            ),
          );
        },
      ),
    );
  }
}
