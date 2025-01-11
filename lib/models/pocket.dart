import 'package:flacardy/data/supabase_database.dart';
import 'package:flacardy/models/flash_card.dart';

class Pocket {
  final int? id;
  final String name;
  final String? folderPath;
  List<FlashCard> cards;

  Pocket({
    this.id,
    required this.name,
    this.folderPath,
    this.cards = const [],
  });

  static Pocket rowToPocket(Map<String, dynamic> row) {
    return Pocket(
      id: row['id'],
      name: row['name'],
      folderPath: row['folder_path'],
      cards: [],
    );
  }

  Map<String, dynamic> pocketToRow() {
    return {
      'name': name,
      'folder_path': folderPath,
    };
  }

  Future<void> loadCards() async {
    if (id == null) {
      throw Exception(
          "Pocket ID is null. Cannot load cards for a pocket without an ID.");
    }
    cards = await SupabaseDatabase().getPocketDueCards(id!);
  }
}
