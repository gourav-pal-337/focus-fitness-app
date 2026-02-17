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

                  final groupedFaqs = <String, List<FaqModel>>{};
                  for (var faq in provider.faqs) {
                    final category = faq.category ?? 'General';
                    if (!groupedFaqs.containsKey(category)) {
                      groupedFaqs[category] = [];
                    }
                    groupedFaqs[category]!.add(faq);
                  }

                  return ListView.builder(
                    padding: EdgeInsets.all(AppSpacing.md),
                    itemCount: groupedFaqs.length,
                    itemBuilder: (context, index) {
                      final category = groupedFaqs.keys.elementAt(index);
                      final faqs = groupedFaqs[category]!;

                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          if (index > 0) SizedBox(height: AppSpacing.lg),
                          Text(
                            _formatCategory(category),
                            style: AppTextStyle.text24SemiBold.copyWith(
                              color: AppColors.textSecondary,
                            ),
                          ),
                          SizedBox(height: AppSpacing.md),
                          ...faqs.map((faq) {
                            return Column(
                              children: [
                                _FaqItem(faq: faq),
                                Divider(color: AppColors.grey200, height: 1),
                              ],
                            );
                          }),
                        ],
                      );
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

  String _formatCategory(String category) {
    if (category.isEmpty) return 'General';
    return category
        .split('_')
        .map((word) {
          if (word.isEmpty) return '';
          return '${word[0].toUpperCase()}${word.substring(1).toLowerCase()}';
        })
        .join(' ');
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
