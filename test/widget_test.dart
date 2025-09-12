// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:outbox_studio_app/main.dart';

void main() {
  testWidgets('OutboxStudioApp login screen loads correctly', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(const OutboxStudioApp());

    // Verify that the login screen elements are present
    expect(find.text('Outbox Studio'), findsOneWidget);
    expect(find.text('Professional Media Production'), findsOneWidget);
    expect(find.text('Sign In'), findsOneWidget);
    expect(find.text('Create Account'), findsOneWidget);
    expect(find.text('Continue as Guest'), findsOneWidget);
  });

  testWidgets('Login form fields are present and functional', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(const OutboxStudioApp());

    // Verify that email and password fields exist
    expect(find.byType(TextField), findsNWidgets(2)); // Email + Password fields
    expect(find.text('Email Address'), findsOneWidget);
    expect(find.text('Password'), findsOneWidget);

    // Test typing in email field
    await tester.enterText(find.widgetWithText(TextField, 'Email Address'), 'test@example.com');
    expect(find.text('test@example.com'), findsOneWidget);

    // Test typing in password field
    await tester.enterText(find.widgetWithText(TextField, 'Password'), 'password123');
    expect(find.text('password123'), findsOneWidget);
  });

  testWidgets('Password visibility toggle works', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(const OutboxStudioApp());

    // Find the password visibility toggle button
    final visibilityButton = find.byIcon(Icons.visibility);

    // Initially should show visibility icon (password hidden)
    expect(visibilityButton, findsOneWidget);

    // Tap the visibility toggle
    await tester.tap(visibilityButton);
    await tester.pump();

    // After tap, should show visibility_off icon (password visible)
    expect(find.byIcon(Icons.visibility_off), findsOneWidget);
  });

  testWidgets('Sign In button triggers validation', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(const OutboxStudioApp());

    // Find and tap the Sign In button without filling fields
    final signInButton = find.text('Sign In');
    expect(signInButton, findsOneWidget);

    await tester.tap(signInButton);
    await tester.pump();

    // Should show validation message
    await tester.pump(const Duration(milliseconds: 100));
    expect(find.text('Please fill in all fields'), findsOneWidget);
  });

  testWidgets('Create Account button shows coming soon message', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(const OutboxStudioApp());

    // Find and tap the Create Account button
    final createAccountButton = find.text('Create Account');
    expect(createAccountButton, findsOneWidget);

    await tester.tap(createAccountButton);
    await tester.pump();

    // Should show coming soon message
    await tester.pump(const Duration(milliseconds: 100));
    expect(find.text('Register feature coming soon'), findsOneWidget);
  });

  testWidgets('Continue as Guest button shows coming soon message', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(const OutboxStudioApp());

    // Find and tap the Continue as Guest button
    final guestButton = find.text('Continue as Guest');
    expect(guestButton, findsOneWidget);

    await tester.tap(guestButton);
    await tester.pump();

    // Should show coming soon message
    await tester.pump(const Duration(milliseconds: 100));
    expect(find.text('Guest access feature coming soon'), findsOneWidget);
  });

  testWidgets('Forgot Password button shows coming soon message', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(const OutboxStudioApp());

    // Find and tap the Forgot Password button
    final forgotPasswordButton = find.text('Forgot Password?');
    expect(forgotPasswordButton, findsOneWidget);

    await tester.tap(forgotPasswordButton);
    await tester.pump();

    // Should show coming soon message
    await tester.pump(const Duration(milliseconds: 100));
    expect(find.text('Forgot password feature coming soon'), findsOneWidget);
  });
}
