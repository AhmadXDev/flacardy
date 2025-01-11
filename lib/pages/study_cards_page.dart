import 'package:flacardy/constants/spacing.dart';
import 'package:flacardy/logic/spaced_repetition.dart';
import 'package:flacardy/widgets/custom_widgets.dart';
import 'package:flutter/material.dart';
import 'package:flacardy/models/flash_card.dart';
import 'package:flacardy/data/supabase_database.dart';
import 'package:flacardy/models/pocket.dart';
import 'package:flip_card/flip_card.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:confetti/confetti.dart';

class StudyCardsPage extends StatefulWidget {
  final Pocket pocket;
  final VoidCallback refreshCallback;

  const StudyCardsPage(
      {super.key, required this.pocket, required this.refreshCallback});

  @override
  State<StudyCardsPage> createState() => _StudyCardsPageState();
}

class _StudyCardsPageState extends State<StudyCardsPage> {
  int currentIndex = 0;
  int cardsNum = 0;
  List<FlashCard> cards = [];
  bool isLoading = true;
  bool showButtons = false;
  GlobalKey<FlipCardState> flipCardKey = GlobalKey<FlipCardState>();
  late ConfettiController confettiController;

  @override
  void dispose() {
    confettiController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    confettiController =
        ConfettiController(duration: const Duration(seconds: 3));
    loadCards();
  }

  loadCards() async {
    setState(() => isLoading = true);
    try {
      final fetchedCards =
          await SupabaseDatabase().getPocketDueCards(widget.pocket.id!);
      for (var card in fetchedCards) {
        print('Front: ${card.front}, Back: ${card.back}');
      }
      setState(() {
        cards = fetchedCards;
        isLoading = false;
        currentIndex = 0;
        cardsNum = cards.length;
      });
    } catch (e) {
      setState(() => isLoading = false);
    }
  }

  void _showSnackbar(String message) {
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text(message)));
  }

  Future<void> finishCard(String evaluation) async {
    final currentCard = cards[currentIndex];
    evaluateFlashCard(evaluation, currentCard);

    try {
      await SupabaseDatabase().updateCard(currentCard);
      nextCard();
      setState(() {});
      widget.refreshCallback();
    } catch (e) {
      _showSnackbar("Error evaluating card: $e");
    }
  }

  void nextCard() async {
    if (currentIndex < cards.length - 1)
      currentIndex++;
    else
      await loadCards();

    showButtons = false;
    flipCardKey.currentState?.toggleCard();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Study | ${widget.pocket.name} | Pocket",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        backgroundColor: const Color.fromARGB(255, 89, 131, 214),
        centerTitle: true,
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context, true);
          },
          icon: Icon(Icons.arrow_back),
        ),
      ),
      body: isLoading
          ? Center(
              child: LoadingAnimationWidget.newtonCradle(
                color: Colors.blue,
                size: 200,
              ),
            )
          : cards.isEmpty
              ? Builder(
                  builder: (context) {
                    confettiController.play();
                    return Stack(
                      alignment: Alignment.topCenter,
                      children: [
                        Center(
                          child: customText(
                            text: "No cards to review!",
                          ),
                        ),
                        customConfettiWidget(confettiController),
                      ],
                    );
                  },
                )
              : Padding(
                  padding: const EdgeInsets.all(40.0),
                  child: Column(
                    children: [
                      Text(
                        "Card ${currentIndex + 1} of ${cardsNum}",
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w900,
                        ),
                      ),
                      height24,
                      Expanded(
                        child: FlipCard(
                          key: flipCardKey,
                          direction: FlipDirection.VERTICAL,
                          onFlipDone: (isBack) {
                            if (isBack) {
                              setState(() {
                                showButtons = true;
                              });
                            }
                          },
                          front: customFlashCard(cards[currentIndex].front),
                          back: customFlashCard(cards[currentIndex].back),
                        ),
                      ),
                      height12,
                      if (showButtons)
                        Column(
                          children: [
                            customText(text: "How was it?"),
                            height12,
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                ElevatedButton(
                                  onPressed: () => finishCard("Again"),
                                  child: const Text("Again"),
                                ),
                                ElevatedButton(
                                  onPressed: () => finishCard("Hard"),
                                  child: const Text("Hard"),
                                ),
                                ElevatedButton(
                                  onPressed: () => finishCard("Good"),
                                  child: const Text("Good"),
                                ),
                                ElevatedButton(
                                  onPressed: () => finishCard("Easy"),
                                  child: const Text("Easy"),
                                ),
                              ],
                            ),
                          ],
                        ),
                    ],
                  ),
                ),
    );
  }
}
