import 'package:flutter/material.dart';

import '../common_toggle_buttons.dart';
import 'serverside_column.dart';
import 'serverside_matchmode.dart';

class ServerSideFilterMenu<T> extends StatefulWidget {
  final List<ServerSideColumn<T>> _columns;
  final Function(ServerSideFilter filterApplied)? _onFilterApplied;
  final int _columnFilterRow;
  const ServerSideFilterMenu({
    Key? key,
    required List<ServerSideColumn<T>> columns,
    Function(ServerSideFilter filterApplied)? onFilterApplied,
    final int columnFilterRow = 1,
  })  : _columns = columns,
        _onFilterApplied = onFilterApplied,
        _columnFilterRow = columnFilterRow,
        super(key: key);

  @override
  State<ServerSideFilterMenu> createState() => _ServerSideFilterMenuState();
}

class _ServerSideFilterMenuState extends State<ServerSideFilterMenu> {
  MatchMode? _matchMode;
  ServerSideColumn? _column;

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton(
      constraints: BoxConstraints.loose(const Size(560, 480)),
      offset: const Offset(0, 0),
      icon: const Icon(Icons.more_vert),
      itemBuilder: (context) {
        final searchController = TextEditingController();
        return [
          PopupMenuItem(
            enabled: false,
            child: SizedBox(
              width: 560,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Padding(padding: EdgeInsets.only(top: 16)),
                  Text(
                    "Filter Table",
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  const Padding(padding: EdgeInsets.only(top: 16)),
                  TextField(
                    controller: searchController,
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(
                        borderSide: BorderSide(),
                      ),
                      hintText: "Filter Keyword",
                      isDense: true,
                    ),
                  ),
                  const Padding(padding: EdgeInsets.only(top: 16)),
                  Text(
                    "Filter By",
                    style: Theme.of(context).textTheme.subtitle1,
                  ),
                  const Padding(padding: EdgeInsets.only(top: 4)),
                  CommonToggleButtons<ServerSideColumn>(
                    items: widget._columns,
                    onItemSelected: (selectedItem) {
                      _column = selectedItem;
                    },
                    rowCount: widget._columnFilterRow,
                  ),
                  const Padding(padding: EdgeInsets.only(top: 16)),
                  Text(
                    "Filter As",
                    style: Theme.of(context).textTheme.subtitle1,
                  ),
                  const Padding(padding: EdgeInsets.only(top: 4)),
                  CommonToggleButtons<MatchMode>(
                    items: MatchMode.values,
                    onItemSelected: (selectedItem) {
                      _matchMode = selectedItem;
                    },
                    rowCount: 3,
                  ),
                  const Padding(padding: EdgeInsets.only(top: 16)),
                  Container(
                    alignment: Alignment.topRight,
                    child: ElevatedButton(
                      onPressed: () {
                        if (_column != null && _matchMode != null) {
                          widget._onFilterApplied?.call(ServerSideFilter(
                            column: _column!,
                            matchMode: _matchMode!,
                            value: searchController.text,
                          ));
                        }
                      },
                      child: const Text("Apply Filter"),
                    ),
                  ),
                  const Padding(padding: EdgeInsets.only(top: 16)),
                ],
              ),
            ),
          ),
        ];
      },
    );
  }
}

class ServerSideFilter {
  ServerSideColumn column;
  MatchMode matchMode;
  String? value;
  int? intValue;

  ServerSideFilter({
    required this.column,
    required this.matchMode,
    this.value,
    this.intValue,
  }) : assert(intValue != null || value != null);
}
