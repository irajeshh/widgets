// ignore_for_file: public_member_api_docs

import 'package:flutter/material.dart';
import 'package:universal_html/html.dart' as html;
import 'package:url_launcher/link.dart' as link;

import '../widgets.dart';

class Inkk extends StatelessWidget {
  final Widget child;
  final Color? spalshColor;
  final double? radius;
  final String? tooltip;
  final VoidCallback? onTap;
  final Function? onHovered;
  final VoidCallback? onDoubleTap;
  final BorderRadius? borderRadius;
  final Color? hoverColor;

  ///Link to be opened in new tab and same tab if [onTap] is not provided
  final String? url;

  ///To allow gesture input
  final bool allowGesture;

  ///Constructor
  const Inkk({
    super.key,
    required this.child,
    required this.onTap,
    this.onHovered,
    this.radius,
    this.spalshColor,
    this.tooltip,
    this.onDoubleTap,
    this.borderRadius,
    this.url,
    this.hoverColor,
    this.allowGesture = false,
  });

  @override
  Widget build(final BuildContext context) {
    final Widget _parent = Semantics(
      label: tooltip ?? url ?? 'Button',
      child: ClipRRect(
        borderRadius: _borderRadius,
        child: _stack(),
      ),
    );
    if (url != null) {
      return _linker(_parent);
    } else {
      return _parent;
    }
  }

  Widget _linker(final Widget child) {
    return link.Link(
      uri: Uri.parse(url!),
      target: link.LinkTarget.blank,
      builder: (final BuildContext context, final link.FollowLink? followLink) {
        return child;
      },
    );
  }

  Widget _stack() {
    return Stack(
      children: <Widget>[
        if (allowGesture) GestureDetector(child: child, onTap: onTap) else child,
        if (allowGesture == false)
          Positioned.fill(
            child: Material(
              color: Colors.transparent,
              borderRadius: _borderRadius,
              child: InkWell(
                hoverColor: hoverColor ?? Colors.transparent,
                highlightColor: (spalshColor ?? WidgetsConfig.primaryColor).withOpacity(0.35),
                splashColor: (spalshColor ?? WidgetsConfig.primaryColor).withOpacity(0.25),
                onTap: onTap ??
                    () {
                      ///When onTap function is not provided,
                      ///but an url is given, then we need to open it in same page!
                      if (url != null) {
                        // ignore: unsafe_html
                        html.window.open(url!, '_self');
                      }
                    },
                onDoubleTap: onDoubleTap ?? () {},
                onHover: (final _) {
                  if (onHovered != null) {
                    onHovered!();
                  }
                },
              ),
            ),
          ),
      ],
    );
  }

  BorderRadius get _borderRadius => borderRadius ?? BorderRadius.circular(radius ?? 8);
}
