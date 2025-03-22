import 'package:ajogame/screen/game.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:ajogame/screen/login.dart';
import 'package:ajogame/screen/leaderboard.dart';
import 'package:ajogame/class/level.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  String? _username;
  Home? drawer;
  Level _selectedLevel = levels[0];

  @override
  void initState() {
    super.initState();
    _loadUsername();
  }

  Future<void> _loadUsername() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      _username = prefs.getString('username') ?? "User";
    });
  }

  Drawer myDrawer() {
    return Drawer(
      elevation: 16.0,
      child: Column(
        children: <Widget>[
          UserAccountsDrawerHeader(
            accountName: Text(_username!),
            accountEmail: Text("xyz@gmail.com"),
            currentAccountPicture: CircleAvatar(
              backgroundImage: NetworkImage("https://i.pravatar.cc/150"),
            ),
          ),
          ListTile(
            title: const Text("Leaderboard"),
            leading: const Icon(Icons.person),
            onTap: () {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => Leaderboard()),
              );
            },
          ),
          ListTile(
            title: const Text("Logout"),
            leading: const Icon(Icons.person),
            onTap: () {
              _logout();
            },
          ),
        ],
      ),
    );
  }

  Future<void> _logout() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.remove('username');

    // Pindah ke LoginScreen setelah logout
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => Login()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Home")),
      drawer: myDrawer(),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text("Selamat datang, $_username!", style: TextStyle(fontSize: 20)),
            SizedBox(height: 20),
            DropdownButton<Level>(
              items:
                  levels.map((level) {
                    return DropdownMenuItem<Level>(
                      value: level, // Simpan langsung object Level
                      child: Text("Level ${level.id} - ${level.time}s"),
                    );
                  }).toList(),
              value: _selectedLevel, // Default harus ada atau null
              onChanged: (value) {
                setState(() {
                  _selectedLevel = value!; // Simpan object Level
                });
              },
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => GameScreen(_selectedLevel)),
                );
              },
              child: Text("playgame"),
            ),
          ],
        ),
      ),
    );
  }
}
