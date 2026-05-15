extension StringExt on String {
  bool get isNotEmpty => this.isNotEmpty;
  String get trim => this.trim();
}

extension ListExt<T> on List<T> {
  bool get isNotEmpty => this.isNotEmpty;
  T? get firstOrNull => isEmpty ? null : first;
}
