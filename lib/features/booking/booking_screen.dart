// lib/features/booking/booking_screen.dart

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:flutter_time_picker_spinner/flutter_time_picker_spinner.dart';

import '../../core/providers/auth_provider.dart';
import '../../core/theme/app_theme.dart';
import '../../widgets/glass_dark_box.dart';
import 'payment_screen.dart'; // ✅ Importar tela de pagamento

class BookingScreen extends StatefulWidget {
  final String packageName;
  final String packageBadge;
  final String packagePrice;

  const BookingScreen({
    super.key,
    required this.packageName,
    required this.packageBadge,
    required this.packagePrice,
  });

  @override
  State<BookingScreen> createState() => _BookingScreenState();
}

class _BookingScreenState extends State<BookingScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();
  final _messageController = TextEditingController();

  DateTime? _selectedDate;
  TimeOfDay? _selectedTime;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _messageController.dispose();
    super.dispose();
  }

  void _loadUserData() {
    final auth = Provider.of<AppAuthProvider>(context, listen: false);
    if (auth.user != null) {
      _nameController.text = auth.user!.userMetadata?['name'] ?? '';
      _emailController.text = auth.user!.email ?? '';
    }
  }

  // ✅ DATE PICKER COM TEMA ESCURO MODERNO
  Future<DateTime?> _showDarkDatePicker(BuildContext context, DateTime initialDate, DateTime firstDate, DateTime lastDate) async {
    return await showDatePicker(
      context: context,
      initialDate: initialDate,
      firstDate: firstDate,
      lastDate: lastDate,
      builder: (BuildContext context, Widget? child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: ColorScheme.dark(
              primary: AppTheme.accentPrimary, // Cor laranja para seleção
              onPrimary: Colors.black,
              surface: const Color(0xFF1F1F1F), // Fundo escuro
              onSurface: Colors.white,
              background: const Color(0xFF141414),
              onBackground: Colors.white,
            ),
            dialogBackgroundColor: const Color(0xFF1F1F1F),
            textButtonTheme: TextButtonThemeData(
              style: TextButton.styleFrom(
                foregroundColor: AppTheme.accentPrimary,
                textStyle: const TextStyle(
                  fontFamily: 'Oswald',
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          child: child!,
        );
      },
    );
  }

  Future<void> _selectDate() async {
    final date = await _showDarkDatePicker(
      context,
      _selectedDate ?? DateTime.now().add(const Duration(days: 1)),
      DateTime.now(),
      DateTime.now().add(const Duration(days: 365)),
    );
    if (date != null) {
      setState(() => _selectedDate = date);
    }
  }

  Future<void> _selectTime() async {
    // ✅ NOVO TIME PICKER MODERNO COM SPINNERS VERTICAIS
    final initialTime = _selectedTime ?? TimeOfDay.now();
    DateTime tempDateTime = DateTime(
      2024, 1, 1,
      initialTime.hour,
      initialTime.minute,
    );

    await showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: const Color(0xFF1F1F1F),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          title: Text(
            'Select Time',
            style: const TextStyle(
              color: Colors.white,
              fontFamily: 'Oswald',
              fontWeight: FontWeight.bold,
              fontSize: 20,
            ),
            textAlign: TextAlign.center,
          ),
          content: Container(
            height: 220,
            width: 300,
            child: TimePickerSpinner(
              time: tempDateTime,
              is24HourMode: false,
              normalTextStyle: TextStyle(
                fontSize: 18,
                color: Colors.white.withOpacity(0.6),
                fontFamily: 'Lato',
              ),
              highlightedTextStyle: TextStyle(
                fontSize: 22,
                color: AppTheme.accentPrimary,
                fontWeight: FontWeight.bold,
                fontFamily: 'Oswald',
              ),
              spacing: 50,
              itemHeight: 60,
              alignment: Alignment.center,
              onTimeChange: (time) {
                tempDateTime = time;
              },
            ),
          ),
          actions: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                TextButton(
                  onPressed: () => Navigator.of(context).pop(),
                  child: Text(
                    'Cancel',
                    style: TextStyle(
                      color: Colors.white.withOpacity(0.7),
                      fontFamily: 'Lato',
                      fontSize: 16,
                    ),
                  ),
                ),
                ElevatedButton(
                  onPressed: () {
                    setState(() {
                      _selectedTime = TimeOfDay(
                        hour: tempDateTime.hour,
                        minute: tempDateTime.minute,
                      );
                    });
                    Navigator.of(context).pop();
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppTheme.accentPrimary,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                    padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                  ),
                  child: Text(
                    'OK',
                    style: const TextStyle(
                      fontFamily: 'Oswald',
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                ),
              ],
            ),
          ],
        );
      },
    );
  }

  // ✅ MODIFICADO: Não salva mais direto, vai para tela de pagamento
  Future<void> _submitBooking() async {
    if (!_formKey.currentState!.validate()) return;
    if (_selectedDate == null || _selectedTime == null) {
      _showMessage('Please select date and time', Colors.red);
      return;
    }

    setState(() => _isLoading = true);

    try {
      // Criar booking date
      final bookingDateTime = DateTime(
        _selectedDate!.year,
        _selectedDate!.month,
        _selectedDate!.day,
        _selectedTime!.hour,
        _selectedTime!.minute,
      );

      // ✅ PREPARAR DADOS PARA PAGAMENTO (não salvar ainda)
      final bookingData = {
        'packageName': widget.packageName,
        'packagePrice': widget.packagePrice,
        'customerName': _nameController.text.trim(),
        'customerEmail': _emailController.text.trim(),
        'customerPhone': _phoneController.text.trim(),
        'message': _messageController.text.trim(),
        'bookingDate': bookingDateTime.toIso8601String(),
        'tempBookingId': DateTime.now().millisecondsSinceEpoch.toString(),
      };

      // ✅ NAVEGAR PARA TELA DE PAGAMENTO
      if (mounted) {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => PaymentScreen(bookingData: bookingData),
          ),
        );
      }
    } catch (e) {
      _showMessage('Error preparing booking: $e', Colors.red);
    } finally {
      setState(() => _isLoading = false);
    }
  }

  void _clearForm() {
    _nameController.clear();
    _emailController.clear();
    _phoneController.clear();
    _messageController.clear();
    setState(() {
      _selectedDate = null;
      _selectedTime = null;
    });
  }

  void _showMessage(String message, Color color) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: color,
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    const kThinBorder = Color(0x21FFFFFF);
    return Scaffold(
      backgroundColor: AppTheme.backgroundPrimary,
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color(0xFF141414),
              Color(0xFF242424),
              Color(0xFF191919),
              Color(0xFF1F1F1F),
            ],
            stops: [0.0, 0.4, 0.7, 1.0],
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              // Header
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 12),
                child: Row(
                  children: [
                    IconButton(
                      icon: const Icon(Icons.arrow_back, color: Colors.white, size: 24),
                      onPressed: () => Navigator.of(context).pop(),
                    ),
                    Expanded(
                      child: Text(
                        'Book ${widget.packageName}',
                        textAlign: TextAlign.center,
                        style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                          color: Colors.white,
                          fontFamily: 'Oswald',
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    const SizedBox(width: 48),
                  ],
                ),
              ),
              // Content - Scrollable
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(16),
                  child: Center(
                    child: ConstrainedBox(
                      constraints: const BoxConstraints(maxWidth: 400),
                      child: GlassDarkBox(
                        child: Form(
                          key: _formKey,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // Package Info
                              Container(
                                width: double.infinity,
                                padding: const EdgeInsets.all(16),
                                decoration: BoxDecoration(
                                  color: AppTheme.accentPrimary.withOpacity(0.1),
                                  borderRadius: BorderRadius.circular(12),
                                  border: Border.all(
                                    color: AppTheme.accentPrimary.withOpacity(0.3),
                                    width: 1,
                                  ),
                                ),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      widget.packageName,
                                      style: const TextStyle(
                                        color: Colors.white,
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold,
                                        fontFamily: 'Oswald',
                                      ),
                                    ),
                                    const SizedBox(height: 4),
                                    Text(
                                      widget.packagePrice,
                                      style: TextStyle(
                                        color: AppTheme.accentPrimary,
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(height: 24),
                              // Form Fields
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
                                      borderSide: BorderSide(color: AppTheme.accentPrimary, width: 1.0),
                                    ),
                                    errorBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(12),
                                      borderSide: const BorderSide(color: Colors.red, width: 1.0),
                                    ),
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(12),
                                      borderSide: const BorderSide(color: kThinBorder, width: 1.0),
                                    ),
                                    labelStyle: TextStyle(color: Colors.white.withOpacity(0.80), fontSize: 14),
                                    floatingLabelStyle: TextStyle(color: Colors.white.withOpacity(0.90), fontSize: 12),
                                    prefixIconColor: Colors.white.withOpacity(0.90),
                                    floatingLabelBehavior: FloatingLabelBehavior.auto,
                                    contentPadding: const EdgeInsets.fromLTRB(12, 20, 12, 16),
                                  ),
                                ),
                                child: Column(
                                  children: [
                                    // Name
                                    TextFormField(
                                      controller: _nameController,
                                      style: const TextStyle(color: Colors.white),
                                      decoration: const InputDecoration(
                                        labelText: 'Full Name',
                                        prefixIcon: Icon(Icons.person_outline),
                                      ),
                                      validator: (value) {
                                        if (value == null || value.trim().isEmpty) {
                                          return 'Name is required';
                                        }
                                        return null;
                                      },
                                    ),
                                    const SizedBox(height: 16),
                                    // Email
                                    TextFormField(
                                      controller: _emailController,
                                      keyboardType: TextInputType.emailAddress,
                                      style: const TextStyle(color: Colors.white),
                                      decoration: const InputDecoration(
                                        labelText: 'Email',
                                        prefixIcon: Icon(Icons.email_outlined),
                                      ),
                                      validator: (value) {
                                        if (value == null || value.trim().isEmpty) {
                                          return 'Email is required';
                                        }
                                        if (!value.contains('@')) {
                                          return 'Enter a valid email';
                                        }
                                        return null;
                                      },
                                    ),
                                    const SizedBox(height: 16),
                                    // Phone
                                    TextFormField(
                                      controller: _phoneController,
                                      keyboardType: TextInputType.phone,
                                      style: const TextStyle(color: Colors.white),
                                      decoration: const InputDecoration(
                                        labelText: 'Phone Number',
                                        prefixIcon: Icon(Icons.phone_outlined),
                                      ),
                                      validator: (value) {
                                        if (value == null || value.trim().isEmpty) {
                                          return 'Phone number is required';
                                        }
                                        return null;
                                      },
                                    ),
                                    const SizedBox(height: 16),
                                    // Date & Time Selection
                                    Column(
                                      children: [
                                        Row(
                                          children: [
                                            Expanded(
                                              child: GestureDetector(
                                                onTap: _selectDate,
                                                child: Container(
                                                  padding: const EdgeInsets.all(16),
                                                  decoration: BoxDecoration(
                                                    border: Border.all(color: kThinBorder),
                                                    borderRadius: BorderRadius.circular(12),
                                                  ),
                                                  child: Row(
                                                    children: [
                                                      Icon(Icons.calendar_today, color: Colors.white.withOpacity(0.7)),
                                                      const SizedBox(width: 12),
                                                      Expanded(
                                                        child: Text(
                                                          _selectedDate == null
                                                              ? 'Select Date'
                                                              : '${_selectedDate!.day}/${_selectedDate!.month}/${_selectedDate!.year}',
                                                          style: TextStyle(
                                                            color: _selectedDate == null
                                                                ? Colors.white.withOpacity(0.6)
                                                                : Colors.white,
                                                          ),
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ),
                                            ),
                                            const SizedBox(width: 12),
                                            Expanded(
                                              child: GestureDetector(
                                                onTap: _selectTime,
                                                child: Container(
                                                  padding: const EdgeInsets.all(16),
                                                  decoration: BoxDecoration(
                                                    border: Border.all(color: kThinBorder),
                                                    borderRadius: BorderRadius.circular(12),
                                                  ),
                                                  child: Row(
                                                    children: [
                                                      Icon(Icons.access_time, color: Colors.white.withOpacity(0.7)),
                                                      const SizedBox(width: 12),
                                                      Expanded(
                                                        child: Text(
                                                          _selectedTime == null
                                                              ? 'Select Time'
                                                              : _selectedTime!.format(context),
                                                          style: TextStyle(
                                                            color: _selectedTime == null
                                                                ? Colors.white.withOpacity(0.6)
                                                                : Colors.white,
                                                          ),
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                    const SizedBox(height: 16),
                                    // Message
                                    TextFormField(
                                      controller: _messageController,
                                      maxLines: 3,
                                      style: const TextStyle(color: Colors.white),
                                      decoration: const InputDecoration(
                                        labelText: 'Additional Message',
                                        prefixIcon: Icon(Icons.message_outlined),
                                        alignLabelWithHint: true,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(height: 24),
                              // ✅ BOTÃO ALTERADO: Continuar para pagamento
                              SizedBox(
                                width: double.infinity,
                                height: 50,
                                child: ElevatedButton(
                                  onPressed: _isLoading ? null : _submitBooking,
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: AppTheme.accentPrimary,
                                    foregroundColor: Colors.white,
                                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                                    disabledBackgroundColor: AppTheme.accentPrimary.withOpacity(0.5),
                                  ),
                                  child: _isLoading
                                      ? const CircularProgressIndicator(color: Colors.white, strokeWidth: 2)
                                      : Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: const [
                                      Icon(Icons.payment, size: 20),
                                      SizedBox(width: 8),
                                      Text(
                                        'Continue to Payment',
                                        style: TextStyle(
                                          fontFamily: 'Oswald',
                                          fontWeight: FontWeight.bold,
                                          fontSize: 16,
                                        ),
                                      ),
                                    ],
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
        ),
      ),
    );
  }
}
