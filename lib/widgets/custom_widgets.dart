import 'package:confetti/confetti.dart';
import 'package:flacardy/constants/spacing.dart';
import 'package:flacardy/data/supabase_database.dart';
import 'package:flacardy/models/folder.dart';
import 'package:flacardy/models/pocket.dart';
import 'package:flacardy/services/methods.dart';
import 'package:flutter/material.dart';

GestureDetector customFolderWidget(
    Folder folder, BuildContext context, VoidCallback onUpdate) {
  return GestureDetector(
    onLongPress: () async {
      bool confirmed = await showDialog(
            context: context,
            builder: (context) {
              return AlertDialog(
                title: Text("Delete Folder"),
                content: Text("Are you sure you want to delete this folder?"),
                actions: [
                  TextButton(
                    onPressed: () => Navigator.of(context).pop(false),
                    child: Text("Cancel"),
                  ),
                  ElevatedButton(
                    onPressed: () => Navigator.of(context).pop(true),
                    child: Text("Delete"),
                  ),
                ],
              );
            },
          ) ??
          false;

      if (confirmed) {
        await SupabaseDatabase().deleteFolder(folder.fullPath);
        onUpdate();
      }
    },
    onDoubleTap: () async {
      TextEditingController nameController =
          TextEditingController(text: folder.name);
      bool confirmed = await showDialog(
            context: context,
            builder: (context) {
              return AlertDialog(
                title: Text("Edit Folder Name"),
                content: TextField(
                  controller: nameController,
                  decoration: InputDecoration(labelText: "New Folder Name"),
                ),
                actions: [
                  TextButton(
                    onPressed: () => Navigator.of(context).pop(false),
                    child: Text("Cancel"),
                  ),
                  ElevatedButton(
                    onPressed: () => Navigator.of(context).pop(true),
                    child: Text("Save"),
                  ),
                ],
              );
            },
          ) ??
          false;

      if (confirmed && nameController.text.isNotEmpty) {
        await SupabaseDatabase()
            .updateFolderName(folder.fullPath, nameController.text);
        onUpdate();
      }
    },
    child: Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      elevation: 5,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.folder, size: 40, color: Colors.blue),
          SizedBox(height: 10),
          Text(
            folder.name,
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            textAlign: TextAlign.center,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    ),
  );
}

GestureDetector customPocketWidget(
    Pocket pocket, BuildContext context, VoidCallback onUpdate) {
  return GestureDetector(
    onLongPress: () async {
      bool confirmed = await showDialog(
            context: context,
            builder: (context) {
              return AlertDialog(
                title: Text("Delete Pocket"),
                content: Text("Are you sure you want to delete this pocket?"),
                actions: [
                  TextButton(
                    onPressed: () => Navigator.of(context).pop(false),
                    child: Text("Cancel"),
                  ),
                  ElevatedButton(
                    onPressed: () => Navigator.of(context).pop(true),
                    child: Text("Delete"),
                  ),
                ],
              );
            },
          ) ??
          false;

      if (confirmed) {
        await SupabaseDatabase().deletePocket(pocket.id!);
        onUpdate();
      }
    },
    onDoubleTap: () async {
      TextEditingController nameController =
          TextEditingController(text: pocket.name);
      bool confirmed = await showDialog(
            context: context,
            builder: (context) {
              return AlertDialog(
                title: Text("Edit Pocket Name"),
                content: TextField(
                  controller: nameController,
                  decoration: InputDecoration(labelText: "New Pocket Name"),
                ),
                actions: [
                  TextButton(
                    onPressed: () => Navigator.of(context).pop(false),
                    child: Text("Cancel"),
                  ),
                  ElevatedButton(
                    onPressed: () => Navigator.of(context).pop(true),
                    child: Text("Save"),
                  ),
                ],
              );
            },
          ) ??
          false;

      if (confirmed && nameController.text.isNotEmpty) {
        await SupabaseDatabase()
            .updatePocketName(pocket.id!, nameController.text);
        onUpdate();
      }
    },
    child: Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      elevation: 5,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset(
            'assets/pocket.png',
            width: 40,
            height: 40,
            fit: BoxFit.cover,
          ),
          SizedBox(height: 10),
          Text(
            pocket.name,
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            textAlign: TextAlign.center,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
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
    shouldLoop: false,
    blastDirection: 0,
    colors: [Colors.red, Colors.blue, Colors.green, Colors.orange],
    emissionFrequency: 0.05,
    numberOfParticles: 40,
    gravity: 0.2,
  );
}

Column EnterData({
  required TextEditingController titleController,
  required Pocket pocket,
  required VoidCallback refreshCallback,
}) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      TextField(
        controller: titleController,
        decoration: const InputDecoration(
          labelText: "Enter Title to generate 10 flash cards",
          border: OutlineInputBorder(),
        ),
      ),
      height12,
      Center(
        child: ElevatedButton(
          onPressed: () {
            final title = titleController.text.trim();
            if (title.isNotEmpty) {
              generateFlashCardsForPocket(title: title, pocket: pocket);
              refreshCallback();
            }
          },
          child: const Text("Generate Flashcards"),
        ),
      )
    ],
  );
}
