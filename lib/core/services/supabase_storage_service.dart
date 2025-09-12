// lib/core/services/supabase_storage_service.dart

import 'dart:io';

import 'package:supabase_flutter/supabase_flutter.dart';

class SupabaseStorageService {
  final SupabaseClient _client = Supabase.instance.client;
  final String _bucketName = 'avatars';

  Future<String> uploadProfilePhoto(String uid, File imageFile) async {
    try {
      // ✅ CORREÇÃO: Adiciona timestamp para evitar cache do CDN
      final String timestamp = DateTime.now().millisecondsSinceEpoch.toString();
      final String fileName = '$uid/profile_$timestamp.jpg';

      // Upload file to Supabase Storage
      await _client.storage
          .from(_bucketName)
          .upload(fileName, imageFile, fileOptions: const FileOptions(
        cacheControl: '0', // ✅ CORREÇÃO: Desabilita cache
        upsert: true,
      ));

      // Get public URL
      final String publicUrl = _client.storage
          .from(_bucketName)
          .getPublicUrl(fileName);

      return publicUrl;
    } catch (e) {
      throw Exception('Failed to upload photo: $e');
    }
  }

  Future<void> deleteProfilePhoto(String uid) async {
    try {
      // ✅ CORREÇÃO: Lista e deleta todos os arquivos do usuário
      final List<FileObject> files = await _client.storage
          .from(_bucketName)
          .list(path: uid);

      if (files.isNotEmpty) {
        final List<String> filePaths = files
            .map((file) => '$uid/${file.name}')
            .toList();

        await _client.storage
            .from(_bucketName)
            .remove(filePaths);
      }
    } catch (e) {
      print('Failed to delete photo: $e');
    }
  }

  // ✅ NOVO: Método para obter URL da foto mais recente
  Future<String?> getLatestProfilePhotoUrl(String uid) async {
    try {
      final List<FileObject> files = await _client.storage
          .from(_bucketName)
          .list(path: uid);

      if (files.isEmpty) return null;

      // Pega o arquivo mais recente
      files.sort((a, b) => b.createdAt!.compareTo(a.createdAt!));
      final latestFile = files.first;

      return _client.storage
          .from(_bucketName)
          .getPublicUrl('$uid/${latestFile.name}');
    } catch (e) {
      return null;
    }
  }

  // ✅ NOVO: Verificar se arquivo existe
  Future<bool> profilePhotoExists(String uid) async {
    try {
      final List<FileObject> files = await _client.storage
          .from(_bucketName)
          .list(path: uid);

      return files.isNotEmpty;
    } catch (e) {
      return false;
    }
  }
}
