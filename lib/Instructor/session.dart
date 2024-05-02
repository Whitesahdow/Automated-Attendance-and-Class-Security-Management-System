// Import for DropdownButton
import 'package:flutter/material.dart';
import 'package:AAMCS_App/Instructor/booked_session.dart';

class Session extends StatefulWidget {
  const Session({super.key});

  @override
  State<Session> createState() => _SessionState();
}

class _SessionState extends State<Session> {
  static const List<String> _courseNames = [
    'Course 1',
    'Course 2',
    'Course 3'
  ]; // Replace with your course names
  static const List<String> _roomNumbers = [
    'Room A101',
    'Room B202',
    'Room C303'
  ]; // Replace with your room numbers
  static const List<String> _sections = [
    'Section A',
    'Section B',
    'Section C'
  ]; // Replace with your sections
  static const List<String> _batches = [
    '2023-2024',
    '2024-2025'
  ]; // Replace with your batches/years

  String? _selectedCourseName;
  String? _selectedRoomNumber;
  String? _selectedSection;
  String? _selectedBatch;
  final _announcementController = TextEditingController();

  get batch => "";
  get announcement => "";
  get courseName => "";
  get section => "";
  get roomNumber => '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Session',
            style: TextStyle(
                fontFamily: 'Sedan',
                fontSize: 22,
                fontWeight: FontWeight.bold)),
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
              onChanged: (value) =>
                  setState(() => _selectedCourseName = value!),
              decoration: const InputDecoration(
                  labelText: 'Course Name',
                  labelStyle: TextStyle(
                      fontFamily: 'Sedan',
                      fontSize: 16,
                      fontWeight: FontWeight.normal),
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(10)))),
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
              onChanged: (value) =>
                  setState(() => _selectedRoomNumber = value!),
              decoration: const InputDecoration(
                  labelText: 'Room Number',
                  labelStyle: TextStyle(
                      fontFamily: 'Sedan',
                      fontSize: 16,
                      fontWeight: FontWeight.normal),
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(10)))),
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
              onChanged: (value) => setState(() => _selectedSection = value!),
              decoration: const InputDecoration(
                  labelText: 'Section',
                  labelStyle: TextStyle(
                      fontFamily: 'Sedan',
                      fontSize: 16,
                      fontWeight: FontWeight.normal),
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(10)))),
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
              onChanged: (value) => setState(() => _selectedBatch = value!),
              decoration: const InputDecoration(
                  labelText: 'Batch/Year',
                  labelStyle: TextStyle(
                      fontFamily: 'Sedan',
                      fontSize: 16,
                      fontWeight: FontWeight.normal),
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(10)))),
            ),
            const SizedBox(height: 10.0),
            TextField(
              controller: _announcementController,
              maxLines: null,
              decoration: const InputDecoration(
                labelText: 'Announcement (Optional)',
                labelStyle: TextStyle(
                    fontFamily: 'Sedan',
                    fontSize: 16,
                    fontWeight: FontWeight.normal),
                border: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(10))),
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
                    fontWeight: FontWeight.bold),
              ),
            ),
            TextButton(
              onPressed: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => BookedSessionPage(
                            courseName: courseName,
                            roomNumber: roomNumber,
                            section: section,
                            batch: batch,
                            announcement: announcement)));
              },
              child: const Text('View session Details',
                  style: TextStyle(
                      fontFamily: 'Sedan',
                      fontSize: 16,
                      fontWeight: FontWeight.normal,
                      fontStyle: FontStyle.italic)),
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
        title: const Text('Confirm Announcement',
            style: TextStyle(
                fontFamily: 'Sedan',
                fontSize: 20,
                fontWeight: FontWeight.bold,
                fontStyle: FontStyle.normal)),
        content: const Text(
            'Warning: Once you confirm the session, the room will be reserved for 20 minutes. Failure to unlock it within this time will result in the room becoming available again, and the session will be canceled. ',
            style: TextStyle(
                fontFamily: 'sedan',
                fontSize: 17,
                fontWeight: FontWeight.normal,
                fontStyle: FontStyle.normal)),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false), // Close dialog (no)
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context, true); // Close dialog (yes)
              _announcementController.text.trim();
            },
            child: const Text('Submit'),
          ),
        ],
      ),
    );
  }
}
