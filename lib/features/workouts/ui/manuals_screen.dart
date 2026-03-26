import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../core/widgets/custom_app_bar.dart';
import '../../../core/widgets/file_opener_widget.dart';
import '../providers/manual_provider.dart';
import '../widgets/empty_state_widget.dart';
import '../widgets/loading_shimmer.dart';
import '../../../routes/app_router.dart';

class ManualsScreen extends StatefulWidget {
  const ManualsScreen({super.key});

  @override
  State<ManualsScreen> createState() => _ManualsScreenState();
}

class _ManualsScreenState extends State<ManualsScreen> {
  late final ManualProvider _provider;

  @override
  void initState() {
    super.initState();
    _provider = ManualProvider();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _provider.fetchManuals();
    });
  }

  @override
  void dispose() {
    _provider.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<ManualProvider>.value(
      value: _provider,
      child: Scaffold(
        backgroundColor: AppColors.background,
        body: SafeArea(
          child: Column(
            children: [
              const CustomAppBar(title: 'Training Manuals'),
              Expanded(
                child: Consumer<ManualProvider>(
                  builder: (context, provider, _) {
                    if (provider.isLoading) {
                      return const LoadingShimmer();
                    }

                    if (provider.manuals.isEmpty) {
                      return const EmptyStateWidget(
                        title: 'No manuals yet',
                        subtitle: 'Trainer manuals will appear here',
                      );
                    }

                    return ListView.separated(
                      padding: EdgeInsets.symmetric(
                        horizontal: AppSpacing.screenPadding.left,
                        vertical: AppSpacing.md,
                      ),
                      itemCount: provider.manuals.length,
                      separatorBuilder: (_, __) => SizedBox(height: AppSpacing.sm),
                      itemBuilder: (context, index) {
                        final manual = provider.manuals[index];
                        final typeLower = manual.type.toLowerCase();
                        final isVideo = typeLower.contains('video') ||
                            manual.fileUrl.toLowerCase().endsWith('.mp4') ||
                            manual.fileUrl.toLowerCase().endsWith('.webm');

                        final listTile = ListTile(
                          contentPadding: EdgeInsets.zero,
                          title: Text(
                            manual.title,
                            style: AppTextStyle.text16Medium.copyWith(
                              color: AppColors.textPrimary,
                            ),
                          ),
                          subtitle: Text(
                            (manual.description.trim().isNotEmpty
                                    ? manual.description.trim()
                                    : manual.type.toUpperCase())
                                .toString(),
                            style: AppTextStyle.text12Regular.copyWith(
                              color: AppColors.grey400,
                            ),
                          ),
                          trailing: const Icon(Icons.open_in_new),
                        );

                        if (isVideo) {
                          return ListTile(
                            contentPadding: EdgeInsets.zero,
                            title: listTile.title,
                            subtitle: listTile.subtitle,
                            trailing: listTile.trailing,
                            onTap: () {
                              context.push(
                                '${VideoPlayerRoute.path}?videoUrl=${Uri.encodeComponent(manual.fileUrl)}&title=${Uri.encodeComponent(manual.title)}',
                              );
                            },
                          );
                        }

                        return FileOpenerWidget(url: manual.fileUrl, child: listTile);
                      },
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
