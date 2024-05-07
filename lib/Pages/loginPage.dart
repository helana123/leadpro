import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:leadconnectpro/Pages/homePage.dart';
import 'package:leadconnectpro/Pages/signupPage.dart';
import 'package:leadconnectpro/Widgets/widgets.dart';
import 'package:leadconnectpro/colors.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final FirebaseAuth _auth = FirebaseAuth.instance;
  bool _isPasswordVisible = false;
  String _errorText = '';

  void _togglePasswordVisibility() {
    setState(() {
      _isPasswordVisible = !_isPasswordVisible;
    });
  }

  Future<void> _login() async {
    try {
      UserCredential userCredential = await _auth.signInWithEmailAndPassword(
        email: _emailController.text.trim(),
        password: _passwordController.text.trim(),
      );
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => HomePage()),
      );
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        setState(() {
          _errorText = 'No user found for that email.';
        });
      } else if (e.code == 'wrong-password') {
        setState(() {
          _errorText = 'Incorrect password.';
        });
      } else if (e.code == 'invalid-email') {
        setState(() {
          _errorText = 'Invalid email format.';
        });
      }
      else if (e.code == 'network-request-failed') {
        setState(() {
          _errorText = 'Network error. Please check your internet connection.';
        });
      }
        else {
        setState(() {
          _errorText = 'Login failed. Please try again later.';
        });
      }
    } catch (e) {
      setState(() {
        _errorText = 'An unexpected error occurred. Please try again later.';
      });

    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: MyAppBar(
        title: ('Login'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              SizedBox(height: 40.0),
              TextField(
                controller: _emailController,
                decoration: InputDecoration(
                  labelText: 'Email',
                  border: OutlineInputBorder(),
                ),
              ),
              SizedBox(height: 20.0),
              TextField(
                controller: _passwordController,
                obscureText: !_isPasswordVisible,
                decoration: InputDecoration(
                  labelText: 'Password',
                  border: OutlineInputBorder(),
                  suffixIcon: IconButton(
                    icon: Icon(_isPasswordVisible ? Icons.visibility : Icons.visibility_off),
                    onPressed: _togglePasswordVisibility,
                  ),
                ),
              ),
              SizedBox(height: 20.0,),
              Text(
                _errorText,
                style: TextStyle(
                  color: Colors.red, // Set the color of the error text
                ),
              ),
              SizedBox(height: 20.0),
              GestureDetector(
                onTap: () {
                  // Handle forgot password
                },
                child: Text(
                  'Forgot Password?',
                  style: TextStyle(
                    color: AppsColor.textlink,
                  ),
                ),
              ),
              SizedBox(height: 50.0),
              ElevatedButton(
                onPressed: _login,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppsColor.primary,
                  padding: EdgeInsets.symmetric(vertical: 15.0, horizontal: 50.0),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(40.0),
                  ),
                ),
                child: Text(
                  'Login',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18.0,
                  ),
                ),
              ),
              SizedBox(height: 80.0),
              Text(
                'Or login with',
                style: TextStyle(
                  fontSize: 16.0,
                ),
              ),
              SizedBox(height: 30.0),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  InkWell(
                    onTap: () {
                      // Handle Google login
                    },
                    child: Image.asset(
                      'assets/google.png',
                      width: 30.0,
                      height: 30.0,
                    ),
                  ),
                  SizedBox(width: 20.0),
                  InkWell(
                    onTap: () {
                      // Handle Facebook login
                    },
                    child: Image.asset(
                      'assets/facebook.png',
                      width: 30.0,
                      height: 30.0,
                    ),
                  ),
                  SizedBox(width: 20.0),
                  InkWell(
                    onTap: () {
                      // Handle LinkedIn login
                    },
                    child: Image.asset(
                      'assets/linkedin.png',
                      width: 30.0,
                      height: 30.0,
                    ),
                  ),
                ],
              ),
              SizedBox(height: 130.0),
              GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => SignUpPage()),
                  );
                },
                child: Text(
                  'New around here? Sign up',
                  style: TextStyle(
                    color: AppsColor.textlink,
                    decoration: TextDecoration.underline,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
