import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '/dashboard.dart';

class SignUpPage extends StatefulWidget {
  final VoidCallback onSignInClicked;

  const SignUpPage({Key? key, required this.onSignInClicked}) : super(key: key);

  @override
  _SignUpPageState createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController = TextEditingController();
  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;

  void _togglePasswordVisibility() {
    setState(() {
      _obscurePassword = !_obscurePassword;
    });
  }

  void _toggleConfirmPasswordVisibility() {
    setState(() {
      _obscureConfirmPassword = !_obscureConfirmPassword;
    });
  }

  Future<void> _signUp() async {
    if (_formKey.currentState!.validate()) {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.setString('username', _usernameController.text);
      await prefs.setString('email', _emailController.text);
      await prefs.setString('password', _passwordController.text);
      await prefs.setBool('loggedIn', true);
      
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => Dashboard()),
      );
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
              const Text('Sign up', style: TextStyle(fontSize: 40, fontWeight: FontWeight.bold, color: Colors.blue)),
              const Text('Create your account', style: TextStyle(fontSize: 20, color: Color.fromARGB(175, 13, 31, 45))),
              const SizedBox(height: 20),
              TextFormField(
                controller: _usernameController,
                cursorColor: const Color.fromARGB(175, 56, 174, 204),
                decoration: getInputDecoration('Username', Icons.person, iconColor: const Color.fromARGB(175, 13, 31, 45)),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your username';
                  }
                  return null;
                },
              ),
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
              const SizedBox(height: 20),
              TextFormField(
                controller: _confirmPasswordController,
                cursorColor: const Color.fromARGB(175, 56, 174, 204),
                cursorHeight: 25,
                cursorOpacityAnimates: true,
                obscureText: _obscureConfirmPassword,
                decoration: getInputDecoration(
                  'Confirm Password',
                  Icons.lock,
                  suffixIcon: IconButton(
                    icon: Icon(_obscureConfirmPassword ? Icons.visibility : Icons.visibility_off, color: const Color.fromARGB(150, 13, 31, 45)),
                    onPressed: _toggleConfirmPasswordVisibility,
                  ),
                  iconColor: const Color.fromARGB(180, 13, 31, 45),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please confirm your password';
                  }
                  if (value != _passwordController.text) {
                    return 'Passwords do not match';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 50),
              ElevatedButton(
                onPressed: _signUp,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
                  padding: const EdgeInsets.symmetric(horizontal: 100, vertical: 15),
                ),
                child: const Text('Sign Up', style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold)),
              ),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  const Text("Already have an account?", style: TextStyle(fontSize: 16, color: Color.fromARGB(180, 13, 31, 45))),
                  TextButton(
                    onPressed: widget.onSignInClicked,
                    child: const Text('Sign In', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.blue)),
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
