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
        MaterialPageRoute(
          builder: (context) => MyHomePage(title: "AJOGAME - Match The Car"),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Color(0xFF3a6186), // warna biru gelap
              Color(0xFF89253e), // merah maroon
            ],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(
                Icons.videogame_asset_rounded,
                size: 80,
                color: Colors.white,
              ),
              const SizedBox(height: 16),
              const Text(
                'Masuk ke AJOGAME',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                  shadows: [
                    Shadow(
                      offset: Offset(1, 1),
                      blurRadius: 3.0,
                      color: Colors.black38,
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 32),
              MouseRegion(
                onEnter: (_) => setState(() => isHoveredTextField = true),
                onExit: (_) => setState(() => isHoveredTextField = false),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 300),
                  curve: Curves.easeInOut,
                  width: 300,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    boxShadow:
                        isHoveredTextField
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
                    textAlign: TextAlign.center,
                    style: const TextStyle(fontWeight: FontWeight.w600),
                    decoration: InputDecoration(
                      labelText: "JENENGMU SOPO",
                      labelStyle: const TextStyle(
                        fontSize: 16,
                        color: Colors.white70,
                      ),
                      floatingLabelStyle: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                      filled: true,
                      fillColor: const Color.fromARGB(255, 81, 94, 124),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide(
                          color: Colors.blue,
                          width: isHoveredTextField ? 3 : 2,
                        ),
                      ),
                    ),

                    onTap: () => _usernameController.text = "",
                  ),
                ),
              ),
              const SizedBox(height: 24),
              MouseRegion(
                onEnter: (_) => setState(() => isHoveredButton = true),
                onExit: (_) => setState(() => isHoveredButton = false),
                child: GestureDetector(
                  onTap: _login,
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 300),
                    curve: Curves.easeInOut,
                    width: isHoveredButton ? 180 : 160,
                    height: 50,
                    decoration: BoxDecoration(
                      color:
                          isHoveredButton ? Colors.blue[700] : Colors.blue[500],
                      borderRadius: BorderRadius.circular(30),
                      boxShadow:
                          isHoveredButton
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
                        duration: const Duration(milliseconds: 300),
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: isHoveredButton ? 20 : 18,
                          fontWeight: FontWeight.bold,
                          letterSpacing: isHoveredButton ? 2.0 : 1.0,
                        ),
                        child: const Text("LOGIN"),
                      ),
                    ),
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
