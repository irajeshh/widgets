import 'package:flutter/material.dart';
import 'package:widgets/widgets.dart';

/// A custom expansion tile widget that allows expanding and collapsing a list of children.
class Expansiontile extends StatelessWidget {
  /// The title of the expansion tile.
  final dynamic title;

  /// The subtitle of the expansion tile.
  final dynamic subtitle;

  /// A leading widget to display before the title.
  final Object? leading;

  ///Trailing widget
  final Widget? trailing;

  /// The list of children widgets to display when the tile is expanded.
  final List<Widget> children;

  /// The color of the expansion tile.
  final Color? textColor;

  /// Determines whether the tile is initially expanded or collapsed.
  final bool initiallyExpanded;

  ///Color of the card
  final Color? cardColor;

  ///Card color opacity
  final double opacity;

  ///Font Weight of title
  final FontWeight? fontWeight;

  ///Padding between the children and the parent
  final EdgeInsets? childrenPadding;

  ///Outter padding
  final EdgeInsets? padding;

  ///Constructor
  const Expansiontile({
    super.key,
    required this.title,
    this.subtitle,
    required this.children,
    this.textColor,
    this.initiallyExpanded = false,
    this.leading,
    this.trailing,
    this.cardColor,
    this.opacity = 0.15,
    this.fontWeight,
    this.padding,
    this.childrenPadding,
  });

  @override
  Widget build(final BuildContext context) {
    return Padding(
      padding: padding ?? const EdgeInsets.symmetric(vertical: 8),
      child: Card(
        elevation: 0,
        color: (cardColor ?? Colors.grey).withOpacity(opacity),
        child: Theme(
          data: Theme.of(context).copyWith(
            // Hide the divider
            dividerTheme: const DividerThemeData(color: Colors.transparent, space: 0, thickness: 0),
          ),
          child: ExpansionTile(
            leading: _leading,
            initiallyExpanded: initiallyExpanded,
            title: title is Widget
                ? title as Widget
                : Txt(
                    title,
                    color: textColor,
                    fontWeight: fontWeight ?? FontWeight.bold,
                    selectable: false,
                  ),
            subtitle: subtitle == null
                ? null
                : Txt(
                    subtitle,
                    color: textColor,
                    selectable: false,
                  ),
            iconColor: textColor,
            collapsedIconColor: textColor,
            expandedCrossAxisAlignment: CrossAxisAlignment.start,
            trailing: trailing ?? Icon(Icons.expand_more, color: textColor),
            childrenPadding: childrenPadding ?? const EdgeInsets.only(left: 16.0),
            shape: const Border(),
            children: children,
          ),
        ),
      ),
    );
  }

  Widget? get _leading {
    if (leading is Widget) {
      return leading! as Widget;
    }

    if (leading is IconData) {
      final Icon icon = Icon(leading! as IconData, color: cardColor);
      return subtitle == null ? icon : Iconbutton(icon: icon);
    }
    return null;
  }
}
