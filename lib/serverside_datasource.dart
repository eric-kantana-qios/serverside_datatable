import 'package:flutter/material.dart';

import 'serverside_column.dart';
import 'serverside_filter_menu.dart';
import 'serverside_repository.dart';

class ServerSideDataSource<T> extends DataTableSource {
  final List<ServerSideColumn<T>> _columns;
  int _offset;
  int _rowsPerPage;
  final List<ServerSideFilter> _filters = [];
  final ServerSideRepository<T> _repository;

  void onRepositoryParamUpdated() {
    _fetch();
  }

  set offset(offset) {
    if (_offset != offset) {
      _offset = offset;
      _fetch();
    }
  }

  List<ServerSideFilter> get filters => _filters;

  void addFilter(ServerSideFilter filter) {
    _filters.add(filter);
    _fetch();
  }

  void removeFilter(ServerSideFilter filter) {
    _filters.removeWhere((element) => element == filter);
    _fetch();
  }

  int get rowsPerPage => _rowsPerPage;

  set rowsPerPage(rowsPerPage) {
    if (_rowsPerPage != rowsPerPage) {
      _rowsPerPage = rowsPerPage;
      _fetch();
    }
  }

  final List<T> _data = [];
  int _totalRecords = 0;

  ServerSideDataSource(this._repository, this._columns, this._offset, this._rowsPerPage) {
    _repository.addListener(onRepositoryParamUpdated);
    _fetch();
  }

  @override
  void dispose() {
    super.dispose();
    _repository.removeListener(onRepositoryParamUpdated);
  }

  void _fetch() async {
    _data.clear();
    notifyListeners();
    _repository.fetchData(_offset, _rowsPerPage).then((response) {
      _data.addAll(response.data);
      _totalRecords = response.totalRecords;
      notifyListeners();
    });
  }

  @override
  DataRow? getRow(int index) {
    final rowIndex = index % _rowsPerPage;
    if (rowIndex > _data.length - 1) return null;
    return DataRow(
      color: MaterialStateProperty.resolveWith<Color?>((states) {
        // if (states.contains(MaterialState.selected)) return Colors.red.withOpacity(0.08);
        return null;
        // return index % 2 == 0 ? Colors.red : Colors.blue;
      }),
      cells: _columns.map(
        (column) {
          return DataCell(column.renderer(_data[rowIndex]));
        },
      ).toList(),
    );
  }

  @override
  bool get isRowCountApproximate => false;

  @override
  int get rowCount => _totalRecords;

  @override
  int get selectedRowCount => 0;
}
