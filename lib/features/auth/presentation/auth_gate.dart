import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../core/providers/auth_provider.dart';
import '../../home/home_screen.dart';
import '../login_screen.dart';

class AuthGate extends StatelessWidget {
  const AuthGate({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<AppAuthProvider>(
      builder: (context, auth, _) {
        // ✅ Loading state
        if (auth.isLoading) {
          return const Scaffold(
            backgroundColor: Color(0xFF1F1F1F),
            body: Center(
              child: CircularProgressIndicator(color: Color(0xFFFBAF2A)),
            ),
          );
        }

        // ✅ Authenticated state
        if (auth.isAuthenticated) {
          return const HomeScreen();
        }

        // ✅ Unauthenticated state
        return const LoginScreen();
      },
    );
  }
}
