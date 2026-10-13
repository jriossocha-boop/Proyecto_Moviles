import 'package:flutter/material.dart';
import 'screens/setup_screen.dart';

void main() {
  runApp(const DrinkingGameApp());
}

class DrinkingGameApp extends StatelessWidget {
  const DrinkingGameApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Adivina o Toma',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.deepPurple,
          brightness: Brightness.dark,
        ),
        useMaterial3: true,
      ),
      home: const SetupScreen(),
    );
  }
}