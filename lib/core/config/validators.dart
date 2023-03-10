class Validators {
  static String? emptyText(String? value, String message) {
    if (value == null || value.isEmpty) {
      return "Please Enter $message";
    }
    return null;
  }
}
