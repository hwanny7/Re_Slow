import 'package:flutter/material.dart';

class CalendarSelection extends StatefulWidget {
  final void Function(DateTime startDate, DateTime endDate) onDateRangeSelected;

  CalendarSelection({required this.onDateRangeSelected});

  @override
  _CalendarSelectionState createState() => _CalendarSelectionState();
}

class _CalendarSelectionState extends State<CalendarSelection> {
  DateTime _startDate = DateTime.now();
  DateTime _endDate = DateTime.now();

  Future<void> _selectDateRange(BuildContext context) async {
    final initialDateRange = DateTimeRange(start: _startDate, end: _endDate);

    final picked = await showDateRangePicker(
      context: context,
      firstDate: DateTime(2022),
      lastDate: DateTime(2024),
      initialDateRange: initialDateRange,
    );

    if (picked != null) {
      setState(() {
        _startDate = picked.start;
        _endDate = picked.end;
      });

      widget.onDateRangeSelected(_startDate, _endDate);
    }
  }

  void _filterToday() {
    final today = DateTime.now();
    widget.onDateRangeSelected(today, today);
  }

  void _filterOneWeek() {
    final today = DateTime.now();
    final oneWeekAgo = today.subtract(Duration(days: 7));
    widget.onDateRangeSelected(oneWeekAgo, today);
  }

  void _filterOneMonth() {
    final today = DateTime.now();
    final oneMonthAgo = DateTime(today.year, today.month - 1, today.day);
    widget.onDateRangeSelected(oneMonthAgo, today);
  }

  void _filterOneYear() {
    final today = DateTime.now();
    final oneYearAgo = DateTime(today.year - 1, today.month, today.day);
    widget.onDateRangeSelected(oneYearAgo, today);
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        GestureDetector(
          onTap: () => _selectDateRange(context),
          child: Text(
            'From ${_startDate.toString().substring(0, 10)} to ${_endDate.toString().substring(0, 10)}',
            style: TextStyle(fontSize: 16.0),
          ),
        ),
        ElevatedButton(
          onPressed: _filterToday,
          child: Text('Today'),
        ),
        ElevatedButton(
          onPressed: _filterOneWeek,
          child: Text('1 Week'),
        ),
        ElevatedButton(
          onPressed: _filterOneMonth,
          child: Text('1 Month'),
        ),
        ElevatedButton(
          onPressed: _filterOneYear,
          child: Text('1 Year'),
        ),
      ],
    );
  }
}
