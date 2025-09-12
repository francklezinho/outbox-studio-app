// lib/core/providers/booking_provider.dart

import 'package:flutter/material.dart';
import '../models/booking_model.dart';
import '../services/booking_service.dart';

class BookingProvider extends ChangeNotifier {
  final BookingService _bookingService = BookingService();

  List<BookingModel> _bookings = [];
  List<BookingModel> _userBookings = [];
  bool _isLoading = false;
  String? _error;

  // Getters
  List<BookingModel> get bookings => _bookings;
  List<BookingModel> get userBookings => _userBookings;
  bool get isLoading => _isLoading;
  String? get error => _error;

  // Filtered bookings by status
  List<BookingModel> get pendingBookings =>
      _userBookings.where((b) => b.status == 'pending').toList();

  List<BookingModel> get confirmedBookings =>
      _userBookings.where((b) => b.status == 'confirmed').toList();

  List<BookingModel> get completedBookings =>
      _userBookings.where((b) => b.status == 'completed').toList();

  // Statistics
  int get totalBookings => _userBookings.length;
  double get totalSpent => _userBookings
      .where((b) => b.status == 'completed')
      .fold(0.0, (sum, b) => sum + double.tryParse(b.packagePrice.replaceAll(r'$', ''))!);

  // Create new booking
  Future<bool> createBooking({
    required String name,
    required String email,
    required String phone,
    required String message,
    required String packageName,
    required String packagePrice,
    required DateTime bookingDate,
  }) async {
    _setLoading(true);
    _clearError();

    try {
      final booking = await _bookingService.createBooking(
        name: name,
        email: email,
        phone: phone,
        message: message,
        packageName: packageName,
        packagePrice: packagePrice,
        bookingDate: bookingDate,
      );

      _userBookings.insert(0, booking);
      notifyListeners();
      return true;
    } catch (e) {
      _setError('Failed to create booking: $e');
      return false;
    } finally {
      _setLoading(false);
    }
  }

  // Load user bookings
  Future<void> loadUserBookings() async {
    _setLoading(true);
    _clearError();

    try {
      _userBookings = await _bookingService.getUserBookings();
      notifyListeners();
    } catch (e) {
      _setError('Failed to load bookings: $e');
    } finally {
      _setLoading(false);
    }
  }

  // Update booking status
  Future<bool> updateBookingStatus(String bookingId, String status) async {
    _clearError();

    try {
      final success = await _bookingService.updateBookingStatus(bookingId, status);
      if (success) {
        final index = _userBookings.indexWhere((b) => b.id == bookingId);
        if (index != -1) {
          _userBookings[index] = _userBookings[index].copyWith(status: status);
          notifyListeners();
        }
      }
      return success;
    } catch (e) {
      _setError('Failed to update booking: $e');
      return false;
    }
  }

  // Cancel booking
  Future<bool> cancelBooking(String bookingId) async {
    return updateBookingStatus(bookingId, 'cancelled');
  }

  // Delete booking
  Future<bool> deleteBooking(String bookingId) async {
    _clearError();

    try {
      final success = await _bookingService.deleteBooking(bookingId);
      if (success) {
        _userBookings.removeWhere((b) => b.id == bookingId);
        notifyListeners();
      }
      return success;
    } catch (e) {
      _setError('Failed to delete booking: $e');
      return false;
    }
  }

  // Get booking by ID
  BookingModel? getBookingById(String id) {
    try {
      return _userBookings.firstWhere((b) => b.id == id);
    } catch (e) {
      return null;
    }
  }

  // Refresh bookings
  Future<void> refresh() async {
    await loadUserBookings();
  }

  // Helper methods
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
    super.dispose();
  }
}
