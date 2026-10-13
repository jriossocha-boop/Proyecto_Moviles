import 'package:flutter/material.dart';

class TurnHeader extends StatelessWidget {
  final String playerName;

  const TurnHeader({super.key, required this.playerName});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.deepPurple.withValues(alpha: 0.3),
        borderRadius: BorderRadius.circular(15),
      ),
      child: Text(
        'Turno de:\n$playerName',
        style: const TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
        textAlign: TextAlign.center,
      ),
    );
  }
}