extension TitleCase on String {
  String toTitleCase() {
    return "${substring(0, 1).toUpperCase()}${substring(1, length).toLowerCase()}";
  }
}
