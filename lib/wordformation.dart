import 'package:flutter/material.dart';

class WordFormation extends StatelessWidget {
  const WordFormation({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Word Formation'),
      ),
      body: Column(
        children: [
          Expanded(
            flex: 1,
            child: Container(
              color: Colors.grey, // Replace with the actual image
              // You can use an Image widget here with the desired image
              alignment: Alignment.center,
              child: Text(
                'Image',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          Expanded(
            flex: 1,
            child: Container(
              color: Colors.white,
              child: GridView.count(
                crossAxisCount: 4,
                children: List.generate(8, (index) {
                  return Container(
                    margin: EdgeInsets.all(8),
                    child: ElevatedButton(
                      onPressed: () {
                        // Handle alphabet button press
                      },
                      child: Text('A'), // Replace with the suggested alphabet
                    ),
                  );
                }),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
