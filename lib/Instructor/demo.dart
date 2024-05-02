// import 'dart:convert';

// import 'package:flutter/material.dart';
// import 'package:food/Instructor/booked_session.dart'; // Assuming BookedSession is in this directory

// void main() => runApp(const MaterialApp(
//   home: Announcement(),
// ));

// class Announcement extends StatefulWidget {
//   const Announcement({super.key});

//   @override
//   State<Announcement> createState() => _AnnouncementState();
// }

// class AnnouncementData {
//   final String courseName;
//   final String roomNumber;
//   final String section;
//   final String batch;
//   final String announcement;

//   const AnnouncementData({
//     required this.courseName,
//     required this.roomNumber,
//     required this.section,
//     required this.batch,
//     required this.announcement,
//   });
// }

// class _AnnouncementState extends State<Announcement> {
//   final _courseNameController = TextEditingController();
//   final _roomNumberController = TextEditingController();
//   final _sectionController = TextEditingController();
//   final _batchController = TextEditingController();
//   final _announcementController = TextEditingController();

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('Announcement',
//             style: TextStyle(
//                 fontFamily: 'Sedan', fontSize: 22, fontWeight: FontWeight.bold)),
//       ),
//       body: SingleChildScrollView(
//         padding: const EdgeInsets.all(16.0),
//         child: Column(
//           children: [
//             TextField(
//               controller: _courseNameController,
//               decoration: const InputDecoration(
//                 labelText: 'Course Name',
//               ),
//             ),
//             const SizedBox(height: 10.0),
//             TextField(
//               controller: _roomNumberController,
//               decoration: const InputDecoration(
//                 labelText: 'Room Number',
//               ),
//             ),
//             const SizedBox(height: 10.0),
//             TextField(
//               controller: _sectionController,
//               decoration: const InputDecoration(
//                 labelText: 'Section',
//               ),
//             ),
//             const SizedBox(height: 10.0),
//             TextField(
//               controller: _batchController,
//               decoration: const InputDecoration(
//                 labelText: 'Batch/Year',
//               ),
//             ),
//             const SizedBox(height: 10.0),
//             TextField(
//               controller: _announcementController,
//               maxLines: null,
//               decoration: const InputDecoration(
//                 labelText: 'Announcement (Optional)',
//               ),
//             ),
//             const SizedBox(height: 10.0),
//             ElevatedButton(
//               onPressed: () {
//                 _showConfirmationDialog(context);
//               },
//               child: const Text('Submit'),
//             ),
//             TextButton(
//               onPressed: () {
//                 // Assuming data is valid, navigate to BookedSessionPage
//                 final courseName = _courseNameController.text;
//                 final roomNumber = _roomNumberController.text;
//                 final section = _sectionController.text;
//                 final batch = _batchController.text;
//                 final announcement = _announcementController.text.trim();
//                 Navigator.push(
//                   context,
//                   MaterialPageRoute(
//                     builder: (context) => BookedSessionPage(
//                       courseName: courseName,
//                       roomNumber: roomNumber,
//                       section: section,
//                       batch: batch,
//                       announcement: announcement,
//                     ),
//                   ),
//                 );
//               },
//               child: const Text('View session Details',
//                   style: TextStyle(
//                       fontFamily: 'Sedan',
//                       fontSize: 16,
//                       fontWeight: FontWeight.normal,
//                       fontStyle: FontStyle.italic)),
//             ),
//           ],
//         ),
//       ),
//     );
//   }

//    _showConfirmationDialog(BuildContext context) {
//     showDialog(
//       context: context,
//       builder: (context) => AlertDialog(
//         title: const Text('Confirm Announcement'),
//         content: const Text(
//           'Warning: Once you confirm the session, the room will be reserved for 20 minutes. Failure to unlock it within this time will result in the room becoming available again, and the session will be canceled. ',
//         ),
//         actions: [
//           TextButton(
//             onPressed: () => Navigator.pop(context, false), // Close dialog (no)
//             child: const Text('Cancel'),
//           ),
//           TextButton(
//             onPressed: () {
//               () async {
//                 await _showConfirmationDialog(context);
//               };
//               Navigator.pop(context, true); // Close
//               final courseName = _courseNameController.text;
//               final roomNumber = _roomNumberController.text;
//               final section = _sectionController.text;
//               final batch = _batchController.text;
//               final announcement = _announcementController.text.trim();
//             },
//               child: const Text('Submit'),
//             ),
//         ],
//       ),
//     );
//   }
              

//   // Implement your announcement submission logic here (e.g., API call, data storage)
//   // Assuming a basic API call for demonstration (replace with your actual implementation)
//   final response = await post(
//     Uri.parse('https://your-api-endpoint.com/announcements'), // Replace with your API endpoint
//     body: {
//       'courseName': courseName,
//       'roomNumber': roomNumber,
//       'section': section,
//       'batch': batch,
//       'announcement': announcement,
//     },
//   );

//   if (response.statusCode == 200) {
//     // Announcement submitted successfully
//     final data = jsonDecode(response.body); // Assuming JSON response

//     // Extract any relevant data from the response (optional)
//     // ...

//     // Navigate to the booked session page
//     Navigator.push(
//       context,
//       MaterialPageRoute(
//         builder: (context) => BookedSessionPage(
//           courseName: courseName,
//           roomNumber: roomNumber,
//           section: section,
//           batch: batch,
//           announcement: announcement,
//         ),
//       ),
//     );
//   } else {
//     // Handle API call failure (show error message, etc.)
//     ScaffoldMessenger.of(context).showSnackBar(
//       SnackBar(
//         content: Text('Error submitting announcement: ${response.reasonPhrase}'),
//       ),
//     );
//   }
// }

// post(Uri parse, {required Map<String, dynamic> body}) {
// },
