import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'serverside_datasource.dart';
import 'serverside_matchmode.dart';

class ServerSideFilterChips<T> extends StatefulWidget {
  const ServerSideFilterChips({Key? key}) : super(key: key);

  @override
  State<ServerSideFilterChips<T>> createState() => _ServerSideFilterChipsState<T>();
}

class _ServerSideFilterChipsState<T> extends State<ServerSideFilterChips<T>> {
  final ScrollController _scrollController = ScrollController();

  @override
  Widget build(BuildContext context) {
    return Scrollbar(
      controller: _scrollController,
      child: Consumer<ServerSideDataSource<T>>(
        builder: (context, source, child) => ListView(
          controller: _scrollController,
          scrollDirection: Axis.horizontal,
          children: [
            ...source.filters.map(
              (filter) => Padding(
                padding: const EdgeInsets.only(right: 8.0),
                child: Chip(
                  deleteIcon: const Icon(Icons.close),
                  onDeleted: () {
                    source.removeFilter(filter);
                  },
                  label: Text("${filter.column.header} ${filter.matchMode.string} ${filter.value ?? filter.intValue}"),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
