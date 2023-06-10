import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class AllPatients extends StatefulWidget {
  const AllPatients({super.key});

  @override
  State<AllPatients> createState() => _AllPatientsState();
}

class _AllPatientsState extends State<AllPatients> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(child: Text("Data")),
    );
  }
}
