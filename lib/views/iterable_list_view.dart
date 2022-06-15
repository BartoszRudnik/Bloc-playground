import 'package:flutter/material.dart';

extension ToListView<T> on Iterable<T> {
  Widget toListView() => IterableListView(
        iterable: this,
      );
}

class IterableListView<T> extends StatelessWidget {
  final Iterable<T> iterable;

  const IterableListView({
    Key? key,
    required this.iterable,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemBuilder: (ctx, index) {
        return ListTile(
          title: Text(
            iterable.elementAt(index).toString(),
          ),
        );
      },
      itemCount: iterable.length,
    );
  }
}