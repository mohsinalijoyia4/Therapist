import 'package:flutter/material.dart';

class GridButton extends StatelessWidget {
  void Function()? click;
  String text;

  GridButton(this.text, this.click);

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      child: Text(
        text,
        style: TextStyle(
          fontSize: 30,
          fontWeight: FontWeight.bold,
        ),
      ),
      // color: Colors.white,
      // shape: RoundedRectangleBorder(
      //   borderRadius: new BorderRadius.circular(8.0),
      // ),
      onPressed: click,
    );
  }
}
