import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/app_text_styles.dart';
import '../provider/sample_provider.dart';
import '../widgets/sample_widget.dart';

class SampleScreen extends StatelessWidget {
  const SampleScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = context.read<SampleProvider>();

    return Scaffold(
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const SampleWidget(),
            SizedBox(height: AppSpacing.md),
            ElevatedButton(
              onPressed: provider.increment,
              child: Text(
                'Increment',
                style: AppTextStyle.text14Regular,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

