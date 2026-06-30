import 'package:flutter_test/flutter_test.dart';
import 'package:papertrail/utils/validators.dart'; 

void main() {
  group('Unit Test: Email Validation', () {
    test('Empty email should return false', () {
      final result = Validators.isValidEmail('');
      expect(result, isFalse);
    });

    test('Invalid email should return false', () {
      final result = Validators.isValidEmail('invalid_email.com');
      expect(result, isFalse);
      
      final resultNoDomain = Validators.isValidEmail('test@');
      expect(resultNoDomain, isFalse);
    });

    test('Valid email should return true', () {
      final result = Validators.isValidEmail('test@example.com');
      expect(result, isTrue);
    });
  });
}