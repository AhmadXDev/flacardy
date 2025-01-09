import 'package:flacardy/constants/spacing.dart';
import 'package:flacardy/data/local_database.dart';
import 'package:flacardy/extensions/nav.dart';
import 'package:flacardy/models/pocket.dart';
import 'package:flacardy/pages/cards_list_page.dart';
import 'package:flacardy/widgets/custom_future_builder.dart';
import 'package:flacardy/widgets/text_input.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  TextEditingController nameController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Home Page"),
        centerTitle: true,
      ),
      body: Padding(
          padding: EdgeInsets.all(20.0),
          child: CustomFutureBuilder<List<Pocket>>(
              future: LocalDatabase.instance.getPockets(),
              onData: (data) {
                return ListView.builder(
                    itemCount: data.length,
                    itemBuilder: (context, index) {
                      final Pocket pocket = data[index];
                      return InkWell(
                        child: Card(
                          child: Column(
                            children: [
                              SizedBox(height: 10),
                              Text(pocket.name),
                              SizedBox(height: 10),
                            ],
                          ),
                        ),
                        onTap: () {
                          context.push(CardsListPage(
                            pocket: pocket,
                          ));
                        },
                      );
                    });
              })),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showDialog(
              context: context,
              builder: (context) {
                return Dialog(
                  child: Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Column(
                      mainAxisSize: MainAxisSize.max,
                      children: [
                        TextInput(
                            controller: nameController,
                            labelText: "Pocket Name"),
                        height12,
                        ElevatedButton(
                            onPressed: () async {
                              await LocalDatabase.instance
                                  .addPocket(Pocket(name: nameController.text));
                              if (context.mounted) {
                                setState(() {});
                              }
                            },
                            child: Text("Add Pocket"))
                      ],
                    ),
                  ),
                );
              });
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
