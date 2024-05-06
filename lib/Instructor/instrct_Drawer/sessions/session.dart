import 'package:flutter/material.dart';
import 'package:AAMCS_App/Instructor/booked_session.dart';

class Session extends StatefulWidget {
  const Session({super.key});

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

class _SessionState extends State<Session> {
  static const List<String> _courseNames = [
    'Course 1',
    'Course 2',
    'Course 3'
  ]; // this should come from api requests
  static const List<String> _roomNumbers = [
    'Room A101',
    'Room B202',
    'Room C303'
  ]; // this should come from api requests
  static const List<String> _sections = [
    'Section A',
    'Section B',
    'Section C'
  ]; // this should come from api requests
  static const List<String> _batches = [
    '2023-2024',
    '2024-2025'
  ]; // this should come from api requests

  String? _selectedCourseName;
  String? _selectedRoomNumber;
  String? _selectedSection;
  String? _selectedBatch;
  final _announcementController = TextEditingController();

  SessionData sessionData = SessionData();

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
              items: _courseNames
                  .map((courseName) => DropdownMenuItem<String>(
                        value: courseName,
                        child: Text(courseName),
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
            const SizedBox(height: 10.0),
            DropdownButtonFormField<String>(
              value: _selectedRoomNumber,
              items: _roomNumbers
                  .map((roomNumber) => DropdownMenuItem<String>(
                        value: roomNumber,
                        child: Text(roomNumber),
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
            const SizedBox(height: 10.0),
            DropdownButtonFormField<String>(
              value: _selectedSection,
              items: _sections
                  .map((section) => DropdownMenuItem<String>(
                        value: section,
                        child: Text(section),
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
            const SizedBox(height: 10.0),
            DropdownButtonFormField<String>(
              value: _selectedBatch,
              items: _batches
                  .map((batch) => DropdownMenuItem<String>(
                        value: batch,
                        child: Text(batch),
                      ))
                  .toList(),
              onChanged: (value) {
                setState(() {
                  _selectedBatch = value;
                  sessionData.batch = value;
                });
              },
              decoration: const InputDecoration(
                labelText: 'Batch/Year',
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
            const SizedBox(height: 10.0),
            TextField(
              controller: _announcementController,
              maxLines: null,
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
            const SizedBox(height: 10.0),
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
                  ),
                ),
              );
              _announcementController.text.trim();
              print(sessionData.courseName);
              print(sessionData.roomNumber);
              print(sessionData.section);
              print(sessionData.batch);
            },
            child: const Text('Submit'),
          ),
        ],
      ),
    );
  }
}
