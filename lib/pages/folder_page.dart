import 'package:flacardy/constants/spacing.dart';
import 'package:flacardy/data/supabase_database.dart';
import 'package:flacardy/extensions/nav.dart';
import 'package:flacardy/models/folder.dart';
import 'package:flacardy/models/pocket.dart';
import 'package:flacardy/pages/pocket_page.dart';
import 'package:flacardy/widgets/custom_floating_action_button.dart';
import 'package:flacardy/widgets/custom_future_builder.dart';
import 'package:flacardy/widgets/custom_widgets.dart';
import 'package:flutter/material.dart';

class FolderPage extends StatefulWidget {
  final Folder folder;

  const FolderPage({super.key, required this.folder});

  @override
  State<FolderPage> createState() => _FolderPageState();
}

class _FolderPageState extends State<FolderPage> {
  TextEditingController nameController = TextEditingController();

  Future<List<dynamic>> getFolderContents() async {
    final folders =
        await SupabaseDatabase().getSubFolders(widget.folder.fullPath);
    final pockets =
        await SupabaseDatabase().getPocketsInFolder(widget.folder.fullPath);
    return [...folders, ...pockets];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: customAppBar('${widget.folder.name} 📁'),
      body: Padding(
        padding: EdgeInsets.all(20.0),
        child: CustomFutureBuilder<List<dynamic>>(
          future: getFolderContents(),
          onData: (data) {
            return GridView.builder(
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3,
                crossAxisSpacing: 10,
                mainAxisSpacing: 10,
              ),
              itemCount: data.length,
              itemBuilder: (context, index) {
                final item = data[index];

                if (item is Folder) {
                  return InkWell(
                    child: customFolderWidget(item),
                    onTap: () {
                      context.push(FolderPage(folder: item));
                    },
                  );
                } else if (item is Pocket) {
                  return InkWell(
                    child: customPocketWidget(item),
                    onTap: () {
                      context.push(PocketPage(
                        pocket: item,
                      ));
                    },
                  );
                } else {
                  return SizedBox.shrink();
                }
              },
            );
          },
        ),
      ),
      floatingActionButton: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          width32,
          CustomFloatingActionButton(
            heroTag: "addFolder_${widget.folder.fullPath}",
            tooltip: "Add Folder",
            icon: const Icon(Icons.folder),
            addButtonName: "Add Folder",
            controller: nameController,
            onStateUpdate: () => setState(() {}),
            onPressed: () async {
              await SupabaseDatabase().addFolder(
                Folder(
                  fullPath: "${widget.folder.fullPath}/${nameController.text}",
                  name: nameController.text,
                  parentPath: widget.folder.fullPath,
                ),
              );
              nameController.clear();
              if (context.mounted) setState(() {});
              Navigator.of(context).pop();
            },
          ),
          Spacer(),
          CustomFloatingActionButton(
            heroTag: "addPocket_${widget.folder.fullPath}",
            tooltip: "Add Pocket",
            icon: const Icon(Icons.add),
            addButtonName: "Add Pocket",
            controller: nameController,
            onStateUpdate: () => setState(() {}),
            onPressed: () async {
              await SupabaseDatabase().addPocket(
                Pocket(
                  name: nameController.text,
                  folderPath: widget.folder.fullPath,
                ),
              );
              if (context.mounted) setState(() {});
              Navigator.of(context).pop();
            },
          ),
        ],
      ),
    );
  }
}
