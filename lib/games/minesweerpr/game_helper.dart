import 'dart:math';

class MineSweeperGame {
  // setting the game variables
  static int row = 6;
  static int col = 6;
  static int cells = row * col;
  bool gameOver = false;
  List<Cell> gameMap = [];
  //static List<Cell> map = List.generate(row * col, (index) => Cell(index % row, index ~/ col, "", false));
  static List<List<dynamic>> map = List.generate(
      row, (x) => List.generate(col, (y) => Cell(x, y, "", false)));

  // function to generate a map
  void generateMap() {
    placeMines(10);
    for (int i = 0; i < row; i++) {
      for (int j = 0; j < col; j++) {
        gameMap.add(map[i][j]);
      }
    }
  }

  // Function to place mines randomly
  static void placeMines(int mineNumber) {
    Random random = Random();
    for (int i = 0; i < mineNumber; i++) {
      int mineRow = random.nextInt(row);
      int mineCol = random.nextInt(col);
      map[mineRow][mineCol] = Cell(mineRow, mineCol, "X", false);
    }
  }

  // Function to show all the mine in case of game over
  void showMines() {
    for (int i = 0; i < row; i++) {
      for (int j = 0; j < col; j++) {
        map[i][j].reveal = map[i][j].content == "X";
      } // revealing all the mines

    }
  }

  // function to calculate adjacent mine on click
  void getClickedCell(Cell cell) {
    //checking if we have clicked on a mine
    if (cell.content == "X") {
      showMines();
      gameOver = true;
    } else {
      //calculate the number to display
      int mineCount = 0;
      int cellRow = cell.row;
      int cellCol = cell.col;
      print("test: ${cell.col}");
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
        //reveal all adjacent cell
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
