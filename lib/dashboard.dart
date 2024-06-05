import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'SignInOut/sign_in_page.dart';
import 'SignInOut/sign_up_page.dart';

class Dashboard extends StatefulWidget {
  @override
  _DashboardState createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  String? _username;
  String? _email;

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  Future<void> _loadUserData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      _username = prefs.getString('username');
      _email = prefs.getString('email');
    });
  }

  Future<void> _signOut() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setBool('loggedIn', false);
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => SignInPage(onSignUpClicked: () {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => SignUpPage(onSignInClicked: () {})),
        );
      })),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue,
        title: Text('Institute Config. Sys', style: TextStyle(fontWeight: FontWeight.bold)),
        actions: [
          Builder(
            builder: (context) => IconButton(
              icon: Icon(Icons.menu),
              onPressed: () => Scaffold.of(context).openDrawer(),
            ),
          ),
        ],
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            UserAccountsDrawerHeader(
              decoration: BoxDecoration(
                color: Color.fromARGB(180, 13, 31, 45),
              ),
              accountName: Text(_username ?? 'Loading...'),
              accountEmail: Text(_email ?? 'Loading...'),
              currentAccountPicture: CircleAvatar(
                backgroundColor: Colors.blue,
                child: Text(
                  _username != null ? _username![0].toUpperCase() : '',
                  style: TextStyle(fontSize: 18.0, color: Colors.white),
                ),
              ),
            ),
            Divider(color: Color.fromARGB(180, 13, 31, 45), thickness: 1.5),
            ListTile(
              leading: Icon(Icons.dashboard, color: Color.fromARGB(180, 13, 31, 45)),
              title: Text('Dashboard'),
              onTap: () {},
            ),
            ListTile(
              leading: Icon(Icons.business, color: Color.fromARGB(180, 13, 31, 45)),
              title: Text('Campus Management'),
              onTap: () {
                Navigator.pushNamed(context, '/campus_management');
              },
            ),
            ListTile(
              leading: Icon(Icons.account_balance, color: Color.fromARGB(180, 13, 31, 45)),
              title: Text('Faculty Management'),
              onTap: () {
                Navigator.pushNamed(context, '/faculty_management');
              },
            ),
            ListTile(
              leading: Icon(Icons.school, color: Color.fromARGB(180, 13, 31, 45)),
              title: Text('Department Management'),
              onTap: () {
                Navigator.pushNamed(context, '/department_management');
              },
            ),
            Divider(color: Color.fromARGB(180, 13, 31, 45), thickness: 1.5),
            ListTile(
              leading: Icon(Icons.logout, color: Color.fromARGB(180, 13, 31, 45)),
              title: Text('Log Out'),
              onTap: () => _showLogoutConfirmation(context),
            ),
          ],
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 10),
              Card(
                color: Colors.blue,
                elevation: 4,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        '----   Welcome to your dashboard   ----',
                        style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Colors.white),
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(height: 10),
              Card(
                elevation: 4,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Text(
                            'Institute Overview:',
                            style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Color.fromARGB(180, 13, 31, 45)),
                          ),
                        ],
                      ),
                      SizedBox(height: 20),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          _buildCard('Institute Info', 'Islamia University Bhawalpur', Icons.info),
                        ],
                      ),
                      SizedBox(height: 10),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          _buildCard('Total Campuses', '3', Icons.business),
                        ],
                      ),
                      SizedBox(height: 10),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          _buildCard('Total Faculties', '5', Icons.account_balance),
                          _buildCard('Total Departments', '20', Icons.school),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              Card(
                elevation: 4,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'News',
                        style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Color.fromARGB(180, 13, 31, 45)),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCard(String title, String count, IconData icon) {
    return Expanded(
      child: Card(
        elevation: 2,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Column(
            children: [
              Icon(icon, size: 35, color: Color.fromARGB(180, 13, 31, 45)),
              SizedBox(height: 10),
              Text(
                title,
                style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Color.fromARGB(180, 13, 31, 45)),
              ),
              SizedBox(height: 10),
              Text(
                count,
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Color.fromARGB(180, 13, 31, 45)),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showLogoutConfirmation(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Log Out'),
        content: Text('Are you sure you want to log out?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              _signOut();
            },
            child: Text('Log Out'),
          ),
        ],
      ),
    );
  }
}