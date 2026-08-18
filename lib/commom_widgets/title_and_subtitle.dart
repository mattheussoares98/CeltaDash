import 'package:celta_dash/commom_widgets/commom_widgets.dart';
import 'package:celta_dash/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class TitleAndSubTitle extends StatelessWidget {
  final String? title;
  final dynamic subTitle;
  final String? emptyMessage;
  final TextStyle? titleStyle;
  final TextStyle? subTitleStyle;
  final bool? subTitleIsPrice;
  final bool? subTitleIsPercentage;
  final TextAlign? textAlign;
  final bool copyableTitle;
  final bool copyableSubtitle;
  final bool removeColon; //two points
  const TitleAndSubTitle({
    super.key,
    required this.title,
    required this.subTitle,
    this.titleStyle,
    this.subTitleStyle,
    this.emptyMessage,
    this.subTitleIsPrice,
    this.subTitleIsPercentage,
    this.textAlign,
    this.copyableTitle = false,
    this.copyableSubtitle = false,
    this.removeColon = false,
  });

  void _copyToClipboard({
    required TitleAndSubTitle titleAndSubtitle,
    required BuildContext context,
    required bool copyTitle,
    required bool copySubtitle,
  }) async {
    if (!copyTitle && !copySubtitle) return;

    await HapticFeedback.mediumImpact();

    late String text;

    if (copyTitle && copySubtitle) {
      text = '${titleAndSubtitle.title} ${titleAndSubtitle.subTitle}';
    } else if (copyTitle) {
      text = titleAndSubtitle.title!;
    } else {
      text = titleAndSubtitle.subTitle;
    }

    // Copy the text to the system clipboard
    await Clipboard.setData(ClipboardData(text: text));

    if (!context.mounted) return;

    // Provide visual feedback
    showToastMessage(
      'Copiado: $text'.hardcoded,
      duration: const Duration(seconds: 2),
    );
  }

  @override
  Widget build(BuildContext context) {
    bool showErrorMessage = false;
    bool subTitleIsNumber = subTitle is double || subTitle is int;

    if (subTitleIsNumber && emptyMessage != null) {
      if ((subTitle as double) == 0) {
        showErrorMessage = true;
      }
    } else if (subTitle == null && emptyMessage != null) {
      showErrorMessage = true;
    } else if (subTitle is String &&
        subTitle.isEmpty &&
        emptyMessage != null &&
        emptyMessage!.isNotEmpty) {
      showErrorMessage = true;
    }

    String? getSubtitleText() {
      if (showErrorMessage) {
        return emptyMessage!;
      } else if (subTitle == null && emptyMessage != null) {
        return emptyMessage!;
      } else if (subTitle == null || (subTitle is List && subTitle!.isEmpty)) {
        return null;
      } else if (subTitleIsNumber) {
        if (subTitle.toString().toInt() != null) {
          return subTitle.toString().toInt().toString();
        } else if (subTitleIsPrice == true) {
          return subTitle.toString().toBRL();
        }
        return subTitle.toString().toBRL(3);
      } else {
        return subTitle.toString();
      }
    }

    Color? getSubtitleColor() {
      if (subTitleStyle != null) {
        return null;
      } else if (showErrorMessage) {
        return Colors.red;
      } else if (subTitleIsNumber && (subTitle as num) <= 0) {
        return Colors.red;
      } else if (subTitleIsNumber && (subTitle as num) > 0) {
        return Colors.green;
      }
      return null;
    }

    final subtitleColor = getSubtitleColor();
    final subtitleText = getSubtitleText();

    if (title == null && subtitleText == null) return const SizedBox.shrink();

    final span = TextSpan(
      children: [
        if (!showErrorMessage && title != null)
          TextSpan(
            text: title!.trimRight() + (removeColon ? ' ' : ': '),
            style: titleStyle ?? context.theme.textTheme.bodyMedium,
          ),
        if (subTitleIsPrice == true && !showErrorMessage)
          TextSpan(
            text: "R\$ ",
            style: (subTitleStyle ?? context.theme.textTheme.titleMedium)
                ?.copyWith(color: subtitleColor, fontSize: 11),
          ),
        if (subtitleText != null)
          TextSpan(
            text: subtitleText,
            style: (subTitleStyle ?? context.theme.textTheme.titleMedium)
                ?.copyWith(color: subtitleColor),
          ),
        if (subTitleIsPercentage == true && !showErrorMessage)
          TextSpan(
            text: ' %',
            style: (subTitleStyle ?? context.theme.textTheme.titleMedium)
                ?.copyWith(color: subtitleColor, fontSize: 11),
          ),
      ],
    );

    final richText = RichText(
      textAlign: textAlign ?? TextAlign.start,
      textHeightBehavior: const TextHeightBehavior(
        applyHeightToFirstAscent: false,
        applyHeightToLastDescent: false,
      ),
      text: span,
    );

    final copyTitle =
        copyableTitle && (title?.isNotEmpty ?? false) && !showErrorMessage;
    final copySubtitle =
        copyableSubtitle &&
        (subTitle?.isNotEmpty ?? false) &&
        !showErrorMessage;
    if (copyTitle || copySubtitle) {
      return GestureDetector(
        behavior: HitTestBehavior.translucent,
        onLongPress: () => _copyToClipboard(
          titleAndSubtitle: this,
          context: context,
          copyTitle: copyTitle,
          copySubtitle: copySubtitle,
        ),
        child: richText,
      );
    }

    return richText;
  }
}
