// lib/core/providers/chat_provider.dart

import 'package:flutter/material.dart';
import '../models/chat_message_model.dart';
import '../models/chat_room_model.dart';
import '../services/chat_service.dart';

class ChatProvider extends ChangeNotifier {
  final ChatService _service = ChatService();

  List<ChatMessageModel> _messages = [];
  List<ChatRoomModel> _chatRooms = [];
  ChatRoomModel? _currentRoom;
  bool _isTyping = false;
  bool _isLoading = false;
  String? _error;

  List<ChatMessageModel> get messages => _messages;
  List<ChatRoomModel> get chatRooms => _chatRooms;
  ChatRoomModel? get currentRoom => _currentRoom;
  bool get isTyping => _isTyping;
  bool get isLoading => _isLoading;
  String? get error => _error;

  // Handle received message
  void _onMessageReceived(ChatMessageModel message) {
    if (_currentRoom != null && message.roomId == _currentRoom!.id) {
      _messages.insert(0, message);
    }

    final roomIndex = _chatRooms.indexWhere((r) => r.id == message.roomId);
    if (roomIndex != -1) {
      _chatRooms[roomIndex] = _chatRooms[roomIndex].copyWith(
        lastMessage: message.content,
        lastMessageAt: message.createdAt,
        unreadCount: _chatRooms[roomIndex].unreadCount + 1,
      );
    }

    notifyListeners();
  }

  Future<void> initialize() async {
    _setLoading(true);
    _clearError();

    try {
      await loadChatRooms();
      await _service.initializeRealTimeSubscription(_onMessageReceived);
    } catch (e) {
      _setError('Error initializing chat: ${e.toString()}');
    } finally {
      _setLoading(false);
    }
  }

  Future<void> loadChatRooms() async {
    try {
      _chatRooms = await _service.getChatRooms();
      notifyListeners();
    } catch (e) {
      _setError('Error loading chat rooms: ${e.toString()}');
    }
  }

  Future<ChatRoomModel?> createOrGetChatRoom() async {
    _clearError();

    try {
      final room = await _service.createOrGetChatRoom();
      final idx = _chatRooms.indexWhere((r) => r.id == room.id);
      if (idx == -1) {
        _chatRooms.insert(0, room);
      } else {
        _chatRooms[idx] = room;
      }
      _currentRoom = room;
      notifyListeners();
      return room;
    } catch (e) {
      _setError('Error creating chat room: ${e.toString()}');
      return null;
    }
  }

  Future<void> enterChatRoom(String roomId) async {
    _setLoading(true);
    _clearError();

    try {
      final room = await _service.getChatRoom(roomId);
      _currentRoom = room;
      await loadMessages(roomId);
      await _service.markMessagesAsRead(roomId);
    } catch (e) {
      _setError('Error entering chat room: ${e.toString()}');
    } finally {
      _setLoading(false);
    }
  }

  Future<void> loadMessages(String roomId) async {
    try {
      _messages = await _service.getMessages(roomId);
      notifyListeners();
    } catch (e) {
      _setError('Error loading messages: ${e.toString()}');
    }
  }

  Future<bool> sendMessage({
    required String content,
    MessageType type = MessageType.text,
    String? replyToId,
  }) async {
    if (_currentRoom == null) return false;

    _clearError();

    try {
      final message = await _service.sendMessage(
        roomId: _currentRoom!.id,
        content: content,
        type: type,
        replyToId: replyToId,
      );

      _messages.insert(0, message);
      final idx = _chatRooms.indexWhere((r) => r.id == _currentRoom!.id);
      if (idx != -1) {
        _chatRooms[idx] = _chatRooms[idx].copyWith(
          lastMessage: content,
          lastMessageAt: message.createdAt,
        );
      }
      notifyListeners();
      return true;
    } catch (e) {
      _setError('Error sending message: ${e.toString()}');
      return false;
    }
  }

  void setTyping(bool typing) {
    if (_isTyping != typing) {
      _isTyping = typing;
      notifyListeners();
      if (typing && _currentRoom != null) {
        _service.sendTypingIndicator(_currentRoom!.id);
      }
    }
  }

  int get totalUnreadCount =>
      _chatRooms.fold(0, (sum, room) => sum + room.unreadCount);

  Future<void> markMessagesAsRead() async {
    if (_currentRoom == null) return;

    try {
      await _service.markMessagesAsRead(_currentRoom!.id);
      final idx = _chatRooms.indexWhere((r) => r.id == _currentRoom!.id);
      if (idx != -1) {
        _chatRooms[idx] = _chatRooms[idx].copyWith(unreadCount: 0);
      }
      notifyListeners();
    } catch (e) {
      _setError('Error marking messages as read: ${e.toString()}');
    }
  }

  void clearCurrentRoom() {
    _currentRoom = null;
    _messages.clear();
    notifyListeners();
  }

  void _setLoading(bool loading) {
    _isLoading = loading;
    notifyListeners();
  }

  void _setError(String error) {
    _error = error;
    notifyListeners();
  }

  void _clearError() {
    _error = null;
  }

  @override
  void dispose() {
    _service.dispose();
    super.dispose();
  }
}
