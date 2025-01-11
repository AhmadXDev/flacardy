class FlashCard {
  final int? id;
  final int pocketId;
  final String front;
  final String back;
  double easeFactor; // Ease factor
  int interval; // Interval in days
  int repetitions; // Number of reviews
  DateTime? nextReview; // Next review date

  FlashCard({
    this.id,
    required this.pocketId,
    required this.front,
    required this.back,
    this.easeFactor = 2.5,
    this.interval = 1,
    this.repetitions = 0,
    this.nextReview,
  });

  factory FlashCard.rowToCard(Map<String, dynamic> row) {
    return FlashCard(
      id: row['id'],
      pocketId: row['pocket_id'],
      front: row['front'],
      back: row['back'],
      easeFactor: row['ease_factor'],
      interval: row['interval'],
      repetitions: row['repetitions'],
      nextReview: row['next_review'] != null
          ? DateTime.parse(row['next_review'])
          : null,
    );
  }

  Map<String, dynamic> CardToRow() {
    return {
      'front': front,
      'back': back,
      'pocket_id': pocketId,
      'ease_factor': easeFactor,
      'interval': interval,
      'repetitions': repetitions,
      'next_review': nextReview?.toIso8601String(),
    };
  }
}
