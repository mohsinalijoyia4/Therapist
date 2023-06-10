import 'package:flutter/material.dart';

class VisualMemory extends StatefulWidget {
  const VisualMemory({super.key});

  @override
  _VisualMemoryState createState() => _VisualMemoryState();
}

class _VisualMemoryState extends State<VisualMemory> {
  int moveCount = 0;
  bool isPaused = false;

  void incrementMoveCount() {
    setState(() {
      moveCount++;
    });
  }

  void togglePause() {
    setState(() {
      isPaused = !isPaused;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Visual Memory'),
      ),
      body: Column(
        children: [
          Expanded(
            flex: 1,
            child: Container(
              color: Colors.green,
              alignment: Alignment.center,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Countdown Timer',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 20,
                    ),
                  ),
                  SizedBox(height: 10),
                  Text(
                    '00:00:00', // Replace with the actual countdown timer value
                    style: TextStyle(
                      fontSize: 18,
                    ),
                  ),
                  SizedBox(height: 10),
                  Text(
                    'Moves: $moveCount',
                    style: TextStyle(
                      fontSize: 18,
                    ),
                  ),
                ],
              ),
            ),
          ),
          Expanded(
            flex: 2,
            child: GridView.count(
              crossAxisCount: 3,
              children: List.generate(12, (index) {
                bool isClicked = false;
                return GestureDetector(
                  onTap: () {
                    if (!isClicked && !isPaused) {
                      setState(() {
                        isClicked = true;
                      });
                      incrementMoveCount();
                    }
                  },
                  child: Container(
                    color: Colors.green,
                    margin: EdgeInsets.all(8),
                  ),
                );
              }),
            ),
          ),
          Container(
            padding: EdgeInsets.all(16),
            child: ElevatedButton(
              onPressed: togglePause,
              child: Text(isPaused ? 'Resume' : 'Pause'),
            ),
          ),
        ],
      ),
    );
  }
}
