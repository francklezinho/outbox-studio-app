// lib/core/services/booking_service.dart

import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/booking_model.dart';

class BookingService {
  final SupabaseClient _client = Supabase.instance.client;

  // Create new booking
  Future<BookingModel> createBooking({
    required String name,
    required String email,
    required String phone,
    required String message,
    required String packageName,
    required String packagePrice,
    required DateTime bookingDate,
  }) async {
    final user = _client.auth.currentUser;
    if (user == null) throw Exception('User not authenticated');

    final bookingData = {
      'user_id': user.id,
      'name': name,
      'email': email,
      'phone': phone,
      'message': message,
      'package_name': packageName,
      'package_price': packagePrice,
      'booking_date': bookingDate.toIso8601String(),
      'created_at': DateTime.now().toIso8601String(),
      'status': 'pending',
    };

    final response = await _client
        .from('bookings')
        .insert(bookingData)
        .select()
        .single();

    return BookingModel.fromJson(response);
  }

  // Get user bookings
  Future<List<BookingModel>> getUserBookings() async {
    final user = _client.auth.currentUser;
    if (user == null) throw Exception('User not authenticated');

    final response = await _client
        .from('bookings')
        .select()
        .eq('user_id', user.id)
        .order('created_at', ascending: false);

    return (response as List)
        .map((booking) => BookingModel.fromJson(booking))
        .toList();
  }

  // Update booking status
  Future<bool> updateBookingStatus(String bookingId, String status) async {
    try {
      await _client
          .from('bookings')
          .update({
        'status': status,
        'updated_at': DateTime.now().toIso8601String(),
      })
          .eq('id', bookingId);

      return true;
    } catch (e) {
      throw Exception('Failed to update booking status: $e');
    }
  }

  // Delete booking
  Future<bool> deleteBooking(String bookingId) async {
    try {
      await _client
          .from('bookings')
          .delete()
          .eq('id', bookingId);

      return true;
    } catch (e) {
      throw Exception('Failed to delete booking: $e');
    }
  }

  // Get bookings by status
  Future<List<BookingModel>> getBookingsByStatus(String status) async {
    final user = _client.auth.currentUser;
    if (user == null) throw Exception('User not authenticated');

    final response = await _client
        .from('bookings')
        .select()
        .eq('user_id', user.id)
        .eq('status', status)
        .order('booking_date', ascending: true);

    return (response as List)
        .map((booking) => BookingModel.fromJson(booking))
        .toList();
  }

  // Get booking statistics
  Future<Map<String, dynamic>> getBookingStats() async {
    final user = _client.auth.currentUser;
    if (user == null) throw Exception('User not authenticated');

    final bookings = await getUserBookings();

    final stats = {
      'total': bookings.length,
      'pending': bookings.where((b) => b.status == 'pending').length,
      'confirmed': bookings.where((b) => b.status == 'confirmed').length,
      'completed': bookings.where((b) => b.status == 'completed').length,
      'cancelled': bookings.where((b) => b.status == 'cancelled').length,
      'totalSpent': bookings
          .where((b) => b.status == 'completed')
          .fold(0.0, (sum, b) => sum + (double.tryParse(b.packagePrice.replaceAll(r'$', '')) ?? 0.0)),
    };

    return stats;
  }
}
