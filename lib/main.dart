import 'package:ajogame/screen/leaderboard.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:ajogame/screen/home.dart';
import 'package:ajogame/screen/game.dart';
import 'package:ajogame/screen/login.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      routes: {
  			   'leaderboard': (context) =>const Leaderboard(),
   			},
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color.fromARGB(255, 0, 91, 182),
        ),
      ),
      home: const MyHomePage(title: 'AJOGAME - Match The Card'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});
  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  String? _username;
  int _currentIndex = 0;
  final List<Widget> _screens = [Home(),];

  @override
  void initState() {
    super.initState();
    _checkLoginStatus();
  }

  Future<void> _checkLoginStatus() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      _username = prefs.getString(
        'username',
      ); // Ambil username dari shared prefs
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      drawer: myDrawer(),
      body: _username == null ? const Login() : _screens[_currentIndex],
    );
  }

  //BATASS
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
              Navigator.pushNamed(context, 'leaderboard');
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

  void _incrementCounter() {
    setState(() {});
  }

  FloatingActionButton floatbut() {
    return FloatingActionButton(
      onPressed: _incrementCounter,
      tooltip: 'Increment',
      child: const Icon(Icons.add),
    );
  }

  Center Default(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          const Text('You have pushed the button this many times:'),
          Text('', style: Theme.of(context).textTheme.headlineMedium),
        ],
      ),
    );
  }

  BottomNavigationBar bottomNav() {
    return BottomNavigationBar(
      currentIndex: _currentIndex,
      fixedColor: const Color.fromARGB(255, 255, 5, 243),
      items: const [
        BottomNavigationBarItem(label: "Home", icon: Icon(Icons.home)),
        BottomNavigationBarItem(label: "Game", icon: Icon(Icons.gamepad)),
      ],
      onTap: (int index) {
        setState(() {
          _currentIndex = index;
        });
      },
    );
  }
}
