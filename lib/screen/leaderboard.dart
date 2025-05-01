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

  Widget _buildPodiumBox(Map<String, dynamic> user, int rank) {
    final colors = [Colors.amber, Colors.grey, Colors.brown];
    return Column(
      children: [
        Icon(Icons.emoji_events, size: 40, color: colors[rank - 1]),
        const SizedBox(height: 8),
        Text(
          'Juara $rank',
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        Text(user['username'] ?? 'No Result'),
        Text('Skor: ${user['score'] ?? 0}'),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    // Pastikan podium selalu ada 3
    final podium = List.generate(3, (index) {
      if (index < leaderboard.length) {
        return leaderboard[index];
      } else {
        return {'username': 'No Result', 'score': 0};
      }
    });

    return Scaffold(
      appBar: AppBar(title: Text('Leaderboard')),

      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            const Text(
              '🏆 Leaderboard 🏆',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 24),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _buildPodiumBox(podium[1], 2),
                _buildPodiumBox(podium[0], 1),
                _buildPodiumBox(podium[2], 3),
              ],
            ),
            const SizedBox(height: 32),
            const Divider(),
            const Text(
              'Peringkat Lengkap',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            Expanded(
              child:
                  leaderboard.isEmpty
                      ? const Center(child: Text('Belum ada data leaderboard'))
                      : ListView.builder(
                        itemCount: leaderboard.length,
                        itemBuilder: (context, index) {
                          return Card(
                            child: ListTile(
                              leading: Text('#${index + 1}'),
                              title: Text(
                                leaderboard[index]['username'] ?? 'Unknown',
                              ),
                              trailing: Text(
                                leaderboard[index]['score']?.toString() ?? '0',
                              ),
                            ),
                          );
                        },
                      ),
            ),
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
