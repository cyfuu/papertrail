import 'package:flutter_test/flutter_test.dart';
import 'package:papertrail/utils/validators.dart'; 

void main() {
  group('Requirement: Username must contain at least 5 characters', () {
    test('Username with less than 5 characters returns false', () {
      final result = Validators.isValidUsername('John'); // 4 chars
      expect(result, isFalse);
    });

    test('Username with exactly 5 characters returns true', () {
      final result = Validators.isValidUsername('Alice'); // 5 chars
      expect(result, isTrue);
    });

    test('Username with more than 5 characters returns true', () {
      final result = Validators.isValidUsername('PaperTrailUser'); // 14 chars
      expect(result, isTrue);
    });

    test('Username containing only spaces returns false', () {
      final result = Validators.isValidUsername('      ');
      expect(result, isFalse);
    });
  });
}