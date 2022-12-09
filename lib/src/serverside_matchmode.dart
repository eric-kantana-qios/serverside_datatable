enum MatchMode {
  lessThan,
  greaterThan,
  lessThanOrEqualTo,
  greaterThanOrEqualTo,
  equal,
  notEqual,
  contains,
  doesNotContains,
  beginWith,
  endWith;

  @override
  String toString() {
    return string;
  }
}

extension MatchModeString on MatchMode {
  String get string {
    switch (this) {
      case MatchMode.equal:
        return "is";
      case MatchMode.notEqual:
        return "is not";
      case MatchMode.lessThan:
        return "<";
      case MatchMode.greaterThan:
        return ">";
      case MatchMode.lessThanOrEqualTo:
        return "<=";
      case MatchMode.greaterThanOrEqualTo:
        return ">=";
      case MatchMode.contains:
        return "contains";
      case MatchMode.doesNotContains:
        return "does not contain";
      case MatchMode.beginWith:
        return "begin with";
      case MatchMode.endWith:
        return "end with";
      default:
        return "";
    }
  }
}
