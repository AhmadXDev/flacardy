import 'package:flutter/material.dart';

class CustomFutureBuilder<T> extends StatefulWidget {
  final Future<T> future; // Future to be passed
  final Widget Function(T data)
      onData; // Widget to build when data is available
  final Widget? loadingWidget; // Custom loading widget (optional)
  final Widget? errorWidget; // Custom error widget (optional)
  final Widget? emptyWidget; // Widget for empty data (optional)

  CustomFutureBuilder({
    required this.future,
    required this.onData,
    this.loadingWidget,
    this.errorWidget,
    this.emptyWidget,
  });

  @override
  _CustomFutureBuilderState<T> createState() => _CustomFutureBuilderState<T>();
}

class _CustomFutureBuilderState<T> extends State<CustomFutureBuilder<T>> {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder<T>(
      future: widget.future, // Use widget.future
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          // Display the loading widget or a default progress indicator
          return widget.loadingWidget ??
              const Center(child: CircularProgressIndicator());
        } else if (snapshot.connectionState == ConnectionState.done) {
          if (snapshot.hasError) {
            // Display the error widget or default error message
            return widget.errorWidget ??
                Center(
                  child: Text(
                    'Error: ${snapshot.error}',
                    style: const TextStyle(color: Colors.red),
                  ),
                );
          } else if (snapshot.hasData) {
            // Use the onData function to display data
            return widget.onData(snapshot.data as T);
          } else {
            // Display the empty data widget or default "No Data" message
            return widget.emptyWidget ??
                const Center(
                  child: Text(
                    'No Data!',
                    style: TextStyle(fontSize: 12),
                  ),
                );
          }
        } else {
          // Fallback for other connection states
          return const Center(
            child: Text(
              'Something went wrong!',
              style: TextStyle(color: Colors.red),
            ),
          );
        }
      },
    );
  }
}
