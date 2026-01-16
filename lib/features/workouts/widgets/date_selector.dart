import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_radius.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/app_text_styles.dart';

class DateSelector extends StatefulWidget {
  const DateSelector({
    super.key,
    required this.selectedDate,
    required this.onDateSelected,
  });

  final DateTime selectedDate;
  final ValueChanged<DateTime> onDateSelected;

  @override
  State<DateSelector> createState() => _DateSelectorState();
}

class _DateSelectorState extends State<DateSelector> {
  late ScrollController _scrollController;
  final today = DateTime.now();
  late List<DateTime> dates;

  @override
  void initState() {
    super.initState();
    dates = List.generate(7, (index) {
      return today.add(Duration(days: index - 3));
    });
    _scrollController = ScrollController();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _scrollToSelectedDate();
    });
  }

  @override
  void didUpdateWidget(DateSelector oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.selectedDate != widget.selectedDate) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _scrollToSelectedDate();
      });
    }
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _scrollToSelectedDate() {
    final selectedIndex = dates.indexWhere((date) =>
        date.day == widget.selectedDate.day &&
        date.month == widget.selectedDate.month &&
        date.year == widget.selectedDate.year);

    if (selectedIndex == -1 || !_scrollController.hasClients) return;

    // Use a simpler approach: estimate average item width
    // Selected items are wider due to full date text
    final baseItemWidth = 50.w; // Approximate width for number-only items
    final separatorWidth = AppSpacing.sm;
    final padding = AppSpacing.screenPadding.left;

    // Calculate approximate offset to center the selected item
    // Assume all previous items are base width (conservative estimate)
    final approximateOffset = padding + (selectedIndex * (baseItemWidth + separatorWidth));
    
    // Center the selected item by adjusting for screen width
    final screenWidth = MediaQuery.of(context).size.width;
    final targetOffset = (approximateOffset - (screenWidth / 2) + (baseItemWidth / 2))
        .clamp(0.0, _scrollController.position.maxScrollExtent);

    _scrollController.animateTo(
      targetOffset,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(top: AppSpacing.md),
      height: 32.h,
      child: ListView.separated(
        controller: _scrollController,
        scrollDirection: Axis.horizontal,
        padding: EdgeInsets.symmetric(horizontal: AppSpacing.screenPadding.left),
        itemCount: dates.length,
        separatorBuilder: (context, index) => SizedBox(width: AppSpacing.sm),
        itemBuilder: (context, index) {
          final date = dates[index];
          final isSelected = date.day == widget.selectedDate.day &&
              date.month == widget.selectedDate.month &&
              date.year == widget.selectedDate.year;
          final isToday = date.day == today.day &&
              date.month == today.month &&
              date.year == today.year;

          return GestureDetector(
            onTap: () => widget.onDateSelected(date),
            child: Container(
              height: 32.h,
              alignment: Alignment.center,
              margin: EdgeInsets.only(right: AppSpacing.sm, top: AppSpacing.sm),
              padding: EdgeInsets.symmetric(
                horizontal: AppSpacing.md,
              ),
              decoration: BoxDecoration(
                color: isSelected ? AppColors.textPrimary : Colors.transparent,
                borderRadius: AppRadius.medium,
              ),
              child: Center(
                child: isSelected
                    ? Text(
                        isToday
                            ? 'Today, ${date.day} ${_getMonthName(date)}'
                            : DateFormat('EEE, dd MMM').format(date),
                        style: AppTextStyle.text12Medium.copyWith(
                          color: AppColors.background,
                        ),
                      )
                    : Text(
                        '${date.day}',
                        style: AppTextStyle.text14Medium.copyWith(
                          color: AppColors.grey400,
                        ),
                      ),
              ),
            ),
          );
        },
      ),
    );
  }

  String _getMonthName(DateTime date) {
    const months = [
      'Jan',
      'Feb',
      'Mar',
      'Apr',
      'May',
      'Jun',
      'Jul',
      'Aug',
      'Sep',
      'Oct',
      'Nov',
      'Dec'
    ];
    return months[date.month - 1];
  }
}

