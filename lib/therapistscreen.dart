import 'package:docapp/patients.dart';
import 'package:docapp/therapisthome.dart';
import 'package:flutter/material.dart';

import 'loginsignup/constants.dart';

class TherapistScreenOne extends StatefulWidget {
  const TherapistScreenOne({super.key});

  @override
  State<TherapistScreenOne> createState() => _TherapistScreenOneState();
}

class _TherapistScreenOneState extends State<TherapistScreenOne>
    with SingleTickerProviderStateMixin {
  int _currentIndex = 0;
  late AnimationController _animationController;
  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 200),
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  final List<Widget> _pages = [
    TherapistAppHomePage(), 
    AllPatients()
    ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kBackgroundColor,
      body: Stack(
        children: [
          _pages[_currentIndex],
          Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              height: 60,
              decoration: BoxDecoration(
                color: kTextFieldFill,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(30),
                  topRight: Radius.circular(30),
                
                ),
                boxShadow: [
                  BoxShadow(
                    offset: Offset(0, -3),
                    blurRadius: 3,
                    color: Colors.black.withOpacity(0.3),
                  ),
                ],
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  buildBottomNavigationBarItem(0, Icons.home, 'Home'),
                  buildBottomNavigationBarItem(1, Icons.work, 'All Patients'),
                  // buildBottomNavigationBarItem(2, Icons.settings, 'Upcoming '),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  GestureDetector buildBottomNavigationBarItem(
      int index, IconData iconData, String label) {
    bool isSelected = _currentIndex == index;
    return GestureDetector(
      onTap: () {
        setState(() {
          _currentIndex = index;
        });
      },
      onTapDown: (TapDownDetails details) {
        _animationController.forward();
      },
      onTapUp: (TapUpDetails details) {
        _animationController.reverse();
      },
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          ScaleTransition(
            scale: isSelected
                ? Tween<double>(begin: 1.6, end: 1.0)
                    .animate(_animationController)
                : Tween<double>(begin: 1.0, end: 1.6)
                    .animate(_animationController),
            child: Icon(
              iconData,
              color: isSelected ? Colors.white : Colors.grey,
            ),
          ),
          SizedBox(height: 2),
          Text(
            label,
            style: TextStyle(
              color: isSelected ? Colors.white : Colors.grey,
              fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
            ),
          ),
        ],
      ),
    );
  }
}
