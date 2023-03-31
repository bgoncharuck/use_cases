extension SliceIterable<T> on Iterable<T> {
  Iterable<List<T>> slices(int length) sync* {
    if (length < 1) yield [];
    final iterator = this.iterator;

    while (iterator.moveNext()) {
      final slice = [iterator.current];
      for (var i = 1; i < length && iterator.moveNext(); i++) {
        slice.add(iterator.current);
      }

      yield slice;
    }
  }
}
