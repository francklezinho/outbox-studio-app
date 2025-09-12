import 'package:flutter/foundation.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class AppAuthProvider extends ChangeNotifier {
  final SupabaseClient _supabase = Supabase.instance.client;

  User? _user;
  bool _isLoading = true;
  String? _error;

  User? get user => _user;
  bool get isLoading => _isLoading;
  bool get isAuthenticated => _user != null;
  String? get error => _error;

  AppAuthProvider() {
    _init();
  }

  void _init() {
    _supabase.auth.onAuthStateChange.listen((data) {
      _user = data.session?.user;
      _isLoading = false;
      notifyListeners();
    });

    _user = _supabase.auth.currentUser;
    _isLoading = false;
  }

  Future<bool> signIn(String email, String password) async {
    try {
      _isLoading = true;
      _error = null;
      notifyListeners();

      await _supabase.auth.signInWithPassword(
        email: email,
        password: password,
      );

      return true;
    } catch (e) {
      _error = e.toString();
      return false;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<bool> signUp(String email, String password) async {
    try {
      _isLoading = true;
      _error = null;
      notifyListeners();

      await _supabase.auth.signUp(
        email: email,
        password: password,
      );

      return true;
    } catch (e) {
      _error = e.toString();
      return false;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> signOut() async {
    try {
      _isLoading = true;
      notifyListeners();
      await _supabase.auth.signOut();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // ✅ VERSÃO FINAL - SEM REDIRECTTO (USA PÁGINA OFICIAL DO SUPABASE)
  Future<bool> sendPasswordResetEmail(String email) async {
    try {
      _error = null;
      print('🔄 Enviando reset email (sem redirectTo): $email');
      // ✅ SÓ EMAIL - SUPABASE DECIDE A PÁGINA
      await _supabase.auth.resetPasswordForEmail(email);
      print('✅ Email enviado - vai usar página oficial do Supabase');
      return true;
    } catch (e) {
      print('❌ Erro: $e');
      _error = e.toString();
      return false;
    }
  }

  // ✅ MÉTODO PARA SINCRONIZAR FOTO ENTRE DRAWER E PROFILE
  String? getProfileImageUrl() {
    if (_user == null) return null;

    final metadata = _user!.userMetadata;
    if (metadata == null) return null;

    // ✅ Busca avatar_url primeiro
    final avatarUrl = metadata['avatar_url'];
    if (avatarUrl != null && avatarUrl.toString().trim().isNotEmpty) {
      return avatarUrl.toString();
    }

    // ✅ Busca picture depois
    final picture = metadata['picture'];
    if (picture != null && picture.toString().trim().isNotEmpty) {
      return picture.toString();
    }

    return null;
  }

  // ✅ MÉTODO PARA OBTER NOME DO USUÁRIO
  String getUserName() {
    if (_user == null) return 'User';

    final metadata = _user!.userMetadata;
    if (metadata != null) {
      final name = metadata['name'];
      if (name != null && name.toString().trim().isNotEmpty) {
        return name.toString();
      }

      final fullName = metadata['full_name'];
      if (fullName != null && fullName.toString().trim().isNotEmpty) {
        return fullName.toString();
      }
    }

    final email = _user!.email;
    if (email != null && email.contains('@')) {
      return email.split('@').first;
    }

    return 'User';
  }

  // ✅ MÉTODO PARA OBTER EMAIL DO USUÁRIO
  String getUserEmail() {
    return _user?.email ?? 'user@example.com';
  }

  void clearError() {
    _error = null;
    notifyListeners();
  }
}
