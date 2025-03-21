class Level {
  int id;
  int time;
  int cardSet;
  int row;
  int column;

  Level({required this.id, required this.time, required this.cardSet, required this.row, required this.column});
}

var levels = <Level>[
  Level(id: 1, time: 20, cardSet: 2, row: 2, column: 2),
  Level(id: 2, time: 40, cardSet: 4, row: 2, column: 4),
  Level(id: 3, time: 60, cardSet: 6, row: 3, column: 4),
];
