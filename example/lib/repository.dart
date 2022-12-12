import 'package:example/foo_bar.dart';
import 'package:serverside_datatable/serverside_datatable.dart';

class Repository extends ServerSideRepository<FooBar> {
  @override
  Future<ServerSideResponse<FooBar>> fetchData(
    List<ServerSideAppliedFilter<DropdownItem>> appliedFilters,
    FooBar? lastFetchedItem,
    PaginateType paginateType,
    int offset,
    int limit,
  ) async {
    final fooBars = [
      FooBar("A", "B"),
      FooBar("C", "D"),
      FooBar("E", "F"),
      FooBar("G", "H"),
    ];
    final totalRecords = fooBars.length;
    if (offset + limit > totalRecords) limit = totalRecords;
    return ServerSideResponse(fooBars.getRange(offset, limit).toList(), totalRecords);
  }
}
