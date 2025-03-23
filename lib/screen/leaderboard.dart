import 'package:flutter/material.dart';
import 'package:ajogame/screen/home.dart';

class Leaderboard extends StatelessWidget {
  const Leaderboard({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Leaderboard')),
      body: Center(
        child: Column(
          children: [
            Text('Leaderbord'),
          ],
        ),
      ),
    );
  }
}
