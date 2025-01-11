import 'package:flutter/material.dart';

class CustomFutureBuilder<T> extends StatefulWidget {
  final Future<T> future;
  final Widget Function(T data) onData;
  final Widget? loadingWidget;
  final Widget? errorWidget;
  final Widget? emptyWidget;

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
      future: widget.future,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return widget.loadingWidget ??
              const Center(child: CircularProgressIndicator());
        } else if (snapshot.connectionState == ConnectionState.done) {
          if (snapshot.hasError) {
            return widget.errorWidget ??
                Center(
                  child: Text(
                    'Error: ${snapshot.error}',
                    style: const TextStyle(color: Colors.red),
                  ),
                );
          } else if (snapshot.hasData) {
            return widget.onData(snapshot.data as T);
          } else {
            return widget.emptyWidget ??
                const Center(
                  child: Text(
                    'No Data!',
                    style: TextStyle(fontSize: 12),
                  ),
                );
          }
        } else {
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
