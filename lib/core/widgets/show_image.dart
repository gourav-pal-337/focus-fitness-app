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
    if (imageUrl == null || imageUrl!.isEmpty) {
      return errorWidget ?? const SizedBox.shrink();
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
              decoration: BoxDecoration(
                color: Colors.white,
                shape: isCircle ? BoxShape.circle : BoxShape.rectangle,
                borderRadius: isCircle
                    ? null
                    : BorderRadius.circular(borderRadius ?? 0),
              ),
            ),
          ),
      errorWidget: (context, url, error) =>
          errorWidget ?? const Icon(Icons.error_outline),
    );

    if (isCircle) {
      return ClipOval(child: image);
    }

    if (borderRadius != null && borderRadius! > 0) {
      return ClipRRect(
        borderRadius: BorderRadius.circular(borderRadius!),
        child: image,
      );
    }

    return image;
  }
}
