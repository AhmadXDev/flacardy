import 'package:flacardy/constants/spacing.dart';

import 'package:flacardy/widgets/text_input.dart';
import 'package:flutter/material.dart';

class CustomFloatingActionButton extends StatelessWidget {
  final Widget icon;
  final String tooltip;
  final VoidCallback onPressed;
  final String heroTag;
  final TextEditingController controller;
  final VoidCallback onStateUpdate; // New callback for updating state
  final String addButtonName;

  const CustomFloatingActionButton({
    Key? key,
    required this.heroTag,
    required this.tooltip,
    required this.icon,
    required this.addButtonName,
    required this.controller,
    required this.onStateUpdate,
    required this.onPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton(
      heroTag: heroTag,
      onPressed: () {
        showDialog(
          context: context,
          builder: (context) {
            return Dialog(
              child: Padding(
                padding: EdgeInsets.all(8.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    TextInput(
                      controller: controller,
                      labelText: "Name",
                    ),
                    height12,
                    ElevatedButton(
                      onPressed: onPressed,
                      child: Text(addButtonName),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
      child: icon,
      tooltip: tooltip,
    );
  }
}
