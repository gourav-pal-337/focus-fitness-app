import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';
import '../theme/app_colors.dart';

class ShowImage extends StatelessWidget {
  final String? imageUrl;
  final double? width;
  final double? height;
  final BoxFit fit;
  final Widget? placeholder;
  final Widget? errorWidget;
  final double? borderRadius;
  final bool isCircle;

  const ShowImage({
    super.key,
    required this.imageUrl,
    this.width,
    this.height,
    this.fit = BoxFit.cover,
    this.placeholder,
    this.errorWidget,
    this.borderRadius,
    this.isCircle = false,
  });

  @override
  Widget build(BuildContext context) {
    // Shared container styling
    BoxDecoration? decoration;
    if (isCircle) {
      decoration = const BoxDecoration(
        shape: BoxShape.circle,
        color: AppColors.grey200,
      );
    } else if (borderRadius != null && borderRadius! > 0) {
      decoration = BoxDecoration(
        color: AppColors.grey200,
        borderRadius: BorderRadius.circular(borderRadius!),
      );
    }

    // Helper to wrap widgets in the consistent shape/size
    Widget wrapInShape(Widget child) {
      if (decoration != null) {
        return Container(
          width: width,
          height: height,
          decoration: decoration,
          clipBehavior: Clip.antiAlias,
          child: Center(child: child),
        );
      }
      return SizedBox(width: width, height: height, child: child);
    }

    if (imageUrl == null || imageUrl!.isEmpty) {
      return wrapInShape(errorWidget ?? const Icon(Icons.error_outline));
    }

    Widget image = CachedNetworkImage(
      imageUrl: imageUrl!,
      width: width,
      height: height,
      fit: fit,
      placeholder: (context, url) =>
          placeholder ??
          Shimmer.fromColors(
            baseColor: AppColors.grey75,
            highlightColor: Colors.white,
            child: Container(
              width: width,
              height: height,
              decoration:
                  decoration?.copyWith(color: Colors.white) ??
                  const BoxDecoration(color: Colors.white),
            ),
          ),
      errorWidget: (context, url, error) =>
          errorWidget ?? const Icon(Icons.error_outline),
    );

    if (isCircle) {
      return wrapInShape(image);
    }

    if (borderRadius != null && borderRadius! > 0) {
      return wrapInShape(image);
    }

    return SizedBox(width: width, height: height, child: image);
  }
}
