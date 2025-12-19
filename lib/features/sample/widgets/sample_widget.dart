import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../core/theme/app_text_styles.dart';
import '../provider/sample_provider.dart';

class SampleWidget extends StatelessWidget {
  const SampleWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final value = context.watch<SampleProvider>().counter;

    return Text(
      'Sample value: $value',
      style: AppTextStyle.text14Regular,
    );
  }
}

