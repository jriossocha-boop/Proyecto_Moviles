import 'package:flutter/material.dart';

class ResultCard extends StatelessWidget {
  final String message;

  const ResultCard({super.key, required this.message});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.purpleAccent, width: 2),
        borderRadius: BorderRadius.circular(15),
        color: Colors.black26,
      ),
      child: Text(
        message,
        style: const TextStyle(fontSize: 22, height: 1.5),
        textAlign: TextAlign.center,
      ),
    );
  }
}