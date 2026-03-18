import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../core/widgets/custom_app_bar.dart';
import '../../../routes/app_router.dart';
import '../provider/track_ticket_provider.dart';
import '../data/models/ticket_model.dart';

class TrackTicketScreen extends StatefulWidget {
  const TrackTicketScreen({super.key});

  @override
  State<TrackTicketScreen> createState() => _TrackTicketScreenState();
}

class _TrackTicketScreenState extends State<TrackTicketScreen> {
  String _selectedTab = 'All';
  final List<String> _tabs = [
    'All',
    'Open',
    'In Progress',
    'Resolved',
    'Closed',
  ];

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _fetchTickets();
    });
  }

  void _fetchTickets() {
    final status = _selectedTab == 'All'
        ? null
        : _selectedTab.toLowerCase().replaceAll(' ', '_');
    context.read<TrackTicketProvider>().fetchTickets(status: status);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Column(
          children: [
            CustomAppBar(title: 'Track Ticket', onBack: () => context.pop()),
            _buildTabs(),
            Expanded(
              child: Consumer<TrackTicketProvider>(
                builder: (context, provider, child) {
                  if (provider.isLoading && provider.tickets.isEmpty) {
                    return const Center(
                      child: CircularProgressIndicator(
                        color: AppColors.primary,
                      ),
                    );
                  }

                  if (provider.error != null && provider.tickets.isEmpty) {
                    return Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(provider.error!),
                          SizedBox(height: AppSpacing.md),
                          ElevatedButton(
                            onPressed: _fetchTickets,
                            child: const Text('Retry'),
                          ),
                        ],
                      ),
                    );
                  }

                  if (provider.tickets.isEmpty) {
                    return Center(
                      child: Text(
                        'No tickets found',
                        style: AppTextStyle.text16Regular.copyWith(
                          color: AppColors.grey500,
                        ),
                      ),
                    );
                  }

                  return RefreshIndicator(
                    onRefresh: () async => _fetchTickets(),
                    color: AppColors.primary,
                    child: ListView.separated(
                      padding: EdgeInsets.zero,
                      itemCount: provider.tickets.length,
                      separatorBuilder: (context, index) => Divider(
                        color: AppColors.grey200,
                        thickness: 1,
                        height: 1,
                      ),
                      itemBuilder: (context, index) {
                        final ticket = provider.tickets[index];
                        return _buildTicketItem(ticket);
                      },
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTabs() {
    return Container(
      width: double.infinity,
      decoration: const BoxDecoration(
        border: Border(bottom: BorderSide(color: AppColors.grey200)),
      ),
      padding: EdgeInsets.symmetric(
        horizontal: AppSpacing.screenPadding.left,
        vertical: AppSpacing.md,
      ),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          children: _tabs.map((tab) {
            final isSelected = _selectedTab == tab;
            return GestureDetector(
              onTap: () {
                setState(() {
                  _selectedTab = tab;
                });
                _fetchTickets();
              },
              behavior: HitTestBehavior.opaque,
              child: Container(
                margin: EdgeInsets.only(right: AppSpacing.md),
                padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
                decoration: BoxDecoration(
                  color: isSelected
                      ? const Color(0xFF111827)
                      : Colors.transparent,
                  borderRadius: BorderRadius.circular(8.r),
                ),
                child: Text(
                  tab,
                  style: AppTextStyle.text14Medium.copyWith(
                    color: isSelected ? Colors.white : AppColors.grey500,
                  ),
                ),
              ),
            );
          }).toList(),
        ),
      ),
    );
  }

  Widget _buildTicketItem(TicketModel ticket) {
    Color badgeBgColor;
    Color badgeTextColor;
    String displayStatus = ticket.status ?? 'Unknown';

    // Normalize status for display and color
    final status = ticket.status?.toLowerCase() ?? '';
    if (status == 'open') {
      displayStatus = 'Open';
      badgeBgColor = const Color(0xFFE1F5FE); // Light blue
      badgeTextColor = const Color(0xFF29B6F6);
    } else if (status == 'in_progress') {
      displayStatus = 'In Progress';
      badgeBgColor = const Color(0xFFFFF9C4); // Light yellow
      badgeTextColor = const Color(0xFFFBC02D);
    } else if (status == 'resolved') {
      displayStatus = 'Resolved';
      badgeBgColor = const Color(0xFFE8F5E9); // Light green
      badgeTextColor = const Color(0xFF4CAF50);
    } else if (status == 'closed') {
      displayStatus = 'Closed';
      badgeBgColor = const Color(0xFFE8F5E9); // Light green
      badgeTextColor = const Color(0xFF4CAF50);
    } else {
      badgeBgColor = AppColors.grey200;
      badgeTextColor = AppColors.grey500;
    }

    String formattedDate = '';
    if (ticket.createdAt != null) {
      try {
        final date = DateTime.parse(ticket.createdAt!);
        formattedDate = DateFormat('dd MMM yyyy').format(date);
      } catch (e) {
        formattedDate = ticket.createdAt!;
      }
    }

    return InkWell(
      onTap: () {
        context.push(TicketDetailsRoute.path, extra: ticket);
      },
      child: Padding(
        padding: EdgeInsets.symmetric(
          horizontal: AppSpacing.screenPadding.left,
          vertical: AppSpacing.lg,
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    ticket.title ?? 'No Subject',
                    style: AppTextStyle.text16Medium.copyWith(
                      color: AppColors.textPrimary,
                    ),
                  ),
                  SizedBox(height: AppSpacing.xs),
                  Text(
                    'Ticket ID: ${ticket.ticketId ?? "N/A"}',
                    style: AppTextStyle.text12Regular.copyWith(
                      color: AppColors.grey500,
                    ),
                  ),
                  SizedBox(height: AppSpacing.xs),
                  Text(
                    'Created on $formattedDate',
                    style: AppTextStyle.text12Regular.copyWith(
                      color: AppColors.grey500,
                    ),
                  ),
                ],
              ),
            ),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 4.h),
              decoration: BoxDecoration(
                color: badgeBgColor,
                borderRadius: BorderRadius.circular(4.r),
              ),
              child: Text(
                displayStatus,
                style: AppTextStyle.text12Medium.copyWith(
                  color: badgeTextColor,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
