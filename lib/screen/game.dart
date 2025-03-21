import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:ajogame/class/gameCard.dart';
import 'dart:async';
import 'package:percent_indicator/percent_indicator.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:ajogame/class/level.dart';

// void main() {
//   runApp(Ajogame());
// }

// class Ajogame extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       debugShowCheckedModeBanner: false,
//       home: GameScreen(),
//     );
//   }
// }

class GameScreen extends StatefulWidget {
  const GameScreen({super.key});

  @override
  _GameScreenState createState() => _GameScreenState();
}

class _GameScreenState extends State<GameScreen> {
  final AudioPlayer _backsound = AudioPlayer();
  final AudioPlayer _losesound = AudioPlayer();
  final AudioPlayer _winsound = AudioPlayer();

  List<GameCard> cards = [];

  Level? _selectedLevel;

  GameCard? firstCard;
  GameCard? secondCard;
  bool isProcessing = false;
  bool win = false;
  int cardFinished = 0;

  int _countdown = 0;
  bool isActive = true;
  int _time = 0;
  late Timer _timer;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      chooseLevel();
    });
  }

  void startGame() {
    _countdown = _selectedLevel!.time;
    _time = _selectedLevel!.time;
    cards = [];
    cards = generateCards(_selectedLevel!);
    startTimer();
    _playBackgroundMusic();
  }

  void chooseLevel() {
    showDialog(
      context: context,
      barrierDismissible: false, // Biar nggak bisa ditutup sebelum pilih level
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Pilih Level"),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children:
                levels.map((level) {
                  return ListTile(
                    title: Text("Level ${level.id}"),
                    subtitle: Text("Waktu: ${level.time} detik"),
                    onTap: () {
                      setState(() {
                        _selectedLevel = level;
                      });
                      Navigator.pop(context); // Tutup popup
                      startGame(); // Panggil fungsi buat mulai game
                    },
                  );
                }).toList(),
          ),
        );
      },
    );
  }

  void startTimer() {
    _timer = Timer.periodic(Duration(milliseconds: 1000), (timer) {
      setState(() {
        if (_countdown == 0) {
          win = false;
          endgame();
        } else {
          _countdown--;
        }
      });
    });
  }

  void _playBackgroundMusic() async {
    await _backsound.stop();
    await _backsound.play(AssetSource('ThemeSong.mp3'), volume: 0.5);
  }

  void _playWinMusic() async {
    await _winsound.stop();
    await _winsound.play(AssetSource('WinTest.mp3'), volume: 0.5);
  }

  void _playLoseMusic() async {
    try {
      await _losesound.stop();
      await _losesound.play(AssetSource('LoseTest.mp3'), volume: 0.5);
    } catch (e) {
      print("Error: $e"); // Lihat error yang lebih spesifik
    }
  }

  void endgame() {
    _timer.cancel();
    _backsound.stop();
    _backsound.dispose();

    showDialog<String>(
      context: context,
      barrierDismissible: false,
      builder:
          (BuildContext context) => AlertDialog(
            title: Text('Quiz'),
            content: Text(win ? "Congrats You Win" : "You Lose"),
            actions: <Widget>[
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                  chooseLevel();
                },
                child: const Text('change level'),
              ),
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                  retry();
                },
                child: const Text('Try Again'),
              ),
            ],
          ),
    );
    if (win) {
      _playWinMusic();
    } else {
      _playLoseMusic();
    }
  }

  void retry() async {
    _losesound.stop();
    _winsound.stop();
    cardFinished = 0;
    startGame();
  }

  void onCardTap(int index) {
    if (isProcessing || cards[index].isFlipped) return;

    setState(() {
      cards[index].isFlipped = true;
    });

    if (firstCard == null) {
      firstCard = cards[index];
    } else {
      secondCard = cards[index];
      isProcessing = true;

      // Cek apakah dua kartu cocok
      if (firstCard!.imagePath == secondCard!.imagePath) {
        firstCard = null;
        secondCard = null;
        isProcessing = false;
        cardFinished++;
        if (cardFinished == cards.length / 2) {
          win = true;
          endgame();
        }
      } else {
        // Jika tidak cocok, balik lagi setelah delay
        Future.delayed(Duration(seconds: 1), () {
          setState(() {
            firstCard!.isFlipped = false;
            secondCard!.isFlipped = false;
            firstCard = null;
            secondCard = null;
            isProcessing = false;
          });
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Ajogame - Match the Cards")),
      body: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          children: <Widget>[
            LinearPercentIndicator(
              percent: _countdown / _time,
              progressColor: Colors.green,
              lineHeight: 20,
            ),
            Text("time left: $_countdown"),
            SizedBox(height: 10), // Tambahkan sedikit jarak
            Center(
              child: SizedBox(
                width:
                    MediaQuery.of(context).size.width * 0.8, // Lebar GridView (80% layar)
                height:
                    MediaQuery.of(context).size.height * 0.6, // Tinggi GridView (50% layar)
                child: GridView.builder(
                  gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
                    maxCrossAxisExtent:
                        ((MediaQuery.of(context).size.width * 0.8) / _selectedLevel!.column), 
                    crossAxisSpacing: 4,
                    mainAxisSpacing: 4,
                    childAspectRatio: 1, // Biar tetap kotak
                  ),
                  itemCount: cards.length,
                  itemBuilder: (context, index) {
                    return GestureDetector(
                      onTap: () => onCardTap(index),
                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8),
                          image: DecorationImage(
                            image: AssetImage(
                              cards[index].isFlipped
                                  ? cards[index].imagePath
                                  : 'assets/0.jpg',
                            ),
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
