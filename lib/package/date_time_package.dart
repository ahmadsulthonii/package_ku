import 'package:flutter/material.dart';
import 'package:intl/intl.dart'; // 👉 untuk format tanggal & waktu

class DateTimePackage extends StatefulWidget {
  const DateTimePackage({super.key});

  @override
  State<DateTimePackage> createState() => _DateTimePackageState();
}

class _DateTimePackageState extends State<DateTimePackage> {
  DateTimeRange? _selectedRange;
  TimeOfDay? _selectedTime;

  // Fungsi pilih rentang tanggal
  Future<void> _selectDateRange(BuildContext context) async {
    final DateTimeRange? picked = await showDateRangePicker(
      context: context,
      initialDateRange:
          _selectedRange ??
          DateTimeRange(
            start: DateTime.now(),
            end: DateTime.now().add(const Duration(days: 1)),
          ),
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
      helpText: 'Pilih Rentang Tanggal',
      confirmText: 'Selesai',
      cancelText: 'Batal',
      // locale: const Locale('id', 'ID'), // aktifkan jika ingin bahasa Indonesia
    );

    if (picked != null && picked != _selectedRange) {
      setState(() {
        _selectedRange = picked;
      });
    }
  }

  // Fungsi pilih waktu
  Future<void> _selectTime(BuildContext context) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: _selectedTime ?? TimeOfDay.now(),
    );

    if (picked != null) {
      setState(() {
        _selectedTime = picked;
      });
    }
  }

  // Format tampilan tanggal & waktu
  String formatDate(DateTime dateTime) {
    return DateFormat('y MMMM dd', 'id_ID').format(dateTime);
  }

  String formatDateTime(DateTime dateTime) {
    final formattedDate = DateFormat('y MMMM dd', 'id_ID').format(dateTime);
    final formattedTime = DateFormat('HH:mm').format(dateTime);
    return '$formattedDate, $formattedTime WIB';
  }

  @override
  Widget build(BuildContext context) {
    // Gabungkan tanggal dan waktu (kalau dipilih)
    String? combinedDateTime;
    if (_selectedRange != null && _selectedTime != null) {
      final start = DateTime(
        _selectedRange!.start.year,
        _selectedRange!.start.month,
        _selectedRange!.start.day,
        _selectedTime!.hour,
        _selectedTime!.minute,
      );
      final end = DateTime(
        _selectedRange!.end.year,
        _selectedRange!.end.month,
        _selectedRange!.end.day,
        _selectedTime!.hour,
        _selectedTime!.minute,
      );

      combinedDateTime =
          '🗓️ Dari: ${formatDateTime(start)}\nSampai: ${formatDateTime(end)}';
    }

    return Scaffold(
      appBar: AppBar(title: const Text('Date Range & Time Picker')),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              /// Tombol pilih rentang tanggal
              ElevatedButton.icon(
                onPressed: () => _selectDateRange(context),
                icon: const Icon(Icons.date_range),
                label: const Text('Pilih Rentang Tanggal'),
              ),
              const SizedBox(height: 10),

              Text(
                _selectedRange == null
                    ? 'Belum memilih rentang tanggal'
                    : 'Dari: ${formatDate(_selectedRange!.start)}\n'
                          'Sampai: ${formatDate(_selectedRange!.end)}',
                style: const TextStyle(fontSize: 16),
                textAlign: TextAlign.center,
              ),

              const SizedBox(height: 30),

              /// Tombol pilih waktu
              ElevatedButton.icon(
                onPressed: () => _selectTime(context),
                icon: const Icon(Icons.access_time),
                label: const Text('Pilih Waktu'),
              ),
              const SizedBox(height: 10),

              Text(
                _selectedTime == null
                    ? 'Belum memilih waktu'
                    : 'Waktu: ${_selectedTime!.format(context)}',
                style: const TextStyle(fontSize: 16),
              ),

              const SizedBox(height: 30),

              /// Hasil gabungan rentang tanggal + waktu
              if (combinedDateTime != null)
                Text(
                  combinedDateTime,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.blueAccent,
                  ),
                  textAlign: TextAlign.center,
                ),
            ],
          ),
        ),
      ),
    );
  }
}
