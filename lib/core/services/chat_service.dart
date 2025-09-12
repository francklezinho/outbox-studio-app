// lib/core/services/chat_service.dart

import 'dart:async';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/chat_message_model.dart';
import '../models/chat_room_model.dart';

class ChatService {
  final SupabaseClient _client = Supabase.instance.client;
  StreamSubscription? _messageSubscription;

  // Initialize real-time subscription
  Future<void> initializeRealTimeSubscription(Function(ChatMessageModel) onMessageReceived) async {
    final user = _client.auth.currentUser;
    if (user == null) return;

    _messageSubscription = _client
        .from('chat_messages')
        .stream(primaryKey: ['id'])
        .order('created_at', ascending: false)
        .listen((List<Map<String, dynamic>> data) {
      if (data.isNotEmpty) {
        final message = ChatMessageModel.fromJson(data.first);
        onMessageReceived(message);
      }
    });
  }

  // Create or get existing chat room
  Future<ChatRoomModel> createOrGetChatRoom() async {
    final user = _client.auth.currentUser;
    if (user == null) throw Exception('User not authenticated');

    try {
      // Try to get existing room
      final existingRoom = await _client
          .from('chat_rooms')
          .select()
          .eq('user_id', user.id)
          .maybeSingle();

      if (existingRoom != null) {
        return ChatRoomModel.fromJson(existingRoom);
      }

      // Create new room
      final roomData = {
        'user_id': user.id,
        'title': 'Chat with Outbox Studio',
        'created_at': DateTime.now().toIso8601String(),
        'updated_at': DateTime.now().toIso8601String(),
        'is_active': true,
      };

      final response = await _client
          .from('chat_rooms')
          .insert(roomData)
          .select()
          .single();

      return ChatRoomModel.fromJson(response);
    } catch (e) {
      throw Exception('Failed to create/get chat room: $e');
    }
  }

  // Get chat rooms for user
  Future<List<ChatRoomModel>> getChatRooms() async {
    final user = _client.auth.currentUser;
    if (user == null) throw Exception('User not authenticated');

    try {
      final response = await _client
          .from('chat_rooms')
          .select()
          .eq('user_id', user.id)
          .order('updated_at', ascending: false);

      return (response as List)
          .map((room) => ChatRoomModel.fromJson(room))
          .toList();
    } catch (e) {
      throw Exception('Failed to get chat rooms: $e');
    }
  }

  // Get specific chat room
  Future<ChatRoomModel> getChatRoom(String roomId) async {
    try {
      final response = await _client
          .from('chat_rooms')
          .select()
          .eq('id', roomId)
          .single();

      return ChatRoomModel.fromJson(response);
    } catch (e) {
      throw Exception('Failed to get chat room: $e');
    }
  }

  // Send message
  Future<ChatMessageModel> sendMessage({
    required String roomId,
    required String content,
    MessageType type = MessageType.text,
    String? replyToId,
  }) async {
    final user = _client.auth.currentUser;
    if (user == null) throw Exception('User not authenticated');

    try {
      final messageData = {
        'room_id': roomId,
        'sender_id': user.id,
        'content': content,
        'type': type.name,
        'status': MessageStatus.sent.name,
        'created_at': DateTime.now().toIso8601String(),
        'reply_to_id': replyToId,
        'is_owner': false,
      };

      final response = await _client
          .from('chat_messages')
          .insert(messageData)
          .select()
          .single();

      // Update room's last message
      await _client
          .from('chat_rooms')
          .update({
        'last_message': content,
        'last_message_at': DateTime.now().toIso8601String(),
        'updated_at': DateTime.now().toIso8601String(),
      })
          .eq('id', roomId);

      return ChatMessageModel.fromJson(response);
    } catch (e) {
      throw Exception('Failed to send message: $e');
    }
  }

  // Get messages for a room
  Future<List<ChatMessageModel>> getMessages(String roomId, {int limit = 50, int offset = 0}) async {
    try {
      final response = await _client
          .from('chat_messages')
          .select()
          .eq('room_id', roomId)
          .order('created_at', ascending: false)
          .limit(limit)
          .range(offset, offset + limit - 1);

      return (response as List)
          .map((message) => ChatMessageModel.fromJson(message))
          .toList();
    } catch (e) {
      throw Exception('Failed to get messages: $e');
    }
  }

  // Mark messages as read
  Future<void> markMessagesAsRead(String roomId) async {
    final user = _client.auth.currentUser;
    if (user == null) return;

    try {
      await _client
          .from('chat_messages')
          .update({'status': MessageStatus.read.name})
          .eq('room_id', roomId)
          .neq('sender_id', user.id)
          .eq('status', MessageStatus.delivered.name);
    } catch (e) {
      // Ignore errors for now
    }
  }

  // Send typing indicator
  Future<void> sendTypingIndicator(String roomId) async {
    final user = _client.auth.currentUser;
    if (user == null) return;

    try {
      // Implementation depends on your real-time setup
    } catch (e) {
      // Ignore errors
    }
  }

  // Delete message
  Future<bool> deleteMessage(String messageId) async {
    try {
      await _client
          .from('chat_messages')
          .delete()
          .eq('id', messageId);

      return true;
    } catch (e) {
      return false;
    }
  }

  // Update message status
  Future<void> updateMessageStatus(String messageId, MessageStatus status) async {
    try {
      await _client
          .from('chat_messages')
          .update({
        'status': status.name,
        'updated_at': DateTime.now().toIso8601String(),
      })
          .eq('id', messageId);
    } catch (e) {
      // Ignore errors
    }
  }

  // Get unread message count - SIMPLIFIED
  Future<int> getUnreadMessageCount(String roomId) async {
    final user = _client.auth.currentUser;
    if (user == null) return 0;

    try {
      final response = await _client
          .from('chat_messages')
          .select('id')
          .eq('room_id', roomId)
          .neq('sender_id', user.id)
          .neq('status', MessageStatus.read.name);

      return (response as List).length;
    } catch (e) {
      return 0;
    }
  }

  // Dispose
  void dispose() {
    _messageSubscription?.cancel();
  }
}
