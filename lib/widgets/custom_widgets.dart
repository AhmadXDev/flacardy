import 'package:confetti/confetti.dart';
import 'package:flacardy/models/folder.dart';
import 'package:flacardy/models/pocket.dart';
import 'package:flutter/material.dart';

Card customFolderWidget(Folder folder) {
  return Card(
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
    elevation: 5,
    child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(Icons.folder, size: 40, color: Colors.blue),
        SizedBox(height: 10),
        Text(folder.name, style: TextStyle(fontWeight: FontWeight.bold)),
      ],
    ),
  );
}

Card customPocketWidget(Pocket pocket) {
  return Card(
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
    elevation: 5,
    child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        // Use the local icon
        Image.asset(
          'assets/pocket.png', // Path to your downloaded icon
          width: 40,
          height: 40,
        ),
        SizedBox(height: 10),
        Text(pocket.name, style: TextStyle(fontWeight: FontWeight.bold)),
      ],
    ),
  );
}

Card customFlashCard(String text) {
  return Card(
    elevation: 4,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(10),
    ),
    child: Center(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Text(
          text,
          style: const TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
          textAlign: TextAlign.center,
        ),
      ),
    ),
  );
}

Text customText({required String text, double fontSize = 20}) {
  return Text(
    text,
    style: TextStyle(
      fontSize: fontSize,
      fontWeight: FontWeight.bold,
    ),
  );
}

AppBar customAppBar(String text) {
  return AppBar(
    title: Text(
      text,
      style: TextStyle(fontWeight: FontWeight.bold),
    ),
    backgroundColor: const Color.fromARGB(255, 89, 131, 214),
    centerTitle: true,
  );
}

ConfettiWidget customConfettiWidget(ConfettiController confettiController) {
  return ConfettiWidget(
    confettiController: confettiController,
    blastDirectionality: BlastDirectionality.explosive,
    shouldLoop: false, // Only play confetti once
    blastDirection: 0,
    colors: [
      Colors.red,
      Colors.blue,
      Colors.green,
      Colors.orange
    ], // Confetti colors
    emissionFrequency: 0.05, // Frequency of confetti
    numberOfParticles: 40,
    gravity: 0.2, // Gravity of confetti
  );
}
