import 'package:flutter/material.dart';
import 'package:ajogame/class/gameCard.dart';

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
  List<GameCard> cards = [];
  GameCard? firstCard;
  GameCard? secondCard;
  bool isProcessing = false;

  @override
  void initState() {
    super.initState();
    cards = generateCards();
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
        child: GridView.builder(
          gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
            maxCrossAxisExtent: 300, // Maksimal lebar tiap kartu (80px)
            crossAxisSpacing: 4, // Jarak antar kartu
            mainAxisSpacing: 4,
            childAspectRatio: 1, // Pasti kotak
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
    );
  }
}
