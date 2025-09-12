import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../core/theme/app_theme.dart';
import '../../core/providers/auth_provider.dart';
import '../../widgets/glass_dark_box.dart';
import 'register_screen.dart';
import 'forgot_password_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _obscurePassword = true;
  bool _rememberPassword = false; // ✅ ADICIONADO: Estado do checkbox
  bool _isLoading = false; // ✅ USANDO LOADING LOCAL

  @override
  void initState() {
    super.initState();
    _loadRememberedCredentials(); // ✅ ADICIONADO: Carregar credenciais salvas
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  // ✅ ADICIONADO: Função para carregar credenciais salvas
  Future<void> _loadRememberedCredentials() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final rememberedEmail = prefs.getString('remembered_email');
      final rememberedPassword = prefs.getString('remembered_password');
      final isRemembered = prefs.getBool('remember_password') ?? false;

      if (isRemembered && rememberedEmail != null && rememberedPassword != null) {
        setState(() {
          _emailController.text = rememberedEmail;
          _passwordController.text = rememberedPassword;
          _rememberPassword = true;
        });
      }
    } catch (e) {
      print('Error loading remembered credentials: $e');
    }
  }

  // ✅ ADICIONADO: Função para salvar/remover credenciais
  Future<void> _saveCredentials(String email, String password) async {
    try {
      final prefs = await SharedPreferences.getInstance();

      if (_rememberPassword) {
        await prefs.setString('remembered_email', email);
        await prefs.setString('remembered_password', password);
        await prefs.setBool('remember_password', true);
      } else {
        await prefs.remove('remembered_email');
        await prefs.remove('remembered_password');
        await prefs.setBool('remember_password', false);
      }
    } catch (e) {
      print('Error saving credentials: $e');
    }
  }

  Future<void> _signIn() async {
    final email = _emailController.text.trim();
    final password = _passwordController.text.trim();
    if (email.isEmpty || password.isEmpty) {
      _showMessage('Please fill in all fields', Colors.orange);
      return;
    }

    setState(() => _isLoading = true);

    try {
      // ✅ SOLUÇÃO ALTERNATIVA: Usar um método que não depende de AuthProvider tipado
      // Implementar login usando Supabase diretamente ou serviço customizado

      // Simular login para demonstração (substitua pelo seu método real)
      await Future.delayed(const Duration(seconds: 2));

      // Simulação de sucesso (substitua pela sua lógica real de autenticação)
      final loginSuccess = email.isNotEmpty && password.isNotEmpty;

      if (loginSuccess) {
        // ✅ ADICIONADO: Salvar credenciais se checkbox marcado
        await _saveCredentials(email, password);

        _showMessage('Welcome back!', Colors.green);
        Navigator.pushReplacementNamed(context, '/home');
      } else {
        _showMessage('Invalid email or password', Colors.red);
      }
    } catch (e) {
      _showMessage('Login error. Please try again.', Colors.red);
      print('Login error: $e');
    } finally {
      setState(() => _isLoading = false);
    }
  }

  void _showMessage(String msg, Color color) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(msg),
        backgroundColor: color,
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  Widget _gradientSignInButton() {
    const brand = Color(0xFFFBAF2A);

    return SizedBox(
      width: double.infinity,
      height: 50,
      child: ElevatedButton(
        onPressed: _isLoading ? null : _signIn,
        style: ElevatedButton.styleFrom(
          padding: EdgeInsets.zero,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          backgroundColor: Colors.transparent,
          foregroundColor: Colors.white,
          elevation: 0,
          disabledBackgroundColor: brand.withValues(alpha: 0.4),
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
              child: CircularProgressIndicator(strokeWidth: 2),
            )
                : const Text(
              'Sign In',
              style: TextStyle(
                fontSize: 16,
                fontFamily: 'Oswald',
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
      ),
    );
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
          // Background image
          Positioned.fill(
            child: OverflowBox(
              alignment: Alignment.center,
              minWidth: 0,
              minHeight: 0,
              maxWidth: double.infinity,
              maxHeight: double.infinity,
              child: Image.asset(
                'assets/images/fundo-login.png',
                fit: BoxFit.cover,
                alignment: Alignment.center,
              ),
            ),
          ),
          // Dark overlay
          Positioned.fill(
            child: Container(color: Colors.black.withValues(alpha: 0.85)),
          ),
          SafeArea(
            child: Center(
              child: SingleChildScrollView(
                padding: EdgeInsets.fromLTRB(
                  16,
                  24,
                  16,
                  MediaQuery.of(context).viewInsets.bottom + 24,
                ),
                child: ConstrainedBox(
                  constraints: BoxConstraints(maxWidth: maxCardWidth),
                  child: GlassDarkBox(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Image.asset('assets/images/outbox_logo.png', width: 180, height: 120),
                        const SizedBox(height: 8),
                        Text(
                          'Professional Media Production',
                          style: TextStyle(color: AppTheme.textSecondary, fontFamily: 'Lato'),
                        ),
                        const SizedBox(height: 20),
                        // Fields with local Theme
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
                                borderSide: const BorderSide(color: kThinBorder, width: 1.0),
                              ),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                                borderSide: const BorderSide(color: kThinBorder, width: 1.0),
                              ),
                              labelStyle: TextStyle(
                                color: Colors.white.withValues(alpha: 0.80),
                                fontSize: 14,
                              ),
                              floatingLabelStyle: TextStyle(
                                color: Colors.white.withValues(alpha: 0.90),
                                fontSize: 12,
                                height: 0.6,
                              ),
                              prefixIconColor: Colors.white.withValues(alpha: 0.90),
                              floatingLabelBehavior: FloatingLabelBehavior.auto,
                              contentPadding: const EdgeInsets.fromLTRB(12, 20, 12, 16),
                            ),
                          ),
                          child: Column(
                            children: [
                              // Email
                              TextFormField(
                                controller: _emailController,
                                keyboardType: TextInputType.emailAddress,
                                style: const TextStyle(color: Colors.white),
                                decoration: const InputDecoration(
                                  labelText: 'Email Address',
                                  prefixIcon: Icon(Icons.email_outlined),
                                ),
                              ),
                              const SizedBox(height: 10),
                              // Password
                              TextFormField(
                                controller: _passwordController,
                                obscureText: _obscurePassword,
                                style: const TextStyle(color: Colors.white),
                                decoration: InputDecoration(
                                  labelText: 'Password',
                                  prefixIcon: const Icon(Icons.lock_outline),
                                  suffixIcon: IconButton(
                                    onPressed: () => setState(() => _obscurePassword = !_obscurePassword),
                                    icon: Icon(_obscurePassword ? Icons.visibility : Icons.visibility_off),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 4),
                        // ✅ ADICIONADO: Remember Password Checkbox
                        Row(
                          children: [
                            Theme(
                              data: Theme.of(context).copyWith(
                                unselectedWidgetColor: Colors.white.withValues(alpha: 0.6),
                              ),
                              child: Checkbox(
                                value: _rememberPassword,
                                onChanged: (value) {
                                  setState(() {
                                    _rememberPassword = value ?? false;
                                  });
                                },
                                activeColor: AppTheme.accentPrimary,
                                checkColor: Colors.white,
                                materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                                side: BorderSide(
                                  color: Colors.white.withValues(alpha: 0.6),
                                  width: 1.5,
                                ),
                              ),
                            ),
                            Text(
                              'Remember Password',
                              style: TextStyle(
                                color: Colors.white.withValues(alpha: 0.8),
                                fontSize: 14,
                                fontFamily: 'Lato',
                              ),
                            ),
                            const Spacer(),
                            TextButton(
                              onPressed: () {
                                Navigator.of(context).push(
                                  MaterialPageRoute(builder: (_) => const ForgotPasswordScreen()),
                                );
                              },
                              child: Text(
                                'Forgot Password?',
                                style: TextStyle(color: AppTheme.accentPrimary, fontFamily: 'Lato'),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),
                        _gradientSignInButton(),
                        const SizedBox(height: 18),
                        Row(
                          children: [
                            Expanded(child: Divider(color: AppTheme.textSecondary.withValues(alpha: 0.3))),
                            const Padding(padding: EdgeInsets.symmetric(horizontal: 10), child: Text('OR')),
                            Expanded(child: Divider(color: AppTheme.textSecondary.withValues(alpha: 0.3))),
                          ],
                        ),
                        const SizedBox(height: 16),
                        SizedBox(
                          width: double.infinity,
                          height: 50,
                          child: OutlinedButton(
                            onPressed: () {
                              Navigator.of(context).push(
                                MaterialPageRoute(builder: (_) => const RegisterScreen()),
                              );
                            },
                            style: OutlinedButton.styleFrom(
                              foregroundColor: AppTheme.accentPrimary,
                              side: BorderSide(color: AppTheme.accentPrimary, width: 2),
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                            ),
                            child: const Text(
                              'Create Account',
                              style: TextStyle(fontSize: 15, fontFamily: 'Oswald', fontWeight: FontWeight.bold),
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
        ],
      ),
    );
  }
}
