<!--
This README describes the package. If you publish this package to pub.dev,
this README's contents appear on the landing page for your package.

For information about how to write a good package README, see the guide for
[writing package pages](https://dart.dev/guides/libraries/writing-package-pages).

For general information about developing packages, see the Dart guide for
[creating packages](https://dart.dev/guides/libraries/create-library-packages)
and the Flutter guide for
[developing packages and plugins](https://flutter.dev/developing-packages).
-->

Serverside Datatable that handle the pagination for you. All you need to do is implement the ServersideRepository class
which define your fetch implementation.

## Features

- Pagination
- Filter is not supported yet.

## Getting started

## Usage

1. Create a class that extends ServersideRepository.
2. Create PODO (Plain Old Dart Object) class.

```dart
class FooBar {
    double foo;
    double bar;

    FooBar(this.foo, this.bar);
}

class FooBarRepository extends ServerSideRepository<FooBar> {

    @override
    Future<ServerSideResponse<FooBar>> fetchData(int offset, int limit) async {
        final fooBars = [
            FooBar(5, 5),
            FooBar(1, 3),
            FooBar(2, 4),
            FooBar(8, 9),
        ];
        final totalRecords = fooBars.length;
        if (offset + limit > totalRecords) limit = totalRecords;
        return ServerSideResponse(fooBars.getRange(offset, limit), totalRecords);
    }
}

ServerSideDataTable<FooBar>(
    repository: FooBarRepository(),
    columns: [
        ServerSideColumn(
            header: "Foo",
            field: "foo",
            renderer: (FooBar rowData) => Text(rowData.foo),
        ),
        ServerSideColumn(
            header: "Bar",
            field: "bar",
            renderer: (FooBar rowData) => Text(rowData.bar),
        ),
    ],
)
```

## Additional information
