import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class TimeConverterScreen extends StatefulWidget {
  const TimeConverterScreen({super.key});

  @override
  State<TimeConverterScreen> createState() => _TimeConverterScreenState();
}

class _TimeConverterScreenState extends State<TimeConverterScreen> {
  DateTime selectedDate = DateTime.now();
  TimeOfDay selectedTime = TimeOfDay.now();
  String fromTimeZone = 'UTC';
  String toTimeZone = 'WIB';
  String formattedResult = '';

  final Map<String, int> timeZoneOffsets = {
    'UTC': 0,
    'WIB': 7,  // Western Indonesia Time (UTC+7)
    'WITA': 8, // Central Indonesia Time (UTC+8)
    'WIT': 9,  // Eastern Indonesia Time (UTC+9)
    'Tokyo': 9,
    'London': 0,
    'New York': -4,
    'Sydney': 10,
  };

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: selectedDate,
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );
    if (picked != null && picked != selectedDate) {
      setState(() {
        selectedDate = picked;
      });
    }
  }

  Future<void> _selectTime(BuildContext context) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: selectedTime,
    );
    if (picked != null && picked != selectedTime) {
      setState(() {
        selectedTime = picked;
      });
    }
  }

  void _convertTime() {
    // Create DateTime object from selected date and time
    DateTime fromDateTime = DateTime(
      selectedDate.year,
      selectedDate.month,
      selectedDate.day,
      selectedTime.hour,
      selectedTime.minute,
    );

    // Get timezone offsets
    int fromOffset = timeZoneOffsets[fromTimeZone] ?? 0;
    int toOffset = timeZoneOffsets[toTimeZone] ?? 0;

    // Calculate the difference in hours
    int hourDifference = toOffset - fromOffset;

    // Apply the timezone conversion
    DateTime convertedDateTime = fromDateTime.add(Duration(hours: hourDifference));

    // Format the result
    String formattedDate = DateFormat('yyyy-MM-dd').format(convertedDateTime);
    String formattedTime = DateFormat('HH:mm').format(convertedDateTime);

    setState(() {
      formattedResult = '$formattedDate $formattedTime ($toTimeZone)';
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Time Converter')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Date Picker
            Row(
              children: [
                const Text('Date: '),
                TextButton(
                  onPressed: () => _selectDate(context),
                  child: Text(DateFormat('yyyy-MM-dd').format(selectedDate)),
                ),
              ],
            ),

            // Time Picker
            Row(
              children: [
                const Text('Time: '),
                TextButton(
                  onPressed: () => _selectTime(context),
                  child: Text(selectedTime.format(context)),
                ),
              ],
            ),

            // From Timezone Dropdown
            DropdownButton<String>(
              value: fromTimeZone,
              items: timeZoneOffsets.keys.map((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              }).toList(),
              onChanged: (String? newValue) {
                setState(() {
                  fromTimeZone = newValue!;
                });
              },
            ),

            const SizedBox(height: 20),
            const Center(child: Text('to')),
            const SizedBox(height: 20),

            // To Timezone Dropdown
            DropdownButton<String>(
              value: toTimeZone,
              items: timeZoneOffsets.keys.map((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              }).toList(),
              onChanged: (String? newValue) {
                setState(() {
                  toTimeZone = newValue!;
                });
              },
            ),

            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _convertTime,
              child: const Text('Convert Time'),
            ),

            const SizedBox(height: 20),
            if (formattedResult.isNotEmpty)
              Text(
                'Converted Time: $formattedResult',
                style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                textAlign: TextAlign.center,
              ),
          ],
        ),
      ),
    );
  }
}