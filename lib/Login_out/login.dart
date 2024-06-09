import 'package:AAMCS_App/Login_out/controllers/auth_cntrl.dart';
import 'package:flutter/material.dart';
import 'package:AAMCS_App/Instructor/instructor_home.dart';
import 'package:AAMCS_App/Student/student_home.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);
  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  String userType = '';
  bool isLoading = false;
  void setUserType(String type) {
    setState(() {
      userType = type;
    });
  }

  AuthController auth_controller = AuthController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: null,
      backgroundColor: Colors.white,
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              Center(child: Image.asset('assets/images/AASTU_logo.png')),
              const SizedBox(height: 40.0),

              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  OutlinedButton(
                    onPressed: isLoading
                        ? null
                        : () {
                            setState(() {
                              userType = 'teacher';
                            });
                          },
                    style: OutlinedButton.styleFrom(
                      side: BorderSide(
                        color: userType == 'teacher' ? Colors.blue : Colors.grey,
                      ),
                    ),
                    child: const Text(
                      'Teacher',
                      style: TextStyle(fontFamily: 'Sedan', fontSize: 16),
                    ),
                  ),
                  const SizedBox(width: 20.0),
                  OutlinedButton(
                    onPressed: isLoading
                        ? null
                        : () {
                            setState(() {
                              userType = 'student';
                            });
                          },
                    style: OutlinedButton.styleFrom(
                      side: BorderSide(
                          color: userType == 'student'
                              ? Colors.blue
                              : Colors.grey),
                    ),
                    child: const Text(
                      'Student',
                      style: TextStyle(fontFamily: 'Sedan', fontSize: 16),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20.0),
              TextField(
                enabled: !isLoading,
                keyboardType: TextInputType.emailAddress,
                controller: auth_controller.username_controller,
                decoration: InputDecoration(
                  labelText: 'Email',
                  labelStyle: const TextStyle(
                    fontSize: 15,
                    fontFamily: 'sedan',
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                ),
              ),
              const SizedBox(height: 20.0),
              TextField(
                enabled: !isLoading,
                obscureText: true,
                controller: auth_controller.password_controller,
                decoration: InputDecoration(
                  labelText: 'Password',
                  labelStyle: const TextStyle(
                    fontSize: 15,
                    fontFamily: 'sedan',
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                ),
              ),
              const SizedBox(height: 20.0),
              ElevatedButton(
                onPressed: isLoading
                    ? null
                    : () async {
                        setState(() {
                          isLoading = true;
                        });
                        var token = await auth_controller.loginuser(userType);
                        setState(() {
                          isLoading = false;
                        });
                        if (auth_controller.reuest_responese.loginArr == "true") {
                          Navigator.pushAndRemoveUntil(
                            context,
                            MaterialPageRoute(
                              builder: (context) => userType == 'teacher'
                                  ? InstructorHome(token)
                                  : StudentHome(token),
                            ),
                            ModalRoute.withName('/'),
                          );
                        } else {
                          _showLoginFailedDialog(context);
                        }
                      },
                style: ElevatedButton.styleFrom(
                  textStyle: const TextStyle(
                    fontFamily: 'sedan',
                    fontWeight: FontWeight.bold,
                    fontSize: 15,
                  ),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 20.0,
                    vertical: 15.0,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                ),
                child: isLoading
                    ? const CircularProgressIndicator(
                        color: Color.fromARGB(255, 1, 100, 181))
                    : const Text('Login'),
              ),
              const SizedBox(height: 12.0),
            ],
          ),
        ),
      ),
    );
  }
}

void _showLoginFailedDialog(BuildContext context) {
  showDialog(
    context: context,
    builder: (context) => AlertDialog(
      title: const Text(
        'Login Failed',
        style: TextStyle(
          fontFamily: 'Sedan',
          fontSize: 20,
          fontWeight: FontWeight.bold,
          fontStyle: FontStyle.normal,
        ),
      ),
      content: const Text(
        'Please try again.',
        style: TextStyle(
          fontFamily: 'Sedan',
          fontSize: 17,
          fontWeight: FontWeight.normal,
          fontStyle: FontStyle.italic,
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Okay'),
        ),
      ],
    ),
  );
}
