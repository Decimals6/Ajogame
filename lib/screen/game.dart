import 'dart:ui';
import 'package:ajogame/main.dart';
import 'package:ajogame/screen/home.dart';
import 'package:ajogame/screen/leaderboard.dart';
import 'package:flutter/material.dart';
import 'package:ajogame/class/gameCard.dart';
import 'dart:async';
import 'package:percent_indicator/percent_indicator.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:ajogame/class/level.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'dart:math';

class GameScreen extends StatefulWidget {
  final String username;
  const GameScreen({super.key, required this.username});

  @override
  _GameScreenState createState() => _GameScreenState();
}

class _GameScreenState extends State<GameScreen> with TickerProviderStateMixin {
  final AudioPlayer _backsound = AudioPlayer();
  final AudioPlayer _losesound = AudioPlayer();
  final AudioPlayer _winsound = AudioPlayer();
  final AudioPlayer _effectSound = AudioPlayer();

  List<GameCard> cards = [];

  GameCard? firstCard;
  GameCard? secondCard;
  bool isProcessing = false;
  bool win = false;
  int cardFinished = 0;
  Level _selectedLevel = levels[0];
  int _levelIndex = 0;

  int _countdown = 0;
  bool isActive = true;
  int _time = 0;
  late Timer _timer;
  int _score = 0;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      startGame();
    });
  }

  void startGame() {
    _countdown = _selectedLevel.time;
    _time = _selectedLevel.time;
    cards = [];
    cards = generateCards(_selectedLevel);

    // Inisialisasi animasi untuk setiap kartu
    for (var card in cards) {
      card.flipController = AnimationController(
        vsync: this,
        duration: Duration(milliseconds: 500),
      );
      card.flipAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
        CurvedAnimation(parent: card.flipController, curve: Curves.easeInOut),
      );
    }

    startTimer();
    _playBackgroundMusic();
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
    await _backsound.play(
      AssetSource(_selectedLevel.id.toString() + '.mp3'),
      volume: 0.5,
    );
  }

  void _playFlipSound() async {
    await _effectSound.stop();
    await _effectSound.play(AssetSource('flip.mp3'), volume: 0.5);
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

  Future<void> updateLeaderboard(String username, int score) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();

    // Ambil leaderboard dari SharedPreferences
    String? leaderboardString = prefs.getString('leaderboard');
    List<dynamic> leaderboard =
        leaderboardString != null ? jsonDecode(leaderboardString) : [];

    // Cek apakah user sudah ada di leaderboard
    bool userExists = false;
    for (var entry in leaderboard) {
      if (entry['username'] == username) {
        if (score > entry['score']) {
          entry['score'] = score; // Update kalau lebih tinggi
        }
        userExists = true;
        break;
      }
    }

    // Kalau user belum ada, tambahkan
    if (!userExists) {
      leaderboard.add({"username": username, "score": score});
    }

    // Urutkan berdasarkan skor (descending)
    leaderboard.sort((a, b) => b['score'].compareTo(a['score']));

    // Simpan hanya 3 skor tertinggi
    if (leaderboard.length > 3) {
      leaderboard = leaderboard.sublist(0, 3);
    }

    // Simpan kembali ke SharedPreferences
    await prefs.setString('leaderboard', jsonEncode(leaderboard));
  }

  void endgame() {
    _timer.cancel();
    _score = _score + (cardFinished * _countdown);
    updateLeaderboard(widget.username, _score);
    cardFinished = 0;
    _backsound.stop();
    if (win) {
      _levelIndex++;
    }

    showDialog<String>(
      context: context,
      barrierDismissible: false,
      builder:
          (BuildContext context) => AlertDialog(
            title: Text(
              win ? "YOU WIN!!" : "GAMEOVER!!",
              textAlign: TextAlign.center,
            ),

            content: Text(
              win
                  ? "Congrats You Win \nYour Total Score: $_score"
                  : "You Lose \nYour Score: $_score",
              textAlign: TextAlign.center,
            ),
            actions: <Widget>[
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                      builder:
                          (context) =>
                              MyHomePage(title: "Imatching - Match The Card"),
                    ),
                  );
                },
                child: const Text('Back to Menu'),
              ),
              if (_levelIndex < levels.length)
                TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                    if (win) {
                      _winsound.stop();
                      _selectedLevel = levels[_levelIndex];
                      startGame();
                    } else {
                      _losesound.stop();
                      retry();
                    }
                  },
                  child: Text(win ? 'Next Level' : 'Try Again'),
                ),

              TextButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => Leaderboard()),
                  );
                },
                child: Text('High Score'),
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
    startGame();
  }

  void onCardTap(int index) {
    if (isProcessing || cards[index].isFlipped) return;

    setState(() {
      cards[index].isFlipped = true;
      _playFlipSound();
      cards[index].flipController.forward(from: 0.0);
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
            firstCard!.flipController.reverse();
            secondCard!.flipController.reverse();
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
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Color(0xFF1A1A2E), // warna gelap
              Color(0xFF16213E), // warna sedikit lebih terang
            ],
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Column(
            children: <Widget>[
              LinearPercentIndicator(
                percent: _countdown / _time,
                progressColor: Colors.green,
                lineHeight: 20,
                backgroundColor: Colors.grey.shade800,
              ),
              const SizedBox(height: 8),
              Text(
                "Time left: $_countdown",
                style: const TextStyle(color: Colors.white, fontSize: 16),
              ),
              const SizedBox(height: 10),
              Center(
                child: SizedBox(
                  width:
                      MediaQuery.of(context).size.width > 800
                          ? (_selectedLevel.id == 1
                              ? MediaQuery.of(context).size.width * 0.4
                              : MediaQuery.of(context).size.width * 0.7)
                          : MediaQuery.of(context).size.width * 0.8,
                  height: MediaQuery.of(context).size.height * 0.8,
                  child: GridView.builder(
                    gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
                      maxCrossAxisExtent:
                          ((MediaQuery.of(context).size.width > 800
                                  ? (_selectedLevel.id == 1
                                      ? MediaQuery.of(context).size.width * 0.4
                                      : MediaQuery.of(context).size.width * 0.7)
                                  : MediaQuery.of(context).size.width * 0.8) /
                              _selectedLevel.column),
                      crossAxisSpacing: 4,
                      mainAxisSpacing: 4,
                      childAspectRatio: 1,
                    ),
                    itemCount: cards.length,
                    itemBuilder: (context, index) {
                      return GestureDetector(
                        onTap: () => onCardTap(index),
                        child: AnimatedBuilder(
                          animation: cards[index].flipAnimation,
                          builder: (context, child) {
                            return Transform(
                              transform: Matrix4.rotationY(
                                cards[index].flipAnimation.value * 3.1416,
                              ),
                              alignment: Alignment.center,
                              child:
                                  cards[index].flipAnimation.value <= 0.5
                                      ? Image.asset('assets/0.jpg')
                                      : Transform.scale(
                                        scaleX: -1,
                                        child: Image.asset(
                                          cards[index].imagePath,
                                        ),
                                      ),
                            );
                          },
                        ),
                      );
                    },
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
