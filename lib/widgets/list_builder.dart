import 'package:flutter/material.dart';
import 'package:ttracker/widgets/empty_result.dart';

typedef ItemWidgetBuilder<T> = Widget Function(BuildContext context, T item);

class ListItemsBuilder<T> extends StatelessWidget {
  final ItemWidgetBuilder<T> itemBuilder;

  final AsyncSnapshot<List<T>> snapshot;
  const ListItemsBuilder({
    Key? key,
    required this.snapshot,
    required this.itemBuilder,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (snapshot.hasData) {
      final List<T>? items = snapshot.data;
      if (items!.isNotEmpty) {
        return _buildList(items);
      } else {
        return const EmptyResultWidget();
      }
    } else if (snapshot.hasError) {
      return const EmptyResultWidget(
        title: 'Something went wrong',
        message: 'Can\'t load items right now',
      );
    }
    return const Center(child: CircularProgressIndicator());
  }

  Widget _buildList(List<T> items) {
    return ListView.separated(
      itemCount: items.length + 2,
      separatorBuilder: (context, index) => const Divider(height: 0.5),
      itemBuilder: (context, index) {
        if (index == 0 || index == items.length + 1) {
          return Container();
        }
        return itemBuilder(context, items[index - 1]);
      },
    );
  }
}
