import 'package:flacardy/data/supabase_database.dart';
import 'package:flacardy/models/flash_card.dart';

class Pocket {
  final int? id; // Unique identifier for the pocket
  final String name; // Pocket name
  final String? folderPath; // Path to the parent folder (nullable)
  List<FlashCard> cards; // Cards belonging to the pocket

  Pocket({
    this.id,
    required this.name,
    this.folderPath,
    this.cards = const [],
  });

  // Convert a database row to a Pocket object
  static Pocket rowToPocket(Map<String, dynamic> row) {
    return Pocket(
      id: row['id'],
      name: row['name'],
      folderPath: row['folder_path'],
      cards: [],
    );
  }

  // Convert a Pocket object to a database row
  Map<String, dynamic> pocketToRow() {
    return {
      'name': name,
      'folder_path': folderPath,
    };
  }

  // Load cards belonging to this pocket
  Future<void> loadCards() async {
    if (id == null) {
      throw Exception(
          "Pocket ID is null. Cannot load cards for a pocket without an ID.");
    }
    cards = await SupabaseDatabase().getPocketDueCards(id!);
  }
}
