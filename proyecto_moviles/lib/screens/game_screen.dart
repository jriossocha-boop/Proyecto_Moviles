import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';
import 'dart:async';
import 'dart:math';
import '../services/deezer_service.dart';
import '../widgets/turn_header.dart';
import '../widgets/timer_display.dart';
import '../widgets/option_button.dart';
import '../widgets/result_card.dart';

class GameScreen extends StatefulWidget {
  final List<String> players;

  const GameScreen({super.key, required this.players});

  @override
  State<GameScreen> createState() => _GameScreenState();
}

class _GameScreenState extends State<GameScreen> {
  final AudioPlayer _player = AudioPlayer();
  final DeezerService _deezerService = DeezerService();
  
  String _currentPlayer = '';
  Map<String, dynamic>? _currentSong;
  List<String> _options = [];
  bool _isLoading = true;
  bool _isGuessing = false;
  int _timeLeft = 10;
  Timer? _timer;
  String _message = '';

  @override
  void initState() {
    super.initState();
    _nextTurn();
  }

  @override
  void dispose() {
    _timer?.cancel();
    _player.dispose();
    super.dispose();
  }

  Future<void> _nextTurn() async {
    setState(() {
      _isLoading = true;
      _isGuessing = false;
      _message = '';
      _currentPlayer = widget.players[Random().nextInt(widget.players.length)];
    });

    try {
      _currentSong = await _deezerService.getRandomSong();
      List<String> wrongOptions = await _deezerService.getWrongOptions(_currentSong!['artist']);
      
      _options = [...wrongOptions, _currentSong!['artist']];
      _options.shuffle(); 

      // Se usa ClippingAudioSource para forzar que el preview dure exactamente 10 segundos
      final audioSource = ClippingAudioSource(
        child: AudioSource.uri(Uri.parse(_currentSong!['preview'])),
        start: Duration.zero,
        end: const Duration(seconds: 10),
      );

      await _player.setAudioSource(audioSource);
      
      setState(() {
        _isLoading = false;
        _isGuessing = true;
        _timeLeft = 10;
      });

      _player.play();
      _startTimer();

    } catch (e) {
      // Mecanismo de reintento en caso de fallo de red o error de la API
      setState(() {
        _message = 'Buscando el siguiente reto...';
      });
      Future.delayed(const Duration(seconds: 2), _nextTurn);
    }
  }

  void _startTimer() {
    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_timeLeft > 0) {
        setState(() {
          _timeLeft--;
        });
      } else {
        _timer?.cancel();
        _player.stop();
        _handleTimeout();
      }
    });
  }

  void _handleTimeout() {
    if (!_isGuessing) return;
    setState(() {
      _isGuessing = false;
      _message = '¡TIEMPO AGOTADO!\n$_currentPlayer toma 2 tragos.\n\nEra: "${_currentSong!['title']}" de ${_currentSong!['artist']}';
    });
  }

  void _checkAnswer(String selectedArtist) {
    if (!_isGuessing) return;
    
    _timer?.cancel();
    _player.stop();
    
    setState(() {
      _isGuessing = false;
      if (selectedArtist == _currentSong!['artist']) {
        _message = '¡CORRECTO!\n$_currentPlayer manda a tomar 2 tragos a quien quiera.';
      } else {
        _message = '¡INCORRECTO!\n$_currentPlayer toma 2 tragos.\n\nEra: "${_currentSong!['title']}" de ${_currentSong!['artist']}';
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Cartas de Caos Musical'),
        automaticallyImplyLeading: false, // Bloquea el botón de retroceso nativo
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: _isLoading 
          ? const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircularProgressIndicator(),
                  SizedBox(height: 20),
                  Text('Preparando la pista...', style: TextStyle(fontSize: 18)),
                ],
              ),
            )
          : Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                TurnHeader(playerName: _currentPlayer),
                const SizedBox(height: 30),
                if (_isGuessing) ...[
                  const Icon(Icons.music_note, size: 80, color: Colors.purpleAccent),
                  const SizedBox(height: 10),
                  TimerDisplay(timeLeft: _timeLeft),
                  const SizedBox(height: 30),
                  const Text(
                    '¿Quién canta esta canción?',
                    style: TextStyle(fontSize: 20),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 20),
                  ..._options.map((option) => OptionButton(
                    text: option,
                    onPressed: () => _checkAnswer(option),
                  )),
                ] else ...[
                  ResultCard(message: _message),
                  const SizedBox(height: 40),
                  ElevatedButton(
                    onPressed: _nextTurn,
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.all(20),
                      backgroundColor: Colors.deepPurpleAccent,
                      foregroundColor: Colors.white,
                    ),
                    child: const Text('Siguiente Turno', style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
                  )
                ]
              ],
            ),
      ),
    );
  }
}