// ignore_for_file: public_member_api_docs

import 'dart:async';

import 'package:extensions/extensions.dart';
import 'package:flutter/material.dart';

import '../widgets.dart';

class Button extends StatefulWidget {
  final dynamic icon;
  final Color? iconColor;
  final EdgeInsets? padding;
  final dynamic onTaskCompletedIcon;
  final dynamic text;
  final String? processingText;
  final String? ontaskCompletedText;
  final double? radius;
  final Function? onPressed;
  final double? fontSize;
  final double? iconSize;
  final int? maxLines;
  final double? width;
  final FontWeight? fontWeight;
  final bool upperCaseFirst;
  final bool isBig;
  final double? elevation;
  final bool isOutlined;
  final Color? textColor;
  final Color? buttonColor;
  final bool isVoid;

  ///To swap text and icon positions ie to show text first and show icon second
  ///This will only work when an [icon] is passed
  final bool swap;

  ///To make the button look like a dropdown
  final bool dropbutton;

  ///To show the icon button more aligned by wraping with expanded
  final bool expandedText;

  ///To automatically focus this button to make just onClick even when pressing [Enter] key
  final bool autoFocus;

  ///Constructor
  const Button({
    super.key,
    this.isBig = false,
    this.isOutlined = false,
    this.fontSize,
    this.iconSize,
    this.icon,
    this.text,
    this.radius,
    this.onPressed,
    this.maxLines,
    this.width,
    this.fontWeight,
    this.upperCaseFirst = false,
    this.processingText,
    this.ontaskCompletedText,
    this.onTaskCompletedIcon,
    this.elevation,
    this.buttonColor,
    this.textColor,
    this.isVoid = false,
    this.swap = false,
    this.dropbutton = false,
    this.expandedText = false,
    this.autoFocus = false,
    this.iconColor,
    this.padding,
  });


  ///Used in [Footers] to Addd/Edit a master
  factory Button.complete({
    required final bool toEdit,
    final bool isMini = false,
    final String? text,
    required final Function completeFn,
    required final VoidCallback showErrorFn,
    required final bool isValid,
    final Color? buttonColor,
    final double? radius,
    final double elevation = 2.5,
    final bool autoFocus = false,
  }) {
    return Button(
      autoFocus: autoFocus,
      elevation: elevation,
      isBig: true,
      radius: radius,
      width: isMini ? null : double.maxFinite,
      icon: toEdit ? Icons.save : Icons.check,
      buttonColor: buttonColor ?? (isValid ? Colors.green : Colors.grey),
      text: text ?? (toEdit ? 'Save Changes' : 'Add'),
      processingText: toEdit ? 'Saving Changes' : 'Adding...',
      onPressed: isValid ? completeFn : showErrorFn,
    );
  }

  @override
  _ButtonState createState() => _ButtonState();
}

class _ButtonState extends State<Button> {
  bool processing = false;
  bool processed = false;

  bool get isIconButton => widget.icon != null || processing == true;

  Color get _buttonColor => widget.buttonColor ?? WidgetsConfig.buttonColor;
  Color get _textColor => widget.textColor ?? _buttonColor.readable;
  Color get backgroundColor => processing ? _buttonColor.dark() : _buttonColor;
  Color get textColor => widget.isOutlined
      ? widget.textColor ??
          (Theme.of(context).brightness == Brightness.dark ? Colors.white : Colors.black)
      : _textColor;

  ButtonStyle get textButtonStyle => TextButton.styleFrom(
        shape: shape,
        backgroundColor: backgroundColor,
        shadowColor: backgroundColor,
        elevation: widget.elevation ?? 1.5,
      );

  ButtonStyle get outlinedButtonStyle => OutlinedButton.styleFrom(
        shape: shape,
        surfaceTintColor: backgroundColor,
        foregroundColor: backgroundColor,
      );

