import 'package:flutter/material.dart';

import 'serverside_column.dart';
import 'serverside_filter.dart';
import 'serverside_metadata.dart';
import 'serverside_paginate_type.dart';
import 'serverside_repository.dart';

class ServerSideDataSource<T> extends DataTableSource {
  final List<ServerSideColumn<T>> _columns;
  int _offset;
  int _rowsPerPage;
  final List<ServerSideAppliedFilter> _filters = [];
  final ServerSideRepository<T> _repository;
  final Function(T rowData)? onRowClick;
  ServerSidePaginateType _paginateType = ServerSidePaginateType.first;
  final void Function(dynamic error)? onFetchError;

  void onRepositoryParamUpdated() {
    _fetch();
  }

  set offset(value) {
    if (_offset != value) {
      if (value == 0) {
        _paginateType = ServerSidePaginateType.first;
      } else if (value + _rowsPerPage >= _totalRecords) {
        _paginateType = ServerSidePaginateType.last;
      } else if (value > _offset) {
        _paginateType = ServerSidePaginateType.next;
      } else {
        _paginateType = ServerSidePaginateType.previous;
      }
      _offset = value;
      _fetch();
    }
  }

  List<ServerSideAppliedFilter> get filters => _filters;

  void addFilter(ServerSideAppliedFilter filter) {
    _filters.add(filter);
    _fetch();
  }

  void removeFilter(ServerSideAppliedFilter filter) {
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

  ServerSideDataSource(this._repository, this._columns, this._offset, this._rowsPerPage, this.onRowClick, this.onFetchError) {
    _repository.addListener(onRepositoryParamUpdated);
    _fetch();
  }

  @override
  void dispose() {
    super.dispose();
    _repository.removeListener(onRepositoryParamUpdated);
  }

  void _fetch() async {
    final metadata = ServerSideMetadata<T>(_paginateType, List.from(_data));
    _data.clear();
    notifyListeners();
    _repository.fetchData(filters, metadata, _offset, _rowsPerPage).then((response) {
      _data.addAll(response.data);
      _totalRecords = response.totalRecords;
      notifyListeners();
    }).catchError((error) {
      onFetchError?.call(error);
    });
  }

  @override
  DataRow? getRow(int index) {
    final rowIndex = index % _rowsPerPage;
    if (rowIndex > _data.length - 1) return DataRow(cells: _columns.map((column) => const DataCell(Text(""))).toList());
    return DataRow(
      onSelectChanged: (value) {
        onRowClick?.call(_data[rowIndex]);
      },
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
