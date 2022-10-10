extension CapExtension on String {

  String ifEmpty(String otherText) {
    return isEmpty ? otherText : this;
  }
}