  RoundedRectangleBorder get shape => RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(widget.radius ?? 6),
      );

  @override
  Widget build(final BuildContext context) {
    return Container(
      height: widget.isBig ? 65 : 52,
      width: widget.width,
      padding: widget.padding ?? const EdgeInsets.all(8),
      child: finalButton(),
    );
  }

  Widget finalButton() {
    if (isIconButton || widget.dropbutton) {
      return (widget.swap || widget.dropbutton) ? swappedIconButton() : iconButton();
    } else {
      return normalButton();
    }
  }

  Widget iconButton() {
    if (widget.isOutlined) {
      return OutlinedButton.icon(
        autofocus: widget.autoFocus,
        icon: iconWidget(),
        style: outlinedButtonStyle,
        label: txtWidget(),
        onPressed: onPressed,
      );
    } else {
      return ElevatedButton.icon(
        autofocus: widget.autoFocus,
        icon: iconWidget(),
        style: textButtonStyle,
        label: txtWidget(),
        onPressed: onPressed,
      );
    }
  }

  Widget swappedIconButton() {
    final Widget row = Row(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        txtWidget(),
        const SizedBox(width: 8),
        iconWidget(),
      ],
    );
    return widget.isOutlined
        ? OutlinedButton(
            autofocus: widget.autoFocus,
            onPressed: onPressed,
            style: outlinedButtonStyle,
            child: row,
          )
        : ElevatedButton(
            autofocus: widget.autoFocus,
            onPressed: onPressed,
            style: textButtonStyle,
            child: row,
          );
  }

  Widget normalButton() {
    if (widget.isOutlined) {
      return OutlinedButton(
        autofocus: widget.autoFocus,
        style: outlinedButtonStyle,
        onPressed: onPressed,
        child: txtWidget(),
      );
    } else {
      return ElevatedButton(
        autofocus: widget.autoFocus,
        style: textButtonStyle,
        onPressed: onPressed,
        child: txtWidget(),
      );
    }
  }

  Widget txtWidget() {
    dynamic finalText;
    if (processing) {
      finalText = widget.processingText;
    }
    if (processed) {
      finalText = widget.ontaskCompletedText;
    }
    finalText ??= widget.text;

    Widget txt() {
      return Txt(
        finalText,
        fontSize: widget.isBig ? 18 : widget.fontSize,
        fontWeight: widget.fontWeight,
        maxlines: widget.maxLines ?? 1,
        useoverflow: true,
        selectable: false,
        color: textColor,
        upperCaseFirst: widget.upperCaseFirst,
      );
    }

    if (widget.expandedText) {
      return Expanded(child: txt());
    } else {
      return txt();
    }
  }

  Widget iconWidget() {
    Widget? child;
    final Color _icnColor = widget.iconColor ?? textColor;
    dynamic _icon = processed ? (widget.onTaskCompletedIcon ?? widget.icon) : widget.icon;
    if (widget.dropbutton) {
      _icon = Icons.keyboard_arrow_down;
    }
    if (_icon is IconData) {
      child = Icon(_icon, color: _icnColor, size: widget.iconSize ?? 20);
    }
    if (widget.icon is String) {
      child = Icon(
        IconsPack.icon(
          widget.dropbutton ? 'keyboard_arrow_down' : '${widget.icon}',
        ),
        color: _icnColor,
        size: widget.iconSize ?? 20,
      );
    }

    if (_icon is Widget) {
      child = _icon;
    }

    if (processing) {
      child = SizedBox(
        height: widget.isBig ? 35 : 32,
        child: Loader(color: _buttonColor),
      );
    }
    return child!;
  }

  Future<void> _onPressed() async {
    if (widget.onPressed != null) {
      await widget.onPressed!();
    } else {
      debugPrint('Invalid Action');
    }
  }

  Future<void> onPressed() async {
    if (processing) {
      showToast('Already processing...');
      return;
    } else {
      ///If the function is a not using [async] we don't need to process it to avoid [loading] indication
      if (widget.isVoid) {
        unawaited(_onPressed());
        if (mounted) {
          setState(() {
            processing = false;
            processed = true;
          });
        }
      } else {
        if (mounted) {
          setState(() {
            processing = true;
            processed = false;
          });
        }
        try {
          await _onPressed();
        } on Exception catch (e) {
          showToast('Error: $e');
        }
        if (mounted) {
          if (mounted) {
            setState(() {
              processing = false;
              processed = true;
            });
          }
        }
      }
    }
  }
}
