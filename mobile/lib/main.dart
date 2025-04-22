import 'package:flutter/material.dart';

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

  void _toggleLamp() {
    setState(() {
      _isLampOn = !_isLampOn;
    });
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
            Icon(
              _isLampOn ? Icons.lightbulb : Icons.lightbulb_outline,
              size: 100,
              color: _isLampOn ? Colors.yellow : Colors.grey,
            ),
            const SizedBox(height: 20),
            Text(
              _isLampOn ? 'La lampe est allumée' : 'La lampe est éteinte',
              style: Theme.of(context).textTheme.headlineSmall,
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _toggleLamp,
        tooltip: 'Allumer/Éteindre',
        child: Icon(_isLampOn ? Icons.power_settings_new : Icons.power_off),
      ),
    );
  }
}
