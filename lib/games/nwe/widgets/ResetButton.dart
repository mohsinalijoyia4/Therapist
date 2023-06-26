import 'package:flutter/material.dart';

class ResetButton extends StatelessWidget {
  void Function() reset;
  String text;

  ResetButton(this.reset, this.text);

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: reset,
      // color: Colors.white,
      // shape: RoundedRectangleBorder(
      //   borderRadius: new BorderRadius.circular(30.0),
//      ),
      child: Text("Reset"),
    );
  }
}
