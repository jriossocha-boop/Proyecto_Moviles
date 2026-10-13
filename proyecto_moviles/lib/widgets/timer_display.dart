import 'package:flutter/material.dart';

class TimerDisplay extends StatelessWidget {
  final int timeLeft;

  const TimerDisplay({super.key, required this.timeLeft});

  @override
  Widget build(BuildContext context) {
    return Text(
      '00:${timeLeft.toString().padLeft(2, '0')}',
      style: TextStyle(
        fontSize: 48, 
        fontWeight: FontWeight.bold, 
        color: timeLeft <= 3 ? Colors.redAccent : Colors.white,
      ),
      textAlign: TextAlign.center,
    );
  }
}