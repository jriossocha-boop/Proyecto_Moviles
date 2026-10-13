import 'package:flutter/material.dart';
import '../widgets/player_list_item.dart';
import 'game_screen.dart';

class SetupScreen extends StatefulWidget {
  const SetupScreen({super.key});

  @override
  State<SetupScreen> createState() => _SetupScreenState();
}

class _SetupScreenState extends State<SetupScreen> {
  final TextEditingController _controller = TextEditingController();
  final List<String> _players = [];

  void _addPlayer() {
    if (_controller.text.trim().isNotEmpty) {
      setState(() {
        _players.add(_controller.text.trim());
        _controller.clear();
      });
    }
  }

  void _startGame() {
    // Regla de negocio: El juego requiere mínimo 2 jugadores
    if (_players.length >= 2) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => GameScreen(players: _players),
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Añade al menos 2 jugadores para comenzar')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Jugadores'),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _controller,
                    decoration: const InputDecoration(
                      labelText: 'Nombre del jugador',
                      border: OutlineInputBorder(),
                    ),
                    onSubmitted: (_) => _addPlayer(),
                  ),
                ),
                const SizedBox(width: 10),
                FloatingActionButton(
                  onPressed: _addPlayer,
                  child: const Icon(Icons.add),
                )
              ],
            ),
            const SizedBox(height: 20),
            Expanded(
              child: ListView.builder(
                itemCount: _players.length,
                itemBuilder: (context, index) {
                  return PlayerListItem(
                    name: _players[index],
                    onDelete: () {
                      setState(() {
                        _players.removeAt(index);
                      });
                    },
                  );
                },
              ),
            ),
            ElevatedButton(
              onPressed: _startGame,
              style: ElevatedButton.styleFrom(
                minimumSize: const Size(double.infinity, 55),
                backgroundColor: Theme.of(context).colorScheme.primary,
                foregroundColor: Colors.white,
              ),
              child: const Text('Comenzar Juego', style: TextStyle(fontSize: 20)),
            )
          ],
        ),
      ),
    );
  }
}