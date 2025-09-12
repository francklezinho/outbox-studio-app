// lib/core/providers/profile_provider.dart

import 'package:flutter/foundation.dart';
import 'dart:io';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../services/supabase_storage_service.dart';

class ProfileProvider extends ChangeNotifier {
  final SupabaseClient _supabase = Supabase.instance.client;
  final SupabaseStorageService _storageService = SupabaseStorageService();

  bool _isLoading = false;
  bool _isUploading = false;
  String? _error;
  String? _avatarUrl;
  String? _fullName;
  String? _phone;

  bool get isLoading => _isLoading;
  bool get isUploading => _isUploading;
  String? get error => _error;
  String? get avatarUrl => _avatarUrl;
  String? get fullName => _fullName;
  String? get phone => _phone;

  Future<void> loadProfile() async {
    try {
      _isLoading = true;
      _error = null;
      notifyListeners();

      final user = _supabase.auth.currentUser;
      if (user == null) return;

      final response = await _supabase
          .from('profiles')
          .select('*')
          .eq('id', user.id)
          .maybeSingle();

      if (response != null) {
        _fullName = response['full_name'];
        _phone = response['phone'];
        _avatarUrl = response['avatar_url'];
      } else {
        _fullName = user.userMetadata?['full_name'] ??
            user.userMetadata?['name'] ??
            user.email?.split('@').first;
        _avatarUrl = user.userMetadata?['avatar_url'] ??
            user.userMetadata?['picture'];
      }
    } catch (e) {
      _error = e.toString();
      debugPrint('Error loading profile: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<bool> updateProfile({
    String? fullName,
    String? phone,
  }) async {
    try {
      _isLoading = true;
      _error = null;
      notifyListeners();

      final user = _supabase.auth.currentUser;
      if (user == null) {
        _error = 'User not authenticated';
        return false;
      }

      final updates = {
        'id': user.id,
        'full_name': fullName ?? _fullName,
        'phone': phone ?? _phone,
        'email': user.email,
        'updated_at': DateTime.now().toIso8601String(),
      };

      await _supabase.from('profiles').upsert(updates);

      _fullName = fullName ?? _fullName;
      _phone = phone ?? _phone;

      return true;
    } catch (e) {
      _error = e.toString();
      debugPrint('Error updating profile: $e');
      return false;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<bool> uploadAvatar(File imageFile) async {
    try {
      _isUploading = true;
      _error = null;
      notifyListeners();

      final user = _supabase.auth.currentUser;
      if (user == null) {
        _error = 'User not authenticated';
        return false;
      }

      final avatarUrl = await _storageService.uploadProfilePhoto(user.id, imageFile);

      await _supabase.from('profiles').upsert({
        'id': user.id,
        'avatar_url': avatarUrl,
        'updated_at': DateTime.now().toIso8601String(),
      });

      _avatarUrl = avatarUrl;
      return true;
    } catch (e) {
      _error = e.toString();
      debugPrint('Error uploading avatar: $e');
      return false;
    } finally {
      _isUploading = false;
      notifyListeners();
    }
  }

  void clearError() {
    _error = null;
    notifyListeners();
  }
}
