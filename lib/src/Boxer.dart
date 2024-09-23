import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

///An indicator widget which shows the border of the given
///child which is used only on developement.
class Boxer extends StatefulWidget {
  ///Child borders to be shown
  final Widget child;

  ///Constructor
  const Boxer({
    super.key,
    required this.child,
  });

  @override
  State<Boxer> createState() => _BoxerState();
}

class _BoxerState extends State<Boxer> {
  bool showColor = true;

  @override
  Widget build(final BuildContext context) {
    if (kDebugMode) {
      return GestureDetector(
        onTap: () {
          if (mounted) {
            setState(() => showColor = !showColor);
          }
        },
        child: Container(
          foregroundDecoration: BoxDecoration(
            border: Border.all(
              color: showColor ? Colors.red : Colors.transparent,
            ),
          ),
          child: widget.child,
        ),
      );
    } else {
      return widget.child;
    }
  }
}
