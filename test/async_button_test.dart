import 'dart:async';

import 'package:async_button_build/async_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('AsyncButton enables, disables, and completes operation',
      (WidgetTester tester) async {
    bool pressed = false;
    final completer = Completer<void>();

    // Build the AsyncButton widget
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: AsyncButton(
            onPressedAsync: () async {
              pressed = true;
              await completer.future;
            },
            buttonBuilder: (context, onPressed, working) {
              return ElevatedButton(
                onPressed: onPressed,
                child: working
                    ? const CircularProgressIndicator()
                    : const Text('Press Me'),
              );
            },
          ),
        ),
      ),
    );

    // Verify that the button is present and initially enabled
    expect(find.text('Press Me'), findsOneWidget);
    expect(find.byType(CircularProgressIndicator), findsNothing);

    // Tap the button and start the async operation
    await tester.tap(find.byType(ElevatedButton));
    await tester.pump(); // Rebuild after the state changes

    // Verify that the button is now in the loading state (disabled and showing a spinner)
    expect(find.byType(CircularProgressIndicator), findsOneWidget);
    expect(pressed, isTrue);

    // Complete the async operation
    completer.complete();
    await tester.pumpAndSettle(); // Wait for the async task to finish

    // Verify that the button returns to its original state
    expect(find.text('Press Me'), findsOneWidget);
    expect(find.byType(CircularProgressIndicator), findsNothing);
  });

  testWidgets('AsyncButton does nothing when onPressedAsync is null',
      (WidgetTester tester) async {
    // Build the AsyncButton widget with no onPressedAsync
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: AsyncButton(
            onPressedAsync: null, // No callback
            buttonBuilder: (context, onPressed, working) {
              return ElevatedButton(
                onPressed: onPressed,
                child: working
                    ? const CircularProgressIndicator()
                    : const Text('Press Me'),
              );
            },
          ),
        ),
      ),
    );

    // Verify the button is present and disabled (onPressed is null)
    expect(find.text('Press Me'), findsOneWidget);
    expect(tester.widget<ElevatedButton>(find.byType(ElevatedButton)).onPressed,
        isNull);
  });
}
