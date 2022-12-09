import 'package:example/foo_bar.dart';
import 'package:example/repository.dart';
import 'package:flutter/material.dart';
import 'package:serverside_datatable/serverside_datatable.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: Scaffold(
        body: SizedBox(
          width: double.infinity,
          child: ServerSideDataTable<FooBar>(
            filters: [
              ServerSideFilter(
                field: "Foo",
                matchModes: [MatchMode.equal],
                filterType: ServerSideFilterType.textField,
              ),
              ServerSideFilter<BarDropdownItem>(
                field: "Bar",
                matchModes: [MatchMode.equal, MatchMode.beginWith, MatchMode.contains],
                filterType: ServerSideFilterType.dropdown,
                items: [BarDropdownItem("Eric"), BarDropdownItem("Kantana")],
              ),
            ],
            label: "FooBar",
            columns: [
              ServerSideColumn(
                header: "Foo",
                field: "foo",
                renderer: (rowData) {
                  return Text(rowData.foo);
                },
              ),
              ServerSideColumn(
                header: "Bar",
                field: "bar",
                renderer: (rowData) {
                  return Text(rowData.bar);
                },
              ),
            ],
            repository: Repository(),
          ),
        ),
      ),
    );
  }
}

class BarDropdownItem extends DropdownItem {
  final String name;

  BarDropdownItem(this.name);

  @override
  String get dropdownName => name;
}
