import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_radius.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../core/widgets/buttons/custom_bottom.dart';
import '../data/models/reschedule_models.dart';
import '../provider/session_details_provider.dart';
import '../provider/session_history_provider.dart';
import '../../trainer/utils/date_time_utils.dart';
import 'session_card.dart';

class RescheduleBottomSheet extends StatefulWidget {
  const RescheduleBottomSheet({super.key, required this.session});

  final SessionData session;

  static Future<void> show(BuildContext context, SessionData session) {
    return showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => RescheduleBottomSheet(session: session),
    );
  }

  @override
  State<RescheduleBottomSheet> createState() => _RescheduleBottomSheetState();
}

class _RescheduleBottomSheetState extends State<RescheduleBottomSheet> {
  String? _selectedDate;
  RescheduleSlot? _selectedSlot;
  final TextEditingController _reasonController = TextEditingController();
  bool _showSummary = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (widget.session.bookingId != null) {
        context.read<SessionDetailsProvider>().fetchRescheduleAvailability(
          widget.session.bookingId!,
        );
      }
    });
  }

  @override
  void dispose() {
    _reasonController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<SessionDetailsProvider>();

    return Container(
      height: MediaQuery.of(context).size.height * 0.85,
      decoration: BoxDecoration(
        color: AppColors.background,
        borderRadius: BorderRadius.vertical(top: Radius.circular(24.r)),
      ),
      child: Column(
        children: [
          _buildHeader(),
          Expanded(
            child: provider.isLoadingAvailability
                ? const Center(child: CircularProgressIndicator())
                : provider.availabilityError != null
                ? _buildError(provider.availabilityError!)
                : _showSummary
                ? _buildSummaryOverlay()
                : _buildDiscoveryView(provider),
          ),
          if (!_showSummary && _selectedSlot != null) _buildNextButton(),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 16.h),
      child: Column(
        children: [
          Container(
            width: 40.w,
            height: 4.h,
            decoration: BoxDecoration(
              color: AppColors.grey200,
              borderRadius: BorderRadius.circular(2.r),
            ),
          ),
          SizedBox(height: 16.h),
          Text(
            _showSummary ? 'Reschedule Summary' : 'Select New Slot',
            style: AppTextStyle.text20SemiBold.copyWith(
              color: AppColors.textPrimary,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildError(String message) {
    return Center(
      child: Padding(
        padding: EdgeInsets.all(AppSpacing.xl),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.error_outline, color: Colors.red, size: 48.sp),
            SizedBox(height: 16.h),
            Text(
              message,
              textAlign: TextAlign.center,
              style: AppTextStyle.text14Regular.copyWith(
                color: AppColors.grey400,
              ),
            ),
            SizedBox(height: 24.h),
            ElevatedButton(
              onPressed: () {
                if (widget.session.bookingId != null) {
                  context
                      .read<SessionDetailsProvider>()
                      .fetchRescheduleAvailability(widget.session.bookingId!);
                }
              },
              child: const Text('Retry'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDiscoveryView(SessionDetailsProvider provider) {
    final sessionPlanId = widget.session.booking?.sessionPlanId;
    final filteredAvailability = provider.availability.where((day) {
      return day.availableSlots.any((slot) => slot.planId == sessionPlanId);
    }).toList();

    final allDates = filteredAvailability.map((e) => e.date).toList();
    final selectedMonth = provider.selectedMonth;
    final uniqueMonths = provider.uniqueMonths;

    // Filter dates by selected month
    final dates = allDates.where((dateStr) {
      final date = DateTime.parse(dateStr);
      return DateTimeUtils.getMonthAbbreviation(date.month) == selectedMonth;
    }).toList();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Month Selector & Header
        Padding(
          padding: EdgeInsets.symmetric(
            horizontal: AppSpacing.screenPadding.left,
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Choose Date',
                style: AppTextStyle.text20SemiBold.copyWith(
                  color: AppColors.textPrimary,
                ),
              ),
              // if (uniqueMonths.isNotEmpty)
              DropdownButton<String>(
                value: selectedMonth,
                underline: const SizedBox.shrink(),
                icon: Icon(
                  Icons.keyboard_arrow_down,
                  color: AppColors.grey400,
                  size: 20.sp,
                ),
                borderRadius: BorderRadius.circular(10),
                items: uniqueMonths.map((m) {
                  return DropdownMenuItem(
                    value: m,
                    child: Text(
                      m,
                      style: AppTextStyle.text14SemiBold.copyWith(
                        color: AppColors.textPrimary,
                      ),
                    ),
                  );
                }).toList(),
                onChanged: (value) {
                  if (value != null) {
                    provider.selectMonth(value);
                    // Clear local selection if the new month doesn't contain the selected date
                    if (_selectedDate != null) {
                      final date = DateTime.parse(_selectedDate!);
                      if (DateTimeUtils.getMonthAbbreviation(date.month) !=
                          value) {
                        setState(() {
                          _selectedDate = null;
                          _selectedSlot = null;
                        });
                      }
                    }
                  }
                },
              ),
            ],
          ),
        ),
        SizedBox(height: AppSpacing.md),
        SizedBox(
          height: 100.h,
          child: ListView.separated(
            padding: EdgeInsets.only(left: AppSpacing.screenPadding.left),
            scrollDirection: Axis.horizontal,
            itemCount: dates.length,
            separatorBuilder: (context, index) =>
                SizedBox(width: AppSpacing.sm),
            itemBuilder: (context, index) {
              final dateStr = dates[index];
              final date = DateTime.parse(dateStr);
              final isSelected = _selectedDate == dateStr;

              return GestureDetector(
                onTap: () {
                  setState(() {
                    _selectedDate = dateStr;
                    _selectedSlot = null; // Reset slot when date changes
                  });
                },
                child: Container(
                  width: 78.w,
                  padding: EdgeInsets.symmetric(
                    horizontal: AppSpacing.sm,
                    vertical: AppSpacing.md,
                  ),
                  decoration: BoxDecoration(
                    color: isSelected ? Colors.black : AppColors.grey75,
                    borderRadius: AppRadius.small,
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        date.day.toString(),
                        style: AppTextStyle.text24Bold.copyWith(
                          color: isSelected
                              ? AppColors.background
                              : AppColors.grey400,
                        ),
                      ),
                      SizedBox(height: 4.h),
                      Text(
                        DateFormat('EEE').format(date),
                        style: AppTextStyle.text14Regular.copyWith(
                          color: isSelected
                              ? AppColors.background
                              : AppColors.grey400,
                        ),
                      ),
                      SizedBox(height: AppSpacing.sm),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: List.generate(
                          3,
                          (index) => Container(
                            width: 4.w,
                            height: 4.w,
                            margin: EdgeInsets.symmetric(horizontal: 1.w),
                            decoration: BoxDecoration(
                              color: isSelected
                                  ? AppColors.background
                                  : AppColors.grey400,
                              shape: BoxShape.circle,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),

        if (_selectedDate != null) ...[
          SizedBox(height: AppSpacing.xl),
          Padding(
            padding: EdgeInsets.only(left: AppSpacing.screenPadding.left),
            child: Text(
              'Choose Time Slot',
              style: AppTextStyle.text20SemiBold.copyWith(
                color: AppColors.textPrimary,
              ),
            ),
          ),
          SizedBox(height: AppSpacing.md),
          SizedBox(height: 50.h, child: _buildSlotsList(provider)),
        ] else
          Expanded(
            child: Center(
              child: Text(
                'Please select a date to see available slots',
                style: AppTextStyle.text14Regular.copyWith(
                  color: AppColors.grey400,
                ),
              ),
            ),
          ),
      ],
    );
  }

  bool shouldShowTimeSlot(String dateStr) {
    try {
      final format = DateFormat('yyyy-MM-dd hh:mm a');
      DateTime slotTime = format.parse(dateStr.toUpperCase());
      DateTime now = DateTime.now();
      return slotTime.isAfter(now);
    } catch (e) {
      return true;
    }
  }

  Widget _buildSlotsList(SessionDetailsProvider provider) {
    final dayAvailability = provider.availability.firstWhere(
      (e) => e.date == _selectedDate,
      orElse: () => DayAvailability(date: '', availableSlots: []),
    );

    final sessionPlanId = widget.session.booking?.sessionPlanId;
    final filteredSlots = dayAvailability.availableSlots.where((slot) {
      return slot.planId == sessionPlanId;
    }).toList();

    if (filteredSlots.isEmpty) {
      return Center(
        child: Text(
          'No slots available for this session plan',
          style: AppTextStyle.text14Regular.copyWith(color: AppColors.grey400),
        ),
      );
    }

    return ListView.separated(
      padding: EdgeInsets.only(left: AppSpacing.screenPadding.left),
      scrollDirection: Axis.horizontal,
      itemCount: filteredSlots.length,
      separatorBuilder: (context, index) => SizedBox(width: AppSpacing.sm),
      itemBuilder: (context, index) {
        final slot = filteredSlots[index];
        final startTime = DateTime.parse(slot.startTime);
        final timeStr = DateFormat('hh:mm a').format(startTime);
        final isSelected = _selectedSlot == slot;

        bool isSlotAvailable = shouldShowTimeSlot('$_selectedDate $timeStr');
        if (!isSlotAvailable) {
          return const SizedBox.shrink();
        }
        return GestureDetector(
          onTap: () {
            setState(() {
              _selectedSlot = slot;
            });
          },
          child: Container(
            padding: EdgeInsets.symmetric(
              horizontal: AppSpacing.md,
              vertical: AppSpacing.sm,
            ),
            decoration: BoxDecoration(
              color: isSelected ? Colors.black : AppColors.grey75,
              borderRadius: AppRadius.small,
            ),
            child: Center(
              child: Text(
                timeStr,
                style: AppTextStyle.text14SemiBold.copyWith(
                  color: isSelected
                      ? AppColors.background
                      : AppColors.textPrimary,
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildNextButton() {
    return SafeArea(
      top: false,
      child: Padding(
        padding: EdgeInsets.all(16.w),
        child: CustomButton(
          text: 'Continue',
          onPressed: () {
            setState(() {
              _showSummary = true;
            });
          },
          borderRadius: 10,
          width: double.infinity,
        ),
      ),
    );
  }

  Widget _buildSummaryOverlay() {
    final originalStart = DateTime.parse(widget.session.booking!.startTime);
    final originalEnd = DateTime.parse(widget.session.booking!.endTime);
    final newStart = DateTime.parse(_selectedSlot!.startTime);

    return SingleChildScrollView(
      padding: EdgeInsets.all(AppSpacing.screenPadding.left),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'New Schedule Details',
            style: AppTextStyle.text20SemiBold.copyWith(
              color: AppColors.textPrimary,
            ),
          ),
          SizedBox(height: AppSpacing.md),
          Container(
            width: double.infinity,
            padding: EdgeInsets.all(20.w),
            decoration: BoxDecoration(
              color: AppColors.background,
              borderRadius: AppRadius.medium,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                ),
              ],
              border: Border.all(color: AppColors.grey100),
            ),
            child: Column(
              children: [
                _buildEnhancedSummaryItem(
                  title: 'CURRENT SCHEDULE',
                  date: DateFormat('EEEE, MMM dd').format(originalStart),
                  time:
                      '${DateFormat('hh:mm a').format(originalStart)} - ${DateFormat('hh:mm a').format(originalEnd)}',
                  icon: Icons.calendar_today_outlined,
                  isDimmed: true,
                ),
                Padding(
                  padding: EdgeInsets.symmetric(vertical: 16.h),
                  child: Row(
                    children: [
                      Expanded(
                        child: Container(height: 1.h, color: AppColors.grey200),
                      ),
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 16.w),
                        child: Container(
                          padding: EdgeInsets.all(8.w),
                          decoration: BoxDecoration(
                            color: AppColors.primary.withOpacity(0.1),
                            shape: BoxShape.circle,
                          ),
                          child: Icon(
                            Icons.arrow_downward_rounded,
                            color: AppColors.primary,
                            size: 20.sp,
                          ),
                        ),
                      ),
                      Expanded(
                        child: Container(height: 1.h, color: AppColors.grey200),
                      ),
                    ],
                  ),
                ),
                _buildEnhancedSummaryItem(
                  title: 'NEW SCHEDULE',
                  date: DateFormat('EEEE, MMM dd').format(newStart),
                  time:
                      '${DateFormat('hh:mm a').format(newStart)} - ${DateFormat('hh:mm a').format(DateTime.parse(_selectedSlot!.endTime))}',
                  icon: Icons.event_available_rounded,
                  isPrimary: true,
                ),
              ],
            ),
          ),
          SizedBox(height: AppSpacing.xl),
          Row(
            children: [
              const Icon(Icons.edit_note, color: AppColors.grey400),
              SizedBox(width: 8.w),
              Text(
                'Reschedule Reason',
                style: AppTextStyle.text16SemiBold.copyWith(
                  color: AppColors.textPrimary,
                ),
              ),
            ],
          ),
          SizedBox(height: 12.h),
          TextField(
            controller: _reasonController,
            maxLines: 3,
            style: AppTextStyle.text14Medium,
            decoration: InputDecoration(
              filled: true,
              fillColor: AppColors.grey75,
              hintText:
                  'Tell the trainer why you are moving this session (optional)',
              hintStyle: AppTextStyle.text14Regular.copyWith(
                color: AppColors.grey400,
                height: 1.2,
              ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12.r),
                borderSide: BorderSide.none,
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12.r),
                borderSide: BorderSide.none,
              ),
            ),
          ),
          SizedBox(height: 32.h),
          Consumer<SessionDetailsProvider>(
            builder: (context, provider, _) {
              return CustomButton(
                text: provider.isRescheduling
                    ? 'Rescheduling...'
                    : 'Confirm Reschedule',
                isLoading: provider.isRescheduling,
                onPressed: () => _handleReschedule(context),
                width: double.infinity,
              );
            },
          ),
          SizedBox(height: 12.h),
          TextButton(
            onPressed: () {
              setState(() {
                _showSummary = false;
              });
            },
            child: Center(
              child: Text(
                'Change Selection',
                style: AppTextStyle.text14SemiBold.copyWith(
                  color: AppColors.grey400,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEnhancedSummaryItem({
    required String title,
    required String date,
    required String time,
    required IconData icon,
    bool isDimmed = false,
    bool isPrimary = false,
  }) {
    return Row(
      children: [
        Container(
          padding: EdgeInsets.all(12.w),
          decoration: BoxDecoration(
            color: isPrimary
                ? AppColors.primary.withOpacity(0.1)
                : AppColors.grey100,
            borderRadius: BorderRadius.circular(12.r),
          ),
          child: Icon(
            icon,
            color: isPrimary ? AppColors.primary : AppColors.grey400,
            size: 24.sp,
          ),
        ),
        SizedBox(width: 16.w),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: AppTextStyle.text12Bold.copyWith(
                  color: isPrimary ? AppColors.primary : AppColors.grey400,
                  letterSpacing: 1.2,
                ),
              ),
              // SizedBox(height: 4.h),
              Text(
                date,
                style: AppTextStyle.text12SemiBold.copyWith(
                  color: isDimmed ? AppColors.grey400 : AppColors.textPrimary,
                  decoration: isDimmed ? TextDecoration.lineThrough : null,
                ),
              ),
              Text(
                time,
                style: AppTextStyle.text14SemiBold.copyWith(
                  color: isPrimary ? AppColors.primary : AppColors.textPrimary,
                  decoration: isDimmed ? TextDecoration.lineThrough : null,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Future<void> _handleReschedule(BuildContext context) async {
    final provider = context.read<SessionDetailsProvider>();
    final success = await provider.rescheduleBooking(
      bookingId: widget.session.bookingId!,
      startTime: _selectedSlot!.startTime,
      endTime: _selectedSlot!.endTime,
      reason: _reasonController.text,
    );

    if (!context.mounted) return;

    if (success) {
      // Show Success Animation or Dialog
      _showSuccessDialog(context);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            provider.availabilityError ??
                'Reschedule failed. Please try again.',
          ),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  void _showSuccessDialog(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: AppRadius.medium),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.check_circle, color: Colors.green, size: 64),
            SizedBox(height: 16.h),
            Text(
              'Rescheduled Successfully!',
              style: AppTextStyle.text18SemiBold,
            ),
            SizedBox(height: 8.h),
            Text(
              'Your session has been moved to the new time.',
              textAlign: TextAlign.center,
              style: AppTextStyle.text14Regular.copyWith(
                color: AppColors.grey400,
              ),
            ),
            SizedBox(height: 24.h),
            CustomButton(
              text: 'Done',
              onPressed: () {
                Navigator.pop(context); // Close dialog
                Navigator.pop(context); // Close bottom sheet
                // Refresh parent
                context.read<SessionHistoryProvider>().fetchBookings();
              },
              width: double.infinity,
            ),
          ],
        ),
      ),
    );
  }
}
