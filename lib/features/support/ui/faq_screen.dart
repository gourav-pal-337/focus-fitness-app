import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/widgets/custom_app_bar.dart';
import '../provider/support_provider.dart';
import '../data/models/faq_model.dart';

class FaqScreen extends StatefulWidget {
  const FaqScreen({super.key});

  @override
  State<FaqScreen> createState() => _FaqScreenState();
}

class _FaqScreenState extends State<FaqScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<SupportProvider>().fetchFaqs();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Column(
          children: [
            CustomAppBar(title: 'FAQs', onBack: () => context.pop()),
            Expanded(
              child: Consumer<SupportProvider>(
                builder: (context, provider, child) {
                  if (provider.isLoading) {
                    return const Center(child: CircularProgressIndicator());
                  }

                  if (provider.error != null) {
                    return Center(child: Text(provider.error!));
                  }

                  if (provider.faqs.isEmpty) {
                    return const Center(child: Text('No FAQs available'));
                  }

                  return ListView.separated(
                    padding: EdgeInsets.all(AppSpacing.md),
                    itemCount: provider.faqs.length,
                    separatorBuilder: (context, index) =>
                        Divider(color: AppColors.grey200, height: 1),
                    itemBuilder: (context, index) {
                      final faq = provider.faqs[index];
                      return _FaqItem(faq: faq);
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _FaqItem extends StatefulWidget {
  final FaqModel faq;

  const _FaqItem({required this.faq});

  @override
  State<_FaqItem> createState() => _FaqItemState();
}

class _FaqItemState extends State<_FaqItem> {
  bool _isExpanded = false;

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
      child: ExpansionTile(
        tilePadding: EdgeInsets.zero,
        title: Text(
          widget.faq.title ?? '',
          style: AppTextStyle.text16Medium.copyWith(
            color: AppColors.textPrimary,
          ),
        ),
        trailing: Icon(
          _isExpanded ? Icons.remove : Icons.add,
          color: AppColors.textPrimary,
        ),
        onExpansionChanged: (expanded) {
          setState(() {
            _isExpanded = expanded;
          });
        },
        children: [
          Padding(
            padding: const EdgeInsets.only(bottom: 16.0),
            child: Text(
              widget.faq.body ?? '',
              style: AppTextStyle.text14Regular.copyWith(
                color: AppColors.textSecondary,
                height: 1.5,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
