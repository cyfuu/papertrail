class Validators {
  static bool isValidEmail(String email) {
    if (email.isEmpty) return false;
    final regex = RegExp(r'^[^@]+@[^@]+\.[^@]+');
    return regex.hasMatch(email);
  }

  static bool isValidUsername(String username) {
    return username.trim().length >= 5;
  }
}