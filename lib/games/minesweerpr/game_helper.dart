import 'dart:math';

class MineSweeperGame {
  static int row = 6;
  static int col = 6;
  static int cells = row * col;
  bool gameOver = false;
  List<Cell> gameMap = [];
  static List<List<dynamic>> map = List.generate(
    row,
    (x) => List.generate(col, (y) => Cell(x, y, "", false)),
  );

  void generateMap() {
    placeMines(10);
    gameMap.clear();
    for (int i = 0; i < row; i++) {
      for (int j = 0; j < col; j++) {
        gameMap.add(map[i][j]);
      }
    }
  }

  static void placeMines(int mineNumber) {
  Random random = Random();
  Set<int> minePositions = {};

  while (minePositions.length < mineNumber) {
    int position = random.nextInt(cells);
    minePositions.add(position);
  }

  for (int i = 0; i < row; i++) {
    for (int j = 0; j < col; j++) {
      int position = i * col + j;
      if (minePositions.contains(position)) {
        map[i][j] = Cell(i, j, "X", false);
      }
    }
  }
}


  void showMines() {
    for (int i = 0; i < row; i++) {
      for (int j = 0; j < col; j++) {
        map[i][j].reveal = map[i][j].content == "X";
      }
    }
  }

  void getClickedCell(Cell cell) {
    if (cell.content == "X") {
      showMines();
      gameOver = true;
    } else {
      int mineCount = 0;
      int cellRow = cell.row;
      int cellCol = cell.col;
      for (int i = max(cellRow - 1, 0); i <= min(cellRow + 1, row - 1); i++) {
        for (int j = max(cellCol - 1, 0); j <= min(cellCol + 1, col - 1); j++) {
          if (map[i][j].content == "X") {
            mineCount++;
          }
        }
      }
      cell.content = mineCount;
      cell.reveal = true;
      if (mineCount == 0) {
        for (int i = max(cellRow - 1, 0); i <= min(cellRow + 1, row - 1); i++) {
          for (int j = max(cellCol - 1, 0);
              j <= min(cellCol + 1, col - 1);
              j++) {
            if (map[i][j].content == "") {
              getClickedCell(map[i][j]);
            }
          }
        }
      }
    }
  }
}

class Cell {
  int row;
  int col;
  dynamic content;
  bool reveal = false;

  Cell(this.row, this.col, this.content, this.reveal);
}
