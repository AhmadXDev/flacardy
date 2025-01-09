import 'package:flacardy/data/local_database.dart';
import 'package:flacardy/models/flash_card.dart';

class Pocket {
  final int? id;
  final String name;
  List<FlashCard> cards;

  Pocket({this.id, required this.name, this.cards = const []});

  // Database row to Pocket object
  static Pocket RowToPocket(Map<String, dynamic> row) {
    return Pocket(
      id: row['id'],
      name: row["name"],
      cards: [],
    );
  }

  Map<String, dynamic> PocketToRow() {
    return {'name': name};
  }

  Future<void> loadCards() async {
    if (id == null) {
      throw Exception(
          "Pocket ID is null. Cannot load cards for a pocket without ID!.");
    }
    cards = await LocalDatabase.instance.getPocketCards(id!);
  }
}
