import 'package:flutter/material.dart';

import '../widgets.dart';

class OfferTimer extends StatefulWidget {
  final int secondsRemaining;
  final Function whenTimeExpires;
  final String? text;
  final Color? color;
  final double? fontSize;
  const OfferTimer({
    super.key,
    required this.secondsRemaining,
    required this.whenTimeExpires,
    this.text,
    this.color,
    this.fontSize,
  });

  @override
  State createState() => _OfferTimerState();
}

class _OfferTimerState extends State<OfferTimer> with TickerProviderStateMixin {
  late AnimationController _controller;
  Duration? duration;

  String get timerDisplayString {
    final Duration duration = _controller.duration! * _controller.value;
    return formatHHMMSS(duration.inSeconds);
  }

  @override
  void initState() {
    super.initState();
    duration = Duration(seconds: widget.secondsRemaining);
    _controller = AnimationController(
      vsync: this,
      duration: duration,
    );
    _controller.reverse(from: widget.secondsRemaining.toDouble());
    _controller.addStatusListener((final AnimationStatus status) {
      if (status == AnimationStatus.completed || status == AnimationStatus.dismissed) {
        widget.whenTimeExpires();
      }
    });
  }

  @override
  // ignore: must_call_super
  void didUpdateWidget(final OfferTimer oldWidget) {
    if (widget.secondsRemaining != oldWidget.secondsRemaining) {
      setState(() {
        duration = Duration(seconds: widget.secondsRemaining);
        _controller.dispose();
        _controller = AnimationController(
          vsync: this,
          duration: duration,
        );
        _controller.reverse(from: widget.secondsRemaining.toDouble());
        _controller.addStatusListener((final AnimationStatus status) {
          if (status == AnimationStatus.completed) {
            // widget.whenTimeExpires();
          } else if (status == AnimationStatus.dismissed) {
            printt('Animation Complete');
          }
        });
      });
    }
  }

  String formatHHMMSS(final int s) {
    final int days = (s / 86400).truncate();
    final int hours = (s / 3600).truncate();
    // ignore: noop_primitive_operations
    final int seconds = (s % 3600).truncate();
    final int minutes = (seconds / 60).truncate();

    final String daysStr = (days).toString().padLeft(1, '0');
    final String hoursStr = (hours).toString().padLeft(2, '0');
    final String minutesStr = (minutes).toString().padLeft(2, '0');
    final String secondsStr = (seconds % 60).toString().padLeft(2, '0');
    final String text = widget.text ?? 'Expires in';

    if (hours > 24) {
      return '$text $daysStr days $minutesStr mins $secondsStr secs';
    }

    if (hours == 0) {
      return '$text $minutesStr mins $secondsStr secs';
    }

    return '$text $hoursStr hrs $minutesStr mins $secondsStr secs';
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(final BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (final _, final Widget? child) {
        return Txt(
          timerDisplayString,
          fontSize: widget.fontSize,
          color: widget.color ?? Colors.yellow,
        );
      },
    );
  }
}
