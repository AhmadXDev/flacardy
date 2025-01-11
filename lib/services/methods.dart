import 'package:flacardy/data/supabase_database.dart';
import 'package:flacardy/models/flash_card.dart';
import 'package:flacardy/models/pocket.dart';
import 'package:flacardy/services/gemini.dart';

Future<void> generateFlashCardsForPocket(
    {required String title, required Pocket pocket}) async {
  try {
    final gemini = Gemini();

    final List<dynamic> flashCardsData = await gemini.generateFlashCards(title);

    final List<Map<String, dynamic>> flashCardsDataCasted =
        flashCardsData.cast<Map<String, dynamic>>();

    final List<FlashCard> flashCards = flashCardsDataCasted.map((data) {
      return FlashCard(
        pocketId: pocket.id!,
        front: data['front'],
        back: data['back'],
      );
    }).toList();

    for (var card in flashCards) {
      await SupabaseDatabase().addCard(card);
    }

    print("FlashCards added to pocket: ${pocket.name}");
  } catch (e) {
    print("Failed to generate flashcards: $e");
  }
}
