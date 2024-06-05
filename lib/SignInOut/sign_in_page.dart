import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '/dashboard.dart';

class SignInPage extends StatefulWidget {
  final VoidCallback onSignUpClicked;

  const SignInPage({Key? key, required this.onSignUpClicked}) : super(key: key);

  @override
  _SignInPageState createState() => _SignInPageState();
}

class _SignInPageState extends State<SignInPage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _obscurePassword = true;

  void _togglePasswordVisibility() {
    setState(() {
      _obscurePassword = !_obscurePassword;
    });
  }

  Future<void> _signIn() async {
    if (_formKey.currentState!.validate()) {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? savedEmail = prefs.getString('email');
      String? savedPassword = prefs.getString('password');

      if (savedEmail == _emailController.text && savedPassword == _passwordController.text) {
        await prefs.setBool('loggedIn', true);
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => Dashboard()),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Invalid email or password')),
        );
      }
    }
  }

  InputDecoration getInputDecoration(String label, IconData prefixIcon,
      {Color iconColor = Colors.grey, IconButton? suffixIcon}) {
    return InputDecoration(
      labelText: label,
      prefixIcon: Icon(prefixIcon, color: iconColor),
      suffixIcon: suffixIcon,
      filled: true,
      fillColor: const Color.fromARGB(255, 247, 247, 255),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10.0),
      ),
      focusedBorder: OutlineInputBorder(
        borderSide: const BorderSide(color: Color.fromARGB(150, 56, 174, 204), width: 1.5),
        borderRadius: BorderRadius.circular(10.0),
      ),
      enabledBorder: OutlineInputBorder(
        borderSide: const BorderSide(color: Color.fromARGB(150, 13, 31, 45), width: 2),
        borderRadius: BorderRadius.circular(10.0),
      ),
      labelStyle: const TextStyle(
          color: Color.fromARGB(175, 13, 31, 45),
          fontSize: 16 // Color of the label text when focused
      ),
      floatingLabelStyle: const TextStyle(
          color: Color.fromARGB(175, 56, 174, 204),
          fontSize: 20
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              const Text('Sign In', style: TextStyle(fontSize: 40, fontWeight: FontWeight.bold, color: Colors.blue)),
              const Text('Welcome back', style: TextStyle(fontSize: 20, color: Color.fromARGB(175, 13, 31, 45))),
              const SizedBox(height: 20),
              TextFormField(
                controller: _emailController,
                cursorColor: const Color.fromARGB(175, 56, 174, 204),
                decoration: getInputDecoration('Email', Icons.email, iconColor: const Color.fromARGB(175, 13, 31, 45)),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your email';
                  }
                  if (!RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(value)) {
                    return 'Please enter a valid email';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 20),
              TextFormField(
                controller: _passwordController,
                cursorColor: const Color.fromARGB(175, 56, 174, 204),
                obscureText: _obscurePassword,
                decoration: getInputDecoration(
                  'Password',
                  Icons.lock,
                  suffixIcon: IconButton(
                    icon: Icon(_obscurePassword ? Icons.visibility : Icons.visibility_off, color: const Color.fromARGB(150, 13, 31, 45)),
                    onPressed: _togglePasswordVisibility,
                  ),
                  iconColor: const Color.fromARGB(175, 13, 31, 45),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your password';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 50),
              ElevatedButton(
                onPressed: _signIn,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
                  padding: const EdgeInsets.symmetric(horizontal: 100, vertical: 15),
                ),
                child: const Text('Sign In', style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold)),
              ),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  const Text("Don't have an account?", style: TextStyle(fontSize: 16, color: Color.fromARGB(180, 13, 31, 45))),
                  TextButton(
                    onPressed: widget.onSignUpClicked,
                    child: const Text('Sign Up', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.blue)),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
