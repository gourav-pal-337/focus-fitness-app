import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';
import 'custom_bottom.dart';
import '../../service/calendar_service.dart';

class AddToCalendarButton extends StatefulWidget {
  final String title;
  final String description;
  final DateTime? startTime;
  final int durationMinutes;

  const AddToCalendarButton({
    super.key,
    required this.title,
    required this.description,
    this.startTime,
    this.durationMinutes = 60,
  });

  @override
  State<AddToCalendarButton> createState() => _AddToCalendarButtonState();
}

class _AddToCalendarButtonState extends State<AddToCalendarButton> {
  bool _isLoading = false;
  final CalendarService _calendarService = CalendarService();

  Future<void> _addToCalendar() async {
    if (widget.startTime == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Session time is not available')),
      );
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      final hasPermission = await _calendarService.requestPermissions();
      if (!hasPermission) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Calendar permission is required to add events')),
          );
        }
        return;
      }

      // Check for duplicates first to provide specific feedback
      final isAlreadyAdded = await _calendarService.isEventAlreadyAdded(
        title: widget.title,
        start: widget.startTime!,
        end: widget.startTime!.add(Duration(minutes: widget.durationMinutes)),
      );

      if (isAlreadyAdded) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('This session is already in your calendar!'),
              backgroundColor: Colors.blue,
            ),
          );
        }
        return;
      }

      final success = await _calendarService.createEvent(
        title: widget.title,
        description: widget.description,
        start: widget.startTime!,
        end: widget.startTime!.add(Duration(minutes: widget.durationMinutes)),
        reminderMinutes: [10, 30], // Default reminders
      );

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(success 
              ? 'Successfully added to calendar!' 
              : 'Failed to add to calendar. Please try again.'),
            backgroundColor: success ? Colors.green : Colors.red,
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('An error occurred: $e')),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return CustomButton(
      text: 'Add to Calendar',
      size: ButtonSize.large,
      width: double.infinity,
      height: 52.h,
      backgroundColor: Colors.transparent,
      textColor: AppColors.primary,
      textStyle: AppTextStyle.text16SemiBold.copyWith(
        color: AppColors.primary,
      ),
      borderRadius: 12.r,
      type: ButtonType.outlined,
      borderColor: AppColors.primary,
      isEnabled: !_isLoading,
      isLoading: _isLoading,
      onPressed: _addToCalendar,
      icon: Icon(
        Icons.calendar_today_outlined,
        color: AppColors.primary,
        size: 20.sp,
      ),
    );
  }
}
