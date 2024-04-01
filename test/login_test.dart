import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:social_media_app/auth/login-signup.dart';
import 'package:social_media_app/components/fbypost.dart';
import 'package:social_media_app/components/textfield.dart';
import 'package:social_media_app/pages/geolocation.dart';
import 'package:social_media_app/pages/profile.dart';

void main() {
  testWidgets('Login UI Test', (WidgetTester tester) async {
    // Build our LoginOrSignUp widget
    await tester.pumpWidget(const MaterialApp(home: LoginOrSignUp()));

    // Verify that certain widgets are present on the screen
    // Verify that certain buttons are present based on whether it's the current user's profile or not
    expect(find.text('Flameberry | Login'), findsOneWidget);

    expect(find.widgetWithText(FBYTextField, 'Email'), findsOneWidget);
    expect(find.widgetWithText(FBYTextField, 'Password'), findsOneWidget);

    expect(find.text('Login'), findsOneWidget);
    expect(find.text('Forgot Password?'), findsOneWidget);
    expect(find.widgetWithText(GestureDetector, 'Login'), findsOneWidget);
    expect(find.text('Forgot Password?'), findsOneWidget);
    expect(find.text("Don't have an account?"), findsOneWidget);
    expect(
        find.widgetWithText(GestureDetector, ' Sign Up here.'), findsOneWidget);

    expect(find.widgetWithText(GestureDetector, 'Sign up with Google'),
        findsOneWidget);
    expect(find.widgetWithText(GestureDetector, 'Sign up with Apple ID'),
        findsOneWidget);

    await tester.enterText(find.byType(TextField).first, 'fby@gmail.com');
    await tester.enterText(find.byType(TextField).last, 'flameberry');
    await tester.tap(find.widgetWithText(GestureDetector, ' Sign Up here.'));

    // Rebuild the widget after the tap
    await tester.pump();
  });
}
