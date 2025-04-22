import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Contrôle de Lampe',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.amber),
      ),
      home: const MyHomePage(title: 'Contrôle de Lampe'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});
  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  bool _isLampOn = false;
  // URL de base pour l'API - à modifier selon votre backend
  final String apiUrl = 'http://localhost:3000/api';
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    // Vérifier l'état initial de la lampe au démarrage
    _fetchLampStatus();
  }

  // Récupérer l'état actuel de la lampe depuis le backend
  Future<void> _fetchLampStatus() async {
    setState(() {
      _isLoading = true;
    });
    
    try {
      final response = await http.get(Uri.parse('$apiUrl/lamp'));
      
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        setState(() {
          _isLampOn = data['status'] == 'on';
        });
      }
    } catch (e) {
      // En cas d'erreur, on peut supposer que la lampe est éteinte
      print('Erreur lors de la récupération de l\'état de la lampe: $e');
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
      final newStatus = _isLampOn ? 'off' : 'on';
      final response = await http.post(
        Uri.parse('$apiUrl/lamp'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'status': newStatus}),
      );
      
      if (response.statusCode == 200) {
        setState(() {
          _isLampOn = !_isLampOn;
        });
      } else {
        // Afficher une erreur si la requête échoue
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Erreur lors du changement d\'état de la lampe')),
        );
      }
    } catch (e) {
      print('Erreur lors de la communication avec le backend: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Erreur de connexion avec le serveur')),
      );
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            _isLoading
              ? const CircularProgressIndicator()
              : Icon(
                  _isLampOn ? Icons.lightbulb : Icons.lightbulb_outline,
                  size: 100,
                  color: _isLampOn ? Colors.yellow : Colors.grey,
                ),
            const SizedBox(height: 20),
            Text(
              _isLampOn ? 'La lampe est allumée' : 'La lampe est éteinte',
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            const SizedBox(height: 10),
            Text(
              'État du serveur: ${_isLoading ? 'En cours de communication...' : 'Connecté'}',
              style: Theme.of(context).textTheme.bodySmall,
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _isLoading ? null : _toggleLamp,
        tooltip: 'Allumer/Éteindre',
        child: Icon(_isLampOn ? Icons.power_settings_new : Icons.power_off),
      ),
    );
  }
}
