import 'package:catatan_keuangan/app.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:catatan_keuangan/main.dart';

void main() {
  testWidgets('Counter increments smoke test', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(MyApp()); // hapus const supaya cocok versi Flutter kamu

    // Cari ikon tambahkan '+' pada layar
    expect(find.byIcon(Icons.add), findsOneWidget);
  });
}
