import 'package:flutter/material.dart';
import 'package:flutter/services.dart'; // For HapticFeedback

class BookedSessionPage extends StatefulWidget {
  final String courseName;
  final String roomNumber;
  final String section;
  final String batch;
  final String department;
  final String time;

  const BookedSessionPage({
    super.key,
    required this.courseName,
    required this.roomNumber,
    required this.section,
    required this.batch,
    required this.department,
    required this.time,
  });

  @override
  State<BookedSessionPage> createState() => _BookedSessionPageState();
}

class _BookedSessionPageState extends State<BookedSessionPage> {
  bool _isReserved = true; // Flag to track reservation status

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          _isReserved ? 'Booked Session' : 'Session Canceled',
          style: const TextStyle(
            fontFamily: 'sedan',
            fontSize: 22,
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (_isReserved || // Show details even if reserved but empty
                widget.courseName.isNotEmpty ||
                widget.roomNumber.isNotEmpty ||
                widget.section.isNotEmpty ||
                widget.batch.isNotEmpty ||
                widget.department.isNotEmpty ||
                widget.time.isNotEmpty)
              Text(
                'Course Name : ${widget.courseName}',
                style: const TextStyle(
                  fontFamily: 'sedan',
                  fontSize: 16,
                ),
              ),
            if (_isReserved || // Show details even if reserved but empty
                widget.courseName.isNotEmpty ||
                widget.roomNumber.isNotEmpty ||
                widget.section.isNotEmpty ||
                widget.batch.isNotEmpty ||
                widget.department.isNotEmpty ||
                widget.time.isNotEmpty)
              const SizedBox(height: 5.0),
            if (_isReserved || // Show details even if reserved but empty
                widget.courseName.isNotEmpty ||
                widget.roomNumber.isNotEmpty ||
                widget.section.isNotEmpty ||
                widget.batch.isNotEmpty ||
                widget.department.isNotEmpty ||
                widget.time.isNotEmpty)
              Text(
                'Room Number : ${widget.roomNumber}',
                style: const TextStyle(
                  fontFamily: 'sedan',
                  fontSize: 16,
                ),
              ),
            if (_isReserved || // Show details even if reserved but empty
                widget.courseName.isNotEmpty ||
                widget.roomNumber.isNotEmpty ||
                widget.section.isNotEmpty ||
                widget.batch.isNotEmpty ||
                widget.department.isNotEmpty ||
                widget.time.isNotEmpty)
              const SizedBox(height: 5.0),
            if (_isReserved || // Show details even if reserved but empty
                widget.courseName.isNotEmpty ||
                widget.roomNumber.isNotEmpty ||
                widget.section.isNotEmpty ||
                widget.batch.isNotEmpty ||
                widget.department.isNotEmpty ||
                widget.time.isNotEmpty)
              Text(
                'Section : ${widget.section}',
                style: const TextStyle(
                  fontFamily: 'sedan',
                  fontSize: 16,
                ),
              ),
            if (_isReserved || // Show details even if reserved but empty
                widget.courseName.isNotEmpty ||
                widget.roomNumber.isNotEmpty ||
                widget.section.isNotEmpty ||
                widget.batch.isNotEmpty ||
                widget.department.isNotEmpty ||
                widget.time.isNotEmpty)
              const SizedBox(height: 5.0),
            if (_isReserved || // Show details even if reserved but empty
                widget.courseName.isNotEmpty ||
                widget.roomNumber.isNotEmpty ||
                widget.section.isNotEmpty ||
                widget.batch.isNotEmpty ||
                widget.department.isNotEmpty ||
                widget.time.isNotEmpty)
              Text(
                'Batch/Year : ${widget.batch}',
                style: const TextStyle(
                  fontFamily: 'sedan',
                  fontSize: 16,
                ),
              ),
            if (_isReserved || // Show details even if reserved but empty
                widget.courseName.isNotEmpty ||
                widget.roomNumber.isNotEmpty ||
                widget.section.isNotEmpty ||
                widget.department.isNotEmpty ||
                widget.time.isNotEmpty)
              const SizedBox(height: 5.0),
            if (_isReserved || // Show details even if reserved but empty
                widget.courseName.isNotEmpty ||
                widget.roomNumber.isNotEmpty ||
                widget.section.isNotEmpty ||
                widget.department.isNotEmpty ||
                widget.time.isNotEmpty)
              Text(
                'Department : ${widget.department}',
                style: const TextStyle(
                  fontFamily: 'sedan',
                  fontSize: 16,
                ),
              ),
            if (_isReserved || // Show details even if reserved but empty
                widget.courseName.isNotEmpty ||
                widget.roomNumber.isNotEmpty ||
                widget.section.isNotEmpty ||
                widget.department.isNotEmpty ||
                widget.time.isNotEmpty)
              Text(
                'Time : in ${widget.time} minutes',
                style: const TextStyle(
                  fontFamily: 'sedan',
                  fontSize: 19,
                ),
              ),
            if (!_isReserved && // Show "No announcement today" for cancellations or empty data
                widget.courseName.isEmpty &&
                widget.roomNumber.isEmpty &&
                widget.section.isEmpty &&
                widget.department.isEmpty &&
                widget.time.isEmpty)
              const Center(
                child: Text(
                  'No announcement today',
                  style: TextStyle(
                    fontFamily: 'sedan',
                    fontSize: 16,
                  ),
                ),
              ),
            const SizedBox(height: 20.0),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                if (_isReserved)
                  ElevatedButton(
                    onPressed: () {
                      setState(() => _isReserved = false);
                      // Simulate haptic feedback on cancellation
                      HapticFeedback.vibrate();
                    },
                    child: const Text('Cancel'),
                  ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
