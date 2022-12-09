import 'package:flutter/material.dart';

import 'serverside_filter.dart';
import 'serverside_matchmode.dart';
import 'serverside_toggle_buttons.dart';

class ServerSideFilterMenu extends StatelessWidget {
  final List<ServerSideFilter> _filters;
  final Function(ServerSideAppliedFilter filterApplied)? _onFilterApplied;
  final int _fieldRowCount;
  final int _matchModeRowCount;
  ServerSideFilterMenu({
    Key? key,
    required List<ServerSideFilter> filters,
    Function(ServerSideAppliedFilter filterApplied)? onFilterApplied,
    final int columnFilterRow = 1,
    final int matchModeRowCount = 1,
  })  : _filters = filters,
        _onFilterApplied = onFilterApplied,
        _fieldRowCount = columnFilterRow,
        _matchModeRowCount = matchModeRowCount,
        assert(filters.isNotEmpty, "Filters cannot be empty"),
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton(
      constraints: BoxConstraints.loose(const Size(560, 480)),
      offset: const Offset(0, 0),
      icon: const Icon(Icons.more_vert),
      itemBuilder: (context) {
        final searchController = TextEditingController();
        MatchMode? matchMode;
        ServerSideFilter serverSideFilter = _filters.first;
        DropdownItem? dropdownItem;
        return [
          PopupMenuItem(
            enabled: false,
            child: StatefulBuilder(
              builder: (context, setState) {
                if (serverSideFilter.filterType == ServerSideFilterType.dropdown && dropdownItem == null) {
                  dropdownItem = serverSideFilter.dropdownItems.first;
                }
                return SizedBox(
                  width: 560,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Filter Table",
                        style: Theme.of(context).textTheme.titleLarge,
                      ),
                      const Padding(padding: EdgeInsets.only(top: 16)),
                      Text(
                        "Filter By",
                        style: Theme.of(context).textTheme.subtitle1,
                      ),
                      const Padding(padding: EdgeInsets.only(top: 4)),
                      ServerSideToggleButtons<ServerSideFilter>(
                        defaultSelected: serverSideFilter,
                        items: _filters,
                        onItemSelected: (selectedItem) {
                          setState(() {
                            serverSideFilter = selectedItem;
                          });
                        },
                        rowCount: _fieldRowCount,
                      ),
                      const Padding(padding: EdgeInsets.only(top: 16)),
                      if (serverSideFilter.filterType == ServerSideFilterType.textField)
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
                      else if (serverSideFilter.filterType == ServerSideFilterType.datetimePicker)
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
                      else if (serverSideFilter.filterType == ServerSideFilterType.dropdown)
                        DropdownButton(
                          value: dropdownItem,
                          isExpanded: true,
                          items: serverSideFilter.dropdownItems.map((dropdownItem) {
                            return DropdownMenuItem(value: dropdownItem, child: Text(dropdownItem.dropdownName));
                          }).toList(),
                          onChanged: (value) {
                            setState(() {
                              dropdownItem = value;
                            });
                          },
                        ),
                      const Padding(padding: EdgeInsets.only(top: 16)),
                      Text(
                        "Filter As",
                        style: Theme.of(context).textTheme.subtitle1,
                      ),
                      const Padding(padding: EdgeInsets.only(top: 4)),
                      ServerSideToggleButtons<MatchMode>(
                        items: serverSideFilter.matchModes,
                        onItemSelected: (selectedItem) {
                          matchMode = selectedItem;
                        },
                        rowCount: _matchModeRowCount,
                      ),
                      const Padding(padding: EdgeInsets.only(top: 16)),
                      Container(
                        alignment: Alignment.topRight,
                        child: ElevatedButton(
                          onPressed: () {
                            if (matchMode != null) {
                              final isDropdownFilter = serverSideFilter.filterType == ServerSideFilterType.dropdown;
                              _onFilterApplied?.call(ServerSideAppliedFilter(
                                field: serverSideFilter.field,
                                filterType: serverSideFilter.filterType,
                                matchMode: matchMode!,
                                value: !isDropdownFilter ? searchController.text : null,
                                dropDownValue: isDropdownFilter ? dropdownItem : null,
                              ));
                            }
                          },
                          child: const Text("Apply Filter"),
                        ),
                      ),
                      const Padding(padding: EdgeInsets.only(top: 16)),
                    ],
                  ),
                );
              },
            ),
          ),
        ];
      },
    );
  }
}
