class FlashCard {
  final int? id;
  final int pocketId;
  final String front;
  final String back;

  FlashCard({
    this.id,
    required this.pocketId,
    required this.front,
    required this.back,
  });

  factory FlashCard.RowToCard(Map<String, dynamic> row) {
    return FlashCard(
        id: row['id'],
        pocketId: row['pocketId'],
        front: row['front'],
        back: row['back']);
  }

  Map<String, dynamic> CardToRow() {
    return {
      'front': front,
      'back': back,
      'pocketId': pocketId,
    };
  }
}
