import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:provider/provider.dart';
import '../../core/theme/app_theme.dart';
import '../../core/providers/auth_provider.dart';
import '../../widgets/glass_dark_box.dart';

class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({super.key});

  @override
  State<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen>
    with TickerProviderStateMixin {
  final _emailController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool _isLoading = false;
  bool _emailSent = false;

  late AnimationController _slideController;
  late AnimationController _pulseController;

  @override
  void initState() {
    super.initState();

    _slideController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );

    _pulseController = AnimationController(
      duration: const Duration(milliseconds: 2000),
      vsync: this,
    );

    _slideController.forward();
    _pulseController.repeat(reverse: true);
  }

  @override
  void dispose() {
    _emailController.dispose();
    _slideController.dispose();
    _pulseController.dispose();
    super.dispose();
  }

  // ✅ FUNÇÃO PRINCIPAL - SEM REDIRECTTO
  Future<void> _sendResetEmail() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    final auth = Provider.of<AppAuthProvider>(context, listen: false);

    // ✅ SÓ EMAIL - SEM PARÂMETROS EXTRAS
    final success = await auth.sendPasswordResetEmail(_emailController.text.trim());

    if (mounted) {
      setState(() => _isLoading = false);

      if (success) {
        setState(() => _emailSent = true);
        _showMessage(
          '✅ Password reset email sent!\n\n📧 Check your inbox and click the link.\n\n🌐 The link will open Supabase\'s official secure page for password reset.',
          AppTheme.accentPrimary,
        );
      } else {
        _showMessage(
          auth.error ?? 'Failed to send reset email. Please try again.',
          Colors.red,
        );
      }
    }
  }

  void _showMessage(String message, Color color) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: color,
        behavior: SnackBarBehavior.floating,
        duration: const Duration(seconds: 5),
      ),
    );
  }

  String? _validateEmail(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter your email address';
    }
    if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(value)) {
      return 'Please enter a valid email address';
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    const Color kThinBorder = Color(0x21FFFFFF);
    final size = MediaQuery.of(context).size;
    final maxCardWidth = size.width < 400 ? size.width - 32 : 360.0;

    return Scaffold(
      backgroundColor: AppTheme.backgroundPrimary,
      resizeToAvoidBottomInset: false,
      body: Stack(
        children: [
          // Background
          Positioned.fill(
            child: Container(
              decoration: BoxDecoration(
                gradient: AppTheme.backgroundGradient,
              ),
            ),
          ),

          // Header com botão de voltar
          SafeArea(
            child: Padding(
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
                        ),
                      ),
                      child: const Icon(
                        Icons.arrow_back,
                        color: Colors.white,
                        size: 24,
                      ),
                    ),
                  ).animate().fadeIn(duration: 600.ms).slideX(begin: -0.5, end: 0),
                ],
              ),
            ),
          ),

          // Main content
          SafeArea(
            child: Center(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(16),
                child: ConstrainedBox(
                  constraints: BoxConstraints(maxWidth: maxCardWidth),
                  child: GlassDarkBox(
                    child: Form(
                      key: _formKey,
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          // Logo
                          Image.asset(
                            'assets/images/outbox_logo.png',
                            width: 120,
                            height: 80,
                          ),

                          const SizedBox(height: 16),

                          // Título
                          Text(
                            _emailSent ? 'Check Your Email!' : 'Forgot Password?',
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 24,
                              fontWeight: FontWeight.w700,
                              fontFamily: 'Oswald',
                            ),
                            textAlign: TextAlign.center,
                          ),

                          const SizedBox(height: 8),

                          // Subtítulo
                          Text(
                            _emailSent
                                ? '✅ Password reset email sent!\n\n📧 Check your inbox and click the link.\n\n🔗 The link will open in your browser with Supabase\'s secure reset page.\n\n🔄 After resetting, return to the app and login with your new password.'
                                : 'Enter your email address and we\'ll send you a secure link to reset your password.',
                            style: TextStyle(
                              color: AppTheme.textSecondary,
                              fontFamily: 'Lato',
                              fontSize: 14,
                            ),
                            textAlign: TextAlign.center,
                          ),

                          const SizedBox(height: 24),

                          if (!_emailSent) ...[
                            // Campo de Email
                            Theme(
                              data: Theme.of(context).copyWith(
                                inputDecorationTheme: InputDecorationTheme(
                                  filled: true,
                                  fillColor: Colors.transparent,
                                  enabledBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(12),
                                    borderSide: const BorderSide(color: kThinBorder, width: 1.0),
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(12),
                                    borderSide: BorderSide(color: AppTheme.accentPrimary, width: 2.0),
                                  ),
                                  errorBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(12),
                                    borderSide: const BorderSide(color: Colors.red, width: 1.0),
                                  ),
                                  focusedErrorBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(12),
                                    borderSide: const BorderSide(color: Colors.red, width: 2.0),
                                  ),
                                  labelStyle: TextStyle(
                                    color: Colors.white.withValues(alpha: 0.80),
                                    fontSize: 14,
                                  ),
                                  floatingLabelStyle: TextStyle(
                                    color: AppTheme.accentPrimary,
                                    fontSize: 12,
                                  ),
                                  prefixIconColor: Colors.white.withValues(alpha: 0.90),
                                  contentPadding: const EdgeInsets.fromLTRB(12, 20, 12, 16),
                                ),
                              ),
                              child: TextFormField(
                                controller: _emailController,
                                keyboardType: TextInputType.emailAddress,
                                style: const TextStyle(color: Colors.white),
                                validator: _validateEmail,
                                decoration: const InputDecoration(
                                  labelText: 'Email Address',
                                  prefixIcon: Icon(Icons.email_outlined),
                                ),
                              ),
                            ),

                            const SizedBox(height: 24),

                            // Botão de enviar
                            SizedBox(
                              width: double.infinity,
                              height: 50,
                              child: ElevatedButton(
                                onPressed: _isLoading ? null : _sendResetEmail,
                                style: ElevatedButton.styleFrom(
                                  padding: EdgeInsets.zero,
                                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                                  backgroundColor: Colors.transparent,
                                  elevation: 0,
                                ),
                                child: Ink(
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(12),
                                    gradient: const LinearGradient(
                                      colors: [Color(0xFFFBAF2A), Color(0xFFED9B10)],
                                      begin: Alignment.centerLeft,
                                      end: Alignment.centerRight,
                                    ),
                                  ),
                                  child: Center(
                                    child: _isLoading
                                        ? const SizedBox(
                                      height: 22,
                                      width: 22,
                                      child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white),
                                    )
                                        : const Text(
                                      'Send Reset Email',
                                      style: TextStyle(
                                        fontSize: 16,
                                        fontFamily: 'Oswald',
                                        fontWeight: FontWeight.bold,
                                        color: Colors.black,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ] else ...[
                            // Ícone de sucesso
                            Container(
                              width: 80,
                              height: 80,
                              decoration: BoxDecoration(
                                color: AppTheme.accentPrimary.withValues(alpha: 0.2),
                                shape: BoxShape.circle,
                                border: Border.all(color: AppTheme.accentPrimary, width: 2),
                              ),
                              child: const Icon(
                                Icons.mark_email_read_outlined,
                                size: 40,
                                color: Color(0xFFFBAF2A),
                              ),
                            ),

                            const SizedBox(height: 24),

                            // Botão de voltar para login
                            SizedBox(
                              width: double.infinity,
                              height: 50,
                              child: OutlinedButton(
                                onPressed: () => Navigator.pop(context),
                                style: OutlinedButton.styleFrom(
                                  foregroundColor: AppTheme.accentPrimary,
                                  side: BorderSide(color: AppTheme.accentPrimary, width: 2),
                                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                                ),
                                child: const Text(
                                  'Back to Login',
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontFamily: 'Oswald',
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ),
                          ],

                          const SizedBox(height: 16),

                          // Texto de ajuda
                          if (!_emailSent)
                            TextButton(
                              onPressed: () => Navigator.pop(context),
                              child: Text(
                                'Remember your password? Sign In',
                                style: TextStyle(
                                  color: AppTheme.textSecondary,
                                  fontFamily: 'Lato',
                                  fontSize: 14,
                                ),
                              ),
                            ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
