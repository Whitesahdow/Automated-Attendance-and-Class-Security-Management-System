import 'package:flutter/material.dart';
import 'package:AAMCS_App/front.dart';
import 'package:shared_preferences/shared_preferences.dart'; // Import shared_preferences package

class LogoutPage extends StatelessWidget {
  const LogoutPage({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Logout',
            style: TextStyle(
                fontFamily: 'Sedan',
                fontSize: 22,
                fontWeight: FontWeight.bold)),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              'Are you sure you want to logout?',
              style: TextStyle(
                  fontFamily: 'Sedan',
                  fontSize: 18,
                  fontWeight: FontWeight.normal),
            ),
            const SizedBox(height: 20.0),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
                  onPressed: () async {
                    final prefs = await SharedPreferences.getInstance();
                    await prefs
                        .clear(); // Clear all stored data in Shared Preferences
                    // ignore: avoid_print
                    print('Logging out...');
                    Navigator.pushAndRemoveUntil(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const Frontpage()),
                      ModalRoute.withName(
                          '/'), // Remove all routes below i.e it will not have any pages below
                    );
                  },
                  child: const Text(
                    'Logout',
                    style: TextStyle(
                        fontFamily: 'Sedan',
                        fontSize: 16,
                        fontWeight: FontWeight.bold),
                  ),
                ),
                const SizedBox(width: 20.0),
                OutlinedButton(
                  onPressed: () {
                    Navigator.pop(
                        context); // Go back to the previous page (StudentHome)
                  },
                  child: const Text(
                    'Cancel',
                    style: TextStyle(
                        fontFamily: 'Sedan',
                        fontSize: 16,
                        fontWeight: FontWeight.bold),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
