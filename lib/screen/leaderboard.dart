import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'package:ajogame/main.dart';

class Leaderboard extends StatefulWidget {
  const Leaderboard({super.key});

  @override
  _LeaderboardState createState() => _LeaderboardState();
}

class _LeaderboardState extends State<Leaderboard> {
  List<Map<String, dynamic>> leaderboard = [];

  @override
  void initState() {
    super.initState();
    _loadLeaderboard();
  }

  Future<void> _loadLeaderboard() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    String? leaderboardString = prefs.getString('leaderboard');
    if (leaderboardString != null) {
      leaderboard = List<Map<String, dynamic>>.from(
        jsonDecode(leaderboardString),
      );
    } else {
      leaderboard = [];
    }
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Leaderboard')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Leaderboard',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            leaderboard.isEmpty
                ? const Center(child: Text('Belum ada data leaderboard'))
                : ListView.builder(
                  shrinkWrap: true,
                  itemCount: leaderboard.length,
                  itemBuilder: (context, index) {
                    return Card(
                      child: ListTile(
                        leading: Text('#${index + 1}'),
                        title: Text(leaderboard[index]['username'] ?? 'Unknown'),
                        trailing: Text(
                          leaderboard[index]['score']?.toString() ?? '0',
                        ),
                      ),
                    );
                  },
                ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const MyHomePage(title: 'AJOGAME'),
                  ),
                );
              },
              child: const Text('Back to Menu'),
            ),
          ],
        ),
      ),
    );
  }
}
