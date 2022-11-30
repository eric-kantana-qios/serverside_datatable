library serverside_datatable;

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'serverside_column.dart';
import 'serverside_datasource.dart';
import 'serverside_filter_chips.dart';
import 'serverside_filter_menu.dart';
import 'serverside_repository.dart';

class ServerSideDataTable<T> extends StatefulWidget {
  final List<ServerSideColumn<T>> _columns;
  final String _label;
  final int _columnFilterRow;
  final ServerSideRepository<T> _repository;

  const ServerSideDataTable({
    Key? key,
    required String label,
    required List<ServerSideColumn<T>> columns,
    required ServerSideRepository<T> repository,
    int columnFilterRow = 1,
  })  : _label = label,
        _columns = columns,
        _repository = repository,
        _columnFilterRow = columnFilterRow,
        super(key: key);

  @override
  State<ServerSideDataTable<T>> createState() => _ServerSideDataTableState<T>();
}

class _ServerSideDataTableState<T> extends State<ServerSideDataTable<T>> {
  late ServerSideDataSource<T> _source;

  @override
  void initState() {
    super.initState();

    _source = ServerSideDataSource<T>(widget._repository, widget._columns, 0, 10);
  }

  @override
  Widget build(BuildContext context) {
    return PaginatedDataTable(
      header: Row(
        children: [
          Text(widget._label),
          const Padding(padding: EdgeInsets.only(right: 16.0)),
          Expanded(
            flex: 1,
            child: ChangeNotifierProvider.value(
              value: _source,
              child: ServerSideFilterChips<T>(),
            ),
          ),
        ],
      ),
      actions: [
        ServerSideFilterMenu<T>(
          columns: widget._columns,
          onFilterApplied: (filterApplied) {
            _source.addFilter(filterApplied);
          },
          columnFilterRow: widget._columnFilterRow,
        ),
      ],
      source: _source,
      rowsPerPage: _source.rowsPerPage,
      availableRowsPerPage: const [10, 20, 50, 100],
      onPageChanged: (offset) {
        _source.offset = offset;
      },
      onRowsPerPageChanged: (rowsPerPage) {
        if (rowsPerPage != null) {
          setState(() {
            _source.rowsPerPage = rowsPerPage;
          });
        }
      },
      columns: widget._columns
          .map(
            (column) => DataColumn(
              label: Text(column.header),
              numeric: column.isNumber,
            ),
          )
          .toList(),
      showFirstLastButtons: true,
    );
  }
}
