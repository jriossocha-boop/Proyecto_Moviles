# CARTAS DE CAOS MUSICAL - TALLER PRÁCTICO FLUTTER:

## DESCRIPCIÓN:
Aplicación móvil desarrollada con Flutter y Dart que funciona como un juego interactivo para fiestas. El proyecto consume la API de Deezer para reproducir fragmentos de 10 segundos de canciones, integrando temporizadores, manejo de estado y reproducción de audio sin requerir un backend propio.

## SECCIONES:
* **Setup:** Pantalla inicial para registrar dinámicamente los nombres de los jugadores (mínimo dos).
* **Juego:** Pantalla principal que gestiona los turnos, reproduce el audio recortado, muestra el temporizador y valida las respuestas.
* **Servicio API:** Lógica independiente que obtiene las canciones por género y genera las opciones falsas de respuesta.

## ESTRUCTURA DEL CÓDIGO:
lib/
├── main.dart
├── screens/
│   ├── setup_screen.dart
│   └── game_screen.dart
├── services/
│   └── deezer_service.dart
└── widgets/
    ├── player_list_item.dart
    ├── turn_header.dart
    ├── timer_display.dart
    ├── option_button.dart
    └── result_card.dart

## EJECUCIÓN DEL PROYECTO:
1. Clonar el repositorio.
2. Abrir la terminal en la raíz del proyecto y ejecutar flutter pub get para instalar dependencias (http, just_audio).
3. Iniciar un emulador o conectar un dispositivo físico con acceso a internet.
4. Ejecutar la aplicación con flutter run.
