import 'dart:math';

import 'package:example/foo_bar.dart';
import 'package:serverside_datatable/serverside_datatable.dart';

class Repository extends ServerSideRepository<FooBar> {
  @override
  Future<ServerSideResponse<FooBar>> fetchData(
    List<ServerSideAppliedFilter<DropdownItem>> appliedFilters,
    ServerSideMetadata metadata,
    int offset,
    int limit,
  ) async {
    final fooBars = <FooBar>[];

    for (var i = 0; i < 2001; i++) {
      final chars = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789".split("");
      chars.shuffle();
      final foo = chars.take(10).join();
      chars.shuffle();
      final bar = chars.take(10).join();
      fooBars.add(FooBar(foo, bar));
    }

    final totalRecords = fooBars.length;
    return ServerSideResponse(
      offset > fooBars.length ? [] : fooBars.getRange(offset, min(offset + limit, totalRecords)).toList(),
      totalRecords,
    );
  }
}
