import 'package:flutter/material.dart';

///A commonly used circle progress indicator loader
class Loader extends StatelessWidget {
  final EdgeInsets? padding;
  final Color? color;
  final double? size;
  final bool centre;
  const Loader({
    super.key,
    this.padding,
    this.color,
    this.size,
    this.centre = true,
  });

  @override
  Widget build(BuildContext context) {
    final Widget loader = Padding(
      padding: padding ?? const EdgeInsets.all(8),
      child: SizedBox(
        height: size,
        width: size,
        child: FittedBox(
          child: CircularProgressIndicator(
            strokeWidth: 5,
            valueColor: const AlwaysStoppedAnimation<Color>(Colors.white),
            backgroundColor: color,
          ),
        ),
      ),
    );
    return centre ? Center(child: loader) : loader;
  }
}
