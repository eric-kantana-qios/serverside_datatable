import 'package:flutter/material.dart';

import 'serverside_filter.dart';
import 'serverside_matchmode.dart';
import 'serverside_toggle_buttons.dart';

class ServerSideFilterMenu extends StatefulWidget {
  final List<ServerSideFilter> _filters;
  final Function(ServerSideAppliedFilter filterApplied)? _onFilterApplied;
  final int _columnFilterRow;
  const ServerSideFilterMenu({
    Key? key,
    required List<ServerSideFilter> filters,
    Function(ServerSideAppliedFilter filterApplied)? onFilterApplied,
    final int columnFilterRow = 1,
  })  : _filters = filters,
        _onFilterApplied = onFilterApplied,
        _columnFilterRow = columnFilterRow,
        super(key: key);

  @override
  State<ServerSideFilterMenu> createState() => _ServerSideFilterMenuState();
}

class _ServerSideFilterMenuState extends State<ServerSideFilterMenu> {
  MatchMode? _matchMode;
  ServerSideFilter? _serverSideFilter;
  DropdownItem? _dropdownItem;

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
                    "Filter By",
                    style: Theme.of(context).textTheme.subtitle1,
                  ),
                  const Padding(padding: EdgeInsets.only(top: 4)),
                  ServerSideToggleButtons<ServerSideFilter>(
                    items: widget._filters,
                    onItemSelected: (selectedItem) {
                      setState(() {
                        _serverSideFilter = selectedItem;
                      });
                    },
                    rowCount: widget._columnFilterRow,
                  ),
                  const Padding(padding: EdgeInsets.only(top: 16)),
                  Text(
                    "Filter Table",
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  const Padding(padding: EdgeInsets.only(top: 16)),
                  if (_serverSideFilter != null) ...[
                    if (_serverSideFilter!.filterType == ServerSideFilterType.textField)
                      TextField(
                        controller: searchController,
                        decoration: const InputDecoration(
                          border: OutlineInputBorder(
                            borderSide: BorderSide(),
                          ),
                          hintText: "Filter Keyword",
                          isDense: true,
                        ),
                      )
                    else if (_serverSideFilter!.filterType == ServerSideFilterType.datetimePicker)
                      TextField(
                        controller: searchController,
                        onTap: () {},
                        decoration: const InputDecoration(
                          border: OutlineInputBorder(
                            borderSide: BorderSide(),
                          ),
                          hintText: "Filter Keyword",
                          isDense: true,
                        ),
                      )
                    else if (_serverSideFilter!.filterType == ServerSideFilterType.dropdown)
                      DropdownButton(
                        items: _serverSideFilter!.dropdownItems.map((dropdownItem) {
                          return DropdownMenuItem(child: Text(dropdownItem.dropdownName));
                        }).toList(),
                        onChanged: (value) {
                          _dropdownItem = value;
                        },
                      ),
                  ],
                  const Padding(padding: EdgeInsets.only(top: 16)),
                  Text(
                    "Filter As",
                    style: Theme.of(context).textTheme.subtitle1,
                  ),
                  const Padding(padding: EdgeInsets.only(top: 4)),
                  ServerSideToggleButtons<MatchMode>(
                    items: _serverSideFilter?.matchModes ?? [],
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
                        if (_serverSideFilter != null && _matchMode != null) {
                          final isDropdownFilter = _serverSideFilter!.filterType == ServerSideFilterType.dropdown;
                          widget._onFilterApplied?.call(ServerSideAppliedFilter(
                            field: _serverSideFilter!.field,
                            filterType: _serverSideFilter!.filterType,
                            matchMode: _matchMode!,
                            value: !isDropdownFilter ? searchController.text : null,
                            dropDownValue: isDropdownFilter ? _dropdownItem : null,
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
