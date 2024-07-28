import 'package:flutter/material.dart';

class TeachingRatingScreen extends StatelessWidget {
  const TeachingRatingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Calificación Docente'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              'Calificar Docente',
            ),
          ],
        ),
      ),
    );
  }
}
