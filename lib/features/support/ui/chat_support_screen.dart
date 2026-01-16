import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../core/widgets/custom_app_bar.dart';
import '../provider/chat_support_provider.dart';
import '../data/models/chat_message_model.dart';

class ChatSupportScreen extends StatefulWidget {
  const ChatSupportScreen({super.key});

  @override
  State<ChatSupportScreen> createState() => _ChatSupportScreenState();
}

class _ChatSupportScreenState extends State<ChatSupportScreen> {
  final ScrollController _scrollController = ScrollController();

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => ChatSupportProvider(),
      child: Consumer<ChatSupportProvider>(
        builder: (context, provider, child) {
          // Scroll to bottom when messages change
          if (provider.messages.isNotEmpty) {
            _scrollToBottom();
          }

          return Scaffold(
            backgroundColor: AppColors.background,
            body: SafeArea(
              child: Column(
                children: [
                  CustomAppBar(
                    title: 'Chat Support',
                    
                    onBack: () {
                      context.pop();
                    },
                  ),
                  Expanded(
                    child: Column(
                      children: [
                        Expanded(
                          child: ListView.builder(
                            controller: _scrollController,
                            padding: EdgeInsets.symmetric(
                              horizontal: AppSpacing.screenPadding.left,
                              vertical: AppSpacing.md,
                            ),
                            itemCount: provider.messages.length,
                            itemBuilder: (context, index) {
                              final message = provider.messages[index];
                              return _ChatMessageBubble(message: message);
                            },
                          ),
                        ),
                        _MessageInputField(),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}

class _ChatMessageBubble extends StatelessWidget {
  const _ChatMessageBubble({
    required this.message,
  });

  final ChatMessageModel message;

  @override
  Widget build(BuildContext context) {
    if (message.isUser) {
      return _UserMessageBubble(message: message);
    } else {
      return _SupportMessageBubble(message: message);
    }
  }
}

class _UserMessageBubble extends StatelessWidget {
  const _UserMessageBubble({
    required this.message,
  });

  final ChatMessageModel message;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(bottom: AppSpacing.md),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Container(
            constraints: BoxConstraints(
              maxWidth: MediaQuery.of(context).size.width * 0.65,
            ),
            padding: EdgeInsets.all(12.w),
            decoration: BoxDecoration(
              // color: AppColors.grey100,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(12.r),
                topRight: Radius.circular(12.r),
                bottomLeft: Radius.circular(12.r),
                bottomRight: Radius.circular(0.r),
              ),
              border: Border.all(
                // color: AppColors.grey200,
                width: 0.5,
              ),
            ),
            child: Text(
              message.message,
              style: AppTextStyle.text14Regular.copyWith(
                color: AppColors.textPrimary,
                height: 1.5,
              ),
            ),
          ),
          SizedBox(height: 4.h),
          Padding(
            padding: EdgeInsets.only(right: 4.w),
            child: Text(
              message.formattedTime,
              style: AppTextStyle.text12Regular.copyWith(
                color: AppColors.grey400,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _SupportMessageBubble extends StatelessWidget {
  const _SupportMessageBubble({
    required this.message,
  });

  final ChatMessageModel message;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(bottom: AppSpacing.md),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          
          
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  constraints: BoxConstraints(
                    maxWidth: MediaQuery.of(context).size.width * 0.65,
                  ),
                  padding: EdgeInsets.all(12.w),
                  decoration: BoxDecoration(
                    color: const Color(0xFF1F2937),
                    borderRadius: BorderRadius.only(
                topLeft: Radius.circular(12.r),
                topRight: Radius.circular(12.r),
                bottomLeft: Radius.circular(0.r),
                bottomRight: Radius.circular(12.r),
              ),
                  ),
                  child: Text(
                    message.message,
                    style: AppTextStyle.text14Regular.copyWith(
                      color: AppColors.background,
                      height: 1.5,
                    ),
                  ),
                ),
                SizedBox(height: 4.h),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Container(
            width: 12.w,
            height: 12.w,
            decoration: BoxDecoration(
              color: const Color(0xFF87CEEB), // Light blue
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.person,
              size: 10.sp,
              color: AppColors.background,
            ),
          ),
          SizedBox(width: AppSpacing.xs),
                    Text(
                      message.formattedTime,
                      style: AppTextStyle.text10Regular.copyWith(
                        color: AppColors.grey400,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _MessageInputField extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final provider = context.watch<ChatSupportProvider>();

    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: AppSpacing.screenPadding.left,
        vertical: AppSpacing.md,
      ),
      decoration: BoxDecoration(
        color: AppColors.background,
        border: Border(
          top: BorderSide(
            color: AppColors.grey200,
            width: 1,
          ),
        ),
      ),
      child: Row(
        children: [
          GestureDetector(
            onTap: () {
              // TODO: Handle attachment
            },
            child: Container(
              width: 40.w,
              height: 40.w,
              decoration: BoxDecoration(
                color: AppColors.grey100,
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.add,
                size: 24.sp,
                color: AppColors.textPrimary,
              ),
            ),
          ),
          SizedBox(width: AppSpacing.sm),
          Expanded(
            child: TextField(
              controller: provider.messageController,
              decoration: InputDecoration(
                hintText: 'Write a message',
                hintStyle: AppTextStyle.text14Regular.copyWith(
                  color: AppColors.grey400,
                ),
                border: InputBorder.none,
                contentPadding: EdgeInsets.symmetric(
                  horizontal: AppSpacing.md,
                  vertical: AppSpacing.sm,
                ),
              ),
              style: AppTextStyle.text14Regular.copyWith(
                color: AppColors.textPrimary,
              ),
              onSubmitted: (value) {
                provider.sendMessage(value);
              },
            ),
          ),
          SizedBox(width: AppSpacing.sm),
          GestureDetector(
            onTap: () {
              final message = provider.messageController.text;
              if (message.trim().isNotEmpty) {
                provider.sendMessage(message);
              }
            },
            child: Container(
              padding: EdgeInsets.all(8.w),
              decoration: BoxDecoration(
                color: AppColors.primary,
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.send,
                size: 20.sp,
                color: AppColors.background,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

