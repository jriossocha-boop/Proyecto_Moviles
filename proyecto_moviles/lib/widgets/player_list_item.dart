import 'package:flutter/material.dart';

class PlayerListItem extends StatelessWidget {
  final String name;
  final VoidCallback onDelete;

  const PlayerListItem({super.key, required this.name, required this.onDelete});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      margin: const EdgeInsets.symmetric(vertical: 5),
      child: ListTile(
        title: Text(name, style: const TextStyle(fontSize: 18)),
        trailing: IconButton(
          icon: const Icon(Icons.delete, color: Colors.redAccent),
          onPressed: onDelete,
        ),
      ),
    );
  }
}