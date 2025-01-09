import 'package:flutter/material.dart';

class TextInput extends StatefulWidget {
  final TextEditingController? controller;
  final String? labelText;
  final double radiusCircular;
  final bool isPassword;

  const TextInput({
    super.key,
    required this.controller,
    required this.labelText,
    this.isPassword = false,
    this.radiusCircular = 16.0,
  });

  @override
  State<TextInput> createState() => _TextInputState();
}

class _TextInputState extends State<TextInput> {
  bool isObscureText = true;
  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: widget.controller,
      obscureText: widget.isPassword ? isObscureText : false,
      decoration: InputDecoration(
        labelText: widget.labelText,
        suffixIcon: widget.isPassword
            ? InkWell(
                onTap: () {
                  isObscureText = !isObscureText;
                  setState(() {});
                },
                child: Icon(
                    isObscureText ? Icons.visibility : Icons.visibility_off),
              )
            : null,
        border: OutlineInputBorder(
          borderRadius:
              BorderRadius.all(Radius.circular(widget.radiusCircular)),
        ),
      ),
    );
  }
}
