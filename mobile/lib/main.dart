import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:developer' as developer;
import 'package:flutter_animate/flutter_animate.dart';
import 'package:google_fonts/google_fonts.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Smart Lighting',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF6E56F7),
          brightness: Brightness.dark,
        ),
        useMaterial3: true,
        textTheme: GoogleFonts.spaceGroteskTextTheme(
          Theme.of(context).textTheme.apply(bodyColor: Colors.white),
        ),
      ),
      home: const MyHomePage(title: 'SMART LIGHTING'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});
  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> with SingleTickerProviderStateMixin {
  bool _isLampOn = false;
  // URL de base pour l'API - correction du port pour correspondre au backend
  final String apiUrl = 'http://10.0.2.2:5000/api';
  bool _isLoading = false;
  late AnimationController _animationController;
  String _serverStatus = "NON CONNECTÉ";
  int _currentLampId = 1; // Par défaut, on utilise la lampe avec l'ID 1

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    );
    // Vérifier l'état initial de la lampe au démarrage
    _fetchLampStatus();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  // Récupérer l'état actuel de la lampe depuis le backend
  Future<void> _fetchLampStatus() async {
    setState(() {
      _isLoading = true;
    });
    
    try {
      final response = await http.get(Uri.parse('$apiUrl/lamps'));
      
      if (response.statusCode == 200) {
        final List<dynamic> lamps = jsonDecode(response.body);
        if (lamps.isNotEmpty) {
          // On utilise la première lampe trouvée (ou celle avec l'ID spécifié si elle existe)
          final lamp = lamps.firstWhere(
            (lamp) => lamp['id'] == _currentLampId,
            orElse: () => lamps.first
          );
          
          setState(() {
            _currentLampId = lamp['id'];
            _isLampOn = lamp['state'] == true;
            _serverStatus = "CONNECTÉ";
          });
          
          if (_isLampOn) {
            _animationController.forward();
          } else {
            _animationController.reverse();
          }
        }
      } else {
        setState(() {
          _serverStatus = "ERREUR";
        });
      }
    } catch (e) {
      developer.log('Erreur lors de la récupération de l\'état de la lampe', error: e);
      setState(() {
        _serverStatus = "NON CONNECTÉ";
      });
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  // Envoyer une demande pour changer l'état de la lampe
  Future<void> _toggleLamp() async {
    setState(() {
      _isLoading = true;
    });
    
    try {
      final response = await http.put(
        Uri.parse('$apiUrl/lamps/$_currentLampId'),
      );
      
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        setState(() {
          _isLampOn = data['lamp']['state'] == true;
          _serverStatus = "CONNECTÉ";
        });
        
        if (_isLampOn) {
          _animationController.forward();
        } else {
          _animationController.reverse();
        }
      } else {
        // Afficher une erreur si la requête échoue
        setState(() {
          _serverStatus = "ERREUR";
        });
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Erreur lors du changement d\'état de la lampe'),
              backgroundColor: Colors.red.shade900,
              behavior: SnackBarBehavior.floating,
            ),
          );
        }
      }
    } catch (e) {
      developer.log('Erreur lors de la communication avec le backend', error: e);
      setState(() {
        _serverStatus = "NON CONNECTÉ";
      });
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Erreur de connexion avec le serveur'),
            backgroundColor: Colors.red.shade900,
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF121212),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Text(
          widget.title,
          style: GoogleFonts.orbitron(
            fontSize: 22,
            fontWeight: FontWeight.w600,
            letterSpacing: 2.0,
          ),
        ),
        centerTitle: true,
      ),
      body: Container(
        width: double.infinity,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              const Color(0xFF121212),
              const Color(0xFF1E1E1E),
            ],
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            if (_isLoading)
              const CircularProgressIndicator(
                color: Color(0xFF6E56F7),
              ).animate().fadeIn()
            else
              AnimatedBuilder(
                animation: _animationController,
                builder: (context, child) {
                  return Container(
                    height: 180,
                    width: 180,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      boxShadow: _isLampOn
                          ? [
                              BoxShadow(
                                color: const Color(0xFF6E56F7).withAlpha(77), // 0.3 * 255 = ~77
                                blurRadius: 30,
                                spreadRadius: 10,
                              ),
                            ]
                          : [],
                    ),
                    child: Icon(
                      Icons.lightbulb_rounded,
                      size: 140,
                      color: _isLampOn
                          ? const Color(0xFF6E56F7)
                          : Colors.grey[800],
                    ),
                  ).animate()
                   .scale(
                     duration: 600.ms,
                     curve: Curves.easeOutBack,
                     begin: const Offset(0.9, 0.9),
                     end: const Offset(1.0, 1.0),
                   );
                },
              ),
            const SizedBox(height: 40),
            // Status indicator
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              decoration: BoxDecoration(
                color: Colors.black.withAlpha(77), // 0.3 * 255 = ~77
                borderRadius: BorderRadius.circular(20),
                border: Border.all(
                  color: _isLampOn
                      ? const Color(0xFF6E56F7).withAlpha(128) // 0.5 * 255 = ~128
                      : Colors.grey.withAlpha(51), // 0.2 * 255 = ~51
                  width: 1.5,
                ),
              ),
              child: Text(
                _isLampOn ? 'ALLUMÉE' : 'ÉTEINTE',
                style: GoogleFonts.orbitron(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 2.0,
                  color: _isLampOn ? const Color(0xFF6E56F7) : Colors.grey,
                ),
              ),
            ).animate().fadeIn(delay: 200.ms).moveY(begin: 10, end: 0),
            const SizedBox(height: 16),
            // Connection status
            Text(
              'ÉTAT DU SERVEUR: ${_isLoading ? 'SYNCHRONISATION' : _serverStatus}',
              style: GoogleFonts.spaceGrotesk(
                fontSize: 12,
                fontWeight: FontWeight.w400,
                color: _getServerStatusColor(),
                letterSpacing: 1,
              ),
            ).animate().fadeIn(delay: 400.ms),
            const SizedBox(height: 16),
            // Lamp ID indicator
            Text(
              'LAMPE ID: $_currentLampId',
              style: GoogleFonts.spaceGrotesk(
                fontSize: 12,
                fontWeight: FontWeight.w400,
                color: Colors.white.withAlpha(153), // 0.6 * 255 = ~153
                letterSpacing: 1,
              ),
            ).animate().fadeIn(delay: 450.ms),
            const SizedBox(height: 64),
            // Power button
            GestureDetector(
              onTap: _isLoading ? null : _toggleLamp,
              child: Container(
                height: 80,
                width: 80,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      _isLampOn ? const Color(0xFF8A75FA) : Colors.grey[800]!,
                      _isLampOn ? const Color(0xFF6E56F7) : Colors.grey[900]!,
                    ],
                  ),
                  boxShadow: _isLampOn
                      ? [
                          BoxShadow(
                            color: const Color(0xFF6E56F7).withAlpha(153), // 0.6 * 255 = ~153
                            blurRadius: 20,
                            spreadRadius: 2,
                            offset: const Offset(0, 4),
                          ),
                        ]
                      : [],
                ),
                child: Icon(
                  Icons.power_settings_new_rounded,
                  size: 32,
                  color: Colors.white,
                ),
              ),
            ).animate().fadeIn(delay: 600.ms).scale(delay: 600.ms),
          ],
        ),
      ),
    );
  }

  Color _getServerStatusColor() {
    switch (_serverStatus) {
      case "CONNECTÉ":
        return Colors.green.withAlpha(204); // 0.8 * 255 = ~204
      case "ERREUR":
        return Colors.red.withAlpha(204); // 0.8 * 255 = ~204
      case "NON CONNECTÉ":
      default:
        return Colors.grey.withAlpha(204); // 0.8 * 255 = ~204
    }
  }
}
