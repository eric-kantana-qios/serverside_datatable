import 'serverside_matchmode.dart';

class ServerSideFilter<T extends DropdownItem> {
  final String field;
  final List<MatchMode> matchModes;
  final ServerSideFilterType filterType;
  final List<T> dropdownItems;

  ServerSideFilter({
    required this.field,
    required this.matchModes,
    required this.filterType,
    List<T> items = const [],
  }) : dropdownItems = items;
}

enum ServerSideFilterType { textField, dropdown, datetimePicker }

class ServerSideAppliedFilter<T extends DropdownItem> {
  final String field;
  final MatchMode matchMode;
  final ServerSideFilterType filterType;
  final String? value;
  final T? dropDownValue;

  ServerSideAppliedFilter({
    required this.field,
    required this.matchMode,
    required this.filterType,
    this.value,
    this.dropDownValue,
  });
}

abstract class DropdownItem {
  String get dropdownName;
}
