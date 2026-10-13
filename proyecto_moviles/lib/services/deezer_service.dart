import 'dart:convert';
import 'dart:math';
import 'package:http/http.dart' as http;

class DeezerService {
  final Map<String, List<String>> _artistsByGenre = {
    'Urbano': [
      'Bad Bunny', 'Feid', 'Karol G', 'Quevedo', 
      'Duki', 'J Balvin', 'Rauw Alejandro', 'Daddy Yankee', 'Myke Towers'
    ],
    'Pop y Rock Latino': [
      'Shakira', 'Juanes', 'Morat', 'Sebastián Yatra', 
      'Luis Fonsi', 'Enrique Iglesias', 'Reik', 'Maná', 'Soda Stereo'
    ],
    'Anglo y Pop Internacional': [
      'Dua Lipa', 'The Weeknd', 'Bruno Mars', 
      'Coldplay', 'Ed Sheeran', 'Taylor Swift', 'Harry Styles', 'Michael Jackson'
    ],
    'Rock en Inglés': [
      'Queen', 'AC/DC', 'Guns N\' Roses', 'Metallica', 
      'Nirvana', 'Aerosmith', 'The Rolling Stones', 'Pink Floyd', 'Bon Jovi'
    ],
    'Balada': [
      'Franco De Vita', 'Chayanne', 'Ricardo Arjona', 'Alejandro Sanz', 
      'Luis Miguel', 'Ricardo Montaner', 'Juan Gabriel', 'Camilo Sesto'
    ],
    'Vallenato': [
      'Diomedes Díaz', 'Silvestre Dangond', 'Binomio de Oro de América', 
      'Jorge Celedón', 'Los Inquietos del Vallenato', 'Kaleth Morales', 'Poncho Zuleta'
    ],
    'Merengue': [
      'Juan Luis Guerra', 'Elvis Crespo', 'Wilfrido Vargas', 
      'Proyecto Uno', 'Sergio Vargas', 'Eddy Herrera', 'Los Hermanos Rosario'
    ],
    'Salsa': [
      'Celia Cruz', 'Marc Anthony', 'Grupo Niche', 'Joe Arroyo', 
      'Héctor Lavoe', 'Rubén Blades', 'Willie Colón', 'Gilberto Santa Rosa', 'Frankie Ruiz'
    ]
  };

  Future<Map<String, dynamic>> getRandomSong() async {
    // Regla especial: 20% de probabilidad de forzar una canción específica (Easter Egg)
    final int randomChance = Random().nextInt(100);

    if (randomChance < 20) {
      final query = 'artist:"Franco De Vita" track:"Un Buen Perdedor"';
      final url = Uri.parse('https://api.deezer.com/search?q=$query');
      
      final response = await http.get(url);
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final List tracks = data['data'];
        
        if (tracks.isNotEmpty) {
          final track = tracks.first;
          return {
            'title': track['title'],
            'artist': track['artist']['name'],
            'preview': track['preview'],
          };
        }
      }
    }

    final genres = _artistsByGenre.keys.toList();
    final randomGenre = genres[Random().nextInt(genres.length)];
    
    final artists = _artistsByGenre[randomGenre]!;
    final randomArtist = artists[Random().nextInt(artists.length)];
    
    final url = Uri.parse('https://api.deezer.com/search?q=$randomArtist');
    
    final response = await http.get(url);
    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      final List tracks = data['data'];
      
      if (tracks.isNotEmpty) {
        final track = tracks[Random().nextInt(tracks.length)];
        return {
          'title': track['title'],
          'artist': track['artist']['name'],
          'preview': track['preview'],
        };
      }
    }
    
    throw Exception('Error al obtener la canción');
  }
  
  Future<List<String>> getWrongOptions(String correctArtist) async {
    List<String> poolOfArtists = [];
    
    for (var genreList in _artistsByGenre.values) {
      if (genreList.any((a) => a.toLowerCase() == correctArtist.toLowerCase())) {
        poolOfArtists = List.from(genreList);
        break;
      }
    }
    
    // Fallback: Si el artista correcto no está en nuestras listas, unimos todos los géneros
    if (poolOfArtists.isEmpty) {
      poolOfArtists = _artistsByGenre.values.expand((x) => x).toList();
    }
    
    poolOfArtists.removeWhere((a) => a.toLowerCase() == correctArtist.toLowerCase());
    poolOfArtists.shuffle();
    
    return poolOfArtists.take(3).toList();
  }
}