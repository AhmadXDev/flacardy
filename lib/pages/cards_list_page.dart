import 'package:flacardy/constants/spacing.dart';
import 'package:flacardy/data/local_database.dart';
import 'package:flacardy/models/flash_card.dart';
import 'package:flacardy/models/pocket.dart';
import 'package:flacardy/widgets/custom_future_builder.dart';
import 'package:flacardy/widgets/text_input.dart';
import 'package:flutter/material.dart';

class CardsListPage extends StatefulWidget {
  final Pocket pocket;
  const CardsListPage({super.key, required this.pocket});

  @override
  State<CardsListPage> createState() => _CardsListPageState();
}

class _CardsListPageState extends State<CardsListPage> {
  TextEditingController frontController = TextEditingController();
  TextEditingController backController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("${widget.pocket.name} Cards"),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(18.0),
        child: CustomFutureBuilder<List<FlashCard>>(
          future: LocalDatabase.instance.getPocketCards(widget.pocket.id!),
          onData: (data) {
            return ListView.builder(
              itemCount: data.length,
              itemBuilder: (context, index) {
                final FlashCard flashCard = data[index];
                return FlashCardWidget(flashCard: flashCard);
              },
            );
          },
          loadingWidget: const Center(child: CircularProgressIndicator()),
          emptyWidget: const Center(child: Text("No cards found!")),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showDialog(
              context: context,
              builder: (context) {
                return Dialog(
                  child: Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Column(
                      mainAxisSize: MainAxisSize.max,
                      children: [
                        TextInput(
                            controller: frontController,
                            labelText: "Front Text"),
                        height12,
                        TextInput(
                            controller: backController, labelText: "Back Text"),
                        ElevatedButton(
                            onPressed: () async {
                              final newCard = FlashCard(
                                pocketId: widget.pocket.id!,
                                front: frontController.text,
                                back: backController.text,
                              );
                              await LocalDatabase.instance.addCard(newCard);
                              if (context.mounted) {
                                setState(() {});
                              }
                            },
                            child: Text("Add Card")),
                      ],
                    ),
                  ),
                );
              });
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}

class FlashCardWidget extends StatefulWidget {
  final FlashCard flashCard;
  const FlashCardWidget({super.key, required this.flashCard});

  @override
  _FlashCardWidgetState createState() => _FlashCardWidgetState();
}

class _FlashCardWidgetState extends State<FlashCardWidget> {
  bool showFront = true; // Tracks whether the front or back is shown

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        // Toggle between front and back
        setState(() {
          showFront = !showFront;
        });
      },
      child: Card(
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Column(
            children: [
              Text(
                showFront
                    ? widget.flashCard.front // Show front if true
                    : widget.flashCard.back, // Show back if false
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 12),
            ],
          ),
        ),
      ),
    );
  }
}
