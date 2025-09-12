// lib/features/booking/widgets/booking_card_widget.dart

import 'package:flutter/material.dart';

class BookingCardWidget extends StatelessWidget {
  final dynamic booking;
  final VoidCallback? onTap;
  final VoidCallback? onCancel;

  const BookingCardWidget({
    super.key,
    required this.booking,
    this.onTap,
    this.onCancel,
  });

  @override
  Widget build(BuildContext context) {
    Color statusColor;
    IconData statusIcon;

    String status = booking?.status ?? 'pending';

    switch (status) {
      case 'pending':
        statusColor = Colors.orange;
        statusIcon = Icons.schedule;
        break;
      case 'confirmed':
        statusColor = Colors.green;
        statusIcon = Icons.check_circle;
        break;
      case 'completed':
        statusColor = Colors.blue;
        statusIcon = Icons.done;
        break;
      case 'cancelled':
        statusColor = Colors.red;
        statusIcon = Icons.cancel;
        break;
      default:
        statusColor = Colors.grey;
        statusIcon = Icons.info;
    }

    return Card(
      color: const Color(0xFF1A1A1A),
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: ListTile(
        contentPadding: const EdgeInsets.all(16),
        onTap: onTap,
        title: Text(
          booking?.packageName ?? 'Package Name',
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 18,
            fontFamily: 'Oswald',
          ),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 4),
            Text(
              booking?.message ?? 'No message',
              style: TextStyle(
                color: Colors.white.withAlpha(150),
                fontSize: 14,
                fontFamily: 'Lato',
              ),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(height: 4),
            Text(
              'Date: ${booking?.bookingDate?.toString().split(' ')[0] ?? 'No date'}',
              style: TextStyle(
                color: Colors.white.withAlpha(180),
                fontSize: 12,
                fontFamily: 'Lato',
              ),
            ),
            const SizedBox(height: 4),
            Text(
              booking?.packagePrice ?? r'$0',
              style: const TextStyle(
                color: Color(0xFFFBAF2A),
                fontSize: 14,
                fontWeight: FontWeight.bold,
                fontFamily: 'Oswald',
              ),
            ),
          ],
        ),
        trailing: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: statusColor.withAlpha(50),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: statusColor.withAlpha(128)),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(statusIcon, color: statusColor, size: 16),
                  const SizedBox(width: 4),
                  Text(
                    status.toUpperCase(),
                    style: TextStyle(
                      color: statusColor,
                      fontWeight: FontWeight.bold,
                      fontSize: 10,
                      fontFamily: 'Oswald',
                    ),
                  ),
                ],
              ),
            ),
            if (onCancel != null && status == 'pending')
              IconButton(
                onPressed: onCancel,
                icon: const Icon(Icons.cancel_outlined, color: Colors.red),
                tooltip: 'Cancel Booking',
                iconSize: 20,
              ),
          ],
        ),
      ),
    );
  }
}
