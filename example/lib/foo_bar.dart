class FooBar {
  final String foo;
  final String bar;

  FooBar(this.foo, this.bar);

  @override
  String toString() {
    return "{ foo: $foo, bar: $bar }";
  }
}
