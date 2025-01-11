import 'package:flutter/material.dart';
import 'package:flacardy/models/flash_card.dart';
import 'package:flacardy/data/supabase_database.dart';
import 'package:flacardy/models/pocket.dart';

class ManageCardsPage extends StatefulWidget {
  final Pocket pocket;
  const ManageCardsPage({super.key, required this.pocket});

  @override
  State<ManageCardsPage> createState() => _ManageCardsPageState();
}

class _ManageCardsPageState extends State<ManageCardsPage> {
  List<FlashCard> cards = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    loadCards();
  }

  Future<void> loadCards() async {
    setState(() => isLoading = true);
    try {
      final fetchedCards =
          await SupabaseDatabase().getPocketCards(widget.pocket.id!);
      setState(() {
        cards = fetchedCards;
        isLoading = false;
      });
    } catch (e) {
      setState(() => isLoading = false);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Failed to load cards: $e")),
      );
    }
  }

  Future<void> deleteCard(int cardId) async {
    try {
      await SupabaseDatabase().deleteCard(cardId);
      setState(() {
        cards.removeWhere((card) => card.id == cardId);
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Card deleted successfully!")),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Failed to delete card: $e")),
      );
    }
  }

  void showEditDialog(FlashCard card) {
    final TextEditingController frontController =
        TextEditingController(text: card.front);
    final TextEditingController backController =
        TextEditingController(text: card.back);

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text("Edit Card"),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: frontController,
                decoration: const InputDecoration(labelText: "Front"),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: backController,
                decoration: const InputDecoration(labelText: "Back"),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text("Cancel"),
            ),
            ElevatedButton(
              onPressed: () async {
                try {
                  final updatedCard = FlashCard(
                    id: card.id,
                    pocketId: card.pocketId,
                    front: frontController.text,
                    back: backController.text,
                    easeFactor: card.easeFactor,
                    interval: card.interval,
                    repetitions: card.repetitions,
                    nextReview: card.nextReview,
                  );

                  await SupabaseDatabase().updateCard(updatedCard);
                  setState(() {
                    final index = cards.indexWhere((c) => c.id == card.id);
                    if (index != -1) cards[index] = updatedCard;
                  });

                  Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text("Card updated successfully!")),
                  );
                } catch (e) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text("Failed to update card: $e")),
                  );
                }
              },
              child: const Text("Save"),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Manage Cards | ${widget.pocket.name}"),
      ),
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : ListView.builder(
              itemCount: cards.length,
              itemBuilder: (context, index) {
                final card = cards[index];
                return ListTile(
                  title: Text("Front: ${card.front}"),
                  subtitle: Text("Back: ${card.back}"),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        icon: Icon(Icons.edit),
                        onPressed: () => showEditDialog(card),
                      ),
                      IconButton(
                        icon: Icon(Icons.delete),
                        onPressed: () => deleteCard(card.id!),
                      ),
                    ],
                  ),
                );
              },
            ),
    );
  }
}
