import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'serverside_datasource.dart';
import 'serverside_matchmode.dart';

class ServerSideFilterChips<T> extends StatefulWidget {
  final void Function()? onFilterRemoved;
  const ServerSideFilterChips({Key? key, this.onFilterRemoved}) : super(key: key);

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
                    widget.onFilterRemoved?.call();
                    source.removeFilter(filter);
                  },
                  label: Text("${filter.field} ${filter.matchMode.string} ${filter.value ?? filter.dropDownValue?.dropdownName}"),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
