import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../core/theme/app_colors.dart';
import '../../core/theme/app_spacing.dart';
import '../../core/theme/app_text_styles.dart';

/// Widget to open files (PDF or images) from URL
class FileOpenerWidget extends StatelessWidget {
  const FileOpenerWidget({
    super.key,
    required this.url,
    this.child,
    this.onError,
  });

  final String url;
  final Widget? child;
  final VoidCallback? onError;

  /// Determine file type from URL
  FileType _getFileType(String url) {
    final lowerUrl = url.toLowerCase();
    if (lowerUrl.endsWith('.pdf')) {
      return FileType.pdf;
    } else if (lowerUrl.endsWith('.jpg') ||
        lowerUrl.endsWith('.jpeg') ||
        lowerUrl.endsWith('.png') ||
        lowerUrl.endsWith('.gif') ||
        lowerUrl.endsWith('.webp') ||
        lowerUrl.endsWith('.bmp')) {
      return FileType.image;
    }
    // Default to PDF if unknown
    return FileType.pdf;
  }

  /// Get full URL (handle relative URLs)
  String _getFullUrl(String url) {
    if (url.isEmpty) return url;
    
    // If URL is already absolute (starts with http:// or https://), return as is
    if (url.startsWith('http://') || url.startsWith('https://')) {
      return url;
    }
    
    // If URL starts with /, it's a relative URL - prepend base URL
    if (url.startsWith('/')) {
      // Extract base URL from Endpoints (remove /api/mobile)
      const baseUrl = 'https://sl5n9v1k-4000.inc1.devtunnels.ms';
      return '$baseUrl$url';
    }
    
    // Otherwise return as is
    return url;
  }

  /// Open file based on type
  Future<void> _openFile(BuildContext context) async {
    try {
      if (url.isEmpty) {
        _showError(context, 'Document URL is not available.');
        return;
      }

      final fullUrl = _getFullUrl(url);
      final fileType = _getFileType(fullUrl);
      
      debugPrint('FileOpenerWidget: Opening file - URL: $fullUrl, Type: $fileType');
      
      if (fileType == FileType.image) {
        // For images, show in full screen viewer
        await _showImagePreview(context, fullUrl);
      } else {
        // For PDFs, open in external app
        final uri = Uri.parse(fullUrl);
        
        debugPrint('FileOpenerWidget: Attempting to launch PDF: $uri');
        
        if (await canLaunchUrl(uri)) {
          final launched = await launchUrl(
            uri,
            mode: LaunchMode.externalApplication,
          );
          debugPrint('FileOpenerWidget: Launch result: $launched');
          if (!launched) {
            _showError(context, 'Unable to open PDF. Please try again.');
          }
        } else {
          debugPrint('FileOpenerWidget: Cannot launch URL: $uri');
          _showError(context, 'Unable to open PDF. Please check if a PDF viewer is installed.');
        }
      }
    } catch (e, stackTrace) {
      debugPrint('FileOpenerWidget: Error opening file: $e');
      debugPrint('FileOpenerWidget: Stack trace: $stackTrace');
      _showError(context, 'Error opening file: ${e.toString()}');
    }
  }

  /// Show image in full screen preview
  Future<void> _showImagePreview(BuildContext context, String imageUrl) async {
    await showDialog(
      context: context,
      barrierColor: Colors.black87,
      builder: (context) => _ImagePreviewDialog(imageUrl: imageUrl),
    );
  }

  /// Show error message
  void _showError(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          message,
          style: AppTextStyle.text14Regular.copyWith(
            color: AppColors.background,
          ),
        ),
        backgroundColor: AppColors.textPrimary,
        duration: const Duration(seconds: 3),
      ),
    );
    onError?.call();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        if (url.isNotEmpty) {
          _openFile(context);
        }
      },
      behavior: HitTestBehavior.opaque,
      child: child ??
          Container(
            padding: EdgeInsets.all(AppSpacing.sm),
            decoration: BoxDecoration(
              color: AppColors.primary.withOpacity(0.1),
              borderRadius: BorderRadius.circular(4.r),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  _getFileType(url) == FileType.image
                      ? Icons.image
                      : Icons.picture_as_pdf,
                  size: 16.sp,
                  color: AppColors.primary,
                ),
                SizedBox(width: AppSpacing.xs),
                Text(
                  'View ${_getFileType(url) == FileType.image ? 'Image' : 'PDF'}',
                  style: AppTextStyle.text12Medium.copyWith(
                    color: AppColors.primary,
                  ),
                ),
              ],
            ),
          ),
    );
  }
}

/// Full screen image preview dialog
class _ImagePreviewDialog extends StatelessWidget {
  const _ImagePreviewDialog({required this.imageUrl});

  final String imageUrl;

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.transparent,
      insetPadding: EdgeInsets.zero,
      child: Stack(
        children: [
          // Full screen image
          Center(
            child: InteractiveViewer(
              minScale: 0.5,
              maxScale: 4.0,
              child: Image.network(
                imageUrl,
                fit: BoxFit.contain,
                loadingBuilder: (context, child, loadingProgress) {
                  if (loadingProgress == null) return child;
                  return Center(
                    child: CircularProgressIndicator(
                      value: loadingProgress.expectedTotalBytes != null
                          ? loadingProgress.cumulativeBytesLoaded /
                              loadingProgress.expectedTotalBytes!
                          : null,
                      color: AppColors.primary,
                    ),
                  );
                },
                errorBuilder: (context, error, stackTrace) {
                  return Container(
                    padding: EdgeInsets.all(AppSpacing.lg),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          Icons.error_outline,
                          size: 48.sp,
                          color: AppColors.grey400,
                        ),
                        SizedBox(height: AppSpacing.md),
                        Text(
                          'Failed to load image',
                          style: AppTextStyle.text14Regular.copyWith(
                            color: AppColors.background,
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
          ),
          // Close button
          Positioned(
            top: MediaQuery.of(context).padding.top + AppSpacing.md,
            right: AppSpacing.md,
            child: GestureDetector(
              onTap: () => Navigator.of(context).pop(),
              child: Container(
                padding: EdgeInsets.all(AppSpacing.sm),
                decoration: BoxDecoration(
                  color: Colors.black54,
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.close,
                  size: 24.sp,
                  color: AppColors.background,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

enum FileType {
  pdf,
  image,
}

