import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:provider/provider.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_stripe/flutter_stripe.dart'; // ✅ ADICIONADO

// ✅ REMOVER STRIPE_SERVICE IMPORT - NÃO É SEGURO
// import 'core/services/stripe_service.dart';

import 'core/services/notification_service.dart';
import 'core/theme/app_theme.dart';
import 'core/providers/auth_provider.dart';
import 'core/providers/profile_provider.dart';

// Screens
import 'features/onboarding/onboarding_screen.dart';
import 'features/auth/login_screen.dart';
import 'features/auth/register_screen.dart';
import 'features/main/main_screen.dart';
import 'features/packages/packages_screen.dart';
import 'features/booking/booking_screen.dart';
import 'features/booking/booking_list_screen.dart';
import 'features/packages/nav_packages_screen.dart';
import 'features/booking/nav_booking_screen.dart';
import 'features/profile/nav_profile_screen.dart';
import 'features/profile/profile_screen.dart' as RealProfileScreen;
import 'features/profile/settings_screen.dart';
import 'features/services/services_screen.dart';
import 'splash/animated_splash.dart';

Future main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // ✅ CARREGAR VARIÁVEIS DE AMBIENTE
  await dotenv.load(fileName: ".env");

  // ✅ CONFIGURAÇÃO STRIPE REAL CORRIGIDA
  final publishableKey = dotenv.env['STRIPE_PUBLISHABLE_KEY'];
  if (publishableKey != null && publishableKey.isNotEmpty) {
    Stripe.publishableKey = publishableKey;

    // ✅ ADICIONAR MERCHANT IDENTIFIER PARA APPLE PAY
    Stripe.merchantIdentifier = 'merchant.com.outbox.outboxstudio';

    await Stripe.instance.applySettings();
    print('✅ Stripe inicializado: ${publishableKey.substring(0, 20)}...');
  } else {
    throw Exception('❌ Chave publicável do Stripe não encontrada');
  }

  // Inicializa Supabase
  await Supabase.initialize(
    url: 'https://zazmlmzullejnkqcwmxp.supabase.co',
    anonKey: 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6Inphem1sbXp1bGxlam5rcWN3bXhwIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NTY0OTA0MTMsImV4cCI6MjA3MjA2NjQxM30.wyIJoWljEtzA0TWndS0YTewaBJp9gbB1vOrrZmiA61M',
  );

  // Inicializar NotificationService
  try {
    await NotificationService().initialize();
  } catch (e) {
    print('Erro ao inicializar NotificationService: $e');
  }

  runApp(const OutboxStudioApp());
}

class OutboxStudioApp extends StatelessWidget {
  const OutboxStudioApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => AppAuthProvider()),
        ChangeNotifierProvider(create: (context) => ProfileProvider()),
      ],
      child: MaterialApp(
        title: 'Outbox Studio',
        theme: AppTheme.darkTheme,
        debugShowCheckedModeBanner: false,
        home: const AnimatedSplash(),
        routes: {
          '/animated_splash': (context) => const AnimatedSplash(),
          '/onboarding': (context) => const OnboardingScreen(),
          '/login': (context) => const LoginScreen(),
          '/register': (context) => const RegisterScreen(),
          '/home': (context) => const MainScreen(),
          '/profile': (context) => const RealProfileScreen.ProfileScreen(),
          '/packages': (context) => const PackagesScreen(),
          '/services': (context) => const ServicesScreen(),
          '/booking': (context) => const BookingScreen(
            packageName: 'Default Package',
            packageBadge: 'Standard',
            packagePrice: r'$99',
          ),
          '/booking-list': (context) => const BookingListScreen(),
          '/settings': (context) => const SettingsScreen(),
        },
      ),
    );
  }
}

// ============================================================================
// RESTO DO CÓDIGO MANTIDO EXATAMENTE IGUAL
// ============================================================================

class ProfileScreen extends StatelessWidget {
  final String? packageName;
  final String? packageBadge;
  final String? packagePrice;

