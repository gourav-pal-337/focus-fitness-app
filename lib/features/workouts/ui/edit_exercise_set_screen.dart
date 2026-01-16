import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../core/widgets/custom_app_bar.dart';
import '../../../core/widgets/buttons/custom_bottom.dart';
import '../provider/workout_provider.dart';

class EditExerciseSetScreen extends StatefulWidget {
  const EditExerciseSetScreen({
    super.key,
    required this.workoutProgress,
    required this.date,
    this.setIndex,
  });

  final WorkoutProgress workoutProgress;
  final DateTime date;
  final int? setIndex;

  @override
  State<EditExerciseSetScreen> createState() => _EditExerciseSetScreenState();
}

class _EditExerciseSetScreenState extends State<EditExerciseSetScreen> {
  late TextEditingController _repsController;
  late TextEditingController _weightController;
  bool _hasChanges = false;

  @override
  void initState() {
    super.initState();
    final set = widget.setIndex != null &&
            widget.setIndex! < widget.workoutProgress.sets.length
        ? widget.workoutProgress.sets[widget.setIndex!]
        : null;

    _repsController = TextEditingController(text: set?.reps.toString() ?? '');
    _weightController = TextEditingController(
      text: set?.weight != null ? set!.weight.toString() : '',
    );

    _repsController.addListener(_onTextChanged);
    _weightController.addListener(_onTextChanged);
  }

  void _onTextChanged() {
    if (!_hasChanges) {
      setState(() {
        _hasChanges = true;
      });
    }
  }

  @override
  void dispose() {
    _repsController.dispose();
    _weightController.dispose();
    super.dispose();
  }

  void _saveChanges() {
    final reps = int.tryParse(_repsController.text);
    if (reps == null || reps <= 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Please enter a valid number of reps'),
          backgroundColor: AppColors.grey400,
        ),
      );
      return;
    }

    final weight = _weightController.text.isNotEmpty
        ? double.tryParse(_weightController.text)
        : null;

    final provider = context.read<WorkoutProgressProvider>();
    final newSet = WorkoutSet(reps: reps, weight: weight);

    if (widget.setIndex != null) {
      provider.updateSet(widget.date, widget.workoutProgress.exerciseId,
          widget.setIndex!, newSet);
    } else {
      provider.addSetToExercise(
        widget.date,
        widget.workoutProgress.exerciseId,
        newSet,
      );
    }

    context.pop();
  }

  void _deleteSet() {
    if (widget.setIndex != null) {
      final provider = context.read<WorkoutProgressProvider>();
      provider.removeSetFromExercise(
        widget.date,
        widget.workoutProgress.exerciseId,
        widget.setIndex!,
      );
      context.pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Column(
          children: [
            CustomAppBar(
              title: widget.workoutProgress.exerciseName,
              actions: widget.setIndex != null
                  ? [
                      GestureDetector(
                        onTap: _deleteSet,
                        child: Padding(
                          padding: EdgeInsets.all(AppSpacing.md),
                          child: Icon(
                            Icons.delete_outline,
                            size: 24.sp,
                            color: AppColors.textPrimary,
                          ),
                        ),
                      ),
                    ]
                  : null,
            ),
            Expanded(
              child: ListView(
                padding: EdgeInsets.symmetric(
                  horizontal: AppSpacing.screenPadding.left,
                ),
                children: [
                  SizedBox(height: AppSpacing.lg),
                  _EditField(
                    label: 'Sets',
                    value: widget.setIndex != null
                        ? '${widget.setIndex! + 1}'
                        : '${widget.workoutProgress.sets.length + 1}',
                  ),
                  Divider(color: AppColors.grey200, thickness: 1),
                  _EditField(
                    label: 'Reps',
                    controller: _repsController,
                    keyboardType: TextInputType.number,
                    hintText: 'Enter reps',
                  ),
                  Divider(color: AppColors.grey200, thickness: 1),
                  _EditField(
                    label: 'Weight',
                    controller: _weightController,
                    keyboardType: TextInputType.number,
                    hintText: 'Enter weight (optional)',
                    value: _weightController.text.isEmpty ? '-' : null,
                  ),
                ],
              ),
            ),
            SafeArea(
              child: Padding(
                padding: EdgeInsets.all(AppSpacing.screenPadding.left),
                child: CustomButton(
                  text: 'Save Changes',
                  type: ButtonType.text,
                  onPressed: _saveChanges,
                  textColor: AppColors.primary,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _EditField extends StatelessWidget {
  const _EditField({
    required this.label,
    this.controller,
    this.value,
    this.keyboardType,
    this.hintText,
  });

  final String label;
  final TextEditingController? controller;
  final String? value;
  final TextInputType? keyboardType;
  final String? hintText;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: AppSpacing.sm),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: AppTextStyle.text16Medium.copyWith(
              color: AppColors.grey400,
            ),
          ),
          if (controller != null)
            SizedBox(
              width: 100.w,
              child: TextField(
                controller: controller,
                keyboardType: keyboardType,
                textAlign: TextAlign.right,
                decoration: InputDecoration(
                  hintText: hintText,
                  hintStyle: AppTextStyle.text16Medium.copyWith(
                    color: AppColors.grey400,
                  ),
                  border: InputBorder.none,
                  contentPadding: EdgeInsets.zero,
                ),
                style: AppTextStyle.text16Medium.copyWith(
                  color: AppColors.textPrimary,
                ),
              ),
            )
          else
            Text(
              value ?? '-',
              style: AppTextStyle.text16Medium.copyWith(
                color: AppColors.textPrimary,
              ),
            ),
        ],
      ),
    );
  }
}

