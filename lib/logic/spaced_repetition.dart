import 'package:flacardy/models/flash_card.dart';

// This Algorithm is inspired by Anki

void evaluateFlashCard(String evaluation, FlashCard card) {
  const int oneMinuteInMilliseconds = 60000; // Milliseconds in a minute
  const int oneDayInMilliseconds = 86400000; // Milliseconds in a day
  final now = DateTime.now();

  if (card.repetitions == 0) {
    // First time studying the card
    switch (evaluation) {
      case "Again":
        card.interval = 1; // <1 minute
        break;

      case "Hard":
        card.interval = 6 * oneMinuteInMilliseconds; // 6 minutes
        break;

      case "Good":
        card.interval = 10 * oneMinuteInMilliseconds; // 10 minutes
        card.repetitions++; // Increment repetitions
        break;

      case "Easy":
        card.interval = 4 * oneDayInMilliseconds; // 4 days
        card.repetitions++; // Increment repetitions
        card.easeFactor += 0.15; // Increase ease factor
        break;

      default:
        throw ArgumentError("Invalid evaluation value: $evaluation");
    }
  } else {
    // Subsequent reviews
    switch (evaluation) {
      case "Again":
        card.repetitions = 0; // Reset repetitions
        card.interval = 1 * oneMinuteInMilliseconds; // <1 minute
        card.easeFactor = 2.5; // Reset ease factor
        break;

      case "Hard":
        card.easeFactor =
            (card.easeFactor - 0.15).clamp(1.3, 2.5); // Decrease EF
        card.interval = (card.interval * 1.2).round(); // Slight increase
        break;

      case "Good":
        card.repetitions++;
        card.interval =
            (card.interval * card.easeFactor).round(); // Multiply by EF
        break;

      case "Easy":
        card.repetitions++;
        card.easeFactor += 0.15; // Increase EF
        card.interval =
            (card.interval * card.easeFactor * 1.3).round(); // Boost EF
        break;

      default:
        throw ArgumentError("Invalid evaluation value: $evaluation");
    }
  }

  // Calculate the next review date
  card.nextReview = now.add(Duration(milliseconds: card.interval));
}
