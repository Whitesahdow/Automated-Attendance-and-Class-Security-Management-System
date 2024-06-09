import 'package:AAMCS_App/Login_out/controllers/auth_cntrl.dart';
import 'package:flutter/material.dart';
import 'package:AAMCS_App/front.dart';
// Import shared_preferences package

class LogoutPage extends StatelessWidget {
  final String? My_Token;
  final String usertype;
  const LogoutPage(this.My_Token, this.usertype, {super.key});
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
                    await logoutUser(usertype, My_Token);
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
