import 'package:serverside_datatable/src/serverside_metadata.dart';

import 'serverside_filter.dart';

abstract class ServerSideRepository<T> {
  List<void Function()> listeners = [];
  Future<ServerSideResponse<T>> fetchData(
    List<ServerSideAppliedFilter> appliedFilters,
    ServerSideMetadata<T> metadata,
    int offset,
    int limit,
  );

  void addListener(void Function() listener) {
    listeners.add(listener);
  }

  void removeListener(void Function() listener) {
    listeners.remove(listener);
  }

  void notifyListeners() {
    for (var listener in listeners) {
      listener();
    }
  }
}

class ServerSideResponse<T> {
  List<T> data;
  int totalRecords;

  ServerSideResponse(this.data, this.totalRecords);
}
