import 'package:ajogame/class/level.dart';

class GameCard {
  String imagePath;
  bool isFlipped;
  bool isMatched;

  GameCard({
    required this.imagePath,
    this.isFlipped = false,
    this.isMatched = false,
  });
}

List<GameCard> generateCards(Level level) {
  List<String> images = [
    'assets/1.jpg',
    'assets/2.jpg',
    'assets/3.jpg',
    'assets/4.jpg',
    'assets/5.jpg',
    'assets/6.jpg',
  ];
  images.shuffle();

  List<GameCard> cards = [];

  // Duplikasi kartu biar ada pasangan
  for (var i=1; i<=level.cardSet; i++) {
    cards.add(GameCard(imagePath: images[i-1]));
    cards.add(GameCard(imagePath: images[i-1]));
  }

  // Shuffle kartu biar acak
  cards.shuffle();

  return cards;
}
