import 'dart:async';

import 'package:docapp/games/minesweerpr/colors.dart';
import 'package:docapp/games/minesweerpr/game_helper.dart';
import 'package:flutter/material.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({Key? key}) : super(key: key);

  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  String _currentTime = '';
  Timer? _timer;
  MineSweeperGame game = MineSweeperGame();
  void _startTimer() {
    _timer = Timer.periodic(Duration(seconds: 1), (Timer timer) {
      setState(() {
        _currentTime = DateTime.now().toString().split(' ')[1].substring(0, 5);
      });
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    game.generateMap();
    _startTimer();
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.primaryColor,
      appBar: AppBar(
        elevation: 0.0,
        backgroundColor: AppColor.primaryColor,
        centerTitle: true,
        title: Text("MineSweeper"),
        actions: [
          IconButton(
            onPressed: () {},
            icon: Icon(Icons.settings),
          ),
        ],
      ),
      body: Column(
        children: [
          /* Building the Header of the Game */
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Expanded(
                child: Container(
                  margin: EdgeInsets.symmetric(horizontal: 20.0),
                  padding:
                      EdgeInsets.symmetric(horizontal: 22.0, vertical: 16.0),
                  decoration: BoxDecoration(
                    color: AppColor.lightPrimaryColor,
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Icon(
                        Icons.flag,
                        color: AppColor.accentColor,
                        size: 34.0,
                      ),
                      Text(
                        _currentTime ,
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 32.0,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Expanded(
                child: Container(
                  margin: EdgeInsets.symmetric(horizontal: 20.0),
                  padding:
                      EdgeInsets.symmetric(horizontal: 22.0, vertical: 16.0),
                  decoration: BoxDecoration(
                    color: AppColor.lightPrimaryColor,
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Icon(
                        Icons.timer,
                        color: AppColor.accentColor,
                        size: 34.0,
                      ),
                      Text(
                        "12:32",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 32.0,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
          Container(
            width: double.infinity,
            height: 500.0,
            padding: EdgeInsets.all(20.0),
            child: GridView.builder(
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: MineSweeperGame.row,
                  crossAxisSpacing: 6.0,
                  mainAxisSpacing: 6.0,
                ),
                itemCount: MineSweeperGame.cells,
                itemBuilder: (BuildContext ctx, index) {
                  return GestureDetector(
                    onTap: () {
                      setState(() {
                        game.getClickedCell(game.gameMap[index]);
                        print(
                            "Cell [${game.gameMap[index].row}][${game.gameMap[index].col}]");
                      });
                    },
                    child: Container(
                      decoration: BoxDecoration(color: Colors.white),
                      child: Center(
                        child: Text(game.gameMap[index].reveal
                            ? "${game.gameMap[index].content}"
                            : ""),
                      ),
                    ),
                  );
                }),
          ),
          RawMaterialButton(
            fillColor: Colors.blue,
            child: Text("repeat"),
            onPressed: () {
              setState(() {
                game.gameMap.clear();
                game.generateMap();
              });
            },
          ),
        ],
      ),
    );
  }
}
