import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:smart_assistant/main.dart';

void main() {
  testWidgets('App starts and shows splash screen', (WidgetTester tester) async {
    await tester.pumpWidget(const MyApp(isDarkMode: false, fontSize: 16.0));
    
    await tester.pump(const Duration(seconds: 2));
    
    expect(find.byType(Scaffold), findsWidgets);
  });
}