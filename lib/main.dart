import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dashboard.dart';
import 'SignInOut/sign_in_page.dart';
import 'SignInOut/sign_up_page.dart';
import 'Services/CampusManagement.dart';
import 'Services/FacultyManagement.dart';
import 'Services/DepartmentManagement.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SharedPreferences prefs = await SharedPreferences.getInstance();
  bool isLoggedIn = prefs.getBool('loggedIn') ?? false;

  runApp(MyApp(isLoggedIn: isLoggedIn));
}

class MyApp extends StatelessWidget {
  final bool isLoggedIn;

  MyApp({required this.isLoggedIn});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        scaffoldBackgroundColor: const Color.fromARGB(255, 247, 247, 255),
      ),
      initialRoute: isLoggedIn ? '/dashboard' : '/',
      routes: {
        '/': (context) => AuthPage(),
        '/dashboard': (context) => Dashboard(),
        '/campus_management': (context) => CampusManagement(),
        '/faculty_management': (context) => FacultyManagement(),
        '/department_management': (context) => DepartmentManagement(),
      },
      debugShowCheckedModeBanner: false,
    );
  }
}

class AuthPage extends StatefulWidget {
  @override
  _AuthPageState createState() => _AuthPageState();
}

class _AuthPageState extends State<AuthPage> {
  final PageController _pageController = PageController();

  void _goToSignUp() {
    _pageController.animateToPage(1, duration: Duration(milliseconds: 300), curve: Curves.easeIn);
  }

  void _goToSignIn() {
    _pageController.animateToPage(0, duration: Duration(milliseconds: 300), curve: Curves.easeIn);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PageView(
        controller: _pageController,
        children: [
          SignInPage(onSignUpClicked: _goToSignUp),
          SignUpPage(onSignInClicked: _goToSignIn),
        ],
      ),
    );
  }
}