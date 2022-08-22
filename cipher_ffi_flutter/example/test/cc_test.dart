import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';

void main() {
  test('', () {
    testing();
  });
}

void testing() {
  for (int i = 1; i < 280; i++) {
    // final str = String.fromCharCodes();
    final base = base64Encode(List.generate(i, (index) => 55));
    print("i: ${i / 16} -> ${base.length}");
  }
}
