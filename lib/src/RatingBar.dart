import 'package:extensions/extensions.dart';
import 'package:flutter/material.dart';

///A common widget to show rating bar
class RatingBar extends StatelessWidget {
  ///Current given rating value
  final Object? rating;

  ///Size of the icon
  final double? size;

  ///Color of the icon
  final Color? color;

  ///Constructor
  const RatingBar({
    super.key,
    required this.rating,
    this.size,
    this.color,
  });

  @override
  Widget build(final BuildContext context) {
    double r = 5;
    if (rating is double) {
      r = rating! as double;
    }
    if (rating is int) {
      r = (rating! as int).toDouble();
    }
    if (rating is String) {
      r = <String, Object>{'tmp': rating!}.safeDouble('tmp', orElse: 5);
    }
    if (r > 5) {
      r = 5;
    }
    return Row(
      children: List<Widget>.generate(5, (final int index) {
        IconData icon = Icons.star_outline;
        if (r >= index + 1) {
          icon = Icons.star;
        }
        if (r.toInt() == index + 1 && '$r'.characters.last == '5') {
          icon = Icons.star_half;
        }
        return Icon(
          icon,
          size: size ?? 16,
          color: color ?? Colors.amber,
        );
      }),
    );
  }
}
