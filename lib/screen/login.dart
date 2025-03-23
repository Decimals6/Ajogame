import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:ajogame/screen/home.dart';
import 'package:ajogame/main.dart';

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final TextEditingController _usernameController = TextEditingController();
  bool isHoveredButton = false;
  bool isHoveredTextField = false;

  Future<void> _login() async {
    String username = _usernameController.text.trim();
    if (username.isNotEmpty) {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.setString('username', username);

      // Pindah ke HomeScreen setelah login
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => MyHomePage(title: "AJOGAME - Match The Car",)),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(
              width: 500,
              child: Column(
                children: [
                  MouseRegion(
                    onEnter: (_) => setState(() => isHoveredTextField = true),
                    onExit: (_) => setState(() => isHoveredTextField = false),
                    child: AnimatedContainer(
                      duration: Duration(milliseconds: 300),
                      curve: Curves.easeInOut,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(10),
                        boxShadow: isHoveredTextField
                            ? [
                                BoxShadow(
                                  color: Colors.blue.withOpacity(0.4),
                                  blurRadius: 10,
                                  spreadRadius: 2,
                                ),
                              ]
                            : [],
                      ),
                      child: TextField(
                        controller: _usernameController,
                        textAlign: TextAlign.center, // Bikin teks di tengah
                        decoration: InputDecoration(
                          labelText: "JENENGMU SOPO",
                          labelStyle: TextStyle(fontSize: 16),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide: BorderSide(
                                color: Colors.blue, width: isHoveredTextField ? 3 : 2),
                          ),
                        ),
                        onTap: () {
                          _usernameController.text = "";
                        },
                        keyboardType: TextInputType.multiline,
                      ),
                    ),
                  ),
                  SizedBox(height: 20),
                  MouseRegion(
                    onEnter: (_) => setState(() => isHoveredButton = true),
                    onExit: (_) => setState(() => isHoveredButton = false),
                    child: GestureDetector(
                      onTap: () {
                        // print("Login button clicked!");
                        _login();
                      },
                      child: AnimatedContainer(
                        duration: Duration(milliseconds: 300),
                        curve: Curves.easeInOut,
                        width: isHoveredButton ? 180 : 160,
                        height: 50,
                        decoration: BoxDecoration(
                          color: isHoveredButton ? Colors.blue[700] : Colors.blue[500],
                          borderRadius: BorderRadius.circular(30),
                          boxShadow: isHoveredButton
                              ? [
                                  BoxShadow(
                                    color: Colors.blue.withOpacity(0.6),
                                    blurRadius: 15,
                                    spreadRadius: 3,
                                  ),
                                ]
                              : [],
                        ),
                        child: Center(
                          child: AnimatedDefaultTextStyle(
                            duration: Duration(milliseconds: 300),
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: isHoveredButton ? 20 : 18,
                              fontWeight: FontWeight.bold,
                              letterSpacing: isHoveredButton ? 2.0 : 1.0,
                            ),
                            child: Text("LOGIN"),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
