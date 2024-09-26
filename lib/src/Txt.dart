import 'package:extensions/extensions.dart';
import 'package:flutter/material.dart';

/// Customized text widget with various styling options.
class Txt extends StatefulWidget {
  /// The text to be displayed.
  final dynamic text;

  /// FontStyle of the text.
  final FontStyle? style;

  /// FontWeight of the text.
  final FontWeight? fontWeight;

  /// Maximum number of lines for text.
  final int? maxlines;

  /// Font size of the text.
  final double? fontSize;

  /// Text color.
  final Color? color;

  /// Text alignment.
  final TextAlign? textAlign;

  /// Whether to apply text overflow ellipsis.
  final bool useoverflow;

  /// Whether to capitalize the first letter of the text.
  final bool upperCaseFirst;

  /// Whether to enclose the text in quotes.
  final bool quoted;

  /// Whether to remove special characters from the text.
  final bool useFiler;

  /// Whether to underline the text.
  final bool underline;

  /// Whether to convert the text to full uppercase.
  final bool fullUpperCase;

  /// Font fontFamily for the text.
  final String? fontFamily;

  /// Whether to prepend an Indian Rupee symbol (₹) before the text.
  final bool toRupees;

  /// Whether to convert an integer value to a readable time format.
  final bool toTimeAgo;

  /// Prefix to be added if `toTimeAgo` is used.
  final String? prefix;

  /// Whether to apply a strike-through effect to the text.
  final bool strikeThrough;

  ///If the string can be selected by clicking on it
  final bool selectable;

  ///Space between each letters of a word
  final double? letterSpacing;

  /// Constructor for the Txt widget.
  const Txt(
    this.text, {
    super.key,
    this.style,
    this.fontWeight,
    this.maxlines,
    this.fontSize,
    this.color,
    this.textAlign,
    this.useoverflow = false,
    this.upperCaseFirst = false,
    this.quoted = false,
    this.useFiler = false,
    this.underline = false,
    this.fullUpperCase = false,
    this.selectable = true,
    this.fontFamily,
    this.prefix,
    this.toRupees = false,
    this.toTimeAgo = false,
    this.strikeThrough = false,
    this.letterSpacing,
  });

  @override
  _TxtState createState() => _TxtState();
}

class _TxtState extends State<Txt> {
  late String fontFamily;

  String finalText = '';

  bool get isDouble => widget.text is double;
  bool get isInt => widget.text is int;

  @override
  void initState() {
    fontFamily = widget.fontFamily ?? 'Roboto';
    super.initState();
  }

  @override
  Widget build(final BuildContext context) {
    // Determine the final text based on widget configuration.
    if (widget.text is String) {
      finalText = widget.text?.toString() ?? 'Error';
    } else if (widget.text is num) {
      if (widget.toRupees) {
        finalText = (isDouble ? (widget.text as double) : (widget.text as int).toDouble()).toRupees;
      } else if (widget.toTimeAgo && widget.text is int) {
        finalText = (widget.text as int).toDate.timeAgo(prefix: widget.prefix);
      } else {
        finalText = widget.text.toString();
      }
    } else {
      finalText = widget.text.toString();
    }

    // Apply text transformations.
    if (widget.upperCaseFirst) {
      finalText = finalText.upperCaseFirst;
    }

    if (widget.quoted) {
      finalText = '❝$finalText❞';
    }

    if (widget.useFiler) {
      finalText = finalText
          .replaceAll('*', '')
          .replaceAll('_', '')
          .replaceAll('-', '')
          .replaceAll('#', '')
          .replaceAll('\n', '')
          .replaceAll('!', '')
          .replaceAll('[', '')
          .replaceAll('(', '')
          .replaceAll(')', '')
          .replaceAll(']', '');
    }
    if (widget.fullUpperCase) {
      finalText = finalText.toUpperCase();
    }

    double? fontSize = widget.fontSize;
    final bool hasEnglishCharacters = RegExp('[a-zA-Z]').hasMatch(finalText);
    if (hasEnglishCharacters == false) {
      ///If no fontSize given, then set it to default as [14]
      fontSize = widget.fontSize ?? 14;

      ///And then reduce [2] pixels from the given fontSize
      fontSize = fontSize - 2;
    }

    ///Mac doesnt show bold fonts, so we need to see it!
    final TextStyle _style =
        // Widgets.debugMode && kIsWeb == false?
        TextStyle(
      letterSpacing: widget.letterSpacing,
      decoration: widget.underline
          ? TextDecoration.underline
          : (widget.strikeThrough ? TextDecoration.lineThrough : null),
      color: widget.color,
      fontSize: widget.fontSize,
      fontWeight: widget.fontWeight,
      fontStyle: widget.style,
    );
    // : GoogleFonts.getFont(
    //     fontFamily,
    //     decoration: widget.underline
    //         ? TextDecoration.underline
    //         : (widget.strikeThrough ? TextDecoration.lineThrough : null),
    //     color: widget.color,
    //     fontSize: widget.fontSize,
    //     fontWeight: widget.fontWeight,
    //     fontStyle: widget.style,
    //   );

    if (widget.selectable) {
      return SelectableText(
        finalText,
        textAlign: widget.textAlign,
        maxLines: widget.maxlines,
        textScaler: TextScaler.noScaling,
        style: _style,
      );
    } else {
      return Text(
        finalText,
        overflow: widget.useoverflow ? TextOverflow.ellipsis : null,
        textAlign: widget.textAlign,
        maxLines: widget.maxlines,
        textScaler: TextScaler.noScaling,
        style: _style,
      );
    }
  }
}