  const ProfileScreen({
    super.key,
    this.packageName,
    this.packageBadge,
    this.packagePrice,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: AppTheme.backgroundGradient,
      ),
      child: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 20),
          child: Consumer<AppAuthProvider>(
            builder: (context, auth, _) {
              final String? profileImageUrl = _getStringValue(auth.user?.userMetadata?['avatar_url']) ??
                  _getStringValue(auth.user?.userMetadata?['picture']);
              final String userName = _getStringValue(auth.user?.userMetadata?['name']) ??
                  _getStringValue(auth.user?.userMetadata?['full_name']) ??
                  (auth.user?.email?.split('@').first) ??
                  'User';
              final String userEmail = auth.user?.email ?? 'user@example.com';

              return Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  _buildHeader(),
                  const SizedBox(height: 40),
                  _buildProfileCard(context, profileImageUrl, userName, userEmail),
                  const SizedBox(height: 30),
                  _buildUserInfo(auth),
                  const SizedBox(height: 30),
                  _buildActionButtons(context),
                  const SizedBox(height: 100),
                ],
              );
            },
          ),
        ),
      ),
    );
  }

  String? _getStringValue(dynamic value) {
    if (value == null) return null;
    if (value is String) return value;
    return value.toString();
  }

  Widget _buildHeader() {
    return Column(
      children: [
        const Text(
          'PROFILE',
          style: TextStyle(
            color: Colors.white,
            fontFamily: 'Oswald',
            fontWeight: FontWeight.w700,
            fontSize: 32,
            letterSpacing: 2,
          ),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 8),
        Text(
          'Manage your account settings',
          style: TextStyle(
            color: Colors.white.withValues(alpha: 0.7),
            fontFamily: 'Lato',
            fontSize: 16,
          ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }

  Widget _buildProfileCard(BuildContext context, String? profileImageUrl, String userName, String userEmail) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(30),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            AppTheme.backgroundSecondary,
            AppTheme.backgroundTertiary.withValues(alpha: 0.6),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: Colors.white.withValues(alpha: 0.1),
          width: 1,
        ),
      ),
      child: Column(
        children: [
          _buildProfileImage(profileImageUrl),
          const SizedBox(height: 20),
          Text(
            userName,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 24,
              fontWeight: FontWeight.w700,
              fontFamily: 'Oswald',
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 8),
          Text(
            userEmail,
            style: TextStyle(
              color: Colors.white.withValues(alpha: 0.7),
              fontSize: 14,
              fontFamily: 'Lato',
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 20),
          TextButton.icon(
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Change profile picture - Coming soon!'),
                  backgroundColor: Color(0xFFFBAF2A),
                  behavior: SnackBarBehavior.floating,
                ),
              );
            },
            style: TextButton.styleFrom(
              foregroundColor: AppTheme.accentPrimary,
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            ),
            icon: const Icon(Icons.edit, size: 16),
            label: const Text(
              'Change Profile Picture',
              style: TextStyle(
                fontSize: 12,
                fontFamily: 'Lato',
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProfileImage(String? profileImageUrl) {
    if (profileImageUrl != null && profileImageUrl.isNotEmpty) {
      return Container(
        width: 120,
        height: 120,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          border: Border.all(
            color: AppTheme.accentPrimary,
            width: 3,
          ),
        ),
        child: ClipOval(
          child: Image.network(
            profileImageUrl,
            fit: BoxFit.cover,
            errorBuilder: (context, error, stackTrace) {
              return _buildDefaultAvatar();
            },
          ),
        ),
      );
    }

    return _buildDefaultAvatar();
  }

  Widget _buildDefaultAvatar() {
    return Container(
      width: 120,
      height: 120,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        gradient: LinearGradient(
          colors: [
            AppTheme.accentPrimary,
            AppTheme.accentSecondary,
          ],
        ),
        border: Border.all(
          color: Colors.white.withValues(alpha: 0.2),
          width: 3,
        ),
      ),
      child: const Icon(
        Icons.person,
        color: Colors.white,
        size: 60,
      ),
    );
  }

  Widget _buildUserInfo(AppAuthProvider auth) {
    DateTime? lastSignInDate;
    if (auth.user?.lastSignInAt != null) {
      try {
        if (auth.user!.lastSignInAt is String) {
          lastSignInDate = DateTime.tryParse(auth.user!.lastSignInAt as String);
        } else if (auth.user!.lastSignInAt is DateTime) {
          lastSignInDate = auth.user!.lastSignInAt as DateTime;
        }
      } catch (e) {
        lastSignInDate = null;
      }
    }

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            AppTheme.backgroundSecondary,
            AppTheme.backgroundTertiary.withValues(alpha: 0.6),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: Colors.white.withValues(alpha: 0.1),
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Account Information',
            style: TextStyle(
              color: AppTheme.accentPrimary,
              fontSize: 18,
              fontWeight: FontWeight.w700,
              fontFamily: 'Oswald',
            ),
          ),
          const SizedBox(height: 16),
          _buildInfoRow('User ID', auth.user?.id ?? 'N/A'),
          const SizedBox(height: 12),
          _buildInfoRow('Email Confirmed', auth.user?.emailConfirmedAt != null ? 'Yes' : 'No'),
          const SizedBox(height: 12),
          _buildInfoRow('Last Sign In', _formatDate(lastSignInDate)),
        ],
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          width: 120,
          child: Text(
            label,
            style: TextStyle(
              color: Colors.white.withValues(alpha: 0.7),
              fontSize: 12,
              fontFamily: 'Lato',
            ),
          ),
        ),
        Expanded(
          child: Text(
            value,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 12,
              fontFamily: 'Lato',
            ),
          ),
        ),
      ],
    );
  }

  String _formatDate(DateTime? date) {
    if (date == null) return 'N/A';
    return '${date.day}/${date.month}/${date.year}';
  }

  Widget _buildActionButtons(BuildContext context) {
    return Column(
      children: [
        SizedBox(
          width: double.infinity,
          child: ElevatedButton.icon(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const EditProfileScreen(),
                ),
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppTheme.accentPrimary,
              foregroundColor: Colors.black,
              padding: const EdgeInsets.symmetric(vertical: 16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            icon: const Icon(Icons.edit, size: 20),
            label: const Text(
              'Edit Profile',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w700,
                fontFamily: 'Oswald',
              ),
            ),
          ),
        ),
        const SizedBox(height: 12),
        SizedBox(
          width: double.infinity,
          child: OutlinedButton.icon(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const SettingsScreen(),
                ),
              );
            },
            style: OutlinedButton.styleFrom(
              foregroundColor: Colors.white,
              side: BorderSide(color: Colors.white.withValues(alpha: 0.3)),
              padding: const EdgeInsets.symmetric(vertical: 16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            icon: const Icon(Icons.settings, size: 20),
            label: const Text(
              'Settings',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                fontFamily: 'Lato',
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class EditProfileScreen extends StatelessWidget {
  const EditProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.backgroundPrimary,
      body: Container(
        decoration: BoxDecoration(
          gradient: AppTheme.backgroundGradient,
        ),
        child: SafeArea(
          child: Column(
            children: [
              _buildHeader(context),
              Expanded(
                child: Center(
                  child: Text(
                    'Edit Profile Screen\nComing Soon!',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: AppTheme.accentPrimary,
                      fontSize: 24,
                      fontWeight: FontWeight.w700,
                      fontFamily: 'Oswald',
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Row(
        children: [
          GestureDetector(
            onTap: () => Navigator.pop(context),
            child: Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: AppTheme.backgroundSecondary.withValues(alpha: 0.8),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: Colors.white.withValues(alpha: 0.1),
                  width: 1,
                ),
              ),
              child: const Icon(
                Icons.arrow_back,
                color: Colors.white,
                size: 24,
              ),
            ),
          ),
          const Spacer(),
          const Text(
            'EDIT PROFILE',
            style: TextStyle(
              color: Colors.white,
              fontSize: 18,
              fontFamily: 'Oswald',
              fontWeight: FontWeight.w700,
              letterSpacing: 1.5,
            ),
          ),
          const Spacer(),
          const SizedBox(width: 48),
        ],
      ),
    );
  }
}
