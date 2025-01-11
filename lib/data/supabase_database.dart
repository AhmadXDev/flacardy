import 'package:flacardy/models/folder.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:flacardy/models/flash_card.dart';
import 'package:flacardy/models/pocket.dart';

class SupabaseDatabase {
  final supabase = Supabase.instance.client;

  // Adding:

  addFolder(Folder folder) async {
    await supabase.from('folders').insert(folder.folderToRow());
  }

  addPocket(Pocket pocket) async {
    await supabase.from('pockets').insert({
      'name': pocket.name,
      'folder_path': pocket.folderPath, // Include the folder path
    });
  }

  addCard(FlashCard card) async {
    await supabase.from('cards').insert({
      'front': card.front,
      'back': card.back,
      'pocket_id': card.pocketId,
    });
  }

  // Retrieving:
  Future<List<Pocket>> getPockets() async {
    final response = await supabase.from('pockets').select();

    List<Pocket> pocketsList = [];
    for (var pocket in response) {
      pocketsList.add(Pocket.rowToPocket(pocket));
    }

    return pocketsList;
  }

  Future<List<FlashCard>> getPocketDueCards(int pocketId) async {
    final result = await supabase
        .from('cards')
        .select()
        .eq('pocket_id', pocketId)
        .or('next_review.lte.${DateTime.now().toIso8601String()},next_review.is.null');
    return result.map<FlashCard>((row) => FlashCard.rowToCard(row)).toList();
  }

  Future<List<FlashCard>> getPocketCards(int pocketId) async {
    final result =
        await supabase.from('cards').select().eq('pocket_id', pocketId);
    return result.map<FlashCard>((row) => FlashCard.rowToCard(row)).toList();
  }

  Future<List<Folder>> getRootFolders() async {
    final response =
        await supabase.from('folders').select().isFilter('parent_path', null);

    List<Folder> foldersList = [];
    for (var folder in response) {
      foldersList.add(Folder.rowToFolder(folder));
    }
    return foldersList;
  }

  Future<List<Folder>> getSubFolders(String folderPath) async {
    final response = await supabase
        .from('folders') // Replace 'folders' with your actual table name
        .select('*')
        .eq('parent_path', folderPath); // Filters by parent_path

    // Convert response data to a list of Folder objects
    return response.map((folder) => Folder.rowToFolder(folder)).toList();
  }

  Future<List<Pocket>> getPocketsInFolder(String folderPath) async {
    final response = await supabase
        .from('pockets') // Replace 'pockets' with your actual table name
        .select('*')
        .eq('folder_path', folderPath); // Filters by folder_path
    return response.map((pocket) => Pocket.rowToPocket(pocket)).toList();
  }

  Future<List<Pocket>> getRootPockets() async {
    final response =
        await supabase.from('pockets').select().isFilter('folder_path', null);

    List<Pocket> pocketsList = [];
    for (var pocket in response) {
      pocketsList.add(Pocket.rowToPocket(pocket));
    }

    return pocketsList;
  }

  Future<void> updateCard(FlashCard card) async {
    await supabase.from('cards').update({
      'ease_factor': card.easeFactor,
      'interval': card.interval,
      'repetitions': card.repetitions,
      'next_review': card.nextReview?.toIso8601String(),
    }).eq('id', card.id!);
  }
}
