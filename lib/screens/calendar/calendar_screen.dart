import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:provider/provider.dart';
import 'package:partyu/providers/app_provider.dart';
import 'package:partyu/utils/app_theme.dart';
import 'package:intl/intl.dart';

class CalendarScreen extends StatefulWidget {
  const CalendarScreen({super.key});

  @override
  State<CalendarScreen> createState() => _CalendarScreenState();
}

class _CalendarScreenState extends State<CalendarScreen> {
  DateTime _selectedDate = DateTime.now();
  DateTime _currentMonth = DateTime.now();

  @override
  Widget build(BuildContext context) {
    final appProvider = context.watch<AppProvider>();

    return Scaffold(
      backgroundColor: AppTheme.backgroundGray,
      appBar: AppBar(
        title: Text(appProvider.selectedVenueName),
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          onPressed: () {
            appProvider.navigateBack();
          },
          icon: const Icon(LucideIcons.arrowLeft),
        ),
      ),
      body: Column(
        children: [
          // Calendar Header
          Container(
            color: Colors.white,
            padding: const EdgeInsets.all(16),
            child: _buildCalendarHeader(),
          ),

          // Calendar
          Expanded(
            child: Container(
              color: Colors.white,
              child: _buildCalendar(),
            ),
          ),

          // Selected Date Info
          _buildSelectedDateInfo(),

          // Continue Button
          _buildContinueButton(appProvider),
        ],
      ),
    );
  }

  Widget _buildCalendarHeader() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        IconButton(
          onPressed: () {
            setState(() {
              _currentMonth = DateTime(_currentMonth.year, _currentMonth.month - 1);
            });
          },
          icon: const Icon(LucideIcons.chevronLeft),
        ),
        Text(
          DateFormat('MMMM yyyy', 'pt_BR').format(_currentMonth),
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w600,
            color: AppTheme.gray900,
          ),
        ),
        IconButton(
          onPressed: () {
            setState(() {
              _currentMonth = DateTime(_currentMonth.year, _currentMonth.month + 1);
            });
          },
          icon: const Icon(LucideIcons.chevronRight),
        ),
      ],
    );
  }

  Widget _buildCalendar() {
    final firstDayOfMonth = DateTime(_currentMonth.year, _currentMonth.month, 1);
    final lastDayOfMonth = DateTime(_currentMonth.year, _currentMonth.month + 1, 0);
    final firstDayWeekday = firstDayOfMonth.weekday % 7;
    final daysInMonth = lastDayOfMonth.day;

    return Column(
      children: [
        // Week days header
        Container(
          padding: const EdgeInsets.symmetric(vertical: 8),
          child: Row(
            children: ['Dom', 'Seg', 'Ter', 'Qua', 'Qui', 'Sex', 'Sáb'].map((day) {
              return Expanded(
                child: Center(
                  child: Text(
                    day,
                    style: const TextStyle(
                      fontWeight: FontWeight.w500,
                      color: AppTheme.gray600,
                      fontSize: 14,
                    ),
                  ),
                ),
              );
            }).toList(),
          ),
        ),

        // Calendar grid
        Expanded(
          child: GridView.builder(
            padding: const EdgeInsets.all(8),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 7,
              childAspectRatio: 1,
            ),
            itemCount: firstDayWeekday + daysInMonth,
            itemBuilder: (context, index) {
              if (index < firstDayWeekday) {
                return const SizedBox.shrink();
              }

              final day = index - firstDayWeekday + 1;
              final date = DateTime(_currentMonth.year, _currentMonth.month, day);
              final isToday = _isSameDay(date, DateTime.now());
              final isSelected = _isSameDay(date, _selectedDate);
              final isPast = date.isBefore(DateTime.now().subtract(const Duration(days: 1)));

              return GestureDetector(
                onTap: isPast ? null : () {
                  setState(() {
                    _selectedDate = date;
                  });
                },
                child: Container(
                  margin: const EdgeInsets.all(2),
                  decoration: BoxDecoration(
                    color: isSelected
                        ? AppTheme.primaryPurple
                        : isToday
                            ? AppTheme.primaryPurple.withOpacity(0.1)
                            : null,
                    borderRadius: BorderRadius.circular(8),
                    border: isToday && !isSelected
                        ? Border.all(color: AppTheme.primaryPurple)
                        : null,
                  ),
                  child: Center(
                    child: Text(
                      day.toString(),
                      style: TextStyle(
                        color: isPast
                            ? AppTheme.gray300
                            : isSelected
                                ? Colors.white
                                : isToday
                                    ? AppTheme.primaryPurple
                                    : AppTheme.gray900,
                        fontWeight: isSelected || isToday ? FontWeight.w600 : FontWeight.normal,
                      ),
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildSelectedDateInfo() {
    return Container(
      padding: const EdgeInsets.all(16),
      color: Colors.white,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Data Selecionada',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: AppTheme.gray900,
            ),
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              const Icon(
                LucideIcons.calendar,
                color: AppTheme.primaryPurple,
                size: 20,
              ),
              const SizedBox(width: 8),
              Text(
                DateFormat('EEEE, d \'de\' MMMM \'de\' yyyy', 'pt_BR').format(_selectedDate),
                style: const TextStyle(
                  fontSize: 16,
                  color: AppTheme.gray700,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.green.withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: Colors.green.withOpacity(0.2)),
            ),
            child: const Row(
              children: [
                Icon(
                  LucideIcons.checkCircle,
                  color: Colors.green,
                  size: 16,
                ),
                SizedBox(width: 8),
                Text(
                  'Data disponível',
                  style: TextStyle(
                    color: Colors.green,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildContinueButton(AppProvider appProvider) {
    return Container(
      padding: const EdgeInsets.all(16),
      color: Colors.white,
      child: SafeArea(
        child: SizedBox(
          width: double.infinity,
          child: ElevatedButton(
            onPressed: () {
              appProvider.navigateToBooking(DateFormat('yyyy-MM-dd').format(_selectedDate));
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppTheme.primaryPurple,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(vertical: 16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            child: const Text(
              'Continuar',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ),
      ),
    );
  }

  bool _isSameDay(DateTime date1, DateTime date2) {
    return date1.year == date2.year &&
        date1.month == date2.month &&
        date1.day == date2.day;
  }
}