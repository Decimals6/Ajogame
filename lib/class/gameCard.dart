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

List<GameCard> generateCards() {
  List<String> images = [
    'assets/1.jpg',
    'assets/2.jpg',
    'assets/3.jpg',
    'assets/4.jpg',
    'assets/5.jpg',
  ];

  List<GameCard> cards = [];

  // Duplikasi kartu biar ada pasangan
  for (var img in images) {
    cards.add(GameCard(imagePath: img));
    cards.add(GameCard(imagePath: img));
  }

  // Shuffle kartu biar acak
  cards.shuffle();

  return cards;
}
