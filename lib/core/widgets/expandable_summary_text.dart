import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

import '../theme/app_colors.dart';
import '../theme/app_text_styles.dart';

/// Shows [text] trimmed to [trimLines] lines with an inline "Read More" link.
/// Tapping the link expands the text in place and swaps it for "Read Less".
/// The link only appears when the text actually overflows [trimLines].
class ExpandableSummaryText extends StatefulWidget {
  const ExpandableSummaryText({
    super.key,
    required this.text,
    this.trimLines = 2,
    this.style,
    this.linkStyle,
    this.readMoreLabel = '  Read More',
    this.readLessLabel = '  Read Less',
  });

  final String text;
  final int trimLines;
  final TextStyle? style;
  final TextStyle? linkStyle;
  final String readMoreLabel;
  final String readLessLabel;

  @override
  State<ExpandableSummaryText> createState() => _ExpandableSummaryTextState();
}

class _ExpandableSummaryTextState extends State<ExpandableSummaryText> {
  bool _expanded = false;
  late final TapGestureRecognizer _tap = TapGestureRecognizer()
    ..onTap = () => setState(() => _expanded = !_expanded);

  @override
  void dispose() {
    _tap.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final textStyle =
        widget.style ??
        AppTextStyle.text12Regular.copyWith(
          color: AppColors.textSecondary,
          height: 1.4,
        );
    final linkStyle =
        widget.linkStyle ??
        AppTextStyle.text10Regular.copyWith(
          color: AppColors.primary,
          fontWeight: FontWeight.bold,
        );

    return LayoutBuilder(
      builder: (context, constraints) {
        final maxWidth = constraints.maxWidth;
        final textDirection = Directionality.of(context);

        final linkSpan = TextSpan(
          text: _expanded ? widget.readLessLabel : widget.readMoreLabel,
          style: linkStyle,
          recognizer: _tap,
        );

        // Measure the full text trimmed to [trimLines] to know if it overflows.
        final textPainter = TextPainter(
          text: TextSpan(text: widget.text, style: textStyle),
          textDirection: textDirection,
          maxLines: widget.trimLines,
        )..layout(maxWidth: maxWidth);

        // Fits within the limit — render plainly, no link needed.
        if (!textPainter.didExceedMaxLines) {
          return Text(widget.text, style: textStyle);
        }

        // Expanded — show everything plus the "Read Less" link.
        if (_expanded) {
          return RichText(
            text: TextSpan(
              style: textStyle,
              children: [
                TextSpan(text: widget.text),
                linkSpan,
              ],
            ),
          );
        }

        // Collapsed + overflowing — trim the text so the "Read More" link fits
        // at the end of the last visible line.
        final linkPainter = TextPainter(
          text: linkSpan,
          textDirection: textDirection,
          maxLines: widget.trimLines,
        )..layout(maxWidth: maxWidth);

        final cutPosition = textPainter.getPositionForOffset(
          Offset(textPainter.width - linkPainter.width, textPainter.height),
        );
        final endIndex = cutPosition.offset.clamp(0, widget.text.length);
        final trimmed = widget.text.substring(0, endIndex).trimRight();

        return RichText(
          maxLines: widget.trimLines,
          overflow: TextOverflow.clip,
          text: TextSpan(
            style: textStyle,
            children: [
              TextSpan(text: '$trimmed… '),
              linkSpan,
            ],
          ),
        );
      },
    );
  }
}
