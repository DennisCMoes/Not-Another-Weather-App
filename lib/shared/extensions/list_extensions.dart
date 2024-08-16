extension ListContextX<E> on List<E> {
  List<E> uniqueBy([Object Function(E element)? func]) {
    final seen = <dynamic>{};
    return where((element) => seen.add(func != null ? func(element) : element))
        .toList();
  }
}
