// lib/views/widgets/date_sorting.dart
import 'package:flutter/material.dart';
import 'package:productivity_app/styles/textstyle.dart';

class DateSorting extends StatefulWidget {
  final Function(String) onMonthSelected;

  const DateSorting({
    super.key,
    required this.onMonthSelected,
  });

  @override
  _DateSortingState createState() => _DateSortingState();
}

class _DateSortingState extends State<DateSorting> {
  String _selectedMonth = 'All';

  void _updateSelectedMonth(String? month) {
    setState(() {
      _selectedMonth = month!;
    });
    widget.onMonthSelected(month!);
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        TitleText(
            words: 'Choose a month: ', size: 20, fontWeight: FontWeight.w400),
        SizedBox(width: 8,),
        DropdownButton<String>(
          value: _selectedMonth,
          items: <String>[
            'All',
            'January',
            'February',
            'March',
            'April',
            'May',
            'June',
            'July',
            'August',
            'September',
            'October',
            'November',
            'December'
          ].map((String value) {
            return DropdownMenuItem<String>(
              value: value,
              child: Text(value),
            );
          }).toList(),
          onChanged: _updateSelectedMonth,
        ),
      ],
    );
  }
}
