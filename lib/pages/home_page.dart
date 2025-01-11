import 'package:flacardy/constants/spacing.dart';
import 'package:flacardy/data/supabase_database.dart';
import 'package:flacardy/extensions/nav.dart';
import 'package:flacardy/models/pocket.dart';
import 'package:flacardy/models/folder.dart';
import 'package:flacardy/pages/folder_page.dart';
import 'package:flacardy/pages/pocket_page.dart';
import 'package:flacardy/widgets/custom_floating_action_button.dart';
import 'package:flacardy/widgets/custom_future_builder.dart';
import 'package:flacardy/widgets/custom_widgets.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  TextEditingController nameController = TextEditingController();

  Future<List<dynamic>> getRootItems() async {
    // Fetch both Folders and Pockets in the root (folder_path == NULL)
    final folders = await SupabaseDatabase().getRootFolders();
    final pockets = await SupabaseDatabase().getRootPockets();
    return [...folders, ...pockets];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: customAppBar("Home Page"),
      body: Padding(
        padding: EdgeInsets.all(20.0),
        child: CustomFutureBuilder<List<dynamic>>(
          future: getRootItems(),
          onData: (data) {
            return GridView.builder(
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3, // Number of columns
                crossAxisSpacing: 10,
                mainAxisSpacing: 10,
              ),
              itemCount: data.length,
              itemBuilder: (context, index) {
                final item = data[index];

                // FOLDER:
                if (item is Folder) {
                  return InkWell(
                    child: customFolderWidget(item),
                    onTap: () {
                      context.push(FolderPage(folder: item));
                    },
                  );
                }

                // POCKET:
                else if (item is Pocket) {
                  return InkWell(
                    child: customPocketWidget(item),
                    onTap: () {
                      context.push(PocketPage(pocket: item));
                    },
                  );
                }

                // Something other than Folder or Pocket
                else {
                  return SizedBox.shrink();
                }
              },
            );
          },
        ),
      ),
      // A floating button to add a Folder and a Pocket
      floatingActionButton: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          width32,
          // Add Folder Button
          CustomFloatingActionButton(
            heroTag: "addFolder",
            tooltip: "Add Folder",
            icon: const Icon(Icons.folder),
            addButtonName: "Add Folder",
            controller: nameController,
            onStateUpdate: () => setState(() {}),
            onPressed: () async {
              await SupabaseDatabase().addFolder(
                Folder(
                  fullPath: nameController
                      .text, // Generate fullPath dynamically if needed
                  name: nameController.text,
                  parentPath: null,
                ),
              );
              nameController.clear();
              if (context.mounted) setState(() {});
              Navigator.of(context).pop(); // Close dialog
            },
          ),

          Spacer(),

          // Add Pocket Button
          CustomFloatingActionButton(
              heroTag: "addPocket",
              tooltip: "Add Pocket",
              icon: const Icon(Icons.add),
              addButtonName: "Add Pocket",
              controller: nameController,
              onStateUpdate: () => {},
              onPressed: () async {
                await SupabaseDatabase().addPocket(
                  Pocket(name: nameController.text, folderPath: null),
                );
                nameController.clear();
                if (context.mounted) setState(() {});
                Navigator.of(context).pop(); // Close dialog
              })
        ],
      ),
    );
  }
}
