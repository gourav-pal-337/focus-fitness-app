import 'package:flutter/widgets.dart';
import 'package:flutter_svg/flutter_svg.dart';

class AppImage extends StatelessWidget {
  const AppImage({
    super.key,
    required this.path,
    this.isNetwork = false,
    this.width,
    this.height,
    this.fit,
    this.alignment = Alignment.center,
  });

  final String path;
  final bool isNetwork;
  final double? width;
  final double? height;
  final BoxFit? fit;
  final Alignment alignment;

  bool get _isSvg => path.toLowerCase().endsWith('.svg');

  @override
  Widget build(BuildContext context) {
    if (isNetwork) {
      if (_isSvg) {
        return SvgPicture.network(
          path,
          width: width,
          height: height,
          fit: fit ?? BoxFit.contain,
          alignment: alignment,
        );
      }

      return Image.network(
        path,
        width: width,
        height: height,
        fit: fit,
        alignment: alignment,
      );
    }

    if (_isSvg) {
      return SvgPicture.asset(
        path,
        width: width,
        height: height,
        fit: fit ?? BoxFit.contain,
        alignment: alignment,
      );
    }

    return Image.asset(
      path,
      width: width,
      height: height,
      fit: fit,
      alignment: alignment,
    );
  }
}


