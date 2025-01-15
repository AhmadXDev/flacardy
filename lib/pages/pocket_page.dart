import 'package:flacardy/constants/spacing.dart';
import 'package:flacardy/extensions/nav.dart';
import 'package:flacardy/models/flash_card.dart';
import 'package:flacardy/pages/manage_cards_page.dart';
import 'package:flacardy/widgets/custom_future_builder.dart';
import 'package:flacardy/widgets/custom_widgets.dart';
import 'package:flutter/material.dart';
import 'package:flacardy/data/supabase_database.dart';
import 'package:flacardy/models/pocket.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'study_cards_page.dart';

class PocketPage extends StatefulWidget {
  final Pocket pocket;
  const PocketPage({super.key, required this.pocket});

  @override
  State<PocketPage> createState() => _PocketPageState();
}

class _PocketPageState extends State<PocketPage> {
  final TextEditingController frontController = TextEditingController();
  final TextEditingController backController = TextEditingController();
  final TextEditingController titleController = TextEditingController();
  final FocusNode frontFocusNode = FocusNode();
  bool LoadingAI = false;

  @override
  void dispose() {
    frontController.dispose();
    backController.dispose();
    frontFocusNode.dispose();
    titleController.dispose();
    super.dispose();
  }

  void showSnackbar(String message) {
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text(message)));
  }

  void setLoading(bool value) {
    setState(() {
      LoadingAI = value;
    });
  }

  Future<void> _addCard() async {
    if (frontController.text.isEmpty || backController.text.isEmpty) {
      showSnackbar("Front and Back fields cannot be empty.");
      return;
    }

    final newCard = FlashCard(
      pocketId: widget.pocket.id!,
      front: frontController.text,
      back: backController.text,
    );

    try {
      await SupabaseDatabase().addCard(newCard);
      frontController.clear();
      backController.clear();
      showSnackbar("Card added successfully!");
      frontFocusNode.requestFocus();
    } catch (e) {
      showSnackbar("Failed to add card: $e");
    }
  }

  void showAddCardDialog() async {
    await showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text("Add New Card"),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: frontController,
                focusNode: frontFocusNode,
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
                await _addCard();
                setState(() {});
              },
              child: const Text("Add"),
            ),
          ],
        );
      },
    );

    setState(() {});
  }

  Future<int> getNumberOfCards() async {
    final cards = await SupabaseDatabase().getPocketCards(widget.pocket.id!);
    return cards.length;
  }

  Future<int> getNumberOfDueCards() async {
    final cards = await SupabaseDatabase().getPocketDueCards(widget.pocket.id!);
    return cards.length;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: customAppBar("${widget.pocket.name} 📘"),
      body: Padding(
        padding: const EdgeInsets.all(18.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    height12,
                    CustomFutureBuilder<int>(
                      future: getNumberOfCards(),
                      onData: (data) {
                        return Text(
                          "Number of Cards: ${data}",
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        );
                      },
                    ),
                    CustomFutureBuilder<int>(
                      future: getNumberOfDueCards(),
                      onData: (data) {
                        return Text(
                          "Number of due Cards: ${data}",
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        );
                      },
                    ),
                  ],
                ),
                width12,
                ElevatedButton(
                  onPressed: () =>
                      context.push(ManageCardsPage(pocket: widget.pocket)),
                  child: const Text("Edit Flashcards"),
                )
              ],
            ),
            height24,
            enterAIData(
                titleController: titleController,
                pocket: widget.pocket,
                refreshCallback: () => setState(() {}),
                setLoading: setLoading,
                showSnackbar: showSnackbar),
            height24,
            Center(
              child: ElevatedButton(
                onPressed: () => context.push(StudyCardsPage(
                  pocket: widget.pocket,
                  refreshCallback: () => setState(() {}),
                )),
                child: const Text("Study Now"),
              ),
            ),
            height24,
            if (LoadingAI) ...[
              Center(
                child: LoadingAnimationWidget.newtonCradle(
                  color: Colors.blue,
                  size: 200,
                ),
              ),
              height12,
            ],
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: showAddCardDialog,
        child: const Icon(Icons.add),
      ),
    );
  }
}
