import 'serverside_paginate_type.dart';

class ServerSideMetadata<T> {
  final ServerSidePaginateType paginateType;
  final List<T> lastFetchedItems;

  ServerSideMetadata(this.paginateType, this.lastFetchedItems);
}
