import 'dart:math';

import 'package:flutter/material.dart';

class CommonToggleButtons<T> extends StatefulWidget {
  final List<T> _items;
  final Function(T selectedItem)? _onItemSelected;
  final int _rowCount;
  final T? _defaultSelected;
  const CommonToggleButtons({
    Key? key,
    required List<T> items,
    Function(T selectedItem)? onItemSelected,
    int rowCount = 1,
    T? defaultSelected,
  })  : _items = items,
        _onItemSelected = onItemSelected,
        _rowCount = rowCount > items.length ? items.length : rowCount,
        _defaultSelected = defaultSelected,
        super(key: key);

  @override
  State<CommonToggleButtons<T>> createState() => _CommonToggleButtonsState();
}

class _CommonToggleButtonsState<T> extends State<CommonToggleButtons<T>> {
  late Map<T, bool> _selections;
  late int columnCount;

  @override
  void initState() {
    super.initState();
    _selections = {
      for (var item in widget._items) item: widget._defaultSelected != null && widget._defaultSelected == item,
    };
    columnCount = (_selections.length / widget._rowCount).ceil();
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            for (int i = 0; i < widget._rowCount; i++)
              Padding(
                padding: EdgeInsets.only(top: i > 0 ? 8.0 : 0.0),
                child: ToggleButtons(
                  isSelected: _selections.entries
                      .toList()
                      .sublist(
                        i * columnCount,
                        min(i * columnCount + columnCount, _selections.length),
                      )
                      .map((e) => e.value)
                      .toList(),
                  borderRadius: const BorderRadius.all(Radius.circular(8.0)),
                  constraints: BoxConstraints.expand(
                    height: 40.0,
                    width: (constraints.maxWidth - columnCount - 1) / columnCount,
                  ),
                  onPressed: (index) {
                    final selectedItem = _selections.entries.elementAt(i * columnCount + index).key;
                    setState(() {
                      _selections.updateAll((key, value) => value = key == selectedItem);
                    });
                    widget._onItemSelected?.call(selectedItem);
                  },
                  children: _selections.entries
                      .toList()
                      .sublist(
                        i * columnCount,
                        min(i * columnCount + columnCount, _selections.length),
                      )
                      .map(
                        (e) => Text(
                          e.key.toString(),
                          textAlign: TextAlign.center,
                        ),
                      )
                      .toList(),
                ),
              ),
          ],
        );
      },
    );
  }
}